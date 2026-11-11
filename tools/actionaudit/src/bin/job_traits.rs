//! 导出本地国服的职业特性和状态名，供录像逐项审计；不推断技能实现情况。
use icarus::{Action::ActionSheet, ActionTransient::ActionTransientSheet};
use icarus::{Status::StatusSheet, Trait::TraitSheet};
use physis::{
    Language,
    resource::{ResourceResolver, SqPackResource},
};
use serde_json::json;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    if args.len() != 2 {
        return Err("用法: job_traits <游戏 game 目录> <输出 JSON>".into());
    }
    let mut resolver = ResourceResolver::new();
    resolver.add_source(SqPackResource::from_existing(&args[0]));
    let language = Language::ChineseSimplified;
    let traits = TraitSheet::read_from(&mut resolver, language)?;
    let header = resolver.read_excel_sheet_header("TraitTransient")?;
    let descriptions = resolver.read_excel_sheet(&header, "TraitTransient", language)?;
    let statuses = StatusSheet::read_from(&mut resolver, language)?;
    let actions = ActionSheet::read_from(&mut resolver, language)?;
    let action_text = ActionTransientSheet::read_from(&mut resolver, language)?;
    let categories = icarus::ClassJobCategory::ClassJobCategorySheet::read_from(&mut resolver, language)?;
    let eligible = |category:u32| -> Vec<&str> {
        categories.row(category).map(|r| [("WAR",r.WAR),("DRK",r.DRK),("GNB",r.GNB),("SCH",r.SCH),
            ("SGE",r.SGE),("MCH",r.MCH),("MNK",r.MNK),("SAM",r.SAM),("DNC",r.DNC),("VPR",r.VPR),
            ("RDM",r.RDM),("RPR",r.RPR)].into_iter().filter_map(|(j,yes)|yes.then_some(j)).collect()).unwrap_or_default()
    };
    let pets = icarus::Pet::PetSheet::read_from(&mut resolver,language)?;
    let pet_rows:Vec<_>=(&pets).into_iter().flat_map(|(id,rows)|rows.into_iter().map(move |(_,p)|json!({"id":id,"name":p.Name,"auto_action":p.AutoAction,"abilities":p.Abilities}))).collect();
    let npc_bases=icarus::BNpcBase::BNpcBaseSheet::read_from(&mut resolver,Language::None)?;
    let actor_models:Vec<_>=(&npc_bases).into_iter().flat_map(|(id,rows)|rows.into_iter().filter(|(_,r)|matches!(r.ModelChara,408|1027|2618|2619|2621|3437)).map(move|(_,r)|json!({"base":id,"model":r.ModelChara}))).collect();
    let npc_names=icarus::BNpcName::BNpcNameSheet::read_from(&mut resolver,language)?;
    let actor_names:Vec<_>=(&npc_names).into_iter().flat_map(|(id,rows)|rows.into_iter().filter(|(_,r)|r.Singular.contains("浮空炮塔")||r.Singular.contains("炽天使")||r.Singular.contains("自走人偶")||r.Singular.contains("朝日小仙女")).map(move|(_,r)|json!({"name_id":id,"name":r.Singular}))).collect();
    let mut rows = Vec::new();
    for (id, subrows) in &traits {
        for (_, row) in subrows {
            if row.Name.is_empty() {
                continue;
            }
            let description = descriptions
                .row(id)
                .and_then(|r| r.columns.first()?.into_string().cloned())
                .unwrap_or_default();
            rows.push(json!({"id":id,"job":row.ClassJob,"job_category":row.ClassJobCategory,"level":row.Level,
                "name":row.Name,"value":row.Value,"description":description,"eligible_jobs":eligible(row.ClassJobCategory as u32)}));
        }
    }
    let mut status_rows = Vec::new();
    for (id, subrows) in &statuses {
        for (_, row) in subrows {
            if !row.Name.is_empty() {
                status_rows.push(json!({"id":id,"name":row.Name,"description":row.Description}));
            }
        }
    }
    let output = std::path::Path::new(&args[1]);
    let mut action_rows = Vec::new();
    for (id, subrows) in &actions {
        for (_, row) in subrows {
            if row.IsPvP {
                continue;
            }
            action_rows.push(json!({"id":id,"name":row.Name,"job":row.ClassJob,
                "eligible_jobs":eligible(row.ClassJobCategory as u32),
                "level":row.ClassJobLevel,"category":row.ActionCategory,
                "description":action_text.row(id).map(|r|r.Description).unwrap_or_default(),
                "radius":row.EffectRange,"range":row.Range,"cast_type":row.CastType,
                "width":row.XAxisModifier,"cast_100ms":row.Cast100ms,"recast_100ms":row.Recast100ms,
                "cost_type":row.PrimaryCostType,"cost":row.PrimaryCostValue,"charges":row.MaxCharges,
                "cooldown_group":row.CooldownGroup,"additional_cooldown_group":row.AdditionalCooldownGroup}));
        }
    }
    if let Some(parent) = output.parent() {
        std::fs::create_dir_all(parent)?;
    }
    std::fs::write(
        output,
        serde_json::to_vec_pretty(
            &json!({"traits":rows,"statuses":status_rows,"actions":action_rows,"pets":pet_rows,"actor_models":actor_models,"actor_names":actor_names}),
        )?,
    )?;
    println!("已导出本地职业特性与状态: {}", output.display());
    Ok(())
}
