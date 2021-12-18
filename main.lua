require("api.plugin") -- Called for plugin system

--utf8 = require "utf8"
api = require "api/api"
cells,delay,dtime,currentstate,currentrot,tex,zoom,offx,offy,placecells,interpolate,inmenu,tpu,updatekey,dodebug,itime,initial,isinitial,
paused,placeables,newwidth,newheight,showinstructions,chunks,ticknum,selecting,volume,copied,selx,sely,selw,selh,pasting,undocells,page,border,wasinitial,typing,subtick,supdatekey =
{},0.2,0,1,0,{},20,0,0,true,true,false,1,0,false,0,{},true,true,{},100,100,true,{},0,false,0.5,nil,0,0,0,0,false,nil,1,2,true,false,false,0
width,height = 102,102
love.graphics.setDefaultFilter("nearest")
tex[-2],tex[-1],tex[0] = love.graphics.newImage("textures/placeable.png"),love.graphics.newImage("textures/wall.png"),love.graphics.newImage("textures/bg.png")
tex[1],tex[2],tex[3] = love.graphics.newImage("textures/mover.png"),love.graphics.newImage("textures/generator.png"),love.graphics.newImage("textures/push.png")
tex[4],tex[5],tex[6] = love.graphics.newImage("textures/slide.png"),love.graphics.newImage("textures/onedirectional.png"),love.graphics.newImage("textures/twodirectional.png")
tex[7],tex[8],tex[9] = love.graphics.newImage("textures/threedirectional.png"),love.graphics.newImage("textures/rotator_cw.png"),love.graphics.newImage("textures/rotator_ccw.png")
tex[10],tex[11],tex[12] = love.graphics.newImage("textures/rotator_180.png"),love.graphics.newImage("textures/trash.png"),love.graphics.newImage("textures/enemy.png")
tex[13],tex[14],tex[15] = love.graphics.newImage("textures/puller.png"),love.graphics.newImage("textures/mirror.png"),love.graphics.newImage("textures/diverger.png")
tex[16],tex[17],tex[18] = love.graphics.newImage("textures/redirector.png"),love.graphics.newImage("textures/gear_cw.png"),love.graphics.newImage("textures/gear_ccw.png")
tex[19],tex[20],tex[21] = love.graphics.newImage("textures/mold.png"),love.graphics.newImage("textures/repulse.png"),love.graphics.newImage("textures/weight.png")
tex[22],tex[23],tex[24] = love.graphics.newImage("textures/crossgenerator.png"),love.graphics.newImage("textures/strongenemy.png"),love.graphics.newImage("textures/freezer.png")
tex[25],tex[26],tex[27] = love.graphics.newImage("textures/cwgenerator.png"),love.graphics.newImage("textures/ccwgenerator.png"),love.graphics.newImage("textures/advancer.png")
tex[28],tex[29],tex[30] = love.graphics.newImage("textures/impulse.png"),love.graphics.newImage("textures/flipper.png"),love.graphics.newImage("textures/doublediverger.png")
tex[31],tex[32],tex[33] = love.graphics.newImage("textures/gate_or.png"),love.graphics.newImage("textures/gate_and.png"),love.graphics.newImage("textures/gate_xor.png")
tex[34],tex[35],tex[36] = love.graphics.newImage("textures/gate_nor.png"),love.graphics.newImage("textures/gate_nand.png"),love.graphics.newImage("textures/gate_xnor.png")
tex[37],tex[38],tex[39] = love.graphics.newImage("textures/straightdiverger.png"),love.graphics.newImage("textures/crossdiverger.png"),love.graphics.newImage("textures/twistgenerator.png")
tex[40],tex[41],tex[42] = love.graphics.newImage("textures/ghost.png"),love.graphics.newImage("textures/bias.png"),love.graphics.newImage("textures/shield.png")
tex[43],tex[44],tex[45] = love.graphics.newImage("textures/intaker.png"),love.graphics.newImage("textures/replicator.png"),love.graphics.newImage("textures/crossreplicator.png")
tex[46],tex[47],tex[48] = love.graphics.newImage("textures/fungal.png"),love.graphics.newImage("textures/forker.png"),love.graphics.newImage("textures/tripleforker.png")
tex[49],tex[50],tex[51] = love.graphics.newImage("textures/super_repulsor.png"),love.graphics.newImage("textures/demolisher.png"),love.graphics.newImage("textures/opposition.png")
tex[52],tex[53],tex[54] = love.graphics.newImage("textures/crossopposition.png"),love.graphics.newImage("textures/slideopposition.png"),love.graphics.newImage("textures/supergenerator.png")
tex[55],tex[56],tex[57] = love.graphics.newImage("textures/crossmirror.png"),love.graphics.newImage("textures/doublerotator.png"),love.graphics.newImage("textures/driller.png")
tex.setinitial = love.graphics.newImage("textures/setinitial.png")
tex.pix = love.graphics.newImage("textures/pixel.png")
tex.menu = love.graphics.newImage("textures/menu.png")
tex.zoomin = love.graphics.newImage("textures/zoomin.png")
tex.zoomout = love.graphics.newImage("textures/zoomout.png")
tex.select = love.graphics.newImage("textures/select.png")
tex.copy = love.graphics.newImage("textures/copy.png")
tex.cut = love.graphics.newImage("textures/cut.png") 
tex.paste = love.graphics.newImage("textures/paste.png")
tex.nonexistant = love.graphics.newImage("textures/nonexistant.png")

-- Textures
tex.mover = tex[1]
tex.push = tex[4]
tex.puller = tex[13]
tex.advancer = tex[27]
tex.redirector = tex[16]
tex.rotator_180 = tex[10]
tex.rotator_cw = tex[8]
tex.rotator_ccw = tex[9]
tex.mirror = tex[14]
tex.trash = tex[11]
tex.generator = tex[2]
tex.super_generator = tex[54]

--[[local path = love.filesystem.getSourceBaseDirectory()								--this crap doesn't work >:(
if (love.filesystem.getInfo(path.."/cellua-textures") or {})[1] == "directory" then
	for i=-2,48 do
		if love.filesystem.getInfo(path.."/cellua-textures/"..i..".png")[1] == "file" then
			local idata = love.image.newImageData(love.filesystem.read(path.."/cellua-textures/"..i..".png"))
			tex[i] = love.graphics.newImage(idata)
		end
	end
end]]
texsize = {}
local firstLoad = true
for k,v in pairs(tex) do
	texsize[k] = {}
	texsize[k].w = tex[k]:getWidth()
	texsize[k].h = tex[k]:getHeight()
	texsize[k].w2 = tex[k]:getWidth()/2	--for optimization
	texsize[k].h2 = tex[k]:getHeight()/2
end

listorder = {0,-2,40,-1,1,13,27,57,2,22,25,26,39,54,44,45,3,4,5,6,7,51,52,53,8,9,10,56,16,29,17,18,20,49,28,14,55,15,30,37,38,11,50,12,23,24,19,46,31,32,33,34,35,36,41,21,42,43,47,48}
bgsprites,winx,winy,winxm,winymc = nil,nil,nil,nil,nil
destroysound = love.audio.newSource("destroy.wav", "static")
beep = love.audio.newSource("beep.wav", "static")
music = love.audio.newSource("music.wav", "stream")
music:setLooping(true)
love.audio.setVolume(0.5)
love.audio.play(music)
enemyparticles = love.graphics.newParticleSystem(tex.pix)
enemyparticles:setSizes(4,0)
enemyparticles:setSpread(math.pi*2)
enemyparticles:setSpeed(0,200)
enemyparticles:setParticleLifetime(0.5,1)
enemyparticles:setEmissionArea("uniform",10,10)
enemyparticles:setSizeVariation(1)
enemyparticles:setLinearDamping(1)
enemyparticles:setBufferSize(10000)

 function lerp(a,b,m,notgraphics)
	if notgraphics or (interpolate and delay > 0) then	
		return a+(b-a)*m
	else return b end
end

function round(a) --lazy moment
	return math.floor(a+0.5)
end

require("src.chunks")
require("src.encoding")

function CopyCell(x,y)
	local newcell = {}
	for k,v in pairs(cells[y][x]) do
		newcell[k] = v
	end
	return newcell
end

require("src.move")

require("src.update")

--Basic structure of subticks:
--"Super" versions of cells before their "normal" counterparts
--Cells that both push and pull usually go before puller-only and pusher-only cells

--Non-moving Cells
	--Effect Cells (cells that give other cells a special effect, freezers first)
	--Swapping Cells (cells that swap positions of cells (aka cells that can move semi-immovables like gates), excluding gears because they are somewhat like rotators)
	--Generating Cells (cells that are similar to generators, excluding gates, and including intakers for the sake of being the "opposite" of a generator)
	--Rotating Cells (cells that affect rotation)
	--Force Cells (cells that apply a force like pushing or pulling)
		--Pulling Cells 
		--Pushing Cells
--Moving Cells
	--Swapping Cells
	--Pulling Cells
	--Pushing Cells
--Gates (because the input variables dont carry over to the next tick, so they need to be at the end in order to register anything that could activate an input)

subticks = {
	UpdateFreezers,
	UpdateShields,
	UpdateMirrors,
	UpdateIntakers,
	UpdateSuperGenerators,
	UpdateGenerators,
	UpdateReplicators,
	UpdateMold,
	UpdateFlippers,
	UpdateRotators,
	UpdateGears,
	UpdateRedirectors,
	UpdateImpulsers,
	UpdateSuperRepulsers,
	UpdateRepulsers,
	UpdateDrillers,
	UpdateAdvancers,
	UpdatePullers,
	UpdateMovers,
	UpdateGates
}

function DoTick()
	if subtick then
		if subtick == 0 then
			modsTick()
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].updated = false
					cells[y][x].protected = false
					cells[y][x].pulleddir = nil
					cells[y][x].testvar = ""
					cells[y][x].inl = false
					cells[y][x].inr = false
					cells[y][x].scrosses = 0
				end
			end
			subticks[subtick+1]()
		elseif subtick == #subticks-1 then
			subticks[subtick+1]()
			ticknum = ticknum + 1
		else
			subticks[subtick+1]()
		end
		if ticknum == 25 then
			RefreshChunks()
		end
		subtick = (subtick + 1)%#subticks
	else
		modsTick()
		for y=0,height-1 do
			for x=0,width-1 do
				cells[y][x].updated = false
				cells[y][x].protected = false
				cells[y][x].pulleddir = nil
				cells[y][x].testvar = ""
				cells[y][x].inl = false
				cells[y][x].inr = false
				cells[y][x].scrosses = 0
			end
		end
		for i=1,#subticks do
			subticks[i]()
		end
		ticknum = ticknum + 1
		if ticknum == 25 then
			RefreshChunks()
		end
	end
end

function love.load()
	bgsprites = love.graphics.newSpriteBatch(tex[0])
	if firstLoad == true then
		initialCellCount = #listorder
		initialCells = {}
		for i=1,#listorder,1 do
			initialCells[#initialCells+1] = listorder[i]
			cellsForIDManagement[#cellsForIDManagement+1] = listorder[i]
		end
		loadInitialPlugins() -- Initialize plugins
		initMods() -- Please work
	end
	firstLoad = false
	for y=0,height-1 do
		initial[y] = {}
		cells[y] = {}
		placeables[y] = {}
		if y%25 == 0 then chunks[math.floor(y/25)] = {} end
		for x=0,width-1 do 
			initial[y][x] = {}
			cells[y][x] = {}
			chunks[math.floor(y/25)][math.floor(x/25)] = {}
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x] = {
					ctype = walls[border],
					rot = 0
				}
			else
				initial[y][x].ctype = 0
				initial[y][x].rot = 0
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			placeables[y][x] = false
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
	winxm = (love.graphics.getWidth()/800)
	winym = (love.graphics.getHeight()/600)
end

function love.update(dt)
	delta = dt
	winxm = (love.graphics.getWidth()/800)
	winym = (love.graphics.getHeight()/600)
	if inmenu then
		if love.mouse.isDown(1) then
			local x,y = love.mouse.getX()/winxm,love.mouse.getY()/winym
			if x >= 145 and x <= 655 then	--give some extra area on the left and right so you can set it to the highest and lowest value more easily
				x = math.min(math.max(x,150),650)	--then cap it so nothing breaks
				if y >= 160 and y <= 170 then
					delay = (x-150)/500
				elseif y >= 195 and y <= 205 then
					tpu = round((x-150)/(500/9))+1
				elseif y >= 230 and y <= 240 then
					volume = round((x-150)/5)/100
					love.audio.setVolume(volume)
				elseif y >= 265 and y <= 275 then
					border = round((x-150)/(500/(#walls-1)))+1
				end
			end
		end
	else
		if not paused then
			dtime = dtime + dt
			if updatekey > 10000000000 then updatekey = 0 end --juuuust in case
			if supdatekey > 10000000000 then supdatekey = 0 end
			if dtime > delay then
				for y=0,height-1 do
					for x=0,width-1 do
						cells[y][x].lastvars = {x,y,cells[y][x].rot}
					end
				end
				for i=1,tpu do
					DoTick()
				end
				dtime = 0
				itime = 0
			end
		end
		if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
			if love.keyboard.isDown("w") then offy = offy - 20 end
			if love.keyboard.isDown("s") then offy = offy + 20 end
			if love.keyboard.isDown("a") then offx = offx - 20 end
			if love.keyboard.isDown("d") then offx = offx + 20 end
		else
			if love.keyboard.isDown("w") then offy = offy - 10 end
			if love.keyboard.isDown("s") then offy = offy + 10 end
			if love.keyboard.isDown("a") then offx = offx - 10 end
			if love.keyboard.isDown("d") then offx = offx + 10 end
		end
		if love.mouse.isDown(1) and placecells then
			local x = love.mouse.getX()/winxm
			local y = love.mouse.getY()/winym
			if x >= 755 and y >= 475-40*(winxm/winym) and x <= 795 and y <= 475 then
				offx = offx + 10
			elseif x >= 715 and y >= 475-80*(winxm/winym) and x <= 755 and y <= 475-40*(winxm/winym) then
				offy = offy - 10
			elseif x >= 715 and y >= 475 and x <= 755 and y <= 475+40*(winxm/winym) then
				offy = offy + 10
			elseif x >= 675 and y >= 475-40*(winxm/winym) and x <= 715 and y <= 475 then
				offx = offx - 10
			elseif selecting then
				selw = math.max(math.min(math.floor((love.mouse.getX()+offx)/zoom),width-2),selx) - selx + 1
				selh = math.max(math.min(math.floor((love.mouse.getY()+offy)/zoom),height-2),sely) - sely + 1
			else
				local x = math.floor((love.mouse.getX()+offx)/zoom)
				local y = math.floor((love.mouse.getY()+offy)/zoom)
				if x > 0 and y > 0 and x < width-1 and y < height-1 then
					if not undocells then
						undocells = {}
						for y=0,height-1 do
							undocells[y] = {}
							for x=0,width-1 do
								undocells[y][x] = {}
								undocells[y][x].ctype = cells[y][x].ctype
								undocells[y][x].rot = cells[y][x].rot
								undocells[y][x].place = placeables[y][x]
								wasinitial = isinitial
							end
						end
					end
					if currentstate == -2 then
						if isinitial then
							placeables[y][x] = true
						end
					else
						local original = CopyCell(x, y)
						cells[y][x].ctype = currentstate
						cells[y][x].rot = currentrot
						cells[y][x].lastvars = {x,y,currentrot}
						local originalInitial = CopyTable(initial[y][x])
						if isinitial then
							initial[y][x].ctype = currentstate
							initial[y][x].rot = currentrot
							initial[y][x].lastvars = {x,y,currentrot}
						end
						SetChunk(x,y,currentstate)
						modsOnPlace(currentstate, x, y, currentrot, original, originalInitial)
					end
				end
			end
		end
		if love.mouse.isDown(2) and placecells then
			selw = 0
			selh = 0
			local x = math.floor((love.mouse.getX()+offx)/zoom)
			local y = math.floor((love.mouse.getY()+offy)/zoom)
			if x > 0 and y > 0 and x < width-1 and y < height-1 then
				if not undocells then
					undocells = {}
					for y=0,height-1 do
						undocells[y] = {}
						for x=0,width-1 do
							undocells[y][x] = {}
							undocells[y][x].ctype = cells[y][x].ctype
							undocells[y][x].rot = cells[y][x].rot
							undocells[y][x].place = placeables[y][x]
							wasinitial = isinitial
						end
					end
				end
				if currentstate == -2 then
					if isinitial then
						placeables[y][x] = false
					end
				else
					local original = CopyCell(x, y)
					cells[y][x].ctype = 0
					cells[y][x].rot = 0
					local originalInitial = CopyTable(cells[y][x])
					if isinitial then
						initial[y][x].ctype = 0
						initial[y][x].rot = 0
					end
					SetChunk(x,y,currentstate)
					modsOnPlace(0, x, y, 0, original, originalInitial)
				end
			end
		end
	end
	if not typing then
		newwidth = math.max(newwidth,1)
		newheight = math.max(newheight,1)
	end
	itime = math.min(itime + dt,delay)
	enemyparticles:update(dt)
	modsCustomUpdate(dt)
	RunPluginBinding("update", dt)
end

function love.draw()
	love.graphics.setColor(1/8,1/8,1/8)
	love.graphics.rectangle("fill",-10,-10,9999,9999)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(bgsprites,math.floor(zoom-offx+zoom/2),math.floor(zoom-offy+zoom/2),0,zoom/texsize[-1].w,zoom/texsize[-1].h,texsize[-1].w2,texsize[-1].h2)
	if currentstate ~= -2 then
		for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
			for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
				if placeables[y][x] then 
					love.graphics.draw(tex[-2],math.floor(x*zoom-offx+zoom/2),math.floor(y*zoom-offy+zoom/2),0,zoom/texsize[-2].w,zoom/texsize[-2].h,texsize[-2].w2,texsize[-2].h2)
				end
			end
		end
	end
	for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
		for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
			if cells[y][x].ctype ~= 0 then 
				love.graphics.draw((tex[cells[y][x].ctype] or tex.nonexistant),math.floor(lerp(cells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(cells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),lerp(cells[y][x].lastvars[3],cells[y][x].lastvars[3]+((cells[y][x].rot-cells[y][x].lastvars[3]+2)%4-2),itime/delay)*math.pi/2,zoom/(texsize[cells[y][x].ctype] or texsize["nonexistant"]).w,zoom/(texsize[cells[y][x].ctype] or texsize["nonexistant"]).h,(texsize[cells[y][x].ctype] or texsize["nonexistant"]).w2,(texsize[cells[y][x].ctype] or texsize["nonexistant"]).h2)
			end
			if dodebug then
				love.graphics.print(tostring(cells[y][x].testvar),x*zoom-offx+zoom/2,y*zoom-offy+zoom/2)
			end
			modsOnCellDraw(cells[y][x].ctype, x, y, cells[y][x].rot)
		end
	end
	if currentstate == -2 then
		for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
			for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
				if placeables[y][x] then 
					love.graphics.draw(tex[-2],math.floor(x*zoom-offx+zoom/2),math.floor(y*zoom-offy+zoom/2),0,zoom/texsize[-2].w,zoom/texsize[-2].h,texsize[-2].w2,texsize[-2].h2)
				end
			end
		end
	end
	modsOnGridRender()
	love.graphics.setColor(1,1,1,0.25)
	if selecting then love.graphics.rectangle("fill",math.floor((selx)*zoom-offx),math.floor((sely)*zoom-offy),selw*zoom,selh*zoom) end
	love.graphics.setColor(1,1,1,0.5)
	if interpolate then love.graphics.draw(enemyparticles,-offx+zoom/2,-offy+zoom/2,0,zoom/20,zoom/20) end	--interpolate is the variable name for all fancy graphics now. no, im not changing it, i'm too lazy
	if pasting then
		for y=0,#copied do
			for x=0,#copied[0] do
				if copied[y][x].place then love.graphics.draw(tex[-2],math.floor((math.floor((love.mouse.getX()+offx)/zoom)+x)*zoom-offx+zoom/2),math.floor((math.floor((love.mouse.getY()+offy)/zoom)+y)*zoom-offy+zoom/2),0,zoom/texsize[-2].w,zoom/texsize[-2].h,texsize[-2].w2,texsize[-2].h2) end
				love.graphics.draw((tex[copied[y][x].ctype] or tex.nonexistant),(math.floor((love.mouse.getX()+offx)/zoom)+x)*zoom-offx+zoom/2,(math.floor((love.mouse.getY()+offy)/zoom)+y)*zoom-offy+zoom/2,copied[y][x].rot*math.pi/2,zoom/(texsize[copied[y][x].ctype] or texsize["nonexistant"]).w,zoom/(texsize[copied[y][x].ctype] or texsize["nonexistant"]).h,(texsize[copied[y][x].ctype] or texsize["nonexistant"]).w2,(texsize[copied[y][x].ctype] or texsize["nonexistant"]).h2)
			end
		end
		love.graphics.rectangle("line",math.floor((math.floor((love.mouse.getX()+offx)/zoom))*zoom-offx),math.floor((math.floor((love.mouse.getY()+offy)/zoom))*zoom-offy),(#copied[0]+1)*zoom,(#copied+1)*zoom)
	end
	if dodebug then
		for y=0,(height-1)/25 do
			for x=0,(width-1)/25 do
				if ticknum == 0 then
					love.graphics.setColor(1,0,0)
				else
					love.graphics.setColor(1,1,1)
				end
				love.graphics.line(math.floor(x*25*zoom-offx),math.floor(y*25*zoom-offy),math.floor((x+1)*25*zoom-offx),math.floor((y)*25*zoom-offy))
				love.graphics.line(math.floor(x*25*zoom-offx),math.floor(y*25*zoom-offy),math.floor((x)*25*zoom-offx),math.floor((y+1)*25*zoom-offy))
			end
		end
		love.graphics.setColor(1,1,1)
	end
	for i=0,15 do
		if listorder[i+16*(page-1)+1] then
			if currentstate == listorder[i+16*(page-1)+1] then love.graphics.setColor(1,1,1,1) else love.graphics.setColor(1,1,1,0.5) end
			love.graphics.draw(tex[listorder[i+16*(page-1)+1]],(25+(775-25)*i/15)*winxm,575*winym,currentrot*math.pi/2,40*winxm/texsize[listorder[i+16*(page-1)+1]].w,40*winxm/texsize[listorder[i+16*(page-1)+1]].h,texsize[listorder[i+16*(page-1)+1]].w2,texsize[listorder[i+16*(page-1)+1]].h2)
		end
	end
	if paused then
		love.graphics.setColor(0.5,0.5,0.5,0.75)
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(tex.mover,725*winxm,25*winym,0,60*winxm/texsize.mover.w,60*winxm/texsize.mover.h)
	else
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(tex.push,785*winxm,25*winym,math.pi/2,60*winxm/texsize.push.w,60*winxm/texsize.push.h)
	end
	if undocells then love.graphics.draw(tex.advancer,725*winxm-150*winxm,25*winym,math.pi,60*winxm/texsize.advancer.w,60*winxm/texsize.advancer.h,texsize.advancer.w,texsize.advancer.h) end
	love.graphics.draw(tex.redirector,725*winxm-75*winxm,25*winym,0,60*winxm/texsize.redirector.w,60*winxm/texsize.redirector.h)
	love.graphics.draw(tex.menu,25*winxm,25*winym,0,60*winxm/texsize.menu.w,60*winxm/texsize.menu.h)
	love.graphics.draw(tex.zoomin,100*winxm,25*winym,0,60*winxm/texsize.zoomin.w,60*winxm/texsize.zoomin.h)
	love.graphics.draw(tex.zoomout,175*winxm,25*winym,0,60*winxm/texsize.zoomout.w,60*winxm/texsize.zoomout.h)
	if selecting then 
		love.graphics.draw(tex.copy,100*winxm,25*winym+75*winxm,0,60*winxm/texsize.copy.w,60*winxm/texsize.copy.h)
		love.graphics.draw(tex.cut,175*winxm,25*winym+75*winxm,0,60*winxm/texsize.cut.w,60*winxm/texsize.cut.h)
		love.graphics.setColor(1,1,1,0.75)
	end
	love.graphics.draw(tex.select,25*winxm,25*winym+75*winxm,0,60*winxm/texsize.select.w,60*winxm/texsize.select.h)
	love.graphics.setColor(1,1,1,0.5)
	if copied then
		love.graphics.draw(tex.paste,25*winxm,25*winym+150*winxm,0,60*winxm/texsize.paste.w,60*winxm/texsize.paste.h)
		love.graphics.draw(tex.mirror,100*winxm,25*winym+150*winxm,0,60*winxm/texsize.mirror.w,60*winxm/texsize.mirror.h)
		love.graphics.draw(tex.mirror,235*winxm,25*winym+150*winxm,math.pi/2,60*winxm/texsize.mirror.w,60*winxm/texsize.mirror.h)
	end
	love.graphics.draw(tex.puller,715*winxm,475*winym-80*winxm,-math.pi/2,40*winxm/texsize.puller.w,40*winxm/texsize.puller.h,texsize.puller.w)
	love.graphics.draw(tex.puller,755*winxm,475*winym-40*winxm,0,40*winxm/texsize.puller.w,40*winxm/texsize.puller.h)
	love.graphics.draw(tex.puller,715*winxm,475*winym,math.pi/2,40*winxm/texsize.puller.w,40*winxm/texsize.puller.h,0,texsize.puller.h)
	love.graphics.draw(tex.puller,675*winxm,475*winym-40*winxm,math.pi,40*winxm/texsize.puller.w,40*winxm/texsize.puller.h,texsize.puller.w,texsize.puller.h)
	love.graphics.draw(tex.rotator_ccw,755*winxm,475*winym-80*winxm,0,40*winxm/texsize.rotator_ccw.w,40*winxm/texsize.rotator_ccw.h)
	love.graphics.draw(tex.rotator_cw,675*winxm,475*winym-80*winxm,0,40*winxm/texsize.rotator_cw.w,40*winxm/texsize.rotator_cw.h)
	love.graphics.draw(tex.mover,755*winxm,475*winym,0,40*winxm/texsize.mover.w,40*winxm/texsize.mover.h)
	love.graphics.draw(tex.mover,675*winxm,475*winym,math.pi,40*winxm/texsize.mover.w,40*winxm/texsize.mover.h,texsize.mover.w,texsize.mover.h)
	if not isinitial then
		love.graphics.draw(tex.rotator_180,725*winxm,25*winym+75*winxm,0,60*winxm/texsize.rotator_180.w,60*winxm/texsize.rotator_180.h)
		love.graphics.draw(tex.setinitial,725*winxm-150*winxm,25*winym+75*winxm,0,135*winxm/texsize.setinitial.w,60*winxm/texsize.setinitial.h)
	end
	local x = love.mouse.getX()/winxm
	local y = love.mouse.getY()/winym
	if inmenu then
		love.graphics.setColor(0.5,0.5,0.5,0.5)
		love.graphics.rectangle("fill",100*winxm,75*winym,600*winxm,450*winym)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("this is the menu",300*winxm,120*winym,0,2*winxm,2*winym)
		love.graphics.print("CelLuAPI by GuyWithAMonitor#1595",300*winxm,90*winym,0,winxm,winym)
		love.graphics.print("built on CelLua by KyYay",335*winxm,105*winym,0,winxm,winym)
		love.graphics.print("Update delay: "..string.sub(delay,1,4).."s",150*winxm,145*winym,0,winxm,winym)
		love.graphics.print("Ticks per update: "..tpu,150*winxm,180*winym,0,winxm,winym)
		love.graphics.print("Volume: "..volume*100 .."%",150*winxm,215*winym,0,winxm,winym)
		love.graphics.print("Border mode: "..border,150*winxm,250*winym,0,winxm,winym)
		love.graphics.print("Width (upon reset/clear)",225*winxm,305*winym,0,winxm,winym)
		love.graphics.print("Height (upon reset/clear)",425*winxm,305*winym,0,winxm,winym)
		love.graphics.print("Debug (Can cause lag!)",200*winxm,378*winym,0,winxm,winym)
		love.graphics.print("Fancy Graphix",400*winxm,378*winym,0,winxm,winym)
		love.graphics.print("Subticking",550*winxm,378*winym,0,winxm,winym)
		local modsString = "Running mods: "
		for i=1,#mods,1 do
			modsString = modsString .. mods[i] .. " "
		end
		if #mods> 0 then
			love.graphics.print(modsString,100*winxm,510*winym,0,winxm,winym)
		end
		love.graphics.setColor(1/4,1/4,1/4,1)
		love.graphics.rectangle("fill",150*winxm,160*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,195*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,230*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,265*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",250*winxm,325*winym,100*winxm,25*winym)
		love.graphics.rectangle("fill",450*winxm,325*winym,100*winxm,25*winym)
		love.graphics.rectangle("fill",175*winxm,375*winym,20*winxm,20*winym)
		love.graphics.rectangle("fill",375*winxm,375*winym,20*winxm,20*winym)
		love.graphics.rectangle("fill",525*winxm,375*winym,20*winxm,20*winym)
		love.graphics.setColor(1/2,1/2,1/2,1)
		love.graphics.rectangle("fill",lerp(149,649,delay,true)*winxm,160*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,(tpu-1)/9,true)*winxm,195*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,volume,true)*winxm,230*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,(border-1)/((#walls)-1),true)*winxm,265*winym,2*winxm,10*winym)
		if dodebug then
		love.graphics.polygon("fill",{180*winxm,378*winym ,177*winxm,380*winym ,190*winxm,393*winym ,193*winxm,390*winym})
		love.graphics.polygon("fill",{190*winxm,378*winym ,193*winxm,380*winym ,180*winxm,393*winym ,177*winxm,390*winym}) end
		if interpolate then
		love.graphics.polygon("fill",{380*winxm,378*winym ,377*winxm,380*winym ,390*winxm,393*winym ,393*winxm,390*winym})
		love.graphics.polygon("fill",{390*winxm,378*winym ,393*winxm,380*winym ,380*winxm,393*winym ,377*winxm,390*winym}) end
		if subtick then
		love.graphics.polygon("fill",{530*winxm,378*winym ,527*winxm,380*winym ,540*winxm,393*winym ,543*winxm,390*winym})
		love.graphics.polygon("fill",{540*winxm,378*winym ,543*winxm,380*winym ,530*winxm,393*winym ,527*winxm,390*winym}) end
		--if dodebug then love.graphics.polygon("fill",{267,385 ,264,382 ,258,394 ,255,391}) end
		love.graphics.setColor(1,1,1,1)
		if typing == 1 then love.graphics.print(newwidth.."_",255*winxm,330*winym,0,winxm,winym) else love.graphics.print(newwidth,255*winxm,330*winym,0,winxm,winym) end
		if typing == 2 then love.graphics.print(newheight.."_",455*winxm,330*winym,0,winxm,winym) else love.graphics.print(newheight,455*winxm,330*winym,0,winxm,winym) end
		if x > 170 and y > 420 and x < 230 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Close menu\n     (Esc)",165*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex.mover,200*winxm,450*winym,0,60*winxm/texsize.mover.w,60*winym/texsize.mover.h,texsize.mover.w2,texsize.mover.h2)
		if x > 270 and y > 420 and x < 330 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Restart level\n   (Ctrl+R)",265*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex.rotator_180,300*winxm,450*winym,0,60*winxm/texsize.rotator_180.w,60*winym/texsize.rotator_180.h,texsize.rotator_180.w2,texsize.rotator_180.h2)
		if x > 370 and y > 420 and x < 430 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Clear level",369*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex.trash,400*winxm,450*winym,0,60*winxm/texsize.trash.w,60*winym/texsize.trash.h,texsize.trash.w2,texsize.trash.h2)
		if x > 470 and y > 420 and x < 530 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Save level",470*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex.generator,500*winxm,450*winym,math.pi*1.5,60*winym/texsize.generator.w,60*winxm/texsize.generator.h,texsize.generator.w2,texsize.generator.h2)
		if x > 570 and y > 420 and x < 630 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Load level\n(V3/K1/K2)",570*winxm,480*winym,0,winxm,winym)  else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex.redirector,600*winxm,450*winym,math.pi*0.5,60*winym/texsize.redirector.w,60*winxm/texsize.redirector.h,texsize.redirector.w2,texsize.redirector.h2)
	end
	if showinstructions then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("WASD = Move\n(Ctrl to speed up)\n\nQ/E = Rotate\n\nEsc = Menu\n\nZ/C = Change cell selection page\n\nSpace = Pause\n\nF = Advance one tick\n\nUp/down or mousewheel = Zoom in/out\n\nTab = Select\n\nOther shortcuts are obvious",10*winxm,300*winym,0,1*winxm,1*winym)
	end
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.print("FPS: ".. 1/delta,10,10) 
	if typing then
		love.keyboard.setTextInput(true)
	else
		love.keyboard.setTextInput(false)
	end
	local dt = love.timer.getDelta()
	RunPluginBinding("draw", dt, 1 / dt)
	modsCustomDraw()
end

function love.mousepressed(x,y,b, istouch, presses)
	x = x/winxm
	y = y/winym
	if inmenu and y > 420 and y < 480 then
		if  x > 170 and x < 230 then
			inmenu = false
			placecells = false
			typing = false
		elseif x > 270 and x < 330 then
			if newheight ~= height-2 or newwidth ~= width-2 then
				undocells = nil
			end
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].ctype = initial[y][x].ctype
					cells[y][x].rot = initial[y][x].rot
				end
			end
			for y=0,newheight+1 do
				initial[y] = initial[y] or {}
				cells[y] = {}
				placeables[y] = placeables[y] or {}
				if y%25 == 0 then chunks[math.floor(y/25)] = {} end
				for x=0,newwidth+1 do
					if x == 0 or x == newwidth+1 or y == 0 or y == newheight+1 then
						initial[y][x] = {
							ctype = walls[border],
							rot = 0
						}
					elseif x >= width-1 or y >= height-1 then
						initial[y][x] = {ctype = 0, rot = 0}
					end
					cells[y][x] = {}
					placeables[y][x] = placeables[y][x] or false
					chunks[math.floor(y/25)][math.floor(x/25)] = {}
				end
			end
			height = newheight+2
			width = newwidth+2
			bgsprites = love.graphics.newSpriteBatch(tex[0])
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].ctype = initial[y][x].ctype
					cells[y][x].rot = initial[y][x].rot
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
					cells[y][x].testvar = ""
					bgsprites:add((x-1)*20,(y-1)*20)
				end
			end
			inmenu = false
			placecells = false
			paused = true
			isinitial = true
			subtick = subtick and 0
			love.audio.play(beep)
			RefreshChunks()
			typing = false
			modsOnReset()
		elseif x > 370 and x < 430 then
			undocells = nil
			width = newwidth+2
			height = newheight+2
			love.load()
			inmenu = false
			placecells = false
			paused = true
			isinitial = true
			subtick = subtick and 0
			love.audio.play(beep)
			RefreshChunks()
			typing = false
			modsOnClear()
		elseif x > 470 and x < 530 then
			if config['use_k2'] == 'true' then
				EncodeK2()
			else
				if CurrentSaving == "AP2" then
					encodeAP2()
				else
					modsEncoding[CurrentSaving]()
				end
			end
			love.audio.play(beep)
			typing = false
		elseif x > 570 and x < 630 then
			if string.sub(love.system.getClipboardText(),1,3) == "V3;" then
				DecodeV3(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
				undocells = nil
			elseif string.sub(love.system.getClipboardText(),1,3) == "K1;" then
				DecodeK1(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
				undocells = nil
			elseif string.sub(love.system.getClipboardText(),1,3) == "K2;" then
				DecodeK2(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
				undocells = nil
			elseif string.sub(love.system.getClipboardText(),1,4) == "AP1;" then
				DecodeAP1(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
				undocells = nil
			elseif string.sub(love.system.getClipboardText(),1,4) == "AP2;" then
				DecodeAP2(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
				undocells = nil
			else
				local succesful = false
				local txt = love.system.getClipboardText()
				
				for signature, decoding in pairs(modsDecoding) do
					if string.sub(txt, 1, string.len(signature)+1) == (signature .. ';') then
						succesful = true
						decoding(txt)
					end
				end
				
				if succesful then
					inmenu = false
					placecells = false
					newwidth = width-2
					newheight = height-2
					love.audio.play(beep)
					undocells = nil
				else
					love.audio.play(destroysound)
				end
			end
			typing = false
		else
			typing = false
		end
	elseif y > 575-20*(winxm/winym) and y < 575+20*(winxm/winym) then
		for i=0,15 do
			if x > 5+(775-25)*i/15 and x < 45+(775-25)*i/15 and listorder[i+16*(page-1)+1] then
				currentstate = listorder[i+16*(page-1)+1]
				placecells = false
			end
		end
	elseif inmenu and y >= 375 and y <= 395 then
		if x >= 175 and x <= 195 then
			dodebug = not dodebug
			love.audio.play(beep)
		elseif x >= 375 and x <= 395 then
			interpolate = not interpolate
			love.audio.play(beep)
		elseif x >= 525 and x <= 545 then
			if subtick == false then
				subtick = 0
			else
				while subtick > 0 do
					DoTick()
				end
				subtick = false
			end
			love.audio.play(beep)
		end
	elseif inmenu then
		if x >= 250 and x <= 350 and y >= 325 and y <= 350 then
			typing = 1
		elseif x >= 450 and x <= 550 and y >= 325 and y <= 350 then
			typing = 2
		else
			typing = false
		end
	elseif not inmenu then
		if x >= 25 and x <= 25+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			inmenu = true
			placecells = false
		elseif x >= 25+75 and x <= 25+75+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			if zoom < 160 then
				zoom = zoom*2
				offx = offx*2 + 400*winxm
				offy = offy*2 + 300*winym
			end
			placecells = false
		elseif x >= 25+150 and x <= 25+150+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			if zoom > 2 then
				offx = (offx-400*winxm)*0.5
				offy = (offy-300*winym)*0.5
				zoom = zoom*0.5
			end
			placecells = false
		elseif x >= 25 and x <= 85 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) then
			selecting = not selecting
			pasting = false
			selw = 0
			selh = 0
			placecells = false
		elseif selecting and x >= 100 and x <= 160 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) then
			if selw > 0 then
				copied = {}
				for y=0,selh-1 do
					copied[y] = {}
					for x=0,selw-1 do
						copied[y][x] = {}
						copied[y][x].ctype = cells[y+sely][x+selx].ctype
						copied[y][x].rot = cells[y+sely][x+selx].rot
						copied[y][x].place = placeables[y+sely][x+selx]
					end
				end
				selecting = false
			end
			placecells = false
			ModsOnCopy(selx, sely, selw, selh)
		elseif selecting and x >= 175 and x <= 175+60 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) then
			local original = CopyTable(copied or {})
			if selw > 0 then
				copied = {}
				for y=0,selh-1 do
					copied[y] = {}
					for x=0,selw-1 do
						copied[y][x] = {}
						copied[y][x].ctype = cells[y+sely][x+selx].ctype
						copied[y][x].rot = cells[y+sely][x+selx].rot
						copied[y][x].place = placeables[y+sely][x+selx]
						cells[y+sely][x+selx].ctype = 0
						cells[y+sely][x+selx].rot = 0
						if isinitial then
							initial[y+sely][x+selx].ctype = 0
							placeables[y+sely][x+selx] = false
						end
					end
				end
				selecting = false
			end
			placecells = false
			ModsOnCut(selx, sely, selw, selh, copied, original)
		elseif x >= 25 and x <= 85 and y >= 25+150*(winxm/winym) and y <= 25+150*(winxm/winym)+60*(winxm/winym) and copied then
			selecting = false
			pasting = true
			placecells = false
		elseif x >= 100 and x <= 160 and y >= 25+150*(winxm/winym) and y <= 25+150*(winxm/winym)+60*(winxm/winym) and copied then
			local lastcop = {}
			local selh = #copied
			local selw = #copied[0]
			for y=0,selh do
				lastcop[y] = {}
				for x=0,selw do
					lastcop[y][x] = {}
					lastcop[y][x].ctype = copied[y][x].ctype
					lastcop[y][x].rot = copied[y][x].rot
					lastcop[y][x].place = copied[y][x].place
				end
			end
			for y=0,selh do
				for x=0,selw do
					copied[y][x].ctype = lastcop[y][selw-x].ctype
					if lastcop[y][selw-x].ctype == 8 then copied[y][x].ctype = 9 copied[y][x].rot = lastcop[y][selw-x].rot
					elseif lastcop[y][selw-x].ctype == 9 then copied[y][x].ctype = 8 copied[y][x].rot = lastcop[y][selw-x].rot
					elseif lastcop[y][selw-x].ctype == 17 then copied[y][x].ctype = 18 copied[y][x].rot = lastcop[y][selw-x].rot
					elseif lastcop[y][selw-x].ctype == 18 then copied[y][x].ctype = 17 copied[y][x].rot = lastcop[y][selw-x].rot
					elseif lastcop[y][selw-x].ctype == 25 then copied[y][x].ctype = 26 copied[y][x].rot = (-lastcop[y][selw-x].rot + 2)%4
					elseif lastcop[y][selw-x].ctype == 26 then copied[y][x].ctype = 25 copied[y][x].rot = (-lastcop[y][selw-x].rot + 2)%4
					elseif (lastcop[y][selw-x].ctype == 6 or lastcop[y][selw-x].ctype == 22 or lastcop[y][selw-x].ctype == 30 or lastcop[y][selw-x].ctype == 45 or lastcop[y][selw-x].ctype == 52) and lastcop[y][selw-x].rot%2 == 0 then copied[y][x].rot = (lastcop[y][selw-x].rot - 1)%4
					elseif (lastcop[y][selw-x].ctype == 6 or lastcop[y][selw-x].ctype == 22 or lastcop[y][selw-x].ctype == 30 or lastcop[y][selw-x].ctype == 45 or lastcop[y][selw-x].ctype == 52) then copied[y][x].rot = (lastcop[y][selw-x].rot + 1)%4
					elseif (lastcop[y][selw-x].ctype == 15 or lastcop[y][selw-x].ctype == 56) and lastcop[y][selw-x].rot%2 == 0 then copied[y][x].rot = (lastcop[y][selw-x].rot + 1)%4
					elseif (lastcop[y][selw-x].ctype == 15 or lastcop[y][selw-x].ctype == 56) then copied[y][x].rot = (lastcop[y][selw-x].rot - 1)%4
					else copied[y][x].rot = (-lastcop[y][selw-x].rot + 2)%4 end
					copied[y][x].place = lastcop[y][selw-x].place
				end
			end
			placecells = false
		elseif x >= 175 and x <= 235 and y >= 25+150*(winxm/winym) and y <= 25+150*(winxm/winym)+60*(winxm/winym) and copied then
			local lastcop = {}
			local selh = #copied
			local selw = #copied[0]
			for y=0,selh do
				lastcop[y] = {}
				for x=0,selw do
					lastcop[y][x] = {}
					lastcop[y][x].ctype = copied[y][x].ctype
					lastcop[y][x].rot = copied[y][x].rot
					lastcop[y][x].place = copied[y][x].place
				end
			end
			for y=0,selh do
				for x=0,selw do
					copied[y][x].ctype = lastcop[selh-y][x].ctype
					if lastcop[selh-y][x].ctype == 8 then copied[y][x].ctype = 9 copied[y][x].rot = lastcop[selh-y][x].rot
					elseif lastcop[selh-y][x].ctype == 9 then copied[y][x].ctype = 8 copied[y][x].rot = lastcop[selh-y][x].rot
					elseif lastcop[selh-y][x].ctype == 17 then copied[y][x].ctype = 18 copied[y][x].rot = lastcop[selh-y][x].rot
					elseif lastcop[selh-y][x].ctype == 18 then copied[y][x].ctype = 17 copied[y][x].rot = lastcop[selh-y][x].rot
					elseif lastcop[selh-y][x].ctype == 25 then copied[y][x].ctype = 26 copied[y][x].rot = (-lastcop[selh-y][x].rot)%4
					elseif lastcop[selh-y][x].ctype == 26 then copied[y][x].ctype = 25 copied[y][x].rot = (-lastcop[selh-y][x].rot)%4
					elseif (lastcop[selh-y][x].ctype == 6 or lastcop[selh-y][x].ctype == 22 or lastcop[selh-y][x].ctype == 30 or lastcop[selh-y][x].ctype == 45 or lastcop[selh-y][x].ctype == 52) and lastcop[selh-y][x].rot%2 == 0 then copied[y][x].rot = (lastcop[selh-y][x].rot + 1)%4
					elseif (lastcop[selh-y][x].ctype == 6 or lastcop[selh-y][x].ctype == 22 or lastcop[selh-y][x].ctype == 30 or lastcop[selh-y][x].ctype == 45 or lastcop[selh-y][x].ctype == 52) then copied[y][x].rot = (lastcop[selh-y][x].rot - 1)%4
					elseif (lastcop[selh-y][x].ctype == 15 or lastcop[selh-y][x].ctype == 56) and lastcop[selh-y][x].rot%2 == 0 then copied[y][x].rot = (lastcop[selh-y][x].rot - 1)%4
					elseif (lastcop[selh-y][x].ctype == 15 or lastcop[selh-y][x].ctype == 56) then copied[y][x].rot = (lastcop[selh-y][x].rot + 1)%4
					else copied[y][x].rot = (-lastcop[selh-y][x].rot)%4 end
					copied[y][x].place = lastcop[selh-y][x].place
				end
			end
			placecells = false
		elseif x >= 725-150 and x <= 725-150+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			if undocells then
				for y=0,height-1 do
					for x=0,width-1 do
						cells[y][x].ctype = undocells[y][x].ctype
						cells[y][x].rot = undocells[y][x].rot
						cells[y][x].lastvars = {x,y,undocells[y][x].rot}
						placeables[y][x] = undocells[y][x].place
						if wasinitial then
							initial[y][x].ctype = undocells[y][x].ctype
							initial[y][x].rot = undocells[y][x].rot
						end
					end
				end
				undocells = nil
				placecells = false
			end
			RefreshChunks()
		elseif x >= 725-75 and x <= 725-75+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
				end
			end
			DoTick()
			dtime = 0
			itime = 0
			isinitial = false
			placecells = false
		elseif x >= 725 and x <= 725+60 and y >= 25 and y <= 25+60*(winxm/winym) then
			paused = not paused
			modsOnUnpause()
			isinitial = false
			placecells = false
		elseif x >= 725 and x <= 725+60 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) and not isinitial then
			if newheight ~= height-2 or newwidth ~= width-2 then
				undocells = nil
			end
			for y=0,newheight+1 do
				initial[y] = initial[y] or {}
				cells[y] = {}
				placeables[y] = placeables[y] or {}
				if y%25 == 0 then chunks[math.floor(y/25)] = {} end
				for x=0,newwidth+1 do
					if x == 0 or x == newwidth+1 or y == 0 or y == newheight+1 then
						initial[y][x] = {
							ctype = walls[border],
							rot = 0,
							lastvars = {x, y, 0}
						}
					elseif x >= width-1 or y >= height-1 then
						initial[y][x] = {ctype = 0, rot = 0}
					end
					cells[y][x] = {}
					placeables[y][x] = placeables[y][x] or false
					chunks[math.floor(y/25)][math.floor(x/25)] = {}
				end
			end
			height = newheight+2
			width = newwidth+2
			bgsprites = love.graphics.newSpriteBatch(tex[0])
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].ctype = initial[y][x].ctype
					cells[y][x].rot = initial[y][x].rot
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
					cells[y][x].testvar = ""
					bgsprites:add((x-1)*20,(y-1)*20)
				end
			end
			placecells = false
			paused = true
			isinitial = true
			subtick = subtick and 0
			RefreshChunks()
			modsOnReset()
		elseif x >= 725-150 and x <= 725-15 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) and not isinitial then
			for y=0,height-1 do
				for x=0,width-1 do
					initial[y][x].ctype = cells[y][x].ctype 
					initial[y][x].rot = cells[y][x].rot
				end
			end
			placecells = false
			paused = true
			isinitial = true
			subtick = subtick and 0
			RefreshChunks()
			modsOnSetInitial()
		elseif x >= 755 and y >= 475-80*(winxm/winym) and x <= 795 and y <= 475-40*(winxm/winym) then
			if pasting then
				local lastcop = {}
				local selh = #copied
				local selw = #copied[0]
				for y=0,selh do
					lastcop[y] = {}
					for x=0,selw do	
						lastcop[y][x] = {}
						lastcop[y][x].ctype = copied[y][x].ctype
						lastcop[y][x].rot = copied[y][x].rot
						lastcop[y][x].place = copied[y][x].place
					end
				end
				copied = {}
				for y=0,selw do
					copied[y] = {}
					for x=0,selh do	
						copied[y][x] = {}
						copied[y][x].ctype = lastcop[x][selw-y].ctype
						copied[y][x].rot = (lastcop[x][selw-y].rot-1)%4
						copied[y][x].place = lastcop[x][selw-y].place
					end
				end
			else
				currentrot = (currentrot - 1)%4
			end
			placecells = false
		elseif x >= 675 and y >= 475-80*(winxm/winym) and x <= 715 and y <= 475-40*(winxm/winym) then
			if pasting then
				local lastcop = {}
				local selh = #copied
				local selw = #copied[0]
				for y=0,selh do
					lastcop[y] = {}
					for x=0,selw do	
						lastcop[y][x] = {}
						lastcop[y][x].ctype = copied[y][x].ctype
						lastcop[y][x].rot = copied[y][x].rot
						lastcop[y][x].place = copied[y][x].place
					end
				end
				copied = {}
				for y=0,selw do
					copied[y] = {}
					for x=0,selh do	
						copied[y][x] = {}
						copied[y][x].ctype = lastcop[selh-x][y].ctype
						copied[y][x].rot = (lastcop[selh-x][y].rot+1)%4
						copied[y][x].place = lastcop[selh-x][y].place
					end
				end
			else
				currentrot = (currentrot + 1)%4
			end
			placecells = false
		elseif x >= 675 and y >= 475 and x <= 715 and y <= 475+40*(winxm/winym) then
			page = math.max(page-1,1)
			placecells = false
		elseif x >= 755 and y >= 475 and x <= 795 and y <= 475+40*(winxm/winym) then
			page = math.min(page+1,math.ceil(#listorder/16))
			placecells = false
		elseif selecting then
			selx = math.max(math.min(math.floor((love.mouse.getX()+offx)/zoom),width-2),1)
			sely = math.max(math.min(math.floor((love.mouse.getY()+offy)/zoom),height-2),1)
		elseif pasting and b == 1 then
			pasting = false
			local original = {}
			if math.floor((love.mouse.getX()+offx)/zoom) > 0 and math.floor((love.mouse.getX()+offx)/zoom) < width-#copied[0]-1 and math.floor((love.mouse.getY()+offy)/zoom) > 0 and math.floor((love.mouse.getY()+offy)/zoom) < height-#copied-1 then 
				undocells = {}
				for y=0,height-1 do
					undocells[y] = {}
					for x=0,width-1 do
						undocells[y][x] = {}
						undocells[y][x].ctype = cells[y][x].ctype
						undocells[y][x].rot = cells[y][x].rot
						undocells[y][x].place = placeables[y][x]
						undocells[y][x].lastvars = {x,y,cells[y][x].rot}
						wasinitial = isinitial
					end
				end
				for y=0,#copied do
					original[y] = {}
					for x=0,#copied[0] do
						original[y][x] = CopyTable(copied[y][x])
						cells[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].ctype = copied[y][x].ctype
						cells[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].rot = copied[y][x].rot
						cells[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].lastvars = {x+math.floor((love.mouse.getX()+offx)/zoom),y+math.floor((love.mouse.getY()+offy)/zoom),copied[y][x].rot}
						if isinitial then
							initial[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].ctype = copied[y][x].ctype
							initial[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].rot = copied[y][x].rot
							placeables[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)] = copied[y][x].place
						end
					end
				end
				RefreshChunks()
			end
			placecells = false
			ModsOnPaste(selx, sely, selw, selh, copied, original)
		elseif pasting and b == 2 then
			pasting = false
			placecells = false
		elseif (b == 1 or b == 2) and math.floor((love.mouse.getY()+offy)/zoom) > 0 and math.floor((love.mouse.getX()+offx)/zoom) > 0 and math.floor((love.mouse.getY()+offy)/zoom) < height-1 and math.floor((love.mouse.getX()+offx)/zoom) < width-1 then
			undocells = nil
		end
	end
	modsOnMousePressed(x, y, b, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	if placecells then
		canundo = true
	end
	placecells = true
	modsOnMouseReleased(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
	if typing then
		if typing == 1 then
			if tonumber(key) then
				newwidth = tonumber(string.sub(tostring(newwidth)..key,1,3))
			elseif key == "backspace" then
				newwidth = tonumber(string.sub(tostring(newwidth),1,string.len(tostring(newwidth))-1)) or 0
			end
		elseif typing == 2 then
			if tonumber(key) then
				newheight = tonumber(string.sub(tostring(newheight)..key,1,3))
			elseif key == "backspace" then
				newheight = tonumber(string.sub(tostring(newheight),1,string.len(tostring(newheight))-1)) or 0
			end
		end
	else
		if key == "q" then
			if pasting then
				local lastcop = {}
				local selh = #copied
				local selw = #copied[0]
				for y=0,selh do
					lastcop[y] = {}
					for x=0,selw do	
						lastcop[y][x] = {}
						lastcop[y][x].ctype = copied[y][x].ctype
						lastcop[y][x].rot = copied[y][x].rot
						lastcop[y][x].place = copied[y][x].place
					end
				end
				copied = {}
				for y=0,selw do
					copied[y] = {}
					for x=0,selh do	
						copied[y][x] = {}
						copied[y][x].ctype = lastcop[x][selw-y].ctype
						copied[y][x].rot = (lastcop[x][selw-y].rot-1)%4
						copied[y][x].place = lastcop[x][selw-y].place
					end
				end
			else
				currentrot = (currentrot - 1)%4
			end
		elseif key == "e" then
			if pasting then
				local lastcop = {}
				local selh = #copied
				local selw = #copied[0]
				for y=0,selh do
					lastcop[y] = {}
					for x=0,selw do	
						lastcop[y][x] = {}
						lastcop[y][x].ctype = copied[y][x].ctype
						lastcop[y][x].rot = copied[y][x].rot
						lastcop[y][x].place = copied[y][x].place
					end
				end
				copied = {}
				for y=0,selw do
					copied[y] = {}
					for x=0,selh do	
						copied[y][x] = {}
						copied[y][x].ctype = lastcop[selh-x][y].ctype
						copied[y][x].rot = (lastcop[selh-x][y].rot+1)%4
						copied[y][x].place = lastcop[selh-x][y].place
					end
				end
			else
				currentrot = (currentrot + 1)%4
			end
		elseif key == "up" then
			if zoom < 160 then
				zoom = zoom*2
				offx = offx*2 + 400*winxm
				offy = offy*2 + 300*winym
			end
		elseif key == "down" then
			if zoom > 2 then
				offx = (offx-400*winxm)*0.5
				offy = (offy-300*winym)*0.5
				zoom = zoom*0.5
			end
		elseif key == "space" then
			paused = not paused
			isinitial = false
			modsOnUnpause()
		elseif key == "f" then
			for y=0,height-1 do
				for x=0,width-1 do
					cells[y][x].lastvars = {x,y,cells[y][x].rot}
				end
			end
			DoTick()
			dtime = 0
			itime = 0
			isinitial = false
		elseif key == "escape" then
			inmenu = not inmenu
			showinstructions = false
			typing = false
		elseif key == "r" then
			if love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui") then
				if newheight ~= height-2 or newwidth ~= width-2 then
					undocells = nil
				end
				for y=0,newheight+1 do
					initial[y] = initial[y] or {}
					cells[y] = {}
					placeables[y] = placeables[y] or {}
					if y%25 == 0 then chunks[math.floor(y/25)] = {} end
					for x=0,newwidth+1 do
						if x == 0 or x == newwidth+1 or y == 0 or y == newheight+1 then
							if border == 1 then
								initial[y][x] = {ctype = -1, rot = 0}
							elseif border == 2 then
								initial[y][x] = {ctype = 40, rot = 0}
							elseif border == 3 then
								initial[y][x] = {ctype = 11, rot = 0}
							elseif border == 4 then
								initial[y][x] = {ctype = 50, rot = 0}
							end
						elseif x >= width-1 or y >= height-1 then
							initial[y][x] = {ctype = 0, rot = 0}
						end
						cells[y][x] = {}
						placeables[y][x] = placeables[y][x] or false
						chunks[math.floor(y/25)][math.floor(x/25)] = {}
					end
				end
				height = newheight+2
				width = newwidth+2
				bgsprites = love.graphics.newSpriteBatch(tex[0])
				for y=0,height-1 do
					for x=0,width-1 do
						cells[y][x].ctype = initial[y][x].ctype
						cells[y][x].rot = initial[y][x].rot
						cells[y][x].lastvars = {x,y,cells[y][x].rot}
						cells[y][x].testvar = ""
						bgsprites:add((x-1)*20,(y-1)*20)
					end
				end
				paused = true
				isinitial = true
				subtick = subtick and 0
				RefreshChunks()
				modsOnReset()
			end
		elseif key == "tab" then
			selecting = not selecting
			selw = 0
			selh = 0
		elseif key == "c" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui")) then
			if selecting and selh > 0 then
				copied = {}
				for y=0,selh-1 do
					copied[y] = {}
					for x=0,selw-1 do
						copied[y][x] = {}
						copied[y][x].ctype = cells[y+sely][x+selx].ctype
						copied[y][x].rot = cells[y+sely][x+selx].rot
						copied[y][x].place = placeables[y+sely][x+selx]
					end
				end
				selecting = false
			end
			ModsOnCopy(selx, sely, selw, selh)
		elseif key == "x" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui")) then
			local original = CopyTable(copied or {})
			if selecting and selh > 0 then
				copied = {}
				for y=0,selh-1 do
					copied[y] = {}
					for x=0,selw-1 do
						copied[y][x] = {}
						copied[y][x].ctype = cells[y+sely][x+selx].ctype
						copied[y][x].rot = cells[y+sely][x+selx].rot
						copied[y][x].place = placeables[y+sely][x+selx]
						cells[y+sely][x+selx].ctype = 0
						cells[y+sely][x+selx].rot = 0
						if isinitial then
							initial[y+sely][x+selx].ctype = 0
							placeables[y+sely][x+selx] = false
						end
					end
				end
				selecting = false
			end
			ModsOnCut(selx, sely, selw, selh, copied, original)
		elseif key == "z" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui")) then
			if undocells then
				for y=0,height-1 do
					for x=0,width-1 do
						cells[y][x].ctype = undocells[y][x].ctype
						cells[y][x].rot = undocells[y][x].rot
						cells[y][x].lastvars = {x,y,undocells[y][x].rot}
						placeables[y][x] = undocells[y][x].place
						if wasinitial then
							initial[y][x].ctype = undocells[y][x].ctype
							initial[y][x].rot = undocells[y][x].rot
						end
					end
				end
				undocells = nil
			end
			RefreshChunks()
		elseif key == "v" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui")) and copied then
			selecting = false
			pasting = true
		elseif key == "c" then
			page = math.min(page+1,math.ceil(#listorder/16))
			placecells = false
		elseif key == "z" then
			page = math.max(page-1,1)
			placecells = false
		end
	end
	modsOnKeyPressed(key, scancode, isrepeat)
end

function love.wheelmoved(x,y)
	if y > 0 then
		for i=1,y do
			if zoom < 160 then
				zoom = zoom*2
				offx = offx*2 + 400*winxm
				offy = offy*2 + 300*winym
			end
		end
	elseif y < 0 then
		for i=-1,y,-1 do
			if zoom > 2 then
				offx = (offx-400*winxm)*0.5
				offy = (offy-300*winym)*0.5
				zoom = zoom*0.5
			end
		end
	end
	modsOnMouseScroll(x, y)
end