// 从本地 SqPack 验证 EObj 资源，不启动客户端，也不访问网络。
use ironworks::{
    Ironworks,
    file::{layer::InstanceData, sgb::SharedGroupFile, tmb},
    sqpack::{Install, SqPack},
};
fn main() -> anyhow::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    let game = Ironworks::new().with_resource(SqPack::new(Install::at_sqpack(&args[1])));
    for path in &args[2..] {
        let file: SharedGroupFile = game.file(path)?;
        println!("SGB {path}");
        for group in file.scene().layer_groups() {
            for layer in group.layers() {
                for item in layer.instances() {
                    let resource = match item.data() {
                        InstanceData::BgPart(p) => p.asset_path().as_str(),
                        InstanceData::Vfx(p) => p.asset_path().as_str(),
                        InstanceData::SharedGroup(p) => p.asset_path().as_str(),
                        _ => "",
                    };
                    println!("  INSTANCE {} {} {}", item.id(), item.name(), resource);
                }
            }
        }
        for t in file.scene().timelines() {
            println!(
                "  TIMELINE {} {:?} auto={} loop={} actors={:?}",
                t.sub_id(),
                t.kind(),
                t.auto_play(),
                t.looping(),
                t.animated()
            );
            for item in t.timeline().items() {
                if let tmb::Item::Command(c) = item {
                    println!("    @{} {:?}", c.time(), c.kind());
                }
            }
        }
    }
    Ok(())
}
