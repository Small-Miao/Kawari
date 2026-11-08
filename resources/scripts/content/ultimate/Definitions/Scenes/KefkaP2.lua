-- 入场、重置和停止均使用这一组初始场景，不在机制脚本散落 MapEffect。
local maps={{index=0,state=64,timeline=128},{index=17,state=1,timeline=2},{index=18,state=1,timeline=4}}
for i=1,8 do maps[#maps+1]={index=i,state=4,timeline=8} end
return {initial={bgm=533,maps=maps},battle={maps={{index=17,state=4,timeline=8}}}}
