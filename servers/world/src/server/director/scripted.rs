//! 脚本演员、真实受击开场及实时命中规则；不接受录像玩家标识。
use super::*;

#[derive(Debug, Clone, PartialEq)]
pub struct ScriptActor {
    pub id: ObjectId,
    pub base: u32,
    pub layout: u32,
    pub model: Option<u16>,
    pub name: u32,
    pub hp: u32,
    pub level: u8,
    pub position: Position,
    pub rotation: f32,
    pub model_state: u8,
    pub model_attribute_flags: u8,
    pub animation_state: u8,
    pub display_flags: u32,
    pub targetable: bool,
    pub visible: bool,
    pub boss: bool,
    /// 仅从当前实例角色复制外观，不保存录像人物外观或身份。
    pub appearance_from: Option<ObjectId>,
}

#[derive(Debug, Clone, Default, PartialEq)]
pub struct HitRules {
    pub first_status: u16,
    pub first_status_duration: f32,
    pub requires_dynamis: bool,
    pub extra_statuses: Vec<HitStatus>,
    pub front_tanks: usize,
    pub front_damage: u32,
    pub targets: Option<Vec<ObjectId>>,
    pub animation_target: Option<ObjectId>,
    pub split: bool,
    pub min_players: usize,
    pub max_players: Option<usize>,
    pub tanks: Option<usize>,
    pub failure_damage: u32,
    pub physical: bool,
    pub unmitigated: bool,
    pub falloff: f32,
    pub status: u16,
    pub status_duration: f32,
    pub status_param: u16,
    pub punish_status: u16,
    /// 仅在本次伤害确实致死时添加；无敌模式不会被附加禁止复活状态。
    pub death_status: u16,
}

#[derive(Debug, Clone, PartialEq)]
pub struct HitStatus {
    pub id: u16,
    pub duration: f32,
    pub limit: u16,
    pub stacks: bool,
}

impl HitRules {
    pub fn from_lua(p: &Table) -> mlua::Result<Self> {
        let r = Self {
            first_status: p.get::<Option<u16>>("first_status")?.unwrap_or(0),
            first_status_duration: p
                .get::<Option<f32>>("first_status_duration")?
                .unwrap_or(0.0),
            requires_dynamis: p.get::<Option<bool>>("requires_dynamis")?.unwrap_or(false),
            extra_statuses: p
                .get::<Option<Vec<Table>>>("statuses")?
                .unwrap_or_default()
                .iter()
                .map(|s| {
                    let duration = s.get::<f32>("duration")?;
                    validate_seconds(duration)?;
                    Ok(HitStatus {
                        id: s.get("id")?,
                        duration,
                        limit: s.get::<Option<u16>>("limit")?.unwrap_or(0),
                        stacks: s.get::<Option<bool>>("stacks")?.unwrap_or(false),
                    })
                })
                .collect::<mlua::Result<Vec<_>>>()?,
            front_tanks: p.get::<Option<usize>>("front_tanks")?.unwrap_or(0),
            front_damage: p.get::<Option<u32>>("front_damage")?.unwrap_or(0),
            targets: p
                .get::<Option<Vec<u32>>>("targets")?
                .map(|ids| ids.into_iter().map(ObjectId).collect()),
            animation_target: p.get::<Option<u32>>("target")?.map(ObjectId),
            split: p.get::<Option<bool>>("split")?.unwrap_or(false),
            min_players: p.get::<Option<usize>>("min_players")?.unwrap_or(0),
            max_players: p.get("max_players")?,
            tanks: p.get("tanks")?,
            failure_damage: p.get::<Option<u32>>("failure_damage")?.unwrap_or(9999999),
            physical: p.get::<Option<bool>>("physical")?.unwrap_or(false),
            unmitigated: p.get::<Option<bool>>("unmitigated")?.unwrap_or(false),
            falloff: p.get::<Option<f32>>("falloff")?.unwrap_or(0.0),
            status: p.get::<Option<u16>>("status")?.unwrap_or(0),
            status_duration: p.get::<Option<f32>>("status_duration")?.unwrap_or(0.0),
            status_param: p.get::<Option<u16>>("status_param")?.unwrap_or(0),
            punish_status: p.get::<Option<u16>>("punish_status")?.unwrap_or(0),
            death_status: p.get::<Option<u16>>("death_status")?.unwrap_or(0),
        };
        validate_seconds(r.status_duration)?;
        validate_seconds(r.first_status_duration)?;
        if !r.falloff.is_finite()
            || r.falloff < 0.0
            || r.max_players.is_some_and(|max| max < r.min_players)
        {
            return Err(mlua::Error::runtime("无效的距离衰减或人数规则"));
        }
        Ok(r)
    }

    pub fn failed(&self, count: usize, tanks: usize) -> bool {
        count < self.min_players
            || self.max_players.is_some_and(|n| count > n)
            || self.tanks.is_some_and(|n| tanks != n)
    }
}

pub fn is_tank(job: u8) -> bool {
    matches!(job, 1 | 3 | 19 | 21 | 32 | 37)
}

/// 副本技能共用的状态减伤。防御属性和三级极限技已由 action 层处理。
pub fn mitigate(
    amount: u32,
    target: Option<&NetworkedActor>,
    source: Option<&NetworkedActor>,
    physical: bool,
) -> u32 {
    let has = |actor: Option<&NetworkedActor>, id| {
        actor
            .and_then(|a| a.status_effects())
            .is_some_and(|s| s.get(id).is_some())
    };
    if has(target, 82) || has(target, 1836) {
        return 0;
    }
    let mut multiplier = 1.0_f64;
    for (ids, scale) in [
        (&[71, 1191][..], 0.8),
        (&[1179][..], 0.8),
        (&[74, 89, 747, 1834][..], 0.7),
        (&[3832, 3835, 3838][..], 0.6),
        (&[2674][..], 0.85),
        (&[735, 2678][..], 0.9),
        (&[2682][..], 0.9),
        (&[1840, 2683][..], 0.85),
        (&[299, 2638][..], 0.9),
        (&[2618][..], 0.9),
        (&[1873, 3985][..], 0.9),
        (&[1839][..], 0.9),
        (&[1894][..], 0.9),
    ] {
        if ids.iter().any(|id| has(target, *id)) {
            multiplier *= scale;
        }
    }
    if has(source, 1193) {
        multiplier *= 0.9;
    }
    if has(source, 860) { multiplier *= 0.9; }
    multiplier *= target.map_or(1.0,crate::server::jobs::machinist::mitigation);
    multiplier *= target.map_or(1.0,crate::server::jobs::samurai::mitigation);
    if has(source, 1195) {
        multiplier *= if physical { 0.9 } else { 0.95 };
    }
    if has(source, 1203) {
        multiplier *= if physical { 0.95 } else { 0.9 };
    }
    let mut damage = (amount as f64 * multiplier).floor() as u32;
    if has(target, 409) || has(target, 811) || has(target, 3255) {
        damage =
            damage.min(target.map_or(0, |a| a.get_common_spawn().health_points.saturating_sub(1)));
    }
    damage
}

fn ordained_action_effects(action: u32) -> Option<(TargetEffectKind, TargetEffectKind, f32)> {
    let effect = match action {
        18558 | 18559 | 18584 | 18858 | 18859 | 18860 | 19213 | 19214 => {
            TargetEffectKind::Teleport {
                unk: [0; 5],
                territory: 0,
            }
        }
        19039 | 19040 => TargetEffectKind::Miss,
        18585 | 18586 => TargetEffectKind::Damage {
            damage_kind: Default::default(),
            damage_type: DamageType::Unique,
            damage_element: DamageElement::Unknown,
            bonus_percent: 0,
            unk3: 0,
            unk4: 0,
            amount: 9_999_999,
        },
        _ => return None,
    };
    // 国服录像的两条效果依次为技能结果和携带本动作 ID 的 0x1B。
    let continuation = TargetEffectKind::ExecuteCombo {
        sequence: 0,
        unk2: 0,
        unk3: 0,
        unk4: 0,
        unk5: 0x80,
        action_id: action as u16,
    };
    let animation_lock = match action {
        18558 | 18559 | 18584 | 18858 | 18859 | 18860 => 3.1,
        _ => 1.1,
    };
    Some((effect, continuation, animation_lock))
}

#[cfg(test)]
mod ordained_tests {
    use super::*;
    use binrw::BinWrite;
    use std::io::Cursor;

    #[test]
    fn ordained_results_encode_the_two_captured_effects() {
        for (action, expected, expected_lock) in [
            (18558, [0x3d, 0, 0, 0, 0, 0, 0, 0], 3.1),
            (18559, [0x3d, 0, 0, 0, 0, 0, 0, 0], 3.1),
            (19039, [0x01, 0, 0, 0, 0, 0, 0, 0], 1.1),
            (19040, [0x01, 0, 0, 0, 0, 0, 0, 0], 1.1),
            (18585, [0x03, 0, 0, 0, 0x98, 0x40, 0x7f, 0x96], 1.1),
        ] {
            let (effect, followup, animation_lock) = ordained_action_effects(action).unwrap();
            let mut bytes = Cursor::new(Vec::new());
            TargetEffect(effect).write_le(&mut bytes).unwrap();
            TargetEffect(followup).write_le(&mut bytes).unwrap();
            let [lo, hi] = (action as u16).to_le_bytes();
            assert_eq!(&bytes.get_ref()[..8], &expected);
            assert_eq!(&bytes.get_ref()[8..], &[0x1b, 0, 0, 0, 0, 0x80, lo, hi]);
            assert_eq!(animation_lock, expected_lock);
        }
        assert!(ordained_action_effects(1).is_none());
    }
}

pub fn register<M: UserDataMethods<LuaDirector>>(methods: &mut M) {
    // 演员自身动作或朝玩家发动的跳跃，不用通用地面 Helper 代替施法者。
    methods.add_method_mut(
        "play_action_targeted",
        |_, this, (source, action, target, ordained): (u32, u32, u32, Option<bool>)| {
            let (effect, followup, animation_lock) = if ordained.unwrap_or(false) {
                let (effect, followup, animation_lock) = ordained_action_effects(action)
                    .ok_or_else(|| mlua::Error::runtime("未知的绝亚行动或静止特效动作"))?;
                (effect, Some(followup), animation_lock)
            } else {
                (TargetEffectKind::None, None, ANIMATION_LOCK_TIME)
            };
            this.tasks.push(LuaDirectorTask::EmitEffect {
                target: ObjectId(target),
                source: Some(ObjectId(source)),
                action_id: action,
                effect,
                followup,
                animation_lock,
            });
            Ok(())
        },
    );
    methods.add_method_mut("slide_actor", |lua, this, (actor, pos, rotation): (u32, Value, f32)| {
        let position: Position = lua.from_value(pos)?;
        if !position.0.is_finite() || !rotation.is_finite() {
            return Err(mlua::Error::runtime("移动坐标和朝向必须为有限值"));
        }
        this.tasks.push(LuaDirectorTask::SlideActor { actor_id: ObjectId(actor), position, rotation });
        Ok(())
    });
    // 动态场景物件共用具名演员注册表，删除和全灭清理不依赖录像槽位。
    methods.add_method_mut("spawn_event_object", |lua, this, (key, p): (String, Table)| {
        if this.helpers.contains_key(&key) {
            return Err(mlua::Error::runtime("场景物件名称重复"));
        }
        let position: Position = lua.from_value(p.get("pos")?)?;
        let rotation: f32 = p.get("rotation")?;
        let radius: f32 = p.get::<Option<f32>>("radius")?.unwrap_or(1.0);
        if !position.0.is_finite() || !rotation.is_finite() || !radius.is_finite() || radius < 0.0 {
            return Err(mlua::Error::runtime("无效的场景物件坐标或半径"));
        }
        let id = ObjectId(fastrand::u32(0x40000000..0x50000000));
        let flags: u8 = p.get("flags")?;
        let object = kawari::ipc::zone::SpawnObject {
            entity_id: id,
            kind: ObjectKind::EventObj,
            not_targetable: flags & 1 != 0,
            extra_flags: flags & !1,
            is_hidden: p.get::<Option<bool>>("hidden")?.unwrap_or(false),
            base_id: p.get("base")?,
            layout_id: p.get::<Option<u32>>("layout")?.unwrap_or(0),
            bind_layout_id: p.get::<Option<u32>>("bind_layout")?.unwrap_or(0),
            owner_id: ObjectId::default(),
            event_state: EventState::from_bits_retain(p.get::<Option<u8>>("state")?.unwrap_or(0)),
            args1: p.get("args1")?,
            args2: p.get("args2")?,
            position,
            rotation,
            radius,
            ..Default::default()
        };
        this.helpers.insert(key, id);
        this.tasks.push(LuaDirectorTask::SpawnScriptObject(object));
        Ok(id.0)
    });
    methods.add_method_mut(
        "setup_map_effects",
        |_, this, (states, flag): (Vec<u16>, u16)| {
            if states.len() != 64 && states.len() != 128 {
                return Err(mlua::Error::runtime("场景基线须为 64 或 128 项"));
            }
            this.tasks
                .push(LuaDirectorTask::SetupMapEffects { states, flag });
            Ok(())
        },
    );
    methods.add_method_mut("set_weather", |_, this, (id, fade): (u8, Option<f32>)| {
        let fade = fade.unwrap_or(0.0);
        validate_seconds(fade)?;
        this.tasks.push(LuaDirectorTask::SetWeather { id, fade });
        Ok(())
    });
    methods.add_method_mut("set_limit_break", |_, this, value: u32| {
        this.tasks
            .push(LuaDirectorTask::SetLimitBreak(value.min(30000)));
        Ok(())
    });
    methods.add_method("enmity_order", |_, this, actor: u32| {
        Ok(this
            .actor(actor)
            .map(|a| {
                a.enmity
                    .iter()
                    .filter(|id| this.actor(id.0).is_some_and(|p| p.is_player && p.alive()))
                    .map(|id| id.0)
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default())
    });
    methods.add_method_mut("director_event", |_, this, (id, args): (u32, Vec<u32>)| {
        if args.len() != 4 || !(0x80000000..=0x80000030).contains(&id) {
            return Err(mlua::Error::runtime("无效的演出事件"));
        }
        this.tasks.push(LuaDirectorTask::ScriptDirectorEvent {
            id,
            args: args.try_into().unwrap(),
        });
        Ok(())
    });
    methods.add_method("job", |_, this, actor: u32| {
        Ok(this.actor(actor).map(|a| a.class_job))
    });
    methods.add_method("aggro_target", |_, this, actor: u32| {
        Ok(this.actor(actor).map(|a| a.target.0))
    });
    methods.add_method_mut("arm_hit_trigger", |_, this, actor: u32| {
        this.tasks
            .push(LuaDirectorTask::ArmHitTrigger(ObjectId(actor)));
        Ok(())
    });
    methods.add_method_mut("spawn_actor", |lua, this, (key, p): (String, Table)| {
        if this.helpers.contains_key(&key) {
            return Err(mlua::Error::runtime("演员名称重复"));
        }
        let id = ObjectId(fastrand::u32(0x40000000..0x50000000));
        let actor = ScriptActor {
            id,
            base: p.get("base")?,
            layout: p.get::<Option<u32>>("layout")?.unwrap_or(p.get("base")?),
            model: p.get("model")?,
            name: p.get("name")?,
            hp: p.get::<Option<u32>>("hp")?.unwrap_or(1).max(1),
            level: p.get::<Option<u8>>("level")?.unwrap_or(90),
            position: lua.from_value(p.get("pos")?)?,
            rotation: p.get::<Option<f32>>("rotation")?.unwrap_or(0.0),
            model_state: p.get::<Option<u8>>("model_state")?.unwrap_or(0),
            model_attribute_flags: p.get::<Option<u8>>("model_attribute_flags")?.unwrap_or(0),
            animation_state: p.get::<Option<u8>>("animation_state")?.unwrap_or(0),
            display_flags: p.get::<Option<u32>>("flags")?.unwrap_or(0),
            targetable: p.get::<Option<bool>>("targetable")?.unwrap_or(false),
            visible: p.get::<Option<bool>>("visible")?.unwrap_or(true),
            boss: p.get::<Option<bool>>("boss")?.unwrap_or(false),
            appearance_from: p.get::<Option<u32>>("appearance_from")?.map(ObjectId),
        };
        this.helpers.insert(key, id);
        this.tasks.push(LuaDirectorTask::SpawnScriptActor(actor));
        Ok(id.0)
    });
    // 录像的读条和技能结果有独立时间，不能在读条结束时重复播放动作。
    methods.add_method_mut(
        "begin_cast",
        |lua,
         this,
         (source, action, seconds, target, omen_delay, position, spell_id): (
            u32,
            u32,
            f32,
            Option<u32>,
            Option<u8>,
            Option<Value>,
            Option<u16>,
        )| {
            validate_seconds(seconds)?;
            this.tasks.push(LuaDirectorTask::CastBar {
                source_id: ObjectId(source),
                action_id: action,
                cast_time: seconds,
                omen_delay: omen_delay.unwrap_or(0),
                target_id: ObjectId(target.unwrap_or(source)),
                spell_id,
                position: position.map(|v| lua.from_value(v)).transpose()?,
            });
            Ok(())
        },
    );
    methods.add_method_mut("object_animation", |_, this, (actor, a, b): (u32, u32, u32)| {
        this.tasks.push(LuaDirectorTask::SendActorControl {
            actor_id: ObjectId(actor),
            category: ActorControlCategory::EObjAnimation { param1: a, param2: b },
        });
        Ok(())
    });
    methods.add_method_mut("projection_death", |_, this, actor: u32| {
        this.tasks.push(LuaDirectorTask::SendActorControl {
            actor_id: ObjectId(actor), category: ActorControlCategory::Kill { animation_id: 0 },
        });
        Ok(())
    });
    methods.add_method_mut("end_cast", |_, this, (source, action): (u32, u32)| {
        this.tasks.push(LuaDirectorTask::EndScriptCast {
            source: ObjectId(source),
            action,
        });
        Ok(())
    });
}

pub fn spawn(
    instance: &mut Instance,
    data: &Arc<Mutex<GameData>>,
    actor: &ScriptActor,
    bosses: &mut HashMap<u32, DirectorBoss>,
) {
    let mut data = data.lock();
    let Some((model_chara, battalion, customize, rank, equip)) = data.find_bnpc(actor.base) else {
        tracing::error!(base = actor.base, "脚本演员 BNpcBase 不存在");
        return;
    };
    let mut equip_spawn = data.get_npc_equip(equip as u32).unwrap_or_default();
    let mut customize = customize;
    let mut model_chara = actor.model.unwrap_or(model_chara);
    drop(data);
    if let Some(source) = actor.appearance_from.and_then(|id| instance.find_actor(id)) {
        let source = source.get_common_spawn();
        equip_spawn.models = source.models;
        equip_spawn.second_model_stain_ids = source.second_model_stain_ids;
        equip_spawn.glasses_ids = source.glasses_ids;
        equip_spawn.main_weapon_model = source.main_weapon_model;
        equip_spawn.sec_weapon_model = source.sec_weapon_model;
        equip_spawn.class_job = source.class_job;
        equip_spawn.voice = source.voice;
        customize = source.look.clone();
        model_chara = source.model_chara;
    }
    let handler_id = instance.director.as_ref().unwrap().id;
    instance.insert_npc(
        actor.id,
        SpawnNpc {
            character_data_flags: if actor.targetable || actor.boss {
                CharacterDataFlag::HOSTILE
            } else {
                CharacterDataFlag::empty()
            },
            character_data_icon: rank,
            common: CommonSpawn {
                handler_id,
                base_id: actor.base,
                layout_id: actor.layout,
                name_id: actor.name,
                health_points: actor.hp,
                max_health_points: actor.hp,
                level: actor.level,
                object_kind: ObjectKind::BattleNpc(BattleNpcSubKind::Enemy),
                battalion,
                model_chara,
                position: actor.position,
                rotation: actor.rotation,
                model_state: actor.model_state,
                model_attribute_flags: actor.model_attribute_flags,
                animation_state: actor.animation_state,
                display_flags: DisplayFlag::from_bits_retain(actor.display_flags),
                look: customize,
                ..equip_spawn
            },
            ..Default::default()
        },
    );
    if let Some(NetworkedActor::Npc {
        state,
        ai_paused,
        targetable,
        visible,
        ..
    }) = instance.find_actor_mut(actor.id)
    {
        *state = NpcState::Stay;
        *ai_paused = true;
        *targetable = actor.targetable;
        *visible = actor.visible;
    }
    if actor.boss {
        bosses.insert(
            actor.base,
            DirectorBoss {
                state: DirectorBossState::Open,
                actor_id: actor.id,
                wall_id: 0,
                line_id: 0,
                place_name: 0,
            },
        );
    }
}
