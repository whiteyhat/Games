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

enstep_wait,enstep_walk,enstep_chase,enstep_patrol,enstep_gocenter,enstep_lightning=0,1,2,3,4,5

function settext(t,c,time,e)
	e.text,e.timer,e.c=t,time,c
	return e
end

function playerhurt(t)
	add(entities,settext(t,8,20,entity(etext,plx,ply-10,0,-1)))
	sfx(14+rnd(2),3)
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
	return sqrt(x*x+y*y+0.001)
end

function getbiglen(x,y)
	x,y=x*0.01,y*0.01
	return sqrt(x*x+y*y+0.00001)*100
end

function getcyldist(x,y,p0,p1)
	local x1,y1,cdx,cdy=x-p1.x,y-p1.y,p0.x-p1.x,p0.y-p1.y
	local cdlen,dist=getbiglen(cdx,cdy),0
	if cdlen<1 then
		dist=getbiglen(x1,y1)
	else
		cdx,cdy=cdx/cdlen,cdy/cdlen
		local dot=max(0,min(cdlen,cdx*x1+cdy*y1))
		dist=getbiglen(p1.x+dot*cdx-x,p1.y+dot*cdy-y)
	end
	return dist
end

function getrot(dx,dy)
	return dy >= 0 and (dx+3) * 0.25 or (1 - dx) * 0.25
end

function normgetrot(dx,dy)
	local l = 1/sqrt(dx*dx+dy*dy+0.001)
	return getrot(dx*l,dy*l)
end

function fillene(l)
	myplayer=entity(player,0,0,0,0)
	l.ene={myplayer}

	bosspart,bossstone={},0
	for i=1,6 do
		local ne={type=zombi,x=32*16+i*16,y=38*16,vx=0,vy=0,life=10,prot=0,lrot=0,panim=0,banim=0,dtim=0,step=0,ox=0,oy=0,num=i,size=(5-abs(i-2))*2}
		add(bosspart, ne)
		add(l.ene, ne)
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

function resetlevel()

	prot,lrot,panim,pstam,plife,blife,banim,coffx,coffy,time,frame  = 0,0,0,100,100,100,0,0,0,0,0
	lstam,llife,lblife,bossalive = pstam,plife,blife,true
	tooglemenu,invent,curitem,switchlevel,canswitchlevel=0,{},nil,false,false
	menuinvent,menumap=cmenu(inventary,invent),cmenu(scroll,{})

	local baserand=rnd(0xffffff)
	srand(1234)
	for i=0,15 do
		rndwat[i] = {}
		for j=0,15 do
			rndwat[i][j] = rnd(100)
		end
	end
	srand(baserand)

	island = createlevel(0,0,64,64,false,false)

	reload(0x1000,0x1000,0x2000,"pcraft2_main"..version..".p8")
	loadgame()
	reload()

	setlevel(island)

	plx,ply = 32*16,32*16
	clx,cly,cmx,cmy=plx,ply,plx,ply

	-- cheat, to remove

	--[[
	local tmpchest = entity(chest,plx+16,ply,0,0)
	tmpchest.hascol=true
	tmpchest.list = {}
	local itl = {haxe,pick,sword,shovel,scythe}
	for i=1,#itl do
		for j=1,5 do
			add(tmpchest.list, setpower(j, instc(itl[i])))
		end
	end
	add(entities,tmpchest)

	add(invent,instc(wood,540))
	add(invent,instc(stone,300))
	add(invent,instc(iron,300))
	add(invent,instc(wheat,300))
	add(invent,instc(gold,300))
	]]--
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
	--dset(1,plx)
	--dset(2,ply)
	dset(3,1)
	dset(4,1) -- is saved
	dset(5,plife)
	dset(18,489)

	save_px,save_py=96,0

	chests={}

	for i=96,127 do
		for j=0,63 do
			mset(i,j,0)
		end
	end

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
	savelevel(oldisland,chests)
	savelevel(oldcave,chests)

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

	--cstore(0, 0, 0x4300, "pcraft2_boss"..version)
	cstore()
end

function loadgame()

	setlevel(island)

	plx,ply,plife,save_px,save_py,chests=dget(1),dget(2),dget(5),96,0,{}
	if(plife<=0) plife=100
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
	oldcave,oldisland = createlevel(64,0,32,32,true,false),createlevel(0,0,64,64,false,false)

	loadlevel(oldisland,chests)
	loadlevel(oldcave,chests)

	-- chest content
	savenewline()
	local chestcount=saveget()
	for i=1,chestcount do
		local it,itemcount=chests[i],saveget()
		if it!=nil then
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
	end
	curmenu,curitem=nil,invent[1]
end

function _init()

	cartdata("nusan_pcraft"..version)

	dset(14,0)--789)
	gamestate = dget(0)
	permadeath = dget(19)>0

	menuitem(1, "new game", function() dset(0,0) load("pcraft2_generation"..version) end)

	music(7)

	-- boss behavior
	bossbehrnd={}
	--local bossbeh={{enstep_chase,10},{enstep_walk,10},{enstep_gocenter,5}}
	add(bossbehrnd,enstep_walk)
	add(bossbehrnd,enstep_gocenter)
	for i=1,12 do
		if rnd()>0.5 then add(bossbehrnd,enstep_walk) end
		for j=1,3+flr(rnd(4)) do add(bossbehrnd,enstep_chase) end
		if i%3==0 or rnd()>0.25 then add(bossbehrnd,enstep_gocenter) end
	end
	-- shuffle
	--[[for i=1,300 do
		local p0,p1=flr(rnd(#bossbehrnd)),flr(rnd(#bossbehrnd))
		bossbehrnd[p0],bossbehrnd[p1]=bossbehrnd[p1],bossbehrnd[p0]
	end]]

	resetlevel()
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
	--return not (gr.istree or gr==grrock or gr==grwater)
	return not (gr.istree or gr==grrock)
end

function getgr(x,y)
	local i,j = getmcoord(x,y)
	return getdirectgr(i,j)
end

function getdirectgr(i,j)
	if(i<0 or j<0 or i>=levelsx or j>=levelsy) return grounds[1]
	return grounds[mget(i+levelx,j)+1]
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

function loop(sel,l)
	local lp = #l
	return (((sel-1)%lp)+lp)%lp+1
end

function entcolfree(x,y,e)
	return max(abs(e.x-x),abs(e.y-y))>8
end

function reflectcol(x,y,dx,dy,checkfun,dp,e)

	local newx,newy = x + dx, y + dy
	local ccur,ctotal,chor,cver = checkfun(x,y,e),checkfun(newx,newy,e),checkfun(newx,y,e),checkfun(x,newy,e)

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
		gi.giveitem,gi.hascol,gi.timer = mat,true,nil
		--gi.timer = 110+rnd(20)
		add(entities,gi)
	end
end

function upground()

	local ci,cj = flr((clx-64)/16),flr((cly-64)/16)
	for i=ci,ci+8 do
		for j=cj,cj+8 do
			local gr = getdirectgr(i,j)
			if gr==grfarm then
				local d = dirgetdata(i,j,0)
				if time>d then
					mset(i+levelx,j,grsand.id)
				end
			end
		end
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

bossbehlast=1
function getnextbeh()
	bossbehlast=bossbehlast%#bossbehrnd+1
	return bossbehrnd[bossbehlast]
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

				elseif curmenu.type.becraft then

				elseif curmenu.list[curmenu.sel].type==disk then
					--savegame()
					--curmenu=nil
					--block5=true
					--sfx(16,3)
				else
					curitem = curmenu.list[curmenu.sel]
					del(curmenu.list,curitem)
					additeminlist(curmenu.list,curitem,1)
					curmenu.sel=1
					curmenu,block5=nil,true
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

	if switchlevel then
		-- win
		savegame()
		--cstore()
		dset(0,1)
		dset(14,789)
		load("pcraft2_main"..version)
		switchlevel=false
		canswitchlevel=false
	end

	if curitem then
		if(howmany(invent,curitem)<=0) curitem=nil
	end

	upground()

	local playhit = getgr(plx,ply)
	if(playhit!=lastground and playhit==grwater) sfx(11,3)
	lastground = playhit
	local s = (playhit==grwater or pstam<=0) and 1 or 2
	if playhit==grholeboss and not bossalive then
		switchlevel = switchlevel or canswitchlevel
	else
		canswitchlevel = true
	end

	if islightning and (playhit==grwater or playhit==grsand) and frame%8==0 then
		plife=max(0,plife-5)
		playerhurt(5)
	end

	local dx,dy,canact,fin = 0,0,true,#entities

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

	for i=fin,1,-1 do
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

	local ebx,eby,nearenemies = cos(prot),sin(prot),{}

	myplayer.x,myplayer.y=plx,ply

	if bossalive then
		for i=1,#bosspart do
			local bp=bosspart[i]
			local distp,disten,size = 0,0,bp.size
			if i>1 then
				local prevpart=bosspart[i-1]
				distp,disten,size = getcyldist(plx,ply,bp,prevpart),getcyldist(plx+ebx*8,ply+eby*8,bp,prevpart),max(size,prevpart.size)
			else
				distp,disten = getbiglen(bp.x-plx,bp.y-ply),getbiglen(bp.x-plx-ebx*8,bp.y-ply-eby*8)
			end
			if disten<size+10 then
				add(nearenemies,bp)
			end

			if bossstone<1 then
				if i==1 then
				  if bp.dtim<=0 then
				    if bp.step==enstep_wait or bp.step==enstep_patrol then
							bp.step=getnextbeh()
							if bp.step==enstep_chase then
								bp.vx,bp.vy,bp.dtim = (plx-bp.x)/distp*4,(ply-bp.y)/distp*4,30
							elseif bp.step==enstep_gocenter then
								bp.dtim = 120
							else
								bp.step,bp.vx,bp.vy,bp.dtim=enstep_walk,rnd()-0.5,rnd()-0.5,30+rnd(60)
							end
							sfx(19,3)
				    elseif bp.step==enstep_walk then
				      bp.step,bp.vx,bp.vy,bp.dtim=enstep_wait,0,0,10+rnd(30)
						elseif bp.step==enstep_gocenter then
							bp.step,bp.dtim=enstep_lightning,100
						elseif bp.step==enstep_lightning then
							bp.step,bp.dtim=enstep_wait,1
				    else -- chase
							bp.step,bp.dtim=enstep_wait,1
				    end
				  else
				    if bp.step==enstep_chase or bp.step==enstep_walk then
							bp.vx += rnd()-0.5
				      bp.vy += rnd()-0.5

							bp.vx *= 0.95
							bp.vy *= 0.95
						elseif bp.step==enstep_gocenter then
							bp.vx,bp.vy = (32*16 - bp.x) * 0.05, (38*16 - bp.y) * 0.05
						elseif bp.step==enstep_lightning then
							bp.x += (rnd()-0.5)*3
				      bp.y += (rnd()-0.5)*3
							bp.vx *= 0.95
							bp.vy *= 0.95
							if frame%8==4 then
								sfx(38,3)
							end
				    end
				    bp.dtim -= 1
				  end
					islightning=bp.step==enstep_lightning
				else
				  local pbp=bosspart[i-1]
				  local dx,dy=pbp.x-bp.x,pbp.y-bp.y
				  local dl = getbiglen(dx,dy)<10.0 and -0.0033 or 0.0033
				  bp.vx += dx*dl
				  bp.vy += dy*dl

					if bosspart[1].step==enstep_gocenter then
						bp.vx += (32*16 - bp.x) * 0.002
						bp.vy += (38*16 - bp.y) * 0.002
					end

				  bp.vx *= 0.95
				  bp.vy *= 0.95
				end

				local pow = 10
				bp.banim+=1
				if distp<size and bp.banim>16 then
					bp.banim=0
				  plife -= pow
					playerhurt(pow)
				  plife = max(0,plife)
				end

				bp.vx,bp.vy = reflectcol(bp.x,bp.y,bp.vx,bp.vy,isfreeenem,0)

				bp.x += bp.vx
				bp.y += bp.vy
			else
				islightning=false
			end
		end
	end
	if bossstone>0 then
		bossstone-=1
	end

	dx,dy = reflectcol(plx,ply,dx,dy,isfree,0)

	plx += dx
	ply += dy

	prot = uprot(lrot,prot)

	llife += max(-1,min(1,(plife-llife)))
	lblife += max(-1,min(1,(blife-lblife)))
	lstam += max(-1,min(1,(pstam-lstam)))

	if btn(4) and not block5 and canact then
		local hitx,hity = plx + cos(prot) * 8,ply + sin(prot) * 8
		local hit = getgr(hitx,hity)
		--[[if not lb5 and curitem and curitem.type.drop then
			if hit == grsand or hit == grgrass then
				if(not curitem.list) curitem.list={}
				curitem.hascol,curitem.x,curitem.y,curitem.vx,curitem.vy = true,flr(hitx/16)*16+8,flr(hity/16)*16+8,0,0
				add(entities,curitem)
				reminlist(invent,curitem)
				canact = false
			end
		end]]

		if banim==0 and pstam>0 and canact then
			banim,stamcost = 8,20
			if #nearenemies>0 and not (curitem and curitem.type.givelife) then
				sfx(19,3)
				local pow = 1
				if curitem and curitem.type==sword then
					pow,stamcost = 1+curitem.power+rnd(curitem.power*curitem.power),max(0,20-curitem.power*2)
					pow=flr(pow)
					sfx(14+rnd(2),3)
				end
				for i=1,#nearenemies do
					local e = nearenemies[i]
					local push = (pow-1)*0.5
					e.ox += max(-push,min(push,e.x-plx))
					e.oy += max(-push,min(push,e.y-ply))
					if i==1 then
						blife -= pow*0.1
						add(entities,settext(pow,9,20,entity(etext,e.x,e.y-10,0,-1)))
					end
				end
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
					if curitem.type==artifact then
						bossstone=200
						sfx(37,3)
					end
					if curitem.type==scroll then
						curmenu=menumap
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

	local m,msp = 16,4
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
	clx,cly = max(26*16,min(40*16,clx)),max(26*16,min(43*16,cly))

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

	if(blife<=0) then
		if bossalive then
			for j=1,#bosspart do
				local bp=bosspart[j]
				additem(bossgem,3,bp.x,bp.y)
			end
			islightning = false
			music(-1)
			sfx(29,1)
		end
		bossalive,bossstone,blife=false,100,0
	end

end

function mirror(rot)
	return ((rot>0.325 and rot<0.825) and 1 or 0),((rot<0.125 or rot>0.625) and 1 or 0)
end

function dplayer(x,y,rot,anim,subanim,isplayer)
	pal()

	local cr,sr,lan = cos(rot),sin(rot),sin(anim*2)*1.5
	local crlan,srlan,bel = cr*lan,sr*lan,getgr(x,y)
	x,y = flr(x),flr(y-4)
	plight,lightcol=false,flr(frame*.5)%2==0 and 10 or 7
	if bel==grwater or bel==grsand then
		plight=islightning
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
		local bcr,bsr,weap = cos(blade),sin(blade),75
		local mx,my = mirror(blade)

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
		if plight then
			pal(2,lightcol)
			pal(15,lightcol)
		end

	if bel!=grwater then
		circfill(x - sr*3 + crlan,y + cr*3 + srlan,3,plight and lightcol or 2)
		circfill(x + sr*3 - crlan,y - cr*3 - srlan,3)

		local my2,mx2 = mirror((rot+0.75)%1)
		spr(75,x - sr*4 + crlan -8+mx2*8 + 1, y + cr*4 + srlan + my2*8 - 7,1,1,mx2==0,my2==1)

	end

	circfill(x+cr,y+sr-2,4,plight and lightcol or 2)
	circfill(x+cr,y+sr,4)
	circfill(x+cr*1.5,y+sr*1.5-2,2.5,plight and lightcol or 15)
	circfill(x-cr,y-sr-3,3,plight and lightcol or 4)

end

level = {}

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

rndwat = {}

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
			local gr,gi,gj = getdirectgr(i,j),(i-ci)*2 + 64,(j-cj)*2 + 32
			if gr and gr.gr == 1 then -- sand
				local sv=0
				if(gr==grfarm or gr==grwheat) sv=3
				mset(gi,gj,rndsand(i,j)+sv)
				mset(gi+1,gj,rndsand(i+0.5,j)+sv)
				mset(gi,gj+1,rndsand(i,j+0.5)+sv)
				mset(gi+1,gj+1,rndsand(i+0.5,j+0.5)+sv)
			else

				local u,d,l,r = comp(i,j-1, gr),comp(i,j+1, gr),comp(i-1,j, gr),comp(i+1,j, gr)

				local b = gr==grrock and 21 or gr==grwater and 26 or 16

				mset(gi,gj,b + (l and (u and (comp(i-1,j-1, gr) and 17+rndcenter(i,j) or 20) or 1) or (u and 16 or 0)) )
				mset(gi+1,gj,b + (r and (u and (comp(i+1,j-1, gr) and 17+rndcenter(i+0.5,j) or 19) or 1) or (u and 18 or 2)) )
				mset(gi,gj+1,b + (l and (d and (comp(i-1,j+1, gr) and 17+rndcenter(i,j+0.5) or 4) or 33) or (d and 16 or 32)) )
				mset(gi+1,gj+1,b + (r and (d and (comp(i+1,j+1, gr) and 17+rndcenter(i+0.5,j+0.5) or 3) or 33) or (d and 18 or 34)) )

			end
		end
	end

	pal()


	map(64,32,ci*16,cj*16,18,18)

	pal()

	for i=ci-1,ci+8 do
		for j=cj-1,cj+8 do
			local gr = getdirectgr(i,j)
			if gr then
				local gi,gj = i*16,j*16
				pal()
				--[[
				if gr==grwater or gr==grsand then
					if(gr==grsand) pal(1,13)
					watanim(i,j)
					watanim(i+0.5,j)
					watanim(i,j+0.5)
					watanim(i+0.5,j+0.5)
				end
				]]
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
			end
		end
	end
end

function drawsplaches()
	local ci,cj = flr((clx-64)/16),flr((cly-64)/16)

	for i=ci-1,ci+8 do
		for j=cj-1,cj+8 do
			pal()
			local gr = getdirectgr(i,j)
			if gr==grwater or gr==grsand then
				local gi,gj = i*16,j*16
				if(gr==grsand) pal(1,13)
				if(islightning) pal(1,10)
				watanim(i,j)
				watanim(i+0.5,j)
				watanim(i,j+0.5)
				watanim(i+0.5,j+0.5)
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

function printb(t,x,y,c)
	print(t,x+1,y,1)
	print(t,x-1,y)
	print(t,x,y+1)
	print(t,x,y-1)
	print(t,x,y,c)
end

function printc(t,x,y,c)
	print(t,x-#t*2,y,c)
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
		local t1 = t[i]
		local t2 = t[i+1]
		if t1.y > t2.y then
			t[i] = t2
			t[i+1] = t1
		end
	end
end

function dsnakepart(drawgr,c,sm,mm)
	for i=#bosspart,1,-1 do
		local e,last = bosspart[i],i==(#bosspart-1)
		--pal(3,4)
		local s=e.size+sm
		if i<#bosspart then
			local pbp=bosspart[i+1]
			local s2,dx,dy,len=last and sm or pbp.size+sm,pbp.x-e.x,pbp.y-e.y,last and 60 or 30
			dx,dy=dx/len,dy/len
			for j=len,1,-4 do
				--circfill(e.x+dx*j,e.y+dy*j,s+1,0)
				local spx,spy,cs=e.x+dx*j,e.y+dy*j,lerp(s,s2,j/len)
				--local terrain=grgrass
				local terrain=getgr(spx,spy).gr
				if terrain==drawgr then
					circfill(spx,spy,cs,c+flr(j/10)%mm)
				end
				--circfill(,s,flr(j/6)%2+1)
			end
		end
	end
end

function sprhead(n,head,dx,dy,s)
	spr(n,head.x+lastbdy*dx+lastbdx*dy-s,head.y-lastbdx*dx+lastbdy*dy-s)
end

function sprheadrot(n,head,dx,dy,s)
	local mx,my=lastbdx<0,lastbdy>0
	spr(n,head.x+lastbdy*dx+lastbdx*dy+(mx and -s*2 or 0),head.y-lastbdx*dx+lastbdy*dy+(my and 0 or -s*2),s/4,s/4,mx,my)
end

function dbosshead(head,issub)

	local prev=bosspart[2]
	if issub or bossstone>0 then
		local pc=bossstone<1 and (islightning and 10 or 1) or 5
		for i=0,15 do
			pal(i,pc)
		end
	end
	--circfill(head.x,head.y,11,0)
	circfill(head.x,head.y,10,3)
	local dx,dy=head.x-prev.x,head.y-prev.y
	local blen=getlen(dx,dy)
	if blen>1 then
		lastbdx,lastbdy=dx/blen,dy/blen
	end
	local perpx,perpy=lastbdy,-lastbdx

	sprheadrot(110,head,0,9,4)
	sprheadrot(110,head,4,7,4)
	sprheadrot(110,head,-4,7,4)
	sprheadrot(110,head,7,4,4)
	sprheadrot(110,head,-7,4,4)

	sprhead(111,head,4,-4,4)
	sprhead(111,head,-4,-4,4)

	sprhead(126,head,5,6,4)
	sprhead(127,head,-5,6,4)
	sprhead(126,head,0,7,4)
	sprhead(126,head,8,1,4)
	sprhead(127,head,-8,1,4)
	sprhead(127,head,0,1,4)

	sprhead(127,head,-4,-9,4)
	sprhead(127,head,4,-9,4)

	--sprheadrot(78,head.x,head.y,4,-8,4)
	--sprheadrot(78,head.x,head.y,-4,-8,4)

	pal()
end

function dbosstail(tail,issubtail)
	local prev=bosspart[#bosspart-1]
	local dx,dy=tail.x-prev.x,tail.y-prev.y
	local blen=getlen(dx,dy)
	if blen>1 then
		lasttdx,lasttdy=dx/blen,dy/blen
	end

	if issubtail or bossstone>0 then
		local pc=bossstone<1 and (islightning and 10 or 1) or 5
		for i=0,11 do
			pal(i,pc)
		end
	end

	local mx,my=lasttdx<0,lasttdy>0
	spr(108,tail.x+(mx and -16 or 0),tail.y+(my and 0 or -16),2,2,mx,my)

	pal()
end

function denemies()
	--sorty(enemies)
	pal()

	local head=bosspart[1]
	local tail=bosspart[#bosspart]
	local issub=getgr(head.x,head.y).gr!=2
	local issubtail=getgr(tail.x,tail.y)!=2

	local edgecolor = islightning and 7 or 2
	dsnakepart(0,edgecolor,2,1)
	dsnakepart(1,edgecolor,2,1)

	if issubtail then
		dbosstail(tail,issubtail)
	end
	if issub then
		dbosshead(head,issub)
	end
	local ccc=bossstone>0 and 5 or (islightning and 10 or 1)
	local mod=(islightning and flr(frame/2)%2==0) and 2 or 1
	dsnakepart(0,ccc,1,mod)
	dsnakepart(1,ccc,1,mod)

	drawsplaches()

	if not issubtail then
		dbosstail(tail,issubtail)
	end

	if bossalive then dplayer(plx,ply,prot,panim,banim,true) end

	dsnakepart(2,0,2,1)
	dsnakepart(2,bossstone>0 and 5 or 3,1,2)

	if not issub then
		dbosshead(head,issub)
	end
	--dbosshead(head,false)

	if not bossalive then
		local gi,gj=32*16,32*16
		pal()
		circfill(gi+8,gj+12,7 + abs((time*6)%5-2),10)
		circfill(gi+8,gj+12,5,15)
		spr(77,gi+4,gj,1,2)
	end

	if not bossalive then dplayer(plx,ply,prot,panim,banim,true) end
	--[[for i=1,#nearenemies do
		local cur=nearenemies[i]
		circ(cur.x,cur.y,cur.size,7)
	end]]

end

function dbar(px,py,v,m,c,c2)
	pal()
	local pe = px+v*0.3
	local pe2 = px+m*0.3
	rectfill(px-1,py-1,px+30,py+4,0)
	rectfill(px,py,pe,py+3,c2)
	rectfill(px,py,max(px,pe-1),py+2,c)
	if(m>v) rectfill(pe+1,py,pe2,py+3,10)
end

function dbossbar(v,m)
	pal()
	local px,py=14,120
	local pe,pe2 = px+v,px+m
	rectfill(px-1,py-1,px+101,py+4,0)
	rectfill(px,py,pe,py+3,2)
	rectfill(px,py,max(px,pe-1),py+2,8)
	if(m>v) rectfill(pe+1,py,pe2,py+3,10)
end

function _draw()

	cls()

	camera(clx-64, cly-64)

	drawback()

	denemies()

	dent()

	camera()

	if isinlist(invent,instc(artifact)) and frame<120 then
		local py=16
		rectfill(0,py,127,py+16,0)
		printb("you feel the talisman",26,py+2,7)
		printb("pulsing with power",28,py+10,7)
	else

		dbar(4,4,plife,llife,8,2)
		dbar(4,9,max(0,pstam),lstam,11,3)

		if lblife>0 then
			dbossbar(blife,lblife)
			printb("giant sea eel",40,112,7)
		end

		if curitem then
			local ix = 35
			local iy = 3
			itemname(ix+1,iy+3,curitem,7)
			if curitem.count then
				local c = ""..curitem.count
				print(c,ix+88-16,iy+3,7)
			end
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

		else
			list(curmenu,4,24,84,96,10)
		end
		if curmenu==menumap then
			rectfill(13,43,78,108,9)
			rect(13,43,78,108,4)
			local pp,dx={15,7,6,7,15,2,2,0,0,0,14,4,4},levelx*.25
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

	--print(""..(oldcave!=nil and #oldcave.ent or -1),0,0,8)
	--[[print(""..#chests,0,0,8)
	for i=1,#chests do
		local cur=chests[i]
		print(" "..#cur.list,0,i*6,8)
	end]]
	--print(bosspart[1].step,0,0,7)
	--[[if(false) then
		print("cpu "..flr(stat(1)*100),96,0,8)
		print("ram "..flr(stat(0)),96,8,8)
	end]]

end

__gfx__
00aaaa001111111111111111111111114444444444fff44ffff44fff020121000004200002031000166666610099944000111100000000000001000000101000
0a2888a011111111111111111111111144444444ff4ffff4ff4fffff31031020030310204142000016eeee610995594401aaaa10000100000011100001000100
a288878a11121111121111111121111144444444fff444ff44fff44f20520002400200103031041016eeee61995995941a9999a1001110000110110010000100
a288888a11111111111111211111111144444444ff4fff44fff44ff415340401340100402020030216eeee619595559919899891000100000011100000000000
9a2888a911111111111111111111112144444444ffffffffffffffff42424303230040341014020116eeee619595995919922991000000000001000001100100
09a22a9011111111112111111111111144444444ff44fff444fff44f313132021240302300034104166666614959959912922921000000000000000000010000
009aa9001111211111111111111111114444444444ff444fff444fff002021404130201204023003167777614495599001211210000000000000000000000000
0009900011111111111111111111111144444444ffffffffffffffff001010000020100003012040166666100449990000100100000000000000000000000000
11111001111111111001111144244444444444441100001111000011110000118808808888088088111112222211112222221111dddddddddddddddd11111111
11100220011111000220011142024444444444241055500000555500000555018808808888088088112222222222222222222211dddddddddddddddd11111111
11022442201110222442201120244444444442020505505550555505550550200000008888000000122222222222222222222221dddddddddddddddd11111666
10244444420002444444490120244444442420240550505550000005550502208800220000220088222211111222222112222221dddddddddddddddd11166666
102444442022202444444901420244444202202405550000000880000000222088020022220050882211ddddd111111dd1222221dddddddddddddddd1116dddd
1024444202444202444449014424424442024202000008888808808888800000000202022050500021dddddddddddddddd122222dddddd1111dddddd116ddddd
0244444424444424444444904444202990244202105508888808808888802201888020000005088821ddddddddddddddddd11222ddddd122221ddddd11dddddd
0244444444444444442444904444429002444424105508888808808888802201888022011055088821ddddddddddddddddddd112ddddd121121ddddd11dd5555
1024424444444444420249014444449002244444105508888800008888802201888022011055088821dddddddddddddddddddd12ddddd122221ddddd11d55555
1024202444444444442090114444420220024244100008888088880888800001888020000005088821dddddddddddddddddddd12dddd12222221dddd11551111
11020244444444444449011142442024422440240550000008088080000002200002020550505000221dddddddddddddddddd121dddd12222221dddd11511111
11102444444442444449011120224244444422020550888808800880888802208802005555005088121dddddddddddddddddd121ddd1222112221ddd11111000
11102444444420244449011142002444444442020550888808800880888802208800550000550088121dddddddddddddddddd121dddd111dd111dddd11110000
11102444444442444420901144220244444420240550000008088080000002200000008888000000221dddddddddddddddddd121dddddddddddddddd11110000
1102024444444444420249014442024444444244100008888088880888800001880880888808808821dddddddddddddddddddd12dddddddddddddddd11111111
1024202444444444442449014444244444444444105508888800008888802201880880888808808821dddddddddddddddddddd12dddddddddddddddd11111111
1024424444444444444449014444444444244444105508888808808888802201880000888800008821ddddddddddddddddddd112dddddddddddddddd00000000
02444444424444424444449044444444420244441055088888088088888022018088880880800808221dddddddddddddddd11222dddddddddddddddd01111000
024444442024442024444490442444244424444400000888880880888880000008000080080880801221dddddddddddddd122221dddddddddddddddd01aaa100
1024444442099902444449014202420244444224055500000008800000002220080880800088880011221dddddddddddd1222221dddddddddddddddd12999a10
102444444490009444444901202444244244200205502022200000022202022008088080008888001112211ddd1111ddd1222111dddddddddddddddd02299210
11099944990111094499901142442444202442240502202220222202220220200800008008088080111222211122221112221111dddddddddddddddd00129210
11100099001111109900011144420244420244441022200000222200000222018088880880800808111122222211112222221111dddddddddddddddd00212100
11111100111111110011111144442444442444441100001111000011110000118800008888000088111111111111111111111111dddddddddddddddd00001000
00000000222020000011111111111100001dd000000282000000770001400000000004100012022001000010000000000011a8610000000000b02200bbb00000
0000000024224200011dddddddddd11001d1110000282820000777700124006006004210012e12ee141111410000000011e1bec100900900bb528820333b0000
000000022422420011d1111111111d111d11111002828282007777770012441441442100122e11e1124444210000000016e1bec100400400351877823333b000
00020024244342001d111111111111d11d1111102828282807777775140122522522104112ee1122412222140011000011113251004444003518a78233333b00
00022024334344201d111111111111d11d1111108282828277777750124111611611142112eee1212444444202ff1000999999990040040033518820333bbbb0
00024244434434201d111111111111d101d1110008282820577775000124441441444210222eee114222222422ff100054111145002442003335115b33bb222b
00224334443434201d111111111111d1001dd000028282000577500000122252252221002222221024111142222200005411114500200200333355b03b22822b
02344433344444201d111111111111d100000000002020000055000014111151151111411221110002444420222000005411114500222200333333b03b28782b
02334444434444201d111111111111d11010101006111600417710211241116116111421222222220d1dd1d006666660444444440020020013b8222b332283b3
24434334443344421d111111111111d1010101010061600017777142012444144144421023333332d515515d15666dd549999994002222001533bb3333b3b3b3
23444434444444201d111111111111d1101010100623260077771442001222522522210023333332511111150155ddd549999994001111001563b333b3bb3bb5
02344333444443201d111111111111d101010101623432607774142100141151151141002222222211a9e9110015dd50444444440010010015765333bb3b3565
00234444334432001d111111111111d1101010106333336017114421001241611614210055555555119e8a110001d5005559955500111100015756353b365675
012333344333221011d1111111111d11010101016233326001444210000124144142100051111115111111110001500054455445001001000011576576575751
0112222222221110011dddddddddd110101010100623260024422100000012222221000051111115156556510054210054444445001001000000157557555110
00011111111110000011111111111100010101010066600012211000000001111110000051111115011111100542121055555555000000000000011111111000
0020000000000000000000000000001100000000000011110111100000001f100222222222222220000001111100000000000000000000030000067700111100
024202000000200000002200000001410000111000001441144441000001fff10233333333333320001111565111100000000000000003300000776001222210
02442420000220000002341000001410000144410001444101111410001ffff4023333333333332001ddd1d1d1ddd10000000000000339300007765012288221
0244344422242020000244410001410000023441000234110002314101ffff41023333333333332001ddd15651ddd10000000000003993000077650012877821
2434434442444242002324410014100000232141002321000023214119fff410023333333333332001ddd1d1d1ddd10000000000339a930008fe500012877821
24434344344444420232441002410000023201410232000002320141019f4100023333333333332001ddd15651ddd1000000000399a9300028e8500012288221
24434444434443202320110023200000232000102320000023200141001910000233333333333320011111d1d111110000000039779300008885000001222210
234444434433432032000000320000003200000032000000020000100001000002333333333333201dddd15651dddd10000003977a9300002820000000111100
023444434343322000555000000005000000400005555d500002220000001220022222222222222015555155515555100000397aa930000000bbbb0000bbbb00
02324443432220000511150000505b50001242205000d6d5012343200001234205555555555555501511111111111510000b97aa930000000bb333b00b33b3b0
00202344320000005111115005b5b735012242e2500d676d1234343200123432055555555555555015191a181a19151000b9aaa930000000b353b33bb333533b
0000023444200000511111155b73535012282efe5000d6d50123434201234321051000000000015015121812181215100b9aaa9500000000b333533bb33b333b
0000002433200000511111150535b5001288efe250000d05123433211234321005110101010101501511511111511510bb9aa9500000000053b3333553353335
000012333211000005111115005b735001288e8250000005123322321233210005101010101011501551615551615510bb39950000000000555333555533b355
00012222222210000055115000053500001288205000000501221121012210000511010101010150115515555515511003355000000000000553355005535550
00001111111100000000550000005000000122000555555000110010001100000510101010101150011111111111110000550000000000000055550000555500
0030003010101010101030003000000000000000000030101010000010102020e020201000000020202020300000000000000000000030101030101030103000
d3b2d3d2b1b1b1b1e2d3d3c2203030301030101010a0a0a030801010101010a00000000000000000000000000000000000000000000000000000000000000000
00300000301010101030000030000000000000000000301010000000000000202020000000000000202020300000000000000000003010103010103010103000
d3e3d3b2d3b2d3d3d3d1b3c320302010102010a0a0a010a080801010101010100000000000000000000000000000000000000000000000000000000000000000
00300000003030303000000030000000000030303030301010000000000000002000000000000000102020303030303000000000003010301010301010300000
d3b2e3e3e3d3e3b2b2c22030302020101030901010a010a010309010101010100000000000000000000000000000000000000000000000000000000000000000
00300000000030300000000030000000000030301030302010000000000000000000000000000000101020303030303000000000000030101030101030000000
e3d3b2d1b3b3e1e3d3c230101020301020109010a010101080801010a01010a00000000000000000000000000000000000000000000000000000000000000000
00300000000030300000000030000000003030101010302010000000000000000000000000000000001010303030303000000000003010103010103030000000
e3e3e3c20121a2b2e3c2102010300111111130801010101030801010101010100000000000000000000000000000000000000000000000000000000000000000
00300000000030300000000030000000301030301030302020000000000000000000000000000000001010303030303030000000003010301010301030000000
b3b3b3c30222a3b3b3c3301010300243433330303080a030301010a0101010100000000000000000000000000000000000000000000000000000000000000000
00300000000030300000000030000030101030303030302020000000000000000000000000000000001010303030303010300000000030101030101030000000
101001114232112120203010101002333333303030303030801010a01010b0100000000000000000000000000000000000000000000000000000000000000000
00300000003000003000000030003010101030000000302020200000000000000000000000000000101020303030303010103000003010103010101030000000
10200231131341223020201020300313131330303030303080101010101010100000000000000000000000000000000000000000000000000000000000000000
00303030300000000030303030003010103000000000302020202020000000000000000000000010202020300000003010101030003010301010101010300000
011142222010023211213020a1b1b1b1b1c130808080303080a01010101010100000000000000000000000000000000000000000000000000000000000000000
00301010300000000030101030003010103000000000302020202020200000000000000000101020202020300000000030101030000030101010101010300000
031341223020023113232030a2e3d3e3d3c290101080303080a09090101080800000000000000000000000000000000000000000000000000000000000000000
00301010300000000030101030000030300000000000302020202020202010101000000010102020202020300000000030101030003010101010101010103000
b1c1023211114222a1b1b1b1e2b2e3b2e3d290101010803080909090108030300000000000000000000000000000000000000000000000000000000000000000
00303030303030303030303030000000000000000030303030303030303020101010101010303030303030303000000000303000003000000000000000003000
d3c2031341311323a2d3e3e3b2b2b2b2d3b230308080303030909090108080300000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000030103030301030303020202010102020303030103030303000000000000000000030303030303030300000
b2d2b1c10222a1b1e2e3e3b2b2b2b2d3b2d330303030303030109090101010800000000000000000000000000000000000000000000000000000000000000000
00000030303030000000000000000000000000000030303030303030303020202020202020303010303030103000000000000000000000000000000000000000
b2b2b2c20323a2b2e3b2e3b2d3b2b2d3b2b230303030303030309080a010a0100000000000000000000000000000000000000000000000000000000000000000
00003000000000300000000000000000000000000030303010303030103030303030303030301030303010303000000000000000300000303030000030000000
b2e3d3d2b1b1e2d3e3d3d3e3e3e3e3d3b2e38080803030303030308010a010100000000000000000000000000000000000000000000000000000000000000000
00300000000000003000000000000000000000000030303030303030303010103030301010303030303030303000000000000030003030002000303000300000
b2d3d3d3e3b2b2b2d3b2b2d3b2d3e3b2b2d330303030303030303030801010a00000000000000000000000000000000000000000000000000000000000000000
00300000000000003000000000000000000000000000301010300000000000000000000000000000301010300000000000000000300000202020000030000000
d3b2d3b2b2b2d3d3d3d3d3d3e3b2b2b2d3b230303030803030303000000000000000000000000000000000000000000000000000000000000000000000000000
00003000003000003000303030303000000030303030101010103000000000000000000000000030101010103030303000000000300000202020000030000000
d3e3d3b2d3b2d3d3d3e3e3e3e3b2e3d3d3e330303080803030303000000000000000000000000000000000000000000000000000000000000000000000000000
00000030300000003030202030202030003010101010101010103000000000000000000000000030101010101010101030000030002020002000202000300000
10100000000000000000000000003030303080808080103030303000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003020202020202020303010101010101010103000000000000000000000000030101010101010101030000030202020200020202020300000
00000000000000000000000000003030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003030303020202020202020300030303030303030300000000000000000000000000000303030303030303000000030002020002000202000300000
00000000000000000000000000003030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000
00003030301010103020202020202020300000000000000000000000000000000000000000000000000000000000000000000000300000002000000030000000
00000000000000000000000000003030303030303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000
00301010101010101030202020202030000000000000000000000000000000000000000000000000000000000000000000000000300020202020200030000000
0000000000000000000000000000b1b1b1b1b1c12010203002124300000000000000000000000000000000000000000000000000000000000000000000000000
30101010101010101010302020203000000000000000000000000000000000000000000000000000000000000000000000000030003030000000303000300000
0000100000000000000000000000e3b2b2b2e3c23020202002333300000000000000000000000000000000000000000000000000000000000000000000000000
30101010101010101010103020300000000000000000000000000000000000000000000000000000000000000000000000000000300000303030000030000000
0000100000000000000000000000e3b2b2e3e3d2b1c1101002124300000000000000000000000000000000000000000000000000000000000000000000000000
30101010101010101010103030303030300000000000303030303030303030303030303030300000000000000000000000000000000000000000000000000000
0000100000000000000000000000d3d1b3b3e1d3d3c2203002311300000000000000000000000000000000000000000000000000000000000000000000000000
30101010101010101010300000000000003000000030303030303030303030303030303030303000003000003000300030003030300030303000300000300000
0000100000000000000000000000e3c21030a2b2e3d2b1c102223000000000000000000000000000000000000000000000000000000000000000000000000000
00301010101010101030000000003030000030003030303010303030303030303030301030303030003030003000300030003000000030003000303000300000
0000100000000000000000000000d3c21030a2e3e3d1b3c302223000000000000000000000000000000000000000000000000000000000000000000000000000
00003010101010101030000000300000000030003030301030101010101010101010103010303030003000303000300030003030300030303000300030300000
0000000000000000000000000000e3d2b1b1e2e3d3c2011142321100100000000000000000000000000000000000000000000000000000000000000000000000
00000030101010101030000000300000000030003030303010303030303030303030301030303030003000003000300030000000300030003000300000300000
0000000000000000000000000000e1b2b2d3e3d1b3c3023312331210400000000000000000000000000000000000000000000000000000000000000000000000
00000000303010103000000000003030303000000030303030303030303030303030303030303000003000003000303030003030300030003000300000300000
0000000000000000000000000000a2d3b2e3b2c20111423312331200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000030300000000000000000000000000000303030303030303030303030303030300000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101000000000000000003030303030303030303030303030303030303030303030303030303030303030f0205ff19ffc10505ff11ffff26ffff0101ff10ffff17ffff13ffff0aff0206
000000000000000003030303000000000000000003030000000000000000000000000000000000000000000303000000000000000001010100000000000000000303030303030303030303030303030303030303030303030303030303030303ff0c1effff0cff130fff031dff11000000000000000000000000000000000000
0000000000000303010101010303000000000003000003000000000003030300000003030300000000000300000300000000000001030303010000000000000003030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0000000000030101000000000101030000000300000000030000030300000003000300000003030000030000000003000000000103000000030100000000000003030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0000000003010100000202000001010300030000000000000303000000000000030000000000000303000000000000030000010300000200000301000000000003030308010803030303030303030303030303030303030303080808010303030000000000000000000000000000000000000000000000000000000000000000
0000000003010000020202020000010300030000000000000000000000000000000000000000000000000000000000030001030000020202000003010000000003030303080803030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0000000301000002020202020200000103000300000000000000000000000000000000000000000000000000000003010103000002020202020000030101000003030303030303030303080801010803030808080108030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0000000301000202020202020202000103000003000000000000000000000000000000000000000000000000000300010103000202020202020200030101000003030303030303030308010a0101010a0a0101010101010803080303030303030000000000000000000000000000000000000000000000000000000000000000
000000030100020202020202020200010300000000000000000000000000000000000000000000000000000000000001010300000202020202000003010100000303030303030303080a010101010101010101010101010101010101010303030000000000000000000000000000000000000000000000000000000000000000
000000030100000202000002020000010300000000000000000000000000000000000000000000000000000000000000000103000002020200000301000000000303030303030303030a010a0a010a01010101010a010a010a010108030303030000000000000000000000000000000000000000000000000000000000000000
000000000301000000020200000001030000000000000000000000000000030303030302000000000000000000000000000001030000020000030100000000000303030303030303030801010a0101010101010a0101010101010303030303030000000000000000000000000000000000000000000000000000000000000000
0000000003010100020202020001010300000000000000000000000000030101010101030200000000000000000000000000000103000000030100000000000003030303010803030303080a0a01010a010101010a01010101080303030303030000000000000000000000000000000000000000000000000000000000000000
0000000000030101000000000101030000000000000000000000000003010101010101010302000000000000000000000000000001030303010000000000000003030308010108030803030308010101090101010801010a09030303030303030000000000000000000000000000000000000000000000000000000000000000
0000000000000303010101010303000000000000000000000000000003010101010101010103020000000000000000000000000000010101000000000000000003030303010108030303080a01010a0109010a01010101010a030303030303030000000000000000000000000000000000000000000000000000000000000000
000000000000000003030303000000000000000000000000000000000301030303010101010103020000000000000000000000000001010100000000000000000303030301010808030101010101010a090101010101010a01030303030303030000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000003030101010101010201010302020000000000000000000000000000000000000000000000030303030908010a010a010909090901010101010a01010101030303030303030000000000000000000000000000000000000000000000000000000000000000
00030303030303030303030303000000000000000000000000000003010101010101010201010302020200000000000000000000000003030303030303030000030303030309010101010909090909010b0101010101010101030303030303030000000000000000000000000000000000000000000000000000000000000000
0003010103000000000301010300000000000000000000000000030303010101010101020101030202020000000000000000000000030101010101010301030003030303030308010101090909090901010101010a01010101080303030303030000000000000000000000000000000000000000000000000000000000000000
00030101030000000003010103000000000000000000000000000000030202020101010201010302020202000000000000000000000301010101010301010300030303030303030101010109090909010101010101010101010a0303030303030000000000000000000000000000000000000000000000000000000000000000
00030303030000000003030303000000000000000000000000000000030202030202020101030202020202000000000000000000000003010101030101030000030303030303030a010101010101010101010101010a010a010a0303030303030000000000000000000000000000000000000000000000000000000000000000
000300000003000003000000030000000000000000000000000000000303030202020201010302020202020000000000000000000000030101030101030103000303030303030301010101010a0a010a08080101010a010a01010803030303030000000000000000000000000000000000000000000000000000000000000000
000300000000030300000000030000000000000000000000000000000003020202020101030202020202020000000000000000000000000303010103010103000303030303030301010101010a01010a080808080a01010101010303030303030000000000000000000000000000000000000000000000000000000000000000
00030000000003030000000003000000000000000000000000010303030303030303030303030303020202000000000000000000000000030101030101030000030303030303030a010101010a0a010a010803030308010101080303030303030000000000000000000000000000000000000000000000000000000000000000
0003000000000303000000000300000000000000000000000101030302020202010101020202030301020000000000000000000000000301010301010301030003030303030308010101010a0a0a0a0a010803030303030808030303030303030000000000000000000000000000000000000000000000000000000000000000
00030000000003030000000003000000000000000000000001010302020202010101020202020203010100000000000000000000000301010301010301010300030303030308080a0101010101010101010803030909030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003000000030303030000000300000000000000000000010102030201010100000000010201010302010100000000000000000000030103010103010103000003030303030308080808010a0a0a0101010803030903030303030303030303030000000000000000000000000000000000000000000000000000000000000000
000300000301010101030000030000000000000000000101020203010101000003030000010101030202010100000000000000000000030101030101030103000303030303030303030303030303080a010803030903030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003000301010101010103000300000000000000000003030303030101000000030300000101010303030303000000000000000000030101030101030101030003030303030303030303030303030308010303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003030101010101010101030300000000000000000003030303030101000000000000000101010303030303000000000000000000030103010103010103000003030303030303030303030303030303010303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003010101010101010101010300000000000000000003020202020100000000000000010101010202020203000000000000000000000301010301010301030003030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003010101010101010101010300000000000000000003020202020100000000020000010102020202020203000000000000000000030101030101030101030003030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
0003030101010101010101030300000000000000000003020102010101010102020201010102020202020203000000000000000000030103010103010103000003030303030303030303030303030303030303030303030303030303030303030000000000000000000000000000000000000000000000000000000000000000
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
011000201215212142121321414516155141651215512165141421415214142161350f1551114514155121650f155121450f15512135141551614216142161320f15516165121550f15516145121551416516155
01100020063340633006330063350a3340a3351233412335083340833008330083350f3340f33508334083350333403330033300333508334083350a3340a335033340333003330033350a3340a3300a3300a335
00100020056350000005635000001b635000050000200002056350000005635000001b635000003463533645056350000005635000001b635366153462533635056350000005635000001b635000003463533645
0020002024757217471e7371b7272a75727747247372272724757217471e7371b7271f7571d7471a7371872724757217471e7371b7272a757277472473722727307572d7472a737277272b757297472673724727
0140002022375213751f3751b3751a3721a37524200172001e355223551e3521e355242001f3751b3721e3551f3751b3751a375223752137221375242001720022355213751b3721b3751e355223552135221355
0040002021175221651f15522175211721e15500000000001b1551e1451b1521b135181521a145161521613521175221651f17522155241722215500100001001f1551e1451b1521b165181521a1451616216155
01100020056553664505655346651b6553664534665336750565533675056551b6551b655366453466533675056653667505645346551b6753666534645336550567533665056551b6451b665366753466533655
0107000004030040700407005070060600706008050090500a0400a0400b0400d0400e0400f040110401403015030180301b0301f0302202025020290202f020380303c0443c0513c0413c0313c0213c0123c000
011600200645506452126350000006455000001263500000064550645212635000000645500000126350000006455064521263500000064550000012635000000645506452126350000006455064001263512635
01160020124651245512441124111d452184541843218412244542442223454234221f4521d4541d4221d4121325516255182551f2552e2552b252242451f2321b225182551b2551b2552e2552b2422923527212
011600201f1541f1511f1411f1311f1211f1111f1001f102271542715127141271312712127111271002710218154181511814118131181211811118100181022215422152221522215227144241442413224112
011600200061509625086550864501635076250c65506635076550c63507625096450d6350a65506625006350b615066550663508625076150b6550c635076450a6150f655096350d65508625086350661507625
01160020124651245512441124111d452184541843218412244542442223454234221f4521d4541d4221d412302552e2452b2322e2552b24529232302552e2452b232292252b245292322e2552b2452923527212
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a0000274121e4121e4221e43237442304523046230462374622b4622b4622b462334622746227462274622c4621d4421d4321d4222043216432164221641222402164021f4021640216402164021b40200302
0003000004615076350b6451165517655196551c6551f645206452264523645236352463523645236452263521635206351f6351e6351c6351b6251a62518625166151561513615116150e6150a6150761505615
0009000037555375413752137511253543134131331313250000000000000001a2000620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 44024344
01 01020344
00 44020344
02 04050344
01 47084944
01 07080a44
02 07480944
03 18191b44
01 1e204344
00 1e204344
00 1e1f4344
00 1e1f4344
00 211f4344
02 21224344

