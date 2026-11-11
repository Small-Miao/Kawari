use super::super::{
    native::{self, AreaAttack, Shape},
    paladin, white_mage,
};
use super::*;
use crate::server::action::area::AreaResult;
use kawari::ipc::zone::{DamageType, TargetEffect, TargetEffectKind};
fn gain(value: u16, amount: u8) -> TargetEffect {
    TargetEffect(TargetEffectKind::Unknown {
        magic: 62,
        param0: amount,
        param1: 0,
        param2: 0,
        param3: 0,
        param4: 128,
        value,
    })
}
fn buff(id: u16, bonus: i8, duration: f32, secondary: bool) -> TargetEffect {
    TargetEffect(TargetEffectKind::GainEffectSelf {
        unk1: bonus as u8,
        unk2: u8::from(secondary),
        param: 0,
        unk3: 128,
        effect_id: id,
        duration,
    })
}
fn append(r: &mut AreaResult, t: ObjectId, es: impl IntoIterator<Item = TargetEffect>) {
    let mut es = es.into_iter().peekable();
    if es.peek().is_none() {
        return;
    }
    if let Some((_, row)) = r.targets.iter_mut().find(|(id, _)| id.object_id == t) {
        for (slot, e) in row
            .iter_mut()
            .filter(|e| matches!(e.0, TargetEffectKind::None))
            .zip(es)
        {
            *slot = e;
        }
    } else {
        r.push(t, es);
    }
}
fn enhanced(id: u32) -> Option<u16> {
    match id {
        34606 | 34614 => Some(3672),
        34607 | 34615 => Some(3772),
        34610..=34613 => Some((id - 34610 + 3645) as u16),
        34618 | 34619 => Some((id - 34618 + 3649) as u16),
        34636..=34639 => Some((id - 34636 + 3657) as u16),
        34644 | 34645 => Some((id - 34644 + 3665) as u16),
        _ => None,
    }
}
fn potency(id: u32, l: u8, pre: &ViperState, enhanced: bool, positional: bool) -> u32 {
    match id {
        34606 | 34607 => (if l >= 74 { 200 } else { 150 }) + if enhanced { 100 } else { 0 },
        34608 | 34609 => {
            if l >= 74 {
                300
            } else {
                250
            }
        }
        34610..=34613 => {
            (if l >= 84 { 340 } else { 300 })
                + if enhanced { 100 } else { 0 }
                + if positional { 60 } else { 0 }
        }
        34614 | 34615 => 120 + if enhanced { 20 } else { 0 },
        34616 | 34617 => 180,
        34618 | 34619 => 180 + if enhanced { 40 } else { 0 },
        34620 => 540,
        34621 | 34622 => 630 + if positional { 50 } else { 0 },
        34623 => 250,
        34624 | 34625 => 300,
        34626 => 750,
        34627..=34630 => {
            if pre.dread == ((id - 34627) as u8 + 7) {
                680
            } else {
                480
            }
        }
        34631 => 1150,
        34632 => 200,
        34633 => 680,
        34634 => 280,
        34635 => 120,
        34636 | 34637 | 34644 | 34645 => 120 + if enhanced { 50 } else { 0 },
        34638 | 34639 => 50 + if enhanced { 30 } else { 0 },
        34640..=34643 => 320,
        _ => 0,
    }
}
pub(super) fn apply(
    n: &mut NetworkState,
    i: &mut Instance,
    c: JobAreaContext<'_>,
) -> Option<AreaResult> {
    if minimum(c.action) == 0 {
        return None;
    }
    let a = i.find_actor(c.caster)?;
    let NetworkedActor::Player {
        combat_state,
        spawn,
        ..
    } = a
    else {
        return None;
    };
    let pre = combat_state.viper.clone();
    let l = spawn.common.level;
    let pos = a.position();
    let o = c.caster;
    let id = c.action;
    let rear = matches!(id, 34612 | 34613 | 34622);
    let directional = matches!(id, 34610..=34613 | 34621 | 34622);
    let positional = directional
        && i.find_actor(c.target)
            .is_some_and(|t| super::super::monk::positional(a, t, rear));
    let has = enhanced(id).is_some_and(|id| c.statuses.get(id).is_some());
    let p = potency(id, l, &pre, has, positional);
    let mut r = AreaResult::new(pos);
    let mut own = Vec::new();
    let hit = if p > 0 {
        let target = i
            .find_actor(c.target)
            .map(NetworkedActor::position)
            .unwrap_or(pos);
        let self_area = matches!(id,34614..=34619|34623..=34626|34635|34638|34639);
        let target_area = matches!(id,34627..=34631|34633|34640..=34645);
        let area = self_area || target_area;
        r = native::damage_area(
            i,
            o,
            AreaAttack {
                center: if self_area { pos } else { target },
                direction: glam::Vec3::Z,
                shape: Shape::Circle(if area { 5.0 } else { 0.01 }),
                primary: Some(c.target),
                potency: p,
                falloff: if target_area || id == 34626 { 75 } else { 0 },
                damage_type: DamageType::Slashing,
                limit: if area { 31 } else { 1 },
            },
            c.modifiers,
        );
        r.targets.iter().any(|(_, es)| {
            es.iter()
                .any(|e| matches!(e.0, TargetEffectKind::Damage { .. }))
        })
    } else {
        false
    };
    if let Some(NetworkedActor::Player {
        combat_state,
        status_effects,
        ..
    }) = i.find_actor_mut(o)
    {
        let s = &mut combat_state.viper;
        // 所有新战技关闭旧的蛇尾/双牙窗口，命中后再建立当前窗口。
        if weapon(id) {
            s.follow = 0;
            s.follow_count = 0;
            s.follow_until = None;
            for old in [3657, 3658, 3659, 3660, 3665, 3666] {
                status_effects.remove(old);
            }
        }
        if matches!(id, 34634..=34645) {
            s.follow_count = s.follow_count.saturating_sub(1);
            if s.follow_count == 0 {
                s.follow = 0;
                s.follow_until = None;
            }
            if let Some(b) = enhanced(id) {
                status_effects.remove(b);
            }
            if has && pre.follow_count == 2 && matches!(id, 34636..=34639 | 34644) {
                let next = match id {
                    34636 => 3658,
                    34637 => 3657,
                    34638 => 3660,
                    34639 => 3659,
                    _ => 3666,
                };
                status_effects.add_with_source(next, 0, if id == 34644 { 60.0 } else { 30.0 }, o);
                own.push(buff(next, 0, if id == 34644 { 60.0 } else { 30.0 }, true));
            }
        }
        if id == 34647 {
            s.coils = (s.coils + 1).min(if l >= 88 { 3 } else { 2 });
            own.push(gain(302, 1));
            if l >= 90 {
                s.ready_until = until(30);
                status_effects.add_with_source(STATUS_READY_TO_REAWAKEN, 0, 30.0, o);
                own.push(buff(STATUS_READY_TO_REAWAKEN, 0, 30.0, false));
            }
        }
        if id == 34626 {
            if active(pre.ready_until) {
                s.ready_until = None;
                status_effects.remove(STATUS_READY_TO_REAWAKEN);
            } else {
                s.offering = s.offering.saturating_sub(50);
            }
            s.tribute = if l >= 96 { 5 } else { 4 };
            s.awaken_until = until(30);
            s.set_dread(7);
            status_effects.add_with_source(STATUS_REAWAKENED, 0, 30.0, o);
        }
        if matches!(id, 34627..=34630) {
            s.tribute = s.tribute.saturating_sub(1);
            s.set_dread(if id == 34630 {
                0
            } else {
                (id - 34627 + 8) as u8
            });
            if s.tribute == 0 {
                s.awaken_until = None;
                status_effects.remove(STATUS_REAWAKENED);
            }
        }
        if id == 34631 {
            s.tribute = 0;
            s.awaken_until = None;
            s.set_dread(0);
            status_effects.remove(STATUS_REAWAKENED);
        }
        if id == 34633 {
            s.coils = s.coils.saturating_sub(1);
        }
        if hit {
            if matches!(id, 34606 | 34607 | 34614 | 34615) {
                let next = if matches!(id, 34606 | 34614) {
                    3772
                } else {
                    3672
                };
                status_effects.remove(3672);
                status_effects.remove(3772);
                status_effects.add_with_source(next, 0, 60.0, o);
                own.push(buff(next, 0, 60.0, false));
            }
            if matches!(id, 34608 | 34616 | 34621 | 34624) {
                status_effects.add_with_source(3668, 0, 40.0, o);
                own.push(buff(3668, 10, 40.0, false));
            }
            if matches!(id, 34609 | 34617 | 34622 | 34625) {
                status_effects.add_with_source(3669, 0, 40.0, o);
                own.push(buff(3669, -15, 40.0, false));
            }
            if (34606..=34619).contains(&id) {
                let fin = matches!(id, 34610..=34613 | 34618 | 34619);
                s.basic = if fin { 0 } else { id };
                s.basic_until = if fin { None } else { until(30) };
            }
            if matches!(id, 34610..=34613 | 34618 | 34619) {
                for old in 3645..=3650 {
                    status_effects.remove(old);
                }
                let next = match id {
                    34610 => 3647,
                    34611 => 3648,
                    34612 => 3646,
                    34613 => 3645,
                    34618 => 3650,
                    _ => 3649,
                };
                status_effects.add_with_source(next, 0, 60.0, o);
                own.push(buff(next, 0, 60.0, false));
                if l >= 90 {
                    s.offering = (s.offering + 10).min(100);
                    own.push(gain(303, 10));
                }
                let kind = if id <= 34613 { 1 } else { 2 };
                if l >= if kind == 1 { 55 } else { 60 } {
                    s.set_follow(kind, 1);
                    own.push(gain(332, kind));
                }
            }
            if matches!(id, 34620 | 34623) {
                s.set_dread(if id == 34620 { 1 } else { 4 });
                if l >= 82 {
                    s.coils = (s.coils + 1).min(if l >= 88 { 3 } else { 2 });
                    own.push(gain(302, 1));
                }
            }
            if matches!(id, 34621 | 34622 | 34624 | 34625) {
                let start = if id <= 34622 { 1 } else { 4 };
                s.set_dread(if pre.dread == start {
                    if matches!(id, 34621 | 34624) {
                        start + 1
                    } else {
                        start + 2
                    }
                } else {
                    0
                });
                if l >= 90 {
                    s.offering = (s.offering + 5).min(100);
                    own.push(gain(303, 5));
                }
                if l >= if id <= 34622 { 75 } else { 80 } {
                    let kind = if id <= 34622 { 7 } else { 8 };
                    s.set_follow(kind, 2);
                    own.push(gain(332, kind));
                    let b = match id {
                        34621 => 3657,
                        34622 => 3658,
                        34624 => 3659,
                        _ => 3660,
                    };
                    status_effects.add_with_source(b, 0, 30.0, o);
                    own.push(buff(b, 0, 30.0, false));
                }
            }
            if matches!(id, 34627..=34630) && l >= 100 {
                let kind = (id - 34627 + 3) as u8;
                s.set_follow(kind, 1);
                own.push(gain(332, kind));
            }
            if id == 34633 && l >= 92 {
                s.set_follow(9, 2);
                own.push(gain(332, 9));
                status_effects.add_with_source(3665, 0, 60.0, o);
                own.push(buff(3665, 0, 60.0, false));
            }
        }
    }
    if hit && let Some(a) = i.find_actor_mut(o) {
        paladin::engage_auto_attack(a, c.target);
    }
    append(
        &mut r,
        o,
        own.into_iter().chain(
            c.effects
                .iter()
                .copied()
                .filter(|e| matches!(e.0, TargetEffectKind::ExecuteCombo { .. })),
        ),
    );
    if r.targets.is_empty() {
        r.push(o, []);
    }
    for (t, _) in &r.targets {
        white_mage::send_hp_mp(n, i, t.object_id);
    }
    Some(r)
}
