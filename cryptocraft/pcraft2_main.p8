pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
--p.craft deluxe
--by nusan

version=""

lb4,lb5,block5,time,frame,allitems = false,false,false,0,0,{}

function item(n,s,p,bc)
	local it={name=n,spr=s,pal=p,becraft=bc}
	add(allitems,it)
	return it
end

function instc(it,c,l)
	return {type=it,count=c,list=l}
end

function setpower(v,i)
	i.power=v
	return i
end

function entity(it,xx,yy,vxx,vyy)
	return {type=it,x=xx,y=yy,vx=vxx,vy=vyy}
end

function rentity(it,xx,yy)
	return entity(it,xx,yy,rnd(3)-1.5,rnd(3)-1.5)
end

enstep_wait,enstep_walk,enstep_chase,enstep_patrol=0,1,2,3

function settext(t,c,time,e)
	e.text,e.timer,e.c=t,time,c
	return e
end

function bigspr(spr,ent)
	ent.bigspr,ent.drop=spr,true
	return ent
end

function recipe(m,require)
	return {type=m.type,power=m.power,count=m.count,req=require,list=m.list}
end

function cancraft(req)
	local can=true
	for i=1,#req.req do
		if howmany(invent,req.req[i])<req.req[i].count then
			can=false
			break
		end
	end
	return can
end

function craft(req)
	for i=1,#req.req do
		reminlist(invent,req.req[i])
	end
	additeminlist(invent,setpower(req.power,instc(req.type,req.count,req.list)),0)
end

pwrnames,pwrpal = {"wood","stone","iron","gold","gem"},{{2,2,4,4,},{5,2,4,13},{13,5,13,6},{9,2,9,10},{13,2,14,12}}

function setpal(l)
	for i=1,#l do
		pal(i,l[i])
	end
end

haxe,sword,scythe,shovel,pick,pstone,piron,pgold = item("haxe",98),item("sword",99),item("scythe",100),item("shovel",101),item("pick",102),{0,1,5,13},{1,5,13,6},{1,9,10,7}

wood,sand,seed,wheat,apple,glass,stone,iron,gold,gem = item("wood",103),item("sand",114,{15}),item("seed",115),item("wheat",118,{4,9,10,9}),item("apple",116),item("glass",117),item("stone",118,pstone),item("iron",118,piron),item("gold",118,pgold),item("gem",118,{1,2,14,12})
disk,scroll,artpart,artifact,fabric,sail,glue,boat,ichor,potion,ironbar,goldbar,bread,bossgem = item("save disk",10),item("map",11),item("artifact piece",63),item("talisman",12),item("fabric",69),item("sail",70),item("glue",85,{1,13,12,7}),item("boat",86),item("ichor",114,{11}),item("potion",85,{1,2,8,14}),item("iron bar",119,piron),item("gold bar",119,pgold),item("bread",119,{1,4,15,7}),item("ruby",0)
apple.givelife,potion.givelife,bread.givelife = 20,100,40

workbench,stonebench,furnace,anvil,factory,chem,chest,inventary,pickuptool,etext = bigspr(104,item("workbench",89,{1,4,9},true)),bigspr(104,item("stonebench",89,{1,6,13},true)),bigspr(106,item("furnace",90,nil,true)),bigspr(108,item("anvil",91,nil,true)),bigspr(71,item("factory",74,nil,true)),bigspr(78,item("chem lab",76,nil,true)),bigspr(110,item("chest",92)),item("inventory",89),item("pickup tool",73),item("text",103)
player,zombi,grwater,grsand,grgrass = 1,2,{id=0,gr=0},{id=1,gr=1},{id=2,gr=2}
grrock,grtree,grfarm,grwheat,grplant,griron,grgold,grgem,grhole,grartsand,grartgrass,grholeboss,lastground,level,rndwat = {id=3,gr=3,mat=stone,tile=grsand,life=15},{id=4,gr=2,mat=wood,tile=grgrass,life=8,istree=true,pal={1,5,3,11}},{id=5,gr=1},{id=6,gr=1},{id=7,gr=2},{id=8,gr=1,mat=iron,tile=grsand,life=45,istree=true,pal={1,1,13,6}},{id=9,gr=1,mat=gold,tile=grsand,life=80,istree=true,pal={1,2,9,10}},{id=10,gr=1,mat=gem,tile=grsand,life=160,istree=true,pal={1,2,14,12}},{id=11,gr=1},{id=12,gr=1},{id=13,gr=2},{id=14,gr=1},grsand,{},{}

grounds = {grwater,grsand,grgrass,grrock,grtree,grfarm,grwheat,grplant,griron,grgold,grgem,grhole,grartsand,grartgrass,grholeboss}

function cmenu(t,l,s,te1,te2)
	return {list=l,type=t,sel=1,off=0,spr=s,text=te1,text2=te2}
end

function howmany(list,it)
	local count=0
	for i=1,#list do
		if list[i].type==it.type then
			if not it.power or it.power==list[i].power then
				if list[i].count then
					count+=list[i].count
				else
					count+=1
				end
			end
		end
	end
	return count
end

function isinlist(list,it)
	for i=1,#list do
		if list[i].type==it.type then
			if not it.power or it.power==list[i].power then
				return list[i]
			end
		end
	end
	return nil
end

function reminlist(list,elem)
	local it=isinlist(list,elem)
	if not it then
		return
	end
	if it.count then
		it.count-=elem.count
		if it.count<=0 then
			del(list,it)
		end
	else
		del(list,it)
	end
end

function additeminlist(list,it,p)
	local it2=isinlist(list,it)
	if not it2 or not it2.count then
		addplace(list,it,p)
	else
		it2.count=min(it2.count+it.count,254)
	end
end

function addplace(l,e,p)
	if p<#l and p>0 then
		for i=#l,p,-1 do
			l[i+1]=l[i]
		end
		l[p]=e
	else
		add(l,e)
	end
end

function isin(e,size)
	return (e.x>clx-size and e.x<clx+size and e.y>cly-size and e.y<cly+size)
end

function lerp(a,b,alpha)
	return a*(1.0-alpha)+b*alpha
end

function getlen(x,y)
	x,y=x*0.1,y*0.1
	return sqrt(x*x+y*y+0.0001)*10
	--return sqrt(x*x+y*y+0.001)
end

function getrot(dx,dy)
	return dy >= 0 and (dx+3) * 0.25 or (1 - dx) * 0.25
end

function normgetrot(dx,dy)
	local l = 1/sqrt(dx*dx+dy*dy+0.001)
	return getrot(dx*l,dy*l)
end

function fillene(l)
	l.ene={entity(player,0,0,0,0)}
	enemies=l.ene
	for i=0,levelsx-1 do
		for j=0,levelsy-1 do
			local c,r,ex,ey = getdirectgr(i,j),rnd(100),i*16 + 8,j*16 + 8
			local dist = max(abs(ex-plx),abs(ey-ply))
			if r<3 and c!=grwater and c!=grrock and not c.istree and dist>50 then
				add(l.ene, {type=zombi,x=ex,y=ey,vx=0,vy=0,life=10,prot=0,lrot=0,panim=0,banim=0,dtim=0,step=0,ox=0,oy=0})
			end
		end
	end
end

function createlevel(xx,yy,sizex,sizey,isunderground,makenew)
	local l = {x=xx,y=yy,sx=sizex,sy=sizey,isunder=isunderground,ent={},ene={},dat={}}
	setlevel(l)
	levelunder = isunderground
	createmap(makenew)
	fillene(l)
	l.stx,l.sty=(holex-levelx)*16+8,(holey-levely)*16+8
	return l
end

function setlevel(l)
	currentlevel,levelx,levely,levelsx,levelsy,entities,levelunder,enemies,data,plx,ply=l,l.x,l.y,l.sx,l.sy,l.ent,l.isunder,l.ene,l.dat,l.stx,l.sty
end

function resetlevel(makenew)

	prot,lrot,panim,pstam,plife,banim,coffx,coffy,time,frame=0,0,0,100,100,0,0,0,0,0
	lstam,llife,tooglemenu,invent,curitem,switchlevel,canswitchlevel=pstam,plife,0,{},nil,0,false
	menuinvent,menumap,bossdead,baserand=cmenu(inventary,invent),cmenu(scroll,{}),false,rnd(0xffffff)
	srand(1234)
	for i=0,15 do
		rndwat[i] = {}
		for j=0,15 do
			rndwat[i][j] = rnd(100)
		end
	end
	srand(baserand)

	cave,island = createlevel(64,0,32,32,true,makenew),createlevel(0,0,64,64,false,makenew)

	if makenew then
		local tmpworkbench = entity(workbench,plx,ply,0,0)
		tmpworkbench.list = workbenchrecipe
		multipleadd(invent, {tmpworkbench,instc(pickuptool),instc(disk)})
		--multipleadd(invent, {tmpworkbench,instc(pickuptool),instc(disk),setpower(5,instc(pick)),setpower(5,instc(sword)),instc(potion,200),instc(boat),instc(scroll),instc(artifact)}) -- cheat
	else
		local loadfromboss=dget(18)==489
		if(loadfromboss) reload(0x1000,0x1000,0x2000,"pcraft2_boss"..version..".p8")
		loadgame()
		if(loadfromboss) reload()
	end
end

function getindex(it)
	for i=1,#allitems do
		if it==allitems[i] then
			return i
		end
	end
	return -1
end

function saveadd(v)
	mset(save_px,save_py,v)
	save_px+=1
	if save_px>=128 then
		save_px=96
		save_py+=1
	end
end

function saveget()
	local v=mget(save_px,save_py)
	save_px+=1
	if save_px>=128 then
		save_px=96
		save_py+=1
	end
	return v
end

function savenewline()
	save_py+=1
	save_px=96
end

function savelevel(lev,chests)
	savenewline()
	local entcount=0
	for i=1,#lev.ent do
		local it=lev.ent[i]
		if it.type==chest or it.type.becraft then
			entcount+=1
		end
	end
	saveadd(entcount)
	for i=1,#lev.ent do
		local it=lev.ent[i]
		if it.type==chest or it.type.becraft then
			saveadd(getindex(it.type))
			saveadd(flr(it.x/16-0.5))
			saveadd(flr(it.y/16-0.5))
			if it.type==chest then
				add(chests,it)
			end
		end
	end
end

function loadlevel(lev,chests)
	savenewline()
	local entcount=saveget()
	for i=1,entcount do
		local it,npx,npy=allitems[saveget()],saveget(),saveget()
		if it then
			local newent = entity(it,npx*16+8,npy*16+8,0,0)
			if it.sl then
				newent.list=it.sl
			elseif it==chest then
				add(chests,newent)
				newent.list={}
			end
			newent.hascol=true
			add(lev.ent,newent)
		end
	end
end

function savegame()
	dset(1,plx)
	dset(2,ply)
	dset(3,currentlevel==island and 0 or 1)
	dset(4,1) -- is saved
	dset(5,plife)
	dset(14,bossdead and 789 or 0)
	dset(18,0)

	save_px,save_py=96,0

	local chests={}

	-- player inventory
	saveadd(#invent)
	for i=1,#invent do
		local it=invent[i]
		saveadd(getindex(it.type))
		saveadd(it.power!=nil and it.power or 255)
		saveadd(it.count!=nil and it.count or 255)
		if it.type==chest then
			add(chests,it)
		end
	end

	-- map entities
	savelevel(island,chests)
	savelevel(cave,chests)

	-- chest content
	savenewline()
	saveadd(#chests)
	for i=1,#chests do
		local it=chests[i]
		saveadd(#it.list)
		for j=1,#it.list do
			local itchest=it.list[j]
			saveadd(getindex(itchest.type))
			saveadd(itchest.power!=nil and itchest.power or 255)
			saveadd(itchest.count!=nil and itchest.count or 255)
		end
	end

	--cstore(0, 0, 0x4300, "pcraft2_main"..version)
	cstore()
end

function loadgame()

	if dget(3)>0 then
		setlevel(cave)
		music(4)
	end

	plx,ply,plife,save_px,save_py,chests,bossdead=dget(1),dget(2),dget(5),96,0,{},dget(14)==789
	llife=plife

	-- player inventory
	local invc=saveget()
	for i=1,invc do
		local it,pow,c=allitems[saveget()],saveget(),saveget()
		if it then
			local newit = instc(it,c!=255 and c or nil)
			if(pow<10) newit=setpower(pow,newit)
			if it.sl then
				-- todo : not good with chest
				newit.list=it.sl
			end
			if it==chest then
				newit.list={}
				add(chests,newit)
			end
			additeminlist(invent,newit,-1)
		end
	end

	-- map entities
	loadlevel(island,chests)
	loadlevel(cave,chests)

	-- chest content
	savenewline()
	local chestcount=saveget()
	for i=1,chestcount do
		local it,itemcount=chests[i],saveget()
		for j=1,itemcount do

			local chestit,pow,c=allitems[saveget()],saveget(),saveget()
			if chestit then
				local newit = instc(chestit,c!=255 and c or nil)
				if(pow<10) newit=setpower(pow,newit)
				if chestit.sl then
					-- todo : not good with chest
					newit.list=chestit.sl
				end
				additeminlist(it.list,newit,-1)
			end
		end
	end
	curmenu,curitem=nil,invent[1]
end

function multipleadd(l,vals)
	for i=1,#vals do
		add(l,vals[i])
	end
end

function _init()

	cartdata("nusan_pcraft"..version)

	gamestate,permadeath = dget(0),dget(19)>0

	menuitem(1, "new game", function() dset(0,0) load("pcraft2_generation"..version) end)
	if not permadeath then
		menuitem(2, "load game", function() if dget(4)==1 then reload() resetlevel(false) end end)
	end
	menuitem(3, "save game", savegame)

	music(1)

	furnacerecipe,workbenchrecipe,stonebenchrecipe,anvilrecipe,factoryrecipe,chemrecipe={},{},{},{},{},{}
	multipleadd(factoryrecipe,{recipe(instc(sail,1),{instc(fabric,3),instc(glue,1)}), recipe(instc(boat),{instc(wood,30),instc(ironbar,8),instc(glue,5),instc(sail,4)}), recipe(instc(artifact,1),{instc(artpart,4),instc(glue,2)})})

	multipleadd(chemrecipe,{recipe(instc(glue,1),{instc(glass,1),instc(ichor,3)}),recipe(instc(potion,1),{instc(glass,1),instc(ichor,1)})})

	multipleadd(furnacerecipe,{recipe(instc(ironbar,1),{instc(iron,3)}),recipe(instc(goldbar,1),{instc(gold,3)}),recipe(instc(glass,1),{instc(sand,3)}),recipe(instc(bread,1),{instc(wheat,5)})})

	local tooltypes,quant,materials,crafter = {haxe,pick,sword,shovel,scythe},{5,5,7,7,7},{wood,stone,ironbar,goldbar,gem},{workbenchrecipe,stonebenchrecipe,anvilrecipe,anvilrecipe,anvilrecipe}
	for j=1,5 do
		for i=1,#tooltypes do
			add(crafter[j],recipe(setpower(j,instc(tooltypes[i])),{instc(materials[j],quant[i]*(j>4 and 3 or 1))}))
		end
	end

	multipleadd(workbenchrecipe,{recipe(instc(scroll),{instc(wood,15),instc(fabric,5),instc(ichor,3)}),recipe(instc(workbench,nil,workbenchrecipe),{instc(wood,15)}),recipe(instc(stonebench,nil,stonebenchrecipe),{instc(stone,15)}),recipe(instc(factory,nil,factoryrecipe),{instc(wood,15),instc(stone,15)}),recipe(instc(chem,nil,chemrecipe),{instc(wood,10),instc(glass,3),instc(gem,10)}),recipe(instc(chest),{instc(wood,15),instc(stone,10)})})

	multipleadd(stonebenchrecipe,{recipe(instc(anvil,nil,anvilrecipe),{instc(iron,25),instc(wood,10),instc(stone,25)}),recipe(instc(furnace,nil,furnacerecipe),{instc(wood,10),instc(stone,15)})})
	--srand(1245)

	factory.sl,chem.sl,furnace.sl,anvil.sl,workbench.sl,stonebench.sl=factoryrecipe,chemrecipe,furnacerecipe,anvilrecipe,workbenchrecipe,stonebenchrecipe

	resetlevel(gamestate == 3)
end

function getmcoord(x,y)
	return flr(x/16),flr(y/16)
end

function isfree(x,y)
	local gr = getgr(x,y)
	return not (gr.istree or gr==grrock)
end

function isfreeenem(x,y)
	local gr = getgr(x,y)
	return not (gr.istree or gr==grrock or gr==grwater)
end

function getgr(x,y)
	return getdirectgr(getmcoord(x,y))
end

function getdirectgr(i,j)
	if(i<0 or j<0 or i>=levelsx or j>=levelsy) return grounds[1]
	return grounds[mget(i+levelx,j)+1]
end

function setgr(x,y,v)
	local i,j = getmcoord(x,y)
	if(i<0 or j<0 or i>=levelsx or j>=levelsy) return
	mset(i+levelx,j,v.id)
end

function dirgetdata(i,j,default)
	local g = i+j*levelsx
	if data[g]==nil then
		data[g] = default
	end
	return data[g]
end

function getdata(x,y,default)
	local i,j = getmcoord(x,y)
	if i<0 or j<0 or i>levelsx-1 or j>levelsy-1 then
		return default
	end
	return dirgetdata(i,j,default)
end

function setdata(x,y,v)
	local i,j = getmcoord(x,y)
	if i<0 or j<0 or i>levelsx-1 or j>levelsy-1 then
		return
	end
	data[i+j*levelsx] = v
end

function cleardata(x,y)
	local i,j = getmcoord(x,y)
	if i<0 or j<0 or i>levelsx-1 or j>levelsy-1 then
		return
	end
	data[i+j*levelsx] = nil
end

function loop(sel,l)
	local lp = #l
	return (((sel-1)%lp)+lp)%lp+1
end

function entcolfree(x,y,e)
	return max(abs(e.x-x),abs(e.y-y))>8
end

function reflectcol(x,y,dx,dy,checkfun,dp,e)

	local newx,newy = x + dx, y + dy
	local ccur,ctotal,chor,cver = checkfun(x,y,e), checkfun(newx,newy,e), checkfun(newx,y,e), checkfun(x,newy,e)

	if ccur then
		if chor or cver then
			if not ctotal then
				if chor then
					dy = -dy*dp
				else
					dx = -dx*dp
				end
			end
		else
			dx=-dx*dp
			dy=-dy*dp
		end
	end

	return dx,dy
end

function additem(mat,count,hitx,hity)
	for i=1,count do
		local gi = rentity(mat,flr(hitx/16)*16 + rnd(14)+1,flr(hity/16)*16 + rnd(14)+1)
		gi.giveitem,gi.hascol,gi.timer = mat,true,110+rnd(20)
		add(entities,gi)
	end
end

function uprot(grot,rot)
	if abs(rot-grot) > 0.5 then
		if rot>grot then
			grot += 1
		else
			grot -= 1
		end
	end
	return (lerp(rot, grot, 0.4)%1+1)%1
end

function _update()

	frame+=1

	if curmenu then
		local intmenu,othmenu = curmenu,menuinvent
		if curmenu.type==chest then
			if(btnp(0)) then tooglemenu-=1 sfx(18,3) end
			if(btnp(1)) then tooglemenu+=1 sfx(18,3) end
			tooglemenu=(tooglemenu%2+2)%2
			if tooglemenu==1 then
				intmenu,othmenu = menuinvent,curmenu
			end
		end

		if #intmenu.list>0 then
			if(btnp(2)) then intmenu.sel-=1 sfx(18,3) end
			if(btnp(3)) then intmenu.sel+=1 sfx(18,3) end

			intmenu.sel = loop(intmenu.sel,intmenu.list)

			if btnp(4) and not lb5 then
				if curmenu.type==chest then
					local el = intmenu.list[intmenu.sel]
					if el.type!=chest then
						sfx(16,3)
						del(intmenu.list,el)
						additeminlist(othmenu.list,el,othmenu.sel)
						if(#intmenu.list>0 and intmenu.sel>#intmenu.list) intmenu.sel-=1
						if intmenu==menuinvent and curitem==el then
							curitem=nil
						end
					end
				elseif curmenu.type.becraft then
					if curmenu.sel>0 and curmenu.sel<=#curmenu.list then
						local rec = curmenu.list[curmenu.sel]
						if cancraft(rec) then
							craft(rec)
							sfx(16,3)
						else
							sfx(17,3)
						end
					end
				elseif curmenu.list[curmenu.sel].type==disk then
					savegame()
					curmenu,block5=nil,true
					sfx(16,3)
				else
					curitem = curmenu.list[curmenu.sel]
					del(curmenu.list,curitem)
					additeminlist(curmenu.list,curitem,1)
					curmenu.sel,curmenu,block5=1,nil,true
					sfx(16,3)
				end
			end
		end
		if btnp(5) and not lb4 then
			curmenu=nil
			sfx(17,3)
		end
		lb4,lb5 = btn(5),btn(4)
		return
	end

	if switchlevel>0 then
		if switchlevel==2 then
			--boss
			--bossdead=false -- cheat
			if not bossdead then
				savegame()
				load("pcraft2_boss"..version)
			end
		else
			if currentlevel==cave then setlevel(island) music(1)
			else setlevel(cave) music(4) end
			fillene(currentlevel)
			switchlevel,canswitchlevel=0,false
		end
	end

	if curitem then
		if(howmany(invent,curitem)<=0) curitem=nil
	end

	local ci,cj = flr((clx-64)/16),flr((cly-64)/16)
	for i=ci,ci+8 do
		for j=cj,cj+8 do
			if getdirectgr(i,j)==grfarm then
				if time>dirgetdata(i,j,0) then
					mset(i+levelx,j,grsand.id)
				end
			end
		end
	end

	local playhit = getgr(plx,ply)
	if(playhit!=lastground and playhit==grwater) sfx(11,3)
	lastground = playhit
	local s = (playhit==grwater or pstam<=0) and 1 or 2
	if playhit==grhole or playhit==grholeboss then
		if canswitchlevel then
			switchlevel = (playhit==grhole and 1 or 2)
		end
	else
		canswitchlevel = true
	end

	local dx,dy,canact = 0,0,true

	if(btn(0)) dx -= 1
	if(btn(1)) dx += 1
	if(btn(2)) dy -= 1
	if(btn(3)) dy += 1

	local dl = 1/getlen(dx,dy)

	dx *= dl
	dy *= dl

	if abs(dx)>0 or abs(dy)>0 then
		lrot = getrot(dx,dy)
		panim += 1/33
	else
		panim = 0
	end

	dx *= s
	dy *= s

	dx,dy = reflectcol(plx,ply,dx,dy,isfree,0)

	for i=#entities,1,-1 do
		local e = entities[i]
		if e.hascol then
			e.vx,e.vy = reflectcol(e.x,e.y,e.vx,e.vy,isfree,0.9)
		end
		e.x += e.vx
		e.y += e.vy
		e.vx *= 0.95
		e.vy *= 0.95

		if e.timer and e.timer<1 then
			del(entities,e)
		else
			if(e.timer) e.timer-=1

			local dist = max(abs(e.x-plx),abs(e.y-ply))
			if e.giveitem then
				if dist<5 then
					if not e.timer or e.timer<115 then
						local newit = instc(e.giveitem,1)
						additeminlist(invent,newit,-1)
						del(entities,e)
						add(entities,settext(howmany(invent,newit),11,20,entity(etext,e.x,e.y-5,0,-1)))
						sfx(18,3)
					end
				end
			else
				if e.hascol then
					dx,dy = reflectcol(plx,ply,dx,dy,entcolfree,0,e)
				end
				if dist<12 and btn(4) and not block5 and not lb5 then
					if curitem and curitem.type==pickuptool then
						if e.type==chest or e.type.becraft then
							additeminlist(invent,e,0)
							curitem=e
							del(entities,e)
						end
						canact = false
					else
						if e.type==chest or e.type.becraft then
							tooglemenu=0
							curmenu = cmenu(e.type,e.list)
							sfx(13,3)
						end
						canact = false
					end
				end
			end
		end
	end

	nearenemies={}

	local ebx,eby,m,msp = cos(prot),sin(prot),16,4

	for i=1,#enemies do
		local e = enemies[i]
		if isin(e,100) then
			if e.type == player then
				e.x,e.y=plx,ply
			else
				local distp,disten,mspeed = getlen(e.x-plx,e.y-ply),getlen(e.x-plx - ebx*8,e.y-ply - eby*8),0.8

				if disten<10 then
					add(nearenemies,e)
				end
				if distp<8 then
					e.ox += max(-0.4,min(0.4,e.x-plx))
					e.oy += max(-0.4,min(0.4,e.y-ply))
				end

				if e.dtim<=0 then
					if e.step==enstep_wait or e.step==enstep_patrol then
						e.step,e.dx,e.dy,e.dtim=enstep_walk,rnd(2)-1,rnd(2)-1,30+rnd(60)
					elseif e.step==enstep_walk then
						e.step,e.dx,e.dy,e.dtim=enstep_wait,0,0,30+rnd(60)
					else -- chase
						e.dtim = 10+rnd(60)
					end
				else
					if e.step==enstep_chase then
						if distp>10 then
							e.dx += plx-e.x
							e.dy += ply-e.y
							e.banim = 0
						else
							e.dx,e.dy,pow = 0,0,10
							e.banim = (e.banim-1)%8
							if e.banim==4 then
								plife -= pow
								add(entities,settext(pow,8,20,entity(etext,plx,ply-10,0,-1)))
								sfx(14+rnd(2),3)
							end
							plife = max(0,plife)
						end
						mspeed = 1.4
						if distp>70 then
							e.step,e.dtim=enstep_patrol,30+rnd(60)
						end
					else
						if distp<40 then
							e.step,e.dtim=enstep_chase,10+rnd(60)
						end
					end
					e.dtim -= 1
				end

				local dl = mspeed/getlen(e.dx,e.dy)
				e.dx *= dl
				e.dy *= dl

				local fx,fy = reflectcol(e.x,e.y,e.dx+e.ox,e.dy+e.oy,isfreeenem,0)

				if abs(e.dx)>0 or abs(e.dy)>0 then
					e.lrot = getrot(e.dx,e.dy)
					e.panim += 1/33
				else
					e.panim = 0
				end

				e.x += fx
				e.y += fy

				e.ox *= 0.9
				e.oy *= 0.9

				e.prot = uprot(e.lrot,e.prot)
			end
		end
	end

	dx,dy = reflectcol(plx,ply,dx,dy,isfree,0)

	plx += dx
	ply += dy

	prot = uprot(lrot,prot)

	llife += max(-1,min(1,(plife-llife)))
	lstam += max(-1,min(1,(pstam-lstam)))

	if btn(4) and not block5 and canact then
		local hitx,hity = plx + cos(prot) * 8,ply + sin(prot) * 8
		local hit = getgr(hitx,hity)

		if not lb5 and curitem and curitem.type.drop then
			if hit == grsand or hit == grgrass then
				if(not curitem.list) curitem.list={}
				curitem.hascol,curitem.x,curitem.y,curitem.vx,curitem.vy = true,flr(hitx/16)*16+8,flr(hity/16)*16+8,0,0
				add(entities,curitem)
				reminlist(invent,curitem)
				canact = false
			end
		end

		if banim==0 and pstam>0 and canact then
			banim,stamcost,pow = 8,20,1
			local lifeitem=curitem and curitem.type.givelife
			if #nearenemies>0 and not lifeitem then
				sfx(19,3)
				if curitem and curitem.type==sword then
					pow = 1+curitem.power+rnd(curitem.power*curitem.power)
					stamcost = max(0,20-curitem.power*2)
					pow=flr(pow)
					sfx(14+rnd(2),3)
				end
				for i=1,#nearenemies do
					local e = nearenemies[i]
					e.life -= pow/#nearenemies
					local push = (pow-1)*0.5
					e.ox += max(-push,min(push,e.x-plx))
					e.oy += max(-push,min(push,e.y-ply))
					if e.life<=0 then
						del(enemies,e)
						additem(ichor,rnd(3),e.x,e.y)
						additem(fabric,rnd(3),e.x,e.y)
					end
					add(entities,settext(pow,9,20,entity(etext,e.x,e.y-10,0,-1)))
				end
			elseif hit.mat and not lifeitem then
				sfx(15,3)
				if curitem then
					if hit==grtree then
					 	if curitem.type==haxe then
							pow = 1+curitem.power+rnd(curitem.power*curitem.power)
							stamcost = max(0,20-curitem.power*2)
							sfx(12,3)
						end
					elseif (hit==grrock or hit.istree) and curitem.type==pick then
						pow = 1+curitem.power*2+rnd(curitem.power*curitem.power)
						stamcost = max(0,20-curitem.power*2)
						sfx(12,3)
					end
				end
				pow=flr(pow)

				local d = getdata(hitx,hity,hit.life)
				if d-pow<=0 then
					setgr(hitx,hity,hit.tile)
					cleardata(hitx,hity)
					additem(hit.mat,rnd(3)+2,hitx,hity)
					if hit==grtree and rnd()>0.7 then
						additem(apple,1,hitx,hity)
					end
				else
					setdata(hitx,hity,d-pow)
				end
				add(entities,settext(pow,10,20,entity(etext,hitx,hity,0,-1)))
			else
				sfx(19,3)
				if curitem then
					if curitem.power then
						stamcost = max(0,20-curitem.power*2)
					end
					if curitem.type.givelife then
						plife = min(100,plife+curitem.type.givelife)
						reminlist(invent,instc(curitem.type,1))
						sfx(21,3)
					end
					if curitem.type==scroll then
						curmenu=menumap
					end
					if (hit==grgrass or hit==grartgrass) and curitem.type==scythe then
						setgr(hitx,hity,hit==grgrass and grsand or grartsand)
						if(rnd()>0.4) additem(seed,1,hitx,hity)
					end
					if (hit==grsand or hit==grartsand) and curitem.type==shovel then
						if hit==grartsand then
							setgr(hitx,hity,grsand)
							local newchest=entity(chest,hitx,hity,0,0)
							newchest.list,newchest.hascol={instc(artpart,1)},true
							add(entities,newchest)
							sfx(39,3)
						elseif curitem.power>3 then
							setgr(hitx,hity,grwater)
							additem(sand,2,hitx,hity)
						else
							setgr(hitx,hity,grfarm)
							setdata(hitx,hity,time+15+rnd(5))
							additem(sand,rnd(2),hitx,hity)
						end
					end
					if hit==grwater and curitem.type==sand then
						setgr(hitx,hity,grsand)
						reminlist(invent,instc(sand,1))
					end
					if hit==grwater and curitem.type==boat then
						-- win
						dset(0,bossdead and 333 or 999)
						if(permadeath) dset(4,0)
						load("pcraft2"..version)
					end
					if hit==grfarm and curitem.type==seed then
						setgr(hitx,hity,grwheat)
						setdata(hitx,hity,time+15+rnd(5))
						reminlist(invent,instc(seed,1))
					end
					if hit==grwheat and curitem.type==scythe then
						setgr(hitx,hity,grsand)
						local d = max(0,min(4,4-(getdata(hitx,hity,0)-time)))
						additem(wheat,d/2+rnd(d/2),hitx,hity)
						additem(seed,1,hitx,hity)
					end
				end
			end
			pstam -= stamcost
		end
	end

	if banim>0 then
		banim -= 1
	end

	if pstam<100 then
		pstam = min(100,pstam+1)
	end

	if abs(cmx-plx)>m then
		coffx += dx*0.4
	end
	if abs(cmy-ply)>m then
		coffy += dy*0.4
	end

	cmx,cmy = max(plx-m,min(plx+m,cmx)),max(ply-m,min(ply+m,cmy))
	coffx *= 0.9
	coffy *= 0.9
	coffx,coffy = min(msp,max(-msp,coffx)),min(msp,max(-msp,coffy))

	clx += coffx
	cly += coffy

	clx,cly = max(cmx-m,min(cmx+m,clx)),max(cmy-m,min(cmy+m,cly))

	if btnp(5) and not lb4 then
		curmenu=menuinvent
		sfx(13,3)
	end

	lb4,lb5 = btn(5),btn(4)
	if not btn(4) then
		block5=false
	end

	time += 1/30

	if(plife<=0) then
		-- death
		dset(0,666)
		if(permadeath) dset(4,0)
		load("pcraft2"..version)
	end

end

function mirror(rot)
	return ((rot>0.325 and rot<0.825) and 1 or 0),((rot<0.125 or rot>0.625) and 1 or 0)
end

function dplayer(x,y,rot,anim,subanim,isplayer)

	local cr,sr,lan = cos(rot),sin(rot),sin(anim*2)*1.5
	local crlan,srlan,bel = cr*lan,sr*lan,getgr(x,y)
	x,y = flr(x),flr(y-4)
	if bel==grwater then
		y += 4
		circ(x - sr*3 + crlan,y + cr*3 + srlan,3,6)
		circ(x + sr*3 - crlan,y - cr*3 - srlan,3)

		local anc = 3 + ((time*3)%1)*3
		circ(x - sr*3 + crlan,y + cr*3 + srlan,anc)
		circ(x + sr*3 - crlan,y - cr*3 - srlan,anc)
	else

		circfill(x - sr*2 - crlan,y + 3 + cr*2 - srlan,3,1)
		circfill(x + sr*2 + crlan,y + 3 - cr*2 + srlan,3)
	end
		local blade = (rot+0.25)%1
		if subanim>0 then
			blade = blade - 0.3 + subanim*0.04
		end
		local weap,bcr,bsr,mx,my = 75,cos(blade),sin(blade),mirror(blade)

		if isplayer and curitem then
			pal()
			weap=curitem.type.spr
			if curitem.power then
				setpal(pwrpal[curitem.power])
			end
			if curitem.type and curitem.type.pal then
				setpal(curitem.type.pal)
			end
		end

		spr(weap,x + bcr*4 - crlan - mx*8 + 1, y + bsr*4 - srlan + my*8 - 7,1,1,mx==1,my==1)

		if(isplayer) pal()

	if bel!=grwater then
		circfill(x - sr*3 + crlan,y + cr*3 + srlan,3,2)
		circfill(x + sr*3 - crlan,y - cr*3 - srlan,3)

		local my2,mx2 = mirror((rot+0.75)%1)
		spr(75,x - sr*4 + crlan -8+mx2*8 + 1, y + cr*4 + srlan + my2*8 - 7,1,1,mx2==0,my2==1)

	end

	circfill(x+cr,y+sr-2,4,2)
	circfill(x+cr,y+sr,4)
	circfill(x+cr*1.5,y+sr*1.5-2,2.5,15)
	circfill(x-cr,y-sr-3,3,4)

end

function createmap(makenew)

	if makenew then
		reload(0x1000,0x1000,0x2000,"pcraft2_generation"..version..".p8")
	end

	plx,ply = dget(makenew and 62 or 1),dget(makenew and 63 or 2)
	holex,holey,clx,cly,cmx,cmy = levelsx/2+levelx,levelsy/2+levely,plx,ply,plx,ply
end

function comp(i,j,gr)
	local gr2 = getdirectgr(i,j)
	return (gr and gr2 and gr.gr == gr2.gr)
end

function watval(i,j)
	return rndwat[flr((i*2)%16)][flr((j*2)%16)]
end

function watanim(i,j)
	local a = ((time*0.6 + watval(i,j)/100)%1) * 19
	if(a>16) spr(13+a-16,i*16,j*16)
end

function rndcenter(i,j)
	return (flr(watval(i,j)/34)+18)%20
end

function rndsand(i,j)
	return flr(watval(i,j)/34)+1
end

function rndtree(i,j)
	return flr(watval(i,j)/51)*32
end

function spr4(i,j,gi,gj,a,b,c,d,off,f)
	spr(f(i,j+off)+a,gi,gj+2*off)
	spr(f(i+0.5,j+off)+b,gi+8,gj+2*off)
	spr(f(i,j+0.5+off)+c,gi,gj+8+2*off)
	spr(f(i+0.5,j+0.5+off)+d,gi+8,gj+8+2*off)
end

function drawback()

	local ci,cj = flr((clx-64)/16),flr((cly-64)/16)
	for i=ci,ci+8 do
		for j=cj,cj+8 do
			local gr,gi,gj,sv = getdirectgr(i,j),(i-ci)*2 + 64,(j-cj)*2 + 32,0

			if gr and gr.gr == 1 then -- sand
				if(gr==grfarm or gr==grwheat) sv=3
				mset(gi,gj,rndsand(i,j)+sv)
				mset(gi+1,gj,rndsand(i+0.5,j)+sv)
				mset(gi,gj+1,rndsand(i,j+0.5)+sv)
				mset(gi+1,gj+1,rndsand(i+0.5,j+0.5)+sv)
			else

				local u,d,l,r = comp(i,j-1, gr),comp(i,j+1, gr),comp(i-1,j, gr),comp(i+1,j, gr)
				local b=gr==grrock and 21 or gr==grwater and 26 or 16

				mset(gi,gj,b + (l and (u and (comp(i-1,j-1, gr) and 17+rndcenter(i,j) or 20) or 1) or (u and 16 or 0)) )
				mset(gi+1,gj,b + (r and (u and (comp(i+1,j-1, gr) and 17+rndcenter(i+0.5,j) or 19) or 1) or (u and 18 or 2)) )
				mset(gi,gj+1,b + (l and (d and (comp(i-1,j+1, gr) and 17+rndcenter(i,j+0.5) or 4) or 33) or (d and 16 or 32)) )
				mset(gi+1,gj+1,b + (r and (d and (comp(i+1,j+1, gr) and 17+rndcenter(i+0.5,j+0.5) or 3) or 33) or (d and 18 or 34)) )

			end
		end
	end

	pal()
	if levelunder then
		pal(15,5)
		pal(4,1)
	end
	map(64,32,ci*16,cj*16,18,18)

	for i=ci-1,ci+8 do
		for j=cj-1,cj+8 do
			local gr = getdirectgr(i,j)
			if gr then
				local gi,gj = i*16,j*16

				pal()

				if gr==grwater then
					watanim(i,j)
					watanim(i+0.5,j)
					watanim(i,j+0.5)
					watanim(i+0.5,j+0.5)
				end

				if gr==grwheat then
					local d = dirgetdata(i,j,0)-time
					for pp=2,4 do
						pal(pp,3)
						if(d>(10-pp*2)) palt(pp,true)
					end
					if(d<0) pal(4,9)
					spr4(i,j,gi,gj,6,6,6,6,0,rndsand)
				end

				if gr.istree then
					setpal(gr.pal)

					spr4(i,j,gi,gj,64,65,80,81,0,rndtree)

					if mget(i+levelx,j+1) == c then
						spr4(i,j,gi,gj,64,65,80,81,4,rndtree)
					end
				end

				if gr==grhole or (gr==grholeboss and not bossdead) then
					pal()
					if gr==grholeboss or not levelunder then
						palt(0,false)
						if (gr==grholeboss) pal(15,5)
						spr(31,gi,gj,1,2)
						spr(31,gi+8,gj,1,2,true)
					end
					palt()
					spr(77,gi+4,gj,1,2)
				end
			end
		end
	end
end

function panel(name,x,y,sx,sy)
	rectfill(x+8,y+8,x+sx-9,y+sy-9,1)
	spr(66,x,y)
	spr(67,x+sx-8,y)
	spr(82,x,y+sy-8)
	spr(83,x+sx-8,y+sy-8)
	sspr(24,32,4,8,x+8,y,sx-16,8)
	sspr(24,40,4,8,x+8,y+sy-8,sx-16,8)
	sspr(16,36,8,4,x,y+8,8,sy-16)
	sspr(24,36,8,4,x+sx-8,y+8,8,sy-16)

	local hx = x+(sx-#name*4)/2
	rectfill(hx,y+1,hx+#name*4,y+7,13)
	print(name,hx+1,y+2,7)
end

function itemname(x,y,it,col)
	local ty,px = it.type,x
	pal()
	if it.power then
		local pwn = pwrnames[it.power]
		print(pwn,x+10,y,col)
		px += #pwn*4 + 4
		setpal(pwrpal[it.power])
	end
	if(ty.pal) setpal(ty.pal)
	spr(ty.spr,x,y-2)
	pal()
	print(ty.name,px+10,y,col)
end

function list(menu,x,y,sx,sy,my)
	panel(menu.type.name,x,y,sx,sy)

	local tlist,sel = #menu.list,menu.sel
	if tlist<1 then
		return
	end

	if(menu.off>max(0,sel-4)) menu.off=max(0,sel-4)
	if(menu.off<min(tlist,sel+3)-my) menu.off=min(tlist,sel+3)-my

	sel -= menu.off

	local debut,fin,sely = menu.off+1,min(menu.off+my,tlist),y+3+sel*8
	rectfill(x+1,sely,x+sx-3,sely+6,13)

	x+=5
	y+=12

	for i=debut,fin do
		local it,py,col = menu.list[i],y+(i-1-menu.off)*8,7
		if it.req and not cancraft(it) then
			col = 0
		end

		itemname(x,py,it,col)

		if it.count then
			local c = ""..it.count
			print(c,x+sx-#c*4-10,py,col)
		end
	end

	spr(68,x-8,sely)
	spr(68,x+sx-10,sely,1,1,true)
end

function requirelist(recip,x,y,sx,sy)
	panel("require",x,y,sx,sy)
	local tlist = #recip.req
	if tlist<1 then
		return
	end

	x+=5
	y+=12

	for i=1,tlist do
		local it,py = recip.req[i],y+(i-1)*8
		itemname(x,py,it,7)

		if it.count then
			local h = howmany(invent,it)
			local c = h.."/"..it.count
			print(c,x+sx-#c*4-10,py,h<it.count and 8 or 7)
		end
	end

end

function printb(t,x,y,c)
	print(t,x+1,y,1)
	print(t,x-1,y)
	print(t,x,y+1)
	print(t,x,y-1)
	print(t,x,y,c)
end

function dent()
	for i=1,#entities do
		local e = entities[i]
		pal()
		if(e.type.pal) setpal(e.type.pal)
		if e.type.bigspr then
			spr(e.type.bigspr,e.x-8,e.y-8,2,2)
		else
			if e.type == etext then
				printb(e.text,e.x-2,e.y-4,e.c)
			else
				if e.timer and e.timer<45 and e.timer%4>2 then
					for i=0,15 do
						palt(i,true)
					end
				end
				spr(e.type.spr,e.x-4,e.y-4)
			end
		end
	end
end

function sorty(t)
	local tv = #t-1
	for i=1,tv do
		local t1,t2 = t[i],t[i+1]
		if t1.y > t2.y then
			t[i],t[i+1] = t2,t1
		end
	end
end

function denemies()
	sorty(enemies)

	for i=1,#enemies do
		local e = enemies[i]
		if e.type == player then
			pal()
			dplayer(plx,ply,prot,panim,banim,true)
		else
			if isin(e,72) then
				pal()
				pal(15,3)
				pal(4,1)
				pal(2,8)
				pal(1,1)

				dplayer(e.x,e.y,e.prot,e.panim,e.banim,false)
			end
		end
	end
end

function dbar(px,py,v,m,c,c2)
	pal()
	local pe,pe2 = px+v*0.3,px+m*0.3
	rectfill(px-1,py-1,px+30,py+4,0)
	rectfill(px,py,pe,py+3,c2)
	rectfill(px,py,max(px,pe-1),py+2,c)
	if(m>v) rectfill(pe+1,py,pe2,py+3,10)
end

function _draw()

	cls()

	camera(clx-64, cly-64)

	drawback()

	dent()

	denemies()

	camera()
	dbar(4,4,plife,llife,8,2)
	dbar(4,9,max(0,pstam),lstam,11,3)

	if curitem then
		itemname(36,6,curitem,7)
		if curitem.count then
			print(""..curitem.count,107,6,7)
		end
	end

	if curmenu then
		camera()
		if curmenu.type==chest then
			if tooglemenu==0 then
				list(menuinvent,87,24,84,96,10)
				list(curmenu,4,24,84,96,10)
			else
				list(curmenu,-44,24,84,96,10)
				list(menuinvent,39,24,84,96,10)
			end
		elseif curmenu.type.becraft then
			if curmenu.sel>=1 and curmenu.sel<=#curmenu.list then
				local curgoal = curmenu.list[curmenu.sel]
				panel("have",71,50,52,30)
				print(howmany(invent,curgoal),91,65,7)
				requirelist(curgoal,4,79,104,50)
			end
			list(curmenu,4,16,68,64,6)
		else
			list(curmenu,4,24,84,96,10)
		end
		if curmenu==menumap then
			rectfill(13,43,78,108,9)
			rect(13,43,78,108,4)
			local pp,dx={15,7,6,7,15,2,2,0,0,0,14,4,4,4},levelx*.25
			for i=0,levelsx-1 do
				for j=0,levelsy-1 do
					local c=mget(i+levelx,j)
					if c>0 then
						pset(14+i+dx,44+j+dx,pp[c])
					end
				end
			end
			--if(currentlevel==island and flr(frame/8	)%2==1) pset(14+plx/16,44+ply/16,8)
			if(flr(frame/8	)%2==1) pset(14+plx/16+dx,44+ply/16+dx,8)
		end
	end

	--[[if(true) then
		print("cpu "..flr(stat(1)*100),96,0,8)
		print("ram "..flr(stat(0)),96,8,8)
	end]]

end

__gfx__
00aaaa00ffffffffffffffffffffffffffffffff44fff44ffff44fff020121000004200002031000166666610099944000111100000000000001000000101000
0a2888a0ffffffffffffffffffffffffffff444fff4ffff4ff4fffff31031020030310204142000016eeee610995594401aaaa10000100000011100001000100
a288878afff4fffff4ffffffff4fffff4444fffffff444ff44fff44f20520002400200103031041016eeee61995995941a9999a1001110000110110010000100
a288888affffffffffffff4ffffffffffffffff4ff4fff44fff44ff415340401340100402020030216eeee619595559919899891000100000011100000000000
9a2888a9ffffffffffffffffffffff4fff44444fffffffffffffffff42424303230040341014020116eeee619595995919922991000000000001000001100100
09a22a90ffffffffff4fffffffffffffffffffffff44fff444fff44f313132021240302300034104166666614959959912922921000000000000000000010000
009aa900ffff4ffffffffffffffffffff4444fff44ff444fff444fff002021404130201204023003167777614495599001211210000000000000000000000000
00099000fffffffffffffffffffffffffffff444ffffffffffffffff001010000020100003012040166666100449990000100100000000000000000000000000
fffff11ffffffffff11fffff3353333333333333ff1111ffff1111ffff1111ff6666666666666666fffff44444ffff444444ffffddddddddddddddddffffffff
fff115511fffff1115511fff3515333333333353f155551111555511115555df6666666666666666ff44444444444444444444ffddddddddddddddddfffff111
ff15533551fff155533551ff5153333333333515155555555555555555555dd166666dddddd66666f4444444444444444444444fddddddddddddddddfff11666
f15333333511153333333b1f515333333353515315556555555665555556ddd1666dddddddddd66644441111144444411444444fddddddddddddddddff166666
f15333335155515333333b1f351533333515515315556666666666666666ddd1666dddddddddd6664411ddddd111111dd144444fddddddddddddddddf116dddd
f15333351533351533333b1f33533533351535151555566666666666666dddd1666dddddddddd66641dddddddddddddddd144444dddddd1111ddddddf16ddddd
1533333353333353333333b13333515bb1533515f155566666666666666ddd1f6666ddd11ddd666641ddddddddddddddddd11444ddddd144441dddddf1dddddd
1533333333333333335333b1333335b115333353f155566666666666666ddd1f6666dd1001dd666641ddddddddddddddddddd114ddddd14ff41dddddf1dd5555
f15335333333333335153b1f333333b115533333f155566666666666666ddd1f666655100155666641dddddddddddddddddddd14ddddd144441dddddf1d55555
f1535153333333333351b1ff33333515511535331555566666666d66666dddd1666655111155666641dddddddddddddddddddd14dddd14444441ddddf1551111
ff15153333333333333b1fff35335153355331531555666665d666666666ddd16666555555556666441dddddddddddddddddd14fdddd14444441ddddf1511111
fff1533333333533333b1fff515535333333551515556666666666666666ddd16666655555566666f41dddddddddddddddddd14fddd1444114441dddf1111000
fff1533333335153333b1fff351153333333351515556666666666666666ddd16666666666666666f41dddddddddddddddddd14fdddd111dd111ddddf1110000
fff15333333335333351b1ff33551533333351531555566666665666666dddd16666666666666666441dddddddddddddddddd14fddddddddddddddddff110000
ff1515333333333335153b1f3335153333333533f15556666666d666666ddd1f666666666666666641dddddddddddddddddddd14ddddddddddddddddfff11111
f15351533333333333533b1f3333533333333333f155566666666666666ddd1f666666666666666641dddddddddddddddddddd14ddddddddddddddddffffffff
f15335333333333333333b1f3333333333533333f155566666666666666ddd1f66666666666d666641ddddddddddddddddddd114dddddddddddddddd00000000
1533333335333335333333b13333333335153333f1556666666666666666dd1f6666666665566666441dddddddddddddddd11444dddddddddddddddd01111000
1533333351533351533333b1335333533353333315556dddddd66dddddd6ddd166655666d6666666f441dddddddddddddd14444fdddddddddddddddd01aaa100
f1533333351bbb1533333b1f35153515333335531555ddddddddddddddddddd166d66d6666666666ff441dddddddddddd144444fdddddddddddddddd12999a10
f153333333b111b333333b1f5153335335335115155dddddddddddddddddddd166666666666666d6fff4411ddd1111ddd1444fffdddddddddddddddd02299210
ff1bbb33bb1fff1b33bbb1ff353353335153355315ddddddddddddddddddddd16666666666666556fff44441114444111444ffffdddddddddddddddd00129210
fff111bb11fffff1bb111fff3335153335153333fddddd1111dddd1111dddd1f55666666666d5666ffff444444ffff444444ffffdddddddddddddddd00212100
ffffff11ffffffff11ffffff3333533333533333ff1111ffff1111ffff1111ff66d6666d66666666ffffffffffffffffffffffffdddddddddddddddd00001000
00000000222020000011111111111100001dd000000282000000770001400000000004100012022001000010000000000011a861000000000000000010101010
0000000024224200011dddddddddd11001d1110000282820000777700124006006004210012e12ee141111410000000011e1bec1009009000000000151515151
000000022422420011d1111111111d111d11111002828282007777770012441441442100122e11e1124444210000000016e1bec100400400000000115a585651
00020024244342001d111111111111d11d1111102828282807777775140122522522104112ee112241222214001100001111325100444400000001d15b5e5c51
00022024334344201d111111111111d11d1111108282828277777750124111611611142112eee1212444444202ff1000999999990040040000011dcd5b5e5c51
00024244434434201d111111111111d101d1110008282820577775000124441441444210222eee114222222422ff1000541111450024420000161ded5b5e5c51
00224334443434201d111111111111d1001dd00002828200057750000012225225222100222222102411114222220000541111450020020001676ded53525151
02344433344444201d111111111111d100000000002020000055000014111151151111411221110002444420222000005411114500222200156f6d8d55555551
02334444434444201d111111111111d11010101006111600417710211241116116111421222222220d1dd1d006666660444444440020020015666ddd52222251
24434334443344421d111111111111d1010101010061600017777142012444144144421023333332d515515d15666dd549999994002222001555555525555521
23444434444444201d111111111111d1101010100623260077771442001222522522210023333332511111150155ddd549999994001111001999999999999991
02344333444443201d111111111111d101010101623432607774142100141151151141002222222211a9e9110015dd5044444444001001001944444444444491
00234444334432001d111111111111d1101010106333336017114421001241611614210055555555119e8a110001d50055599555001111001999999999999991
012333344333221011d1111111111d11010101016233326001444210000124144142100051111115111111110001500054455445001001001544501010154451
0112222222221110011dddddddddd110101010100623260024422100000012222221000051111115156556510054210054444445001001001544510101054451
00011111111110000011111111111100010101010066600012211000000001111110000051111115011111100542121055555555000000000155101010105510
0020000000000000000000000000001100000000000011110111100000001f100222222222222220000001111100000000000000000000000000000000000000
024202000000200000002200000001410000111000001441144441000001fff10233333333333320001111565111100000666666666666000011111111111100
02442420000220000002341000001410000144410001444101111410001ffff4023333333333332001ddd1d1d1ddd100066666666776666d0144444444444410
0244344422242020000244410001410000023441000234110002314101ffff41023333333333332001ddd15651ddd10066666666666666dd0144999999994410
2434434442444242002324410014100000232141002321000023214119fff410023333333333332001ddd1d1d1ddd1001666666666666dd10149999999999410
24434344344444420232441002410000023201410232000002320141019f4100023333333333332001ddd15651ddd100156666666666dd100149999999999410
24434444434443202320110023200000232000102320000023200141001910000233333333333320011111d1d111110015566666666dd1000149999999999410
234444434433432032000000320000003200000032000000020000100001000002333333333333201dddd15651dddd101555666666dd10000149999999999410
023444434343322000555000000005000000400005555d50000222000000122002222222222222201555515551555510015556666dd100000144999999994410
02324443432220000511150000505b50001242205000d6d501234320000123420555555555555550151111111111151001555566ddd400000144444444444410
00202344320000005111115005b5b735012242e2500d676d1234343200123432055555555555555015191a181a1915101245555ddd2410000155559999555510
0000023444200000511111155b73535012282efe5000d6d50123434201234321051000000000015015121812181215101412555dd21441000154445445444510
0000002433200000511111150535b5001288efe250000d051234332112343210051101010101015015115111115115100101255d210144100154445555444510
000012333211000005111115005b735001288e825000000512332232123321000510101010101150155161555161551000001242100014100154444444444510
00012222222210000055115000053500001288205000000501221121012210000511010101010150115515555515511000000141000001000155555555555510
00001111111100000000550000005000000122000555555000110010001100000510101010101150011111111111110000000111000000000011111111111100
0000000000001020204040303030302020204020202020204040100040000010b030001020100010204010000000000000000000100000000000000000000000
1020529393626272a1b1e2d3e3e3e3b2d3e3101010a0a0a0308010101010a0a0a00000000000000000000000000030303030801010a010803030303030303030
00000000000000102040203030302040202020402020204020201000100000303030100000001020204010000000000000000000000000000000000000000000
1030526293628372a2d3b2b2b2d3d3d3d3b210a0a0a010a08080101010101010100000000000000000000000000030303030101010a0a0a03030308080a01030
00000000000000001020203030304020202020202020402030202000100000001010202020202040204010001000000010000000000000000000000000000000
3010528383939372a2d3b2e3d3e3e3d3b2d3901010a010a0103090101010101010000000000000000000000000003030303010a0a0a010a03030801010a01080
00000000000000000000003030302040404020202020202030202000101000001020202020202020202010003010000010402020401010101000000000000000
3030526262836272a3b3e1d3d3d3e3b2b2b29010a010101080801010a01010a0100000000000000000000000000030303030901010a010a03030101010a0a0a0
00000000000000000000000000000010204020202040203030302000101000000020404020204040202000303010000020202020202020202000000000000000
10105283838393826171a2b2d3b2b2b2d3d330801010101030801010101010101000000000000000000000000000303030309010a0101010303010a0a0a010a0
00000000000000000000000000000010202020402020202030202010000000000010402020402020202010003000000010404020202040100000000000000000
10105293938163636373a3b3b3b3e1b2d3d330303080a030301010a0101010101000000000000000000000000000303030303080101010103030901010a010a0
0000000000000000000000000000c010204020202020202040204020101010000010202020202020202010000000000010204020204020000000000000000000
2030529393723020201010302020a2d3e3b2303030303030801010a01010b01010000000000000000000000000003030303030303080a03030309010a0101010
00000000000000000000000000001020202020402020204020202040402040100010402020402020101010101010100000102020202010000000000000000000
3020528362721020301020103010a2e3b2e330303030303080101010101010101000000000000000000000000000303030303030303030303030308010101010
00000000000010101000000000101040202040101010404020204020402040100010204020201000000010202040100000002020202000000000000000000000
5161929383721030301020202030a2d3e3b230808080303080a0101010101010100000000000000000000000000030303030303030303030303030303080a030
00000000100000000000000000001010202010100010101020404020404010100000000000000000001010102010000000000010200000000000000000000000
5363636363731030102020101020a2e3d3b290101080303080a09090101080803000000000000000000000000000303030303080808030303030303030303030
00000000100000000000000000000010201010000000001010101010101000000000001010000000101010100000000010000000000000000000000000000000
1020202030101010101010102020a2e3d3e390101010803080909090108030303000100000000000000000000000303030309010108030303030303030303030
00000010200000000000000000000000101000000000000000000000000000000000104040400000201010000000101020100000000000000000000000000000
2020302020102030303010202030a2d3e3e330308080303030909090108080303010400000000000000000000000303030309010101080303030308080803030
00001010200000000000000000000000100000001000000000000010101000000010202020200000202000003030204020204010000000000000000000000000
5161616161616171a1b1b1b1b1b1e2d3e3b230303030303030109090101010808000000000000000000000000000303030303030808030303030901010803030
00000000100000000000000000000000100000001000000000000000000000000000104040100000201000000030102020101000000000000000000000000000
5363919393629372a2e3d3d3d3e3b2e3e3e330303030303030309080a010a0108000000000000000000000000000303030303030303030303030901010108030
00000000000000000000000000000010100000001000000000000000000000000000000000000000000000000000001010000000000000000000000000000000
2010526293626272a2b2e3b2d3e3b2e3e3d38080803030303030308010a010101020201000000000000000000000303030303030303030303030303080803030
00000000000000000000000010101010100000001000000000000000000000000000000010000000000000000000000000000000000000000000000000000000
1010536391936272a3b3e1b2b2e3d3b2d3d330303030303030303030801010a0a020202000000000000000000000303030308080803030303030303030303030
00000000000000000000104030202020100000001000000000000000000000000000102020200000000000000000000000000000000000000000000000000000
10201020526262826171a2d3e3e3e3b2d3e330303030803030303000000000000040402000000000000000000000303030303030303030303030303030303030
00000000000000000010202040201010000000000000000000000000000000000000001040100000000000000000000000000000000000000000000000000000
10302030536391626272a2b2b2d3d3d3d3b230303080803030303000000000000020201000000000000000000000303030303030303080303030808080303030
00000000000000000010202020201000000000000000000000000000000000000000000010000000000000000000000010000000000000000000000000000000
10100000000000000000000000003030303080808080103030303000000000000020101000000000000000000000303030303030308080303030303030303030
00000000000000001040202020200000000000000000000000000000000000000000000000000000000000000000001020000000c00000000000000000000000
00000000000000000000000000003030303030303030303030303000000000000010000000000000000000000000303030308080808010303030303030308030
00000000000000003020202040400000200000001000000000000000000000001000000000000000000000101000001020100000300000000000000000000000
00000000000000000000000000003030303030303030303030303000000000000000000000000000002010100000000000000000000030303030303030808030
00000000000000001010202040100000000000000000000000000000000000000000000000000000000000000000000010000000100000000000000000000000
00000000000000000000000000003030303030303030303030303000000000000000000000000000001000000000000000000000000030303030808080801030
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000
0000000000000000000000000000b1b1b1b1b1c1201020300212430000000000000000000000000000000000000000000000003030303030303080a030203002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000
0000100000000000000000000000e3b2b2b2e3c23020202002333300000000000000000000000000000000000000000000000030303030303030303030202002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000100000000000000000000000e3b2b2e3e3d2b1c1101002124300000000000000000000000000000000000000000000000030303030303030303030101002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000100000000000000000000000d3d1b3b3e1d3d3c2203002311300000000000000000000000000000000000000000000000030303030308080803030203002
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000100000000000000000000000e3c21030a2b2e3d2b1c102223000000000000000000000000010000000000000000000000030303030901010803030b1c102
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000100000000000000000000000d3c21030a2e3e3d1b3c302223000000000000000000000001040000000000000000000000030303030901010108030b3c302
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000e3d2b1b1e2e3d3c2011142321100100000000000000000000000000000000000000000000030303030303080803030011142
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000e1b2b2d3e3d1b3c3023312331210400000000000000000000000000000000000000000000030303030303030303030023312
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000a2d3b2e3b2c20111423312331200000000000000000000002020100000000000000000000030303030303030303030423312
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111100000000000000000000002020200000000000000000000030303030808080303030111111
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0505ff11ffff0205ff26ffff0101ff10ffff19ffc817ffff13ffff0aff0206
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff0c1effff0cff130fff030303030300030303030308080a0103030303030303
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303030303030000000303000000000003030303000000000000000000001e141d00030303030308080a010300030303030801010a0108030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000303030303030303030003030303030003030303030303030000030300000000000000030303030801010a010800030303030101010a0a0a030303030808
000000000000000000000000000000000000000000000000000000000000000000000000000000000101010103000000000000000000000000000000000000000003030801010101010803030303030303030303010a080808030303030000000000000000030303030101010a0a0a0003030303010a0a0a010a030303030303
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000030303010101010a01030303030303030303010a0a01010803030303000000000000000003030303010a0a0a010a00030303030901010a010a030303030303
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030308010a01010a080303030303030301010a010a0a08080803030300000000000000030303030901010a010a000303030309010a010101030303030303
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003030308010a0101010a0a0a0a080803010101010a0a0a080808030303000000000000000303030309010a0101010003030303030801010101030303030808
000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010200000000000000000000000003030309090908080a01010a0a0a010a0a01010101010108080808080300000000000000030303030308010101010003030303030303080a03030303030303
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000003030303090808080a0101010a0a0101010101010101010808030303030000000000000003030303030303080a030003030303030303030303030303030308
000000000000000000000000000000000000000000000000000000000000000000000102040201000000000000000000000000000000000000000000000000000003030303030308030a0101090a0a0a010a010101010a0a0a080303030000000000000000030303030303030303030003030303030303030303030303030801
0000000000000000000000000000000000000000020100000000000104010000000001040404040000000000000000010401000000000000000000000000000000000303030303030308010a09010a01010a01010a01010a0a080303030000000000000000030303030303030303030003030303030808080303030303030101
0000000000000000000000000000000000000001020100000000010404040000000004040404020000000000000001040404000000000000000000000000000000000303030303030308010109010101010a0a0a010a010a0108030303030000000000000003030303030808080303000303030309010108030303030303010a
00000000000000000000000000000000000000040202010000000102040201000000020404020401000000000000010404040100000000000000000000000000000303030308080a01010a09090101010101010a0101010101080303010a0a0a0000000000030303030901010803030003030303090101010803030303030901
0000000000000000000000000000000000000104040202010001020204020c000001020204040201000000000101010101010100000000000000000000000000000303080a0a0a0a010109090909010101010101010a010a0a03030301010e0a0000000000030303030901010108030003030303030308080303030303030901
000000000000000000000000000000000101020202040402020404020404020401020204020202020001010102010100000101010100000000000000000000000303080a010101010109090909090101010101010a01010101010101010a0a0a0000000000030303030303080803030003030303030303030303030303030308
0000000102020204010000000000000102020202020202040204020101010404040202020302020201010404040401000000010204010000000000000000000003030a0a0101010109090909090909010b010101010a010108030303030000000000000000030303030303030303030003030303030303030303030303030303
0000000001010102020100000000000202040204020402020204020100010404040402020204020202040404040200000000000102000000000000000000000003030909010909090909090909090901010101010a01010101080303030000000000000000030303030303030303030003030303080808030303030303030303
000000000000000102020101000104040202020202020202020202010001020404040204020202020402040402040000020000000100000000000000000000000003090909090909090909090909090909010a0a01010a010a0a0103030300000000000000030303030808080303030003030303030303030303030303030303
0000000000000001040402020402020202020204020404020202020000010204040402040202040204040402020200010201000000000000000000000000000000030909090909090909090a0101090909090a0108010a010a0a0108030300000000000000030303030303030303030003030303030303030803030303030308
00000000000000010202020402040202020303030303030303020400000102020304040402020202040204040202000303020000000000010300000000000000000309090909090903090901010a09090909090303080101010a010a080300000000000000030303030303030308030003030303030303080803030303030901
000000000000000404020202020202020402030303030303020202010002020403040402020204040404020202020001040100000000000000000000000000000003030909090909090901010101010909090a08030301010101010a080300000000000000030303030303030808030003030303080808080103030303030901
000000000000010202020204040202020402030303030302020404020102020202020404020202040402020203020000020000000000000000000000000000000003030801010101080101010a0101010901010803030801010a0101080300000000000000030303030808080801030000000000000000000000030303030303
000000000104020202020404040204020404030303030302040404020302020402040401000001010404020403020000000000000000000000000000000000000003030303080a010a0a0a010101010a0101010803030308010a0108080300000404020202010000000000000000000000000000000000000000030303030303
0000000102020202020402020402020402040203030302040202020303030204040400010201000001010403030301000000000000000000000000000000000000000303030308010101010808010101010108030303030303080808080300000000010102000000000000000002020100000000000000000000030303030303
0000000002020202020204040202040202020402030404020202020303030202040401000201000000000101020101000000000000000000000000000000000000000003030303030303030303080101010a08030303030303030303030300000300000102000000000000000002020200000000000000000000030303030808
0000000000010202020202020204040202020204020202020202010303040202020202000101010101000001010101000000000101000000000000000000000000000000030303030303030303030801010103030303030303030303030000000100000102000000000000000004040200000000000000000000030303030303
000000000000010202040202020404020402020202020202030301030402020404020401000101010401000001010000000001020201010000000000000000000000000003030303030303030303030a010a03030303030303030303030000000400000102010000000000000002020100000000000000000000030303030303
0000000000000002020202020202020402020202020202030303010304020204040402040000010404020100010000000001020202040402010000000000000000000003030303030303030303030303010303030303030303030303030000000200000104010000000000000002010100000000000000000000030303030303
0000000000000102020202040202040202040202020202040303010402020204040402010001010104010000000000000000000101010100000000000000000000000003030303030303000000000303030303000000000000000000000000000801010103030303000000000001000000000000000000000000030303030808
0000000000000104020202040202020202020204020202020303020201040404040402000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000a000000000000000000000000000303030303030303030303030303080a0303
0000000000000102020404040302020204020402020202020202040100010403030301000201000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000030303030308080a01030303030303030303
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0128002017164171721d1741a1721d1741c1621a152171720000217172151741a1721717415172191741717217102171721a174151721a17415172191741717200002171721a174171721a1721e1741e17215172
015000200b3520b35511352113550e3520e355153521035217352173551d3521d3551a3521a355213521c3520b3520b35511352113550e3520e3551535210352173551d3521a352213550b352113520e35210355
011400200b1630b3030b16300003116752d6050b1630b1630b163000000b1632d605116752d6252d6252d6250b1630b3030b16300003116752d6050b1630b1630b163000000b1632d605116750b163116750b163
011400201d1741c1621a1521e1741d1741c1621a1521c1621a1521d1741c1621a1521d1741c1621a152171721d104171721515218174151741716215174171620e10217172151521817417162151521716215152
012800200b1550b30511155113050e1550e30515155103050b5750b50511575115050e5750e505155751c3050b1550b30511155113050e1550e30515155105050b5750b50511575115050e5750e5051557510305
012800201d07024070240721d07024070240721d070240702407216070150701607516075160751a0701d0701f0751f075220751a07022070260751d0752b0752a07526075260722607226072260752600526002
0128002023234212312123221235292342a2312a2322a235262342823128232282352d2342e2312e2322e23523234212312123221235292342a2312a2322a235262342823128232282352d2342e2312e2322e235
015000000b1751217211175101720e17516172151750917217575125721d5751c5721a5752257221575155720b1751217211175101720e17516172151750917217575125721d5751c5721a575225722157528572
01140020346451c6751c6551c665346151062510645106351c675106551064510665346151062510635106453464534675346551c665346151c6251c6451c6351c6751c6553464534665346151c6251c63534645
01140020346451c6051c6051c605346151060510605106051c675106051060510605346151060510605106053464534605346051c605346151c6051c6051c6051c6751c6053460534605346151c6051c60534645
00040000066200c62012630156301564012650106500e6500d6500b6500a6500965007650076500c6500f6501065010640106400f6300f6300f6300f6300c6300a62009620096200861003610036100262000000
0001000006620136501a6603f7703f7701867013660106400c6300a62007610056100260002600016000260001600016000260002600026000260002600026000160002600016000160002600036000360001600
000100000000016570255702d57038570385700000000000000001750000000105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000f7700f7702d6702d67037670346702b6702667026650296502165027650296501e6401c64022630346202e62033630356202e620236302063023630296202f620336103561030610296102760000000
0001000012770127701e670256703067033670346703067027670226602466025660226601f660186601a6601765014650136501164010640106400f6400f6300f6201062010620106100d610106000000000000
0001000019000361303617036170361703616036150361503614036130361103611035110351102e3702e3602e3502e3402e3302e3202e3103310033100331003310032100321003210032100321003210032100
000100001227003270032700327003270032700327003270032700327003270032700327002270022700227003270032600327003260042700426004250042500424005240052300623007220072100000000000
00010000000003a330373603437000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000000001262012620126301263011640106500f6500f6500f6500e6500e6500e6500e6500e6500e6500d6500d6500d6500d6500c6500c6400b6300b6300a6200a6200a6100961009600000000000000000
000100000d4200e4200f4201143013430144401645031450304601c4601e4601f4703947024470294702f4703047027570295702c5702f5203251022570235700000000000000000000000000000000000000000
00020000000000e4700e4701147013470184701b4701d470114701247017470194701c47020470000001c4601f46024460274702947000000204402345027450294702a470014001d4601e46021440274302e420
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009000037555375413752137511253543134131331313250000000000000001a2000620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 44024344
01 01020344
00 44020344
02 04050344
01 47084944
01 07080a44
02 07480944
