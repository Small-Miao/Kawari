return {actions={
    [49471]={kind="visual"},[49539]={kind="visual"},
    [49769]={kind="rect",length=40,width=10,damage=9999999,unmitigated=true},
    [47951]={kind="circle",radius=6,damage=880000,split=true,min_players=8},
},resolve=function(d,s,e,p,U)
    if e.action==47951 then local list=U.shuffled(d);local id=list[1];if id then p.pos=d:position(id);p.target=id end end
end}
