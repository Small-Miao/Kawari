return {actions={
    [47931]={kind="visual"},[47934]={kind="visual"},
    [47932]={kind="circle",radius=6,damage=9999999,unmitigated=true},
    [47933]={kind="circle",radius=6,damage=9999999,unmitigated=true},
    [47935]={kind="spread",radius=5,damage=150000,status=2941,status_duration=2,punish_status=2941},
},prepare=function(d,s,e,U)
    if e.action==47934 then s.spreads=U.shuffled(d);s.spread_index=0 end
end}
