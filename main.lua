local cells,delay,dtime,currentstate,currentrot,tex,zoom,offx,offy,placecells,interpolate,inmenu,tpu,updatekey,dodebug,itime,initial,isinitial,
paused,placeables,newwidth,newheight,showinstructions,chunks,ticknum,selecting,volume,copied,selx,sely,selw,selh,pasting =
{},0.25,0,1,0,{},20,0,0,true,true,false,1,0,false,0,{},true,true,{},100,100,true,{},0,false,0.5,{},0,0,0,0,false

local width,height = 102,102
love.graphics.setDefaultFilter("nearest")
tex[-2],tex[-1],tex[0] = love.graphics.newImage("placeable.png"),love.graphics.newImage("wall.png"),love.graphics.newImage("bg.png")
tex[1],tex[2],tex[3] = love.graphics.newImage("mover.png"),love.graphics.newImage("generator.png"),love.graphics.newImage("push.png")
tex[4],tex[5],tex[6] = love.graphics.newImage("slide.png"),love.graphics.newImage("onedirectional.png"),love.graphics.newImage("twodirectional.png")
tex[7],tex[8],tex[9] = love.graphics.newImage("threedirectional.png"),love.graphics.newImage("rotator_cw.png"),love.graphics.newImage("rotator_ccw.png")
tex[10],tex[11],tex[12] = love.graphics.newImage("rotator_180.png"),love.graphics.newImage("trash.png"),love.graphics.newImage("enemy.png")
tex[13],tex[14],tex[15] = love.graphics.newImage("puller.png"),love.graphics.newImage("mirror.png"),love.graphics.newImage("diverger.png")
tex[16],tex[17],tex[18] = love.graphics.newImage("redirector.png"),love.graphics.newImage("gear_cw.png"),love.graphics.newImage("gear_ccw.png")
tex[19],tex[20],tex[21] = love.graphics.newImage("mold.png"),love.graphics.newImage("repulse.png"),love.graphics.newImage("weight.png")
tex[22],tex[23],tex[24] = love.graphics.newImage("crossgenerator.png"),love.graphics.newImage("strongenemy.png"),love.graphics.newImage("freezer.png")
tex[25],tex[26],tex[27] = love.graphics.newImage("cwgenerator.png"),love.graphics.newImage("ccwgenerator.png"),love.graphics.newImage("advancer.png")
tex[28] = love.graphics.newImage("impulse.png")
tex.setinitial = love.graphics.newImage("setinitial.png")
tex.pix = love.graphics.newImage("pixel.png")
tex.menu = love.graphics.newImage("menu.png")
tex.zoomin = love.graphics.newImage("zoomin.png")
tex.zoomout = love.graphics.newImage("zoomout.png")
tex.select = love.graphics.newImage("select.png")
tex.copy = love.graphics.newImage("copy.png")
tex.cut = love.graphics.newImage("cut.png")
tex.paste = love.graphics.newImage("paste.png")
local bgsprites,winx,winy,winxm,winym
local destroysound = love.audio.newSource("destroy.wav", "static")
local beep = love.audio.newSource("beep.wav", "static")
local music = love.audio.newSource("music.wav", "stream")
music:setLooping(true)
love.audio.setVolume(0.5)
love.audio.play(music)
local enemyparticles = love.graphics.newParticleSystem(tex.pix)
enemyparticles:setSizes(4,0)
enemyparticles:setSpread(math.pi*2)
enemyparticles:setSpeed(0,200)
enemyparticles:setParticleLifetime(0.5,1)
enemyparticles:setEmissionArea("uniform",10,10)
enemyparticles:setSizeVariation(1)
enemyparticles:setLinearDamping(1)
enemyparticles:setBufferSize(10000)

local function lerp(a,b,m,notgraphics)
	if notgraphics or (interpolate and delay > 0) then	
		return a+(b-a)*m
	else return b end
end

local function round(a) --lazy moment
	return math.floor(a+0.5)
end
--honestly the chunk system doesn't help the lag as much as i expected it to but it helps a little bit so
local function SetChunk(x,y,ctype)
	if ctype == 1 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmover = true
	elseif ctype == 2 or ctype == 22 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasgenerator = true
	elseif ctype == 13 then
		chunks[math.floor(y/25)][math.floor(x/25)].haspuller = true
	elseif ctype == 8 or ctype == 9 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasrotator = true
	elseif ctype == 14 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmirror = true
	elseif ctype == 17 or ctype == 18 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasgear = true
	elseif ctype == 20 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasrepulser = true
	elseif ctype == 19 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmold = true
	elseif ctype == 16 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasredirector = true
	elseif ctype == 24 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasfreezer = true
	elseif ctype == 25 or ctype == 26 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasanglegenerator = true
	elseif ctype == 27 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasadvancer = true
	elseif ctype == 28 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasimpulser = true
	end
end

local function RefreshChunks()
	for y=0,(height-1)/25 do
		for x=0,(width-1)/25 do
			chunks[math.floor(y)][math.floor(x)] = {}
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			SetChunk(x,y,cells[y][x].ctype)
		end
	end
	ticknum = 0
end

local function GetChunk(x,y)
	return chunks[math.floor(y/25)][math.floor(x/25)]
end

local b74cheatsheet = {}	--i dont know why, but for some god damn reason i have to seperate the cheatsheets even though they use the exact same characters
for i=0,9 do b74cheatsheet[tostring(i)] = i end
for i=0,25 do b74cheatsheet[string.char(string.byte("a")+i)] = i+10 end
for i=0,25 do b74cheatsheet[string.char(string.byte("A")+i)] = i+36 end
b74cheatsheet["!"] = 62 b74cheatsheet["$"] = 63 b74cheatsheet["%"] = 64 b74cheatsheet["&"] = 65 b74cheatsheet["+"] = 66
b74cheatsheet["-"] = 67 b74cheatsheet["."] = 68 b74cheatsheet["="] = 69 b74cheatsheet["?"] = 70 b74cheatsheet["^"] = 71
b74cheatsheet["{"] = 72 b74cheatsheet["}"] = 73
local cheatsheet = {}
for i=0,9 do cheatsheet[tostring(i)] = i end
for i=0,25 do cheatsheet[string.char(string.byte("a")+i)] = i+10 end
for i=0,25 do cheatsheet[string.char(string.byte("A")+i)] = i+36 end
cheatsheet["!"] = 62 cheatsheet["$"] = 63 cheatsheet["%"] = 64 cheatsheet["&"] = 65 cheatsheet["+"] = 66
cheatsheet["-"] = 67 cheatsheet["."] = 68 cheatsheet["="] = 69 cheatsheet["?"] = 70 cheatsheet["^"] = 71
cheatsheet["{"] = 72 cheatsheet["}"] = 73 cheatsheet["/"] = 74 cheatsheet["#"] = 75 cheatsheet["+"] = 76
cheatsheet["-"] = 77 cheatsheet["_"] = 78 cheatsheet["*"] = 79 cheatsheet["'"] = 80 cheatsheet[":"] = 81
cheatsheet[","] = 82 cheatsheet["@"] = 83 cheatsheet["~"] = 84 cheatsheet["|"] = 85
for i=0,9 do cheatsheet[i] = tostring(i) end
for i=0,25 do cheatsheet[10+i] = string.char(string.byte("a")+i) end
for i=0,25 do cheatsheet[36+i] = string.char(string.byte("A")+i) end
cheatsheet[62] = "!" cheatsheet[63] = "$" cheatsheet[64] = "%" cheatsheet[65] = "&" cheatsheet[66] = "+" 
cheatsheet[67] = "-" cheatsheet[68] = "." cheatsheet[69] = "=" cheatsheet[70] = "?" cheatsheet[71] = "^" 
cheatsheet[72] = "{" cheatsheet[73] = "}" cheatsheet[74] = "/" cheatsheet[75] = "#" cheatsheet[76] = "+" 
cheatsheet[77] = "-" cheatsheet[78] = "_" cheatsheet[79] = "*" cheatsheet[80] = "'" cheatsheet[81] = ":" 
cheatsheet[82] = "," cheatsheet[83] = "@" cheatsheet[84] = "~" cheatsheet[85] = "|"

local function unbase74(origvalue)
	local result = 0
	local iter = 0
	local chars = string.len(origvalue)
	for i=chars,1,-1 do
		iter = iter + 1
		local mult = 74^(iter-1)
		result = result + b74cheatsheet[string.sub(origvalue,i,i)] * mult
	end
	return result
end

local function unbase86(origvalue)
	local result = 0
	local iter = 0
	local chars = string.len(origvalue)
	for i=chars,1,-1 do
		iter = iter + 1
		local mult = 86^(iter-1)
		result = result + cheatsheet[string.sub(origvalue,i,i)] * mult
	end
	return result
end

local function base86(origvalue)
	if origvalue == 0 then return 0 else
	local result = ""
	local iter = 0
	while true do
		iter = iter + 1
		local lowermult = 86^(iter-1)
		local mult = 86^(iter)
		if lowermult > origvalue then
			break
		else
			result = cheatsheet[math.floor(origvalue/lowermult)%86] .. result
		end
	end
	return result
	end
end

local V3Cells = {}
V3Cells["0"] = {2,0,false} V3Cells["i"] = {2,1,false} V3Cells["A"] = {2,2,false} V3Cells["S"] = {2,3,false}
V3Cells["1"] = {2,0,true} V3Cells["j"] = {2,1,true} V3Cells["B"] = {2,2,true} V3Cells["T"] = {2,3,true} 
V3Cells["2"] = {8,0,false} V3Cells["k"] = {8,1,false} V3Cells["C"] = {8,2,false} V3Cells["U"] = {8,3,false}
V3Cells["3"] = {8,0,true} V3Cells["l"] = {8,1,true} V3Cells["D"] = {8,2,true} V3Cells["V"] = {8,3,true} 
V3Cells["4"] = {9,0,false} V3Cells["m"] = {9,1,false} V3Cells["E"] = {9,2,false} V3Cells["W"] = {9,3,false}
V3Cells["5"] = {9,0,true} V3Cells["n"] = {9,1,true} V3Cells["F"] = {9,2,true} V3Cells["X"] = {9,3,true} 
V3Cells["6"] = {1,0,false} V3Cells["o"] = {1,1,false} V3Cells["G"] = {1,2,false} V3Cells["Y"] = {1,3,false}
V3Cells["7"] = {1,0,true} V3Cells["p"] = {1,1,true} V3Cells["H"] = {1,2,true} V3Cells["Z"] = {1,3,true} 
V3Cells["8"] = {4,0,false} V3Cells["q"] = {4,1,false} V3Cells["I"] = {4,2,false} V3Cells["!"] = {4,3,false}
V3Cells["9"] = {4,0,true} V3Cells["r"] = {4,1,true} V3Cells["J"] = {4,2,true} V3Cells["$"] = {4,3,true} 
V3Cells["a"] = {3,0,false} V3Cells["s"] = {3,1,false} V3Cells["K"] = {3,2,false} V3Cells["%"] = {3,3,false}
V3Cells["b"] = {3,0,true} V3Cells["t"] = {3,1,true} V3Cells["L"] = {3,2,true} V3Cells["&"] = {3,3,true} 
V3Cells["c"] = {-1,0,false} V3Cells["u"] = {-1,1,false} V3Cells["M"] = {-1,2,false} V3Cells["+"] = {-1,3,false}
V3Cells["d"] = {-1,0,true} V3Cells["v"] = {-1,1,true} V3Cells["N"] = {-1,2,true} V3Cells["-"] = {-1,3,true} 
V3Cells["e"] = {12,0,false} V3Cells["w"] = {12,1,false} V3Cells["O"] = {12,2,false} V3Cells["."] = {12,3,false}
V3Cells["f"] = {12,0,true} V3Cells["x"] = {12,1,true} V3Cells["P"] = {12,2,true} V3Cells["="] = {12,3,true} 
V3Cells["g"] = {11,0,false} V3Cells["y"] = {11,1,false} V3Cells["Q"] = {11,2,false} V3Cells["?"] = {11,3,false}
V3Cells["h"] = {11,0,true} V3Cells["z"] = {11,1,true} V3Cells["R"] = {11,2,true} V3Cells["^"] = {11,3,true} 
V3Cells["{"] = {0,0,false} V3Cells["}"] = {0,0,true}
V3Cells["^"] = {0,0,false}

local function CellToNum(y,x,hasplaceables)
	if x >= 0 and y >= 0 and x < width and y < height then
		if hasplaceables then
			return (cells[y][x].ctype+1)*8 + cells[y][x].rot*2 + ((placeables[y][x] and 1) or 0)
		else
			return (cells[y][x].ctype+1)*4 + cells[y][x].rot
		end
	else return -99 end
end

local function NumToCell(num,hasplaceables)
	if hasplaceables then
		return (math.floor(num/8)-1), math.floor(num/2)%4, num%2==1		--ctype, rot, placeable
	else
		return (math.floor(num/4)-1), num%4, false
	end
end

local function DecodeV3(code)
	local currentspot = 0
	local currentcharacter = 3 --start right after V3;
	local storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	width = unbase74(storedstring)+2
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	height = unbase74(storedstring)+2
	for y=0,height-1 do
		initial[y] = {}
		placeables[y] = {}
		cells[y] = {}
		for x=0,width-1 do
			initial[y][x] = {}
			cells[y][x] = {}
			initial[y][x].ctype = 0
			initial[y][x].rot = 0
			placeables[y][x] = false
		end
	end
	for y=0,(height-1)/25 do
		chunks[y] = {}
		for x=0,(width-1)/25 do
			chunks[y][x] = {}
		end
	end
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ")" then							--basic repeat
			local howmany = unbase74(string.sub(code,currentcharacter+1,currentcharacter+1))
			local howmuch = unbase74(string.sub(code,currentcharacter+2,currentcharacter+2))
			local curcell = 0
			local startspot = currentspot
			for i=1,howmuch do
				if curcell == 0 then
					curcell = howmany
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].ctype
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].rot
				placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = placeables[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1]
			end
			currentcharacter = currentcharacter + 2
		elseif string.sub(code,currentcharacter,currentcharacter) == "(" then						--advanced repeat
			local howmany = ""
			local howmuch = ""
			local simplemuch = false
			while true do
				currentcharacter = currentcharacter + 1
				if string.sub(code,currentcharacter,currentcharacter) == "(" then
					break
				elseif string.sub(code,currentcharacter,currentcharacter) == ")" then
					simplemuch = true
					break
				else
					howmany = howmany..string.sub(code,currentcharacter,currentcharacter)
				end
			end
			howmany = unbase74(howmany)
			if simplemuch then
				currentcharacter = currentcharacter + 1
				howmuch = unbase74(string.sub(code,currentcharacter,currentcharacter))
			else
				while true do
					currentcharacter = currentcharacter + 1
					if string.sub(code,currentcharacter,currentcharacter) == ")" then
						break
					else
						howmuch = howmuch..string.sub(code,currentcharacter,currentcharacter)
					end
				end
				howmuch = unbase74(howmuch)
			end
			local curcell = 0
			local startspot = currentspot
			for i=1,howmuch do
				if curcell == 0 then
					curcell = howmany
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].ctype
				initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = initial[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1].rot
				placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = placeables[math.floor(height-1-(startspot-curcell)/(width-2))][(startspot-curcell-1)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else																						--one cell
			currentspot = currentspot + 1
			local cell = V3Cells[string.sub(code,currentcharacter,currentcharacter)]
			initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].ctype = cell[1]
			initial[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1].rot = cell[2]
			placeables[math.floor(height-1-(currentspot)/(width-2))][(currentspot-1)%(width-2)+1] = cell[3]
		end
	end
	bgsprites = love.graphics.newSpriteBatch(tex[0])
	for y=0,height-1 do
		for x=0,width-1 do
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x].ctype = -1
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
	RefreshChunks()
	paused = true
	isinitial = true
end

local function DecodeK1(code)
	local currentspot = 0
	local currentcharacter = 3 --start right after K1;
	local storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	width = unbase86(storedstring)+2
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	height = unbase86(storedstring)+2
	local hasplaceables
	if string.sub(code,currentcharacter+1,currentcharacter+1) == "0" then
		hasplaceables = false
	else
		hasplaceables = true
	end
	currentcharacter = currentcharacter + 2
	for y=0,height-1 do
		initial[y] = {}
		placeables[y] = {}
		cells[y] = {}
		for x=0,width-1 do
			initial[y][x] = {}
			cells[y][x] = {}
			initial[y][x].ctype = 0
			initial[y][x].rot = 0
			placeables[y][x] = false
		end
	end
	for y=0,(height-1)/25 do
		chunks[y] = {}
		for x=0,(width-1)/25 do
			chunks[y][x] = {}
		end
	end
	while currentspot <= (width-2)*(height-2) do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == "<" then						--duplicate the last 6 cells X times
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase86(string.sub(code,currentcharacter+1,currentcharacter+2))*6
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase86(string.sub(code,currentcharacter,currentcharacter))*6
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = 6
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].ctype
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].rot
				placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = placeables[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == ">" then						--duplicate the last 5 cells X times
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase86(string.sub(code,currentcharacter+1,currentcharacter+2))*5
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase86(string.sub(code,currentcharacter,currentcharacter))*5
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = 5
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].ctype
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].rot
				placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = placeables[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == "[" then						--duplicate the last 4 cells X times
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase86(string.sub(code,currentcharacter+1,currentcharacter+2))*4
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase86(string.sub(code,currentcharacter,currentcharacter))*4
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = 4
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].ctype
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].rot
				placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = placeables[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == "]" then						--duplicate the last 3 cells X times
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase86(string.sub(code,currentcharacter+1,currentcharacter+2))*3
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase86(string.sub(code,currentcharacter,currentcharacter))*3
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = 3
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].ctype
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].rot
				placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = placeables[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == ")" then						--duplicate the last 2 cells X times
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase86(string.sub(code,currentcharacter+1,currentcharacter+2))*2
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase86(string.sub(code,currentcharacter,currentcharacter))*2
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = 2
				else
					curcell = curcell - 1
				end
				currentspot = currentspot + 1
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].ctype
				initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = initial[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1].rot
				placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = placeables[math.floor((startspot-curcell)/(width-2)+1)][(startspot-curcell)%(width-2)+1]
			end
		elseif string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else																						--one cell
			local celltype,cellrot,place
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				celltype,cellrot,place = NumToCell(unbase86(string.sub(code,currentcharacter+1,currentcharacter+2)),hasplaceables)
				currentcharacter = currentcharacter + 2
			else
				celltype,cellrot,place = NumToCell(unbase86(string.sub(code,currentcharacter,currentcharacter)),hasplaceables)
			end
			currentspot = currentspot + 1
			initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].ctype = celltype
			initial[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1].rot = cellrot
			placeables[math.floor((currentspot-1)/(width-2)+1)][(currentspot-1)%(width-2)+1] = place
		end  
	end
	bgsprites = love.graphics.newSpriteBatch(tex[0])
	for y=0,height-1 do
		for x=0,width-1 do
			if y == 0 or x == 0 or y == height-1 or x == width-1 then
				initial[y][x].ctype = -1
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
	RefreshChunks()
	paused = true
	isinitial = true
end

local function EncodeK1()
	local currentcell = 0
	local result = "K1;"
	local hasplaceables = false
	for x=0,width-1 do
		for y=0,height-1 do
			hasplaceables = hasplaceables or placeables[y][x]
		end
	end
	result = result..base86(width-2)..";"..base86(height-2)..";"
	if hasplaceables then
		result = result.."1;"
	else
		result = result.."0;"
	end
	local currentloopmode = false
	local reps = 0
	while currentcell <= (width-2)*(height-2) do
		if currentloopmode ~= "break" and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and				--if the next 2 cells are the same as the last 5 cells, compress
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7396 then
			if currentloopmode == 2 or currentloopmode == false then
				if reps == 0 then
					result = result..")"
				end
				reps = reps + 1
				currentcell = currentcell + 2
				currentloopmode = 2
			else
				currentloopmode = "break"
			end
		elseif currentloopmode ~= "break" and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and				--or the next 3
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7396 then
			if currentloopmode == 3 or currentloopmode == false then
				if reps == 0 then
					result = result.."]"
				end
				reps = reps + 1
				currentcell = currentcell + 3
				currentloopmode = 3
			else
				currentloopmode = "break"
			end
		elseif currentloopmode ~= "break" and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-4)/(width-2)+1),(currentcell-4)%(width-2)+1,hasplaceables) and				--or the next 4
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+3)/(width-2)+1),(currentcell+3)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7396 then
			if currentloopmode == 4 or currentloopmode == false then
				if reps == 0 then
					result = result.."["
				end
				reps = reps + 1
				currentcell = currentcell + 4
				currentloopmode = 4
			else
				currentloopmode = "break"
			end
		elseif currentloopmode ~= "break" and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-5)/(width-2)+1),(currentcell-5)%(width-2)+1,hasplaceables) and				--or the next 5
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-4)/(width-2)+1),(currentcell-4)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+3)/(width-2)+1),(currentcell+3)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+4)/(width-2)+1),(currentcell+4)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7396 then
			if currentloopmode == 5 or currentloopmode == false then
				if reps == 0 then
					result = result..">"
				end
				reps = reps + 1
				currentcell = currentcell + 5
				currentloopmode = 5
			else
				currentloopmode = "break"
			end
		elseif currentloopmode ~= "break" and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-6)/(width-2)+1),(currentcell-6)%(width-2)+1,hasplaceables) and				--or the next 6
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-5)/(width-2)+1),(currentcell-5)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-4)/(width-2)+1),(currentcell-4)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+3)/(width-2)+1),(currentcell+3)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+4)/(width-2)+1),(currentcell+4)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+5)/(width-2)+1),(currentcell+5)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7396 then
			if currentloopmode == 6 or currentloopmode == false then
				if reps == 0 then
					result = result.."<"
				end
				reps = reps + 1
				currentcell = currentcell + 6
				currentloopmode = 6
			else
				currentloopmode = "break"
			end
		elseif reps ~= 0 or currentloopmode == "break" then
			if reps >= 86 then
				result = result.."("
			end
			result = result..base86(reps)
			currentloopmode = false
			reps = 0
		else
			if CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1) >= 86 then
				result = result.."("
				result = result..base86(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
			else
				result = result..base86(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
			end
			currentcell = currentcell + 1
		end
	end
	love.system.setClipboardText(result)
end

local function PushCell(x,y,dir,updateforces,force,replacetype,replacerot,replaceupdated,replacelastvars)	--replacetype/replacerot/etc is the cell that's going to replace the first one- needed for generator cells 
																						--note that cx/cy is the ORIGIN of the force; not the first cell that's going to be replaced
																						--which is why movers have it 1 cell behind them
																						--also it returns whether the movement was a success
	replacetype = replacetype or 0
	replacerot = replacerot or 0
	replaceupdated = replaceupdated or false
	replacelastvars = replacelastvars or {cx,cy,direction}
	updateforces = (updateforces == nil and true) or updateforces	--if it's nothing, set to true. this lets it have a default value without overwriting false with true
	local cx = x
	local cy = y
	local direction = dir
	local addedrot = 0
	local totalforce = force or 1
	local pushingdiverger = false
	local lasttype = replacetype
	local lastrot = replacerot
	repeat							--check for forces or blockages before doing movement
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].updatekey ~= updatekey then
			cells[cy][cx].projectedtype = cells[cy][cx].ctype
			cells[cy][cx].projectedrot = cells[cy][cx].rot
		end
		local checkedtype = cells[cy][cx].projectedtype
		local checkedrot = cells[cy][cx].projectedrot
		if checkedtype == 1 or checkedtype == 27 then
			if not pushingdiverger then	--any force towards the mover would go into the diverger so it doesnt count (also it makes some interactions symmetrical-er)
				if checkedrot == direction then
					totalforce = totalforce + 1
				elseif checkedrot == (direction+2)%4 then
					totalforce = totalforce - 1
				end
				if updateforces and direction%2 == checkedrot%2 then
					cells[cy][cx].updated = true
				end
			end
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
		or checkedtype == 5 and direction ~= checkedrot
		or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
		or checkedtype == 7 and direction == (checkedrot+2)%4 then
			totalforce = 0
		elseif checkedtype == 15 then
			local lastdir = direction
			if direction == 0 and checkedrot == 1 or direction == 2 and checkedrot == 0 then
				direction = 1
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 1 and checkedrot == 3 or direction == 3 and checkedrot == 0 then
				direction = 0
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 2 and checkedrot == 3 or direction == 0 and checkedrot == 2 then
				direction = 3
				addedrot = addedrot + (direction-lastdir)
			elseif direction == 3 and checkedrot == 1 or direction == 1 and checkedrot == 2 then
				direction = 2
				addedrot = addedrot + (direction-lastdir)
			else
				pushingdiverger = true
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				lasttype = checkedtype
				lastrot = checkedrot
				addedrot = 0
			end
		elseif checkedtype == 20 or checkedtype == 21 then
			totalforce = totalforce - 1 
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		else
			cells[cy][cx].projectedtype = lasttype
			cells[cy][cx].projectedrot = (lastrot+addedrot)%4
			lasttype = checkedtype
			lastrot = checkedrot
			addedrot = 0
		end
		cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
		if cells[cy][cx].crosses >= 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop
			totalforce = 0
		end
		if cx == x and cy == y and direction == dir and replacetype == 0 then		--if a cell isn't generated, let logical infinite loops work
			break
		end
		cells[cy][cx].updatekey = updatekey
	until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
	--movement time
	cells[cy][cx].testvar = "end"
	if totalforce > 0 then
		local direction = dir
		local cx = x
		local cy = y
		local storedtype = replacetype
		local storedrot = replacerot
		local storedupdated = replaceupdated
		local storedvars = replacelastvars
		local addedrot = 0
		local reps = 0
		repeat
			reps = reps + 1
			if reps == 999999 then cells[cy][cx].ctype = 11 break end
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 11 then
				if storedtype ~= 0 then love.audio.play(destroysound) end
				break
			elseif cells[cy][cx].ctype == 12 then
				if storedtype ~= 0 then 
					cells[cy][cx].ctype = 0
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				end
				break
			elseif cells[cy][cx].ctype == 23 then
				if storedtype ~= 0 then 
					cells[cy][cx].ctype = 12
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				end
				break
			elseif cells[cy][cx].ctype == 15 then
				local olddir = direction
				if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
					direction = 1
					addedrot = addedrot + (direction - olddir)
				elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
					direction = 0
					addedrot = addedrot + (direction - olddir)
				elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
					direction = 3
					addedrot = addedrot + (direction - olddir)
				elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
					direction = 2
					addedrot = addedrot + (direction - olddir)
				else
					local oldtype = cells[cy][cx].ctype 
					local oldrot = cells[cy][cx].rot
					local oldupdated = cells[cy][cx].updated
					local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					cells[cy][cx].ctype = storedtype
					cells[cy][cx].rot =  (storedrot + addedrot)%4
					cells[cy][cx].updated = storedupdated
					cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
					storedtype = oldtype
					storedrot = oldrot
					storedupdated = oldupdated
					storedvars = oldvars
					addedrot = 0
				end
			else
				local oldtype = cells[cy][cx].ctype 
				local oldrot = cells[cy][cx].rot
				local oldupdated = cells[cy][cx].updated
				local oldvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
				cells[cy][cx].ctype = storedtype
				cells[cy][cx].rot =  (storedrot + addedrot)%4
				cells[cy][cx].updated = storedupdated
				cells[cy][cx].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
				storedtype = oldtype
				storedrot = oldrot
				storedupdated = oldupdated
				storedvars = oldvars
				addedrot = 0
			end
			SetChunk(cx,cy,cells[cy][cx].ctype)
		until storedtype == 0
	else
		updatekey = updatekey + 1
		return false
	end
	updatekey = updatekey + 1
	return true
end

local function PullCell(x,y,dir,ignoreblockage,force,updateforces)	--same story as pushcell, but pulls; x/y is the actual cell you want to be the puller here, instead of the origin
																	--also ignoreblockage is only useful for advancer-like cells
	updateforces = (updateforces == nil and true) or updateforces
	local direction = dir
	local cx = x
	local cy = y
	local blocked = false
	if not ignoreblockage then
		while true do
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 0 or cells[cy][cx].ctype == 11 or cells[cy][cx].ctype == 12 or cells[cy][cx].ctype == 23 then
				break
			elseif cells[cy][cx].ctype == 15 then
				if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
					direction = 1
				elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
					direction = 0
				elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
					direction = 3
				elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
					direction = 2
				else
					blocked = true
					break
				end
			else
				blocked = true
				break
			end
		end
	end
	cells[cy][cx].testvar = "front"
	if not blocked then
		local frontcx = cx
		local frontcy = cy
		local frontdir = direction
		local totalforce = force or 0
		local addedrot = 0
		cells[cy][cx].updated = true
		local lastcx = cx
		local lastcy = cy
		local ignoreforce = false	--onedirectional shenanigans
		repeat							--check for forces or blockages before doing movement
			if direction == 0 then
				cx = cx - 1	
			elseif direction == 2 then
				cx = cx + 1
			elseif direction == 3 then
				cy = cy + 1
			elseif direction == 1 then
				cy = cy - 1
			end
			if cells[cy][cx].updatekey ~= updatekey then
				cells[cy][cx].projectedtype = cells[cy][cx].ctype
				cells[cy][cx].projectedrot = cells[cy][cx].rot
			end
			local checkedtype = cells[cy][cx].projectedtype
			local checkedrot = cells[cy][cx].projectedrot
			if checkedtype == 1 or checkedtype == 13 or checkedtype == 27 then
				if not ignoreforce then
					if checkedrot == direction then
						totalforce = totalforce + 1
					elseif checkedrot == (direction+2)%4 then
						totalforce = totalforce - 1
					end
					if updateforces and checkedrot%2 == direction%2 then
						cells[cy][cx].updated = true
					end
				end
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			elseif checkedtype == -1 or checkedtype == 4 and direction%2 ~= checkedrot%2
			or checkedtype == 5 and direction ~= checkedrot
			or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
			or checkedtype == 7 and direction == (checkedrot+2)%4 then
				break
			elseif checkedtype == 5 or checkedtype == 6 --these two either stop the puller or face towards it with the other side unpullable, so we dont need to check their rotation
			or checkedtype == 7 and direction == checkedrot then
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
				ignoreforce = true
			elseif checkedtype == 15 then
				local lastdir = direction
				if direction == 0 and checkedrot == 3 or direction == 2 and checkedrot == 2 then
					direction = 1
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 1 and checkedrot == 1 or direction == 3 and checkedrot == 2 then
					direction = 0
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 2 and checkedrot == 1 or direction == 0 and checkedrot == 0 then
					direction = 3
					addedrot = addedrot + (direction-lastdir)
				elseif direction == 3 and checkedrot == 3 or direction == 1 and checkedrot == 0 then
					direction = 2
					addedrot = addedrot + (direction-lastdir)
				else
					break												--look, to be honest i've had enough of dealing with weird diverger bs and its pretty much never useful to pull anything PAST a diverger
				end
			elseif checkedtype == 20 or checkedtype == 21 or checkedtype == 28 then
				totalforce = totalforce - 1
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			else
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			end
			cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
			if cells[cy][cx].crosses == 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop, and a bad one at that; the chain will stop in case of this emergency.
				totalforce = 0
			end
			cells[cy][cx].updatekey = updatekey
		until (totalforce <= 0 and checkedtype ~= 15) or checkedtype == 0 or checkedtype == 11 or checkedtype == 12 or checkedtype == 23
		--movement time
		cells[cy][cx].testvar = "end"
		if totalforce > 0 then
			updatekey = updatekey + 1
			local cx = frontcx
			local cy = frontcy
			local direction = frontdir
			local addedrot = 0
			local lastcx = frontcx
			local lastcy = frontcy
			local reps = 0
			cells[y][x].origpuller = true
			repeat
				reps = reps + 1
				if reps == 999999 then cells[cy][cx].ctype = 11 end
				cells[lastcy][lastcx].updatekey = updatekey
				if direction == 0 then
					cx = cx - 1	
				elseif direction == 2 then
					cx = cx + 1
				elseif direction == 3 then
					cy = cy + 1
				elseif direction == 1 then
					cy = cy - 1
				end
				if cells[cy][cx].ctype == 11 or cells[cy][cx].ctype == 12 or cells[cy][cx].ctype == 23 then
					cells[lastcy][lastcx].ctype = 0
					break
				elseif cells[cy][cx].ctype == 15 then
					local olddir = direction
					if direction == 0 and cells[cy][cx].rot == 3 or direction == 2 and cells[cy][cx].rot == 2 then
						direction = 1
						addedrot = addedrot + (direction-olddir)
					elseif direction == 1 and cells[cy][cx].rot == 1 or direction == 3 and cells[cy][cx].rot == 2 then
						direction = 0
						addedrot = addedrot + (direction-olddir)
					elseif direction == 2 and cells[cy][cx].rot == 1 or direction == 0 and cells[cy][cx].rot == 0 then
						direction = 3
						addedrot = addedrot + (direction-olddir)
					elseif direction == 3 and cells[cy][cx].rot == 3 or direction == 1 and cells[cy][cx].rot == 0 then
						direction = 2
						addedrot = addedrot + (direction-olddir)
					else
						cells[lastcy][lastcx].ctype = cells[cy][cx].ctype 
						cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)%4
						cells[lastcy][lastcx].updated = cells[cy][cx].updated
						cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
						cells[cy][cx].ctype = 0
						break
					end
				elseif cells[cy][cx].ctype == -1 or cells[cy][cx].ctype == 4 and direction%2 ~= cells[cy][cx].rot%2
				or cells[cy][cx].ctype == 5 and direction ~= cells[cy][cx].rot
				or cells[cy][cx].ctype == 6 and (direction ~= cells[cy][cx].rot and direction ~= (cells[cy][cx].rot-1)%4)
				or cells[cy][cx].ctype == 7 and direction == (cells[cy][cx].rot+2)%4 then
					cells[lastcy][lastcx].ctype = 0
					break
				elseif (cells[cy][cx].updatekey == updatekey and cells[cy][cx].origpuller) then	--while it would make sense to let it pull stuff that's already been pulled, i cant allow it because of weird infinite loops that would otherwise function how you'd expect
					cells[lastcy][lastcx].ctype = 0
					cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)%4
					cells[lastcy][lastcx].updated = cells[cy][cx].updated
					cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					break
				else
					if cells[lastcy][lastcx].ctype == 11 then
						if cells[cy][cx].ctype ~= 0 then love.audio.play(destroysound) end
					elseif cells[lastcy][lastcx].ctype == 12 then
						if cells[cy][cx].ctype ~= 0 then
							love.audio.play(destroysound)
							cells[lastcy][lastcx].ctype = 0
							enemyparticles:setPosition(lastcx*20,lastcy*20)
							enemyparticles:emit(50)
						end
					elseif cells[lastcy][lastcx].ctype == 23 then
						if cells[cy][cx].ctype ~= 0 then
							love.audio.play(destroysound)
							cells[lastcy][lastcx].ctype = 12
							enemyparticles:setPosition(lastcx*20,lastcy*20)
							enemyparticles:emit(50)
						end
					else
						cells[lastcy][lastcx].ctype = cells[cy][cx].ctype 
						cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)%4
						cells[lastcy][lastcx].updated = cells[cy][cx].updated
						cells[lastcy][lastcx].lastvars = {cells[cy][cx].lastvars[1],cells[cy][cx].lastvars[2],cells[cy][cx].lastvars[3]}
					end
					addedrot = 0
					SetChunk(lastcx,lastcy,cells[lastcy][lastcx].ctype)
					lastcx = cx
					lastcy = cy
				end
			until cells[cy][cx].ctype == 0
			cells[cy][cx].testvar = "moveend"
		else
			updatekey = updatekey + 1
			return false
		end
	else
		updatekey = updatekey + 1
		return false
	end
	updatekey = updatekey + 1
	return true
end

local function UpdateFreezers()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasfreezer then
				if cells[y][x].ctype == 24 then
					cells[y+1][x].updated = cells[y+1][x].ctype ~= 19	--mold disappears if .updated is true
					cells[y-1][x].updated = cells[y-1][x].ctype ~= 19
					cells[y][x+1].updated = cells[y][x+1].ctype ~= 19
					cells[y][x-1].updated = cells[y][x-1].ctype ~= 19
				end
			else
				x = x + 25
			end
		end
	end
end

local function UpdateMirrors()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasmirror then
				if not cells[y][x].updated and cells[y][x].ctype == 14 and (cells[y][x].rot == 0 or cells[y][x].rot == 2) then
					if cells[y][x-1].ctype ~= 11 and cells[y][x-1].ctype ~= -1 and cells[y][x-1].ctype ~= 14 and cells[y][x+1].ctype ~= 11 and cells[y][x+1].ctype ~= -1 and cells[y][x+1].ctype ~= 14 then
						local oldcell = cells[y][x-1].ctype
						local oldrot = cells[y][x-1].rot
						local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
						cells[y][x-1].ctype = cells[y][x+1].ctype
						cells[y][x-1].rot = cells[y][x+1].rot
						cells[y][x-1].lastvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
						cells[y][x+1].ctype = oldcell
						cells[y][x+1].rot = oldrot
						cells[y][x+1].lastvars = oldvars
						SetChunk(x+1,y,cells[y][x+1].ctype)
						SetChunk(x-1,y,cells[y][x-1].ctype)
					end
				end
			else
				x = x + 25
			end
		end
	end
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).hasmirror then
				if not cells[y][x].updated and cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) then
					if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 14 and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 14 then
						local oldcell = cells[y-1][x].ctype
						local oldrot = cells[y-1][x].rot
						local oldvars = {cells[y-1][x].lastvars[1],cells[y-1][x].lastvars[2],cells[y-1][x].lastvars[3]}
						cells[y-1][x].ctype = cells[y+1][x].ctype
						cells[y-1][x].rot = cells[y+1][x].rot
						cells[y-1][x].lastvars = {cells[y+1][x].lastvars[1],cells[y+1][x].lastvars[2],cells[y+1][x].lastvars[3]}
						cells[y+1][x].ctype = oldcell
						cells[y+1][x].rot = oldrot
						cells[y+1][x].lastvars = oldvars
						cells[y+1][x].lastvars = oldvars
						SetChunk(x,y+1,cells[y+1][x].ctype)
						SetChunk(x,y-1,cells[y-1][x].ctype)
					end
				end
			else
				y = y + 25
			end
		end
	end
end

local function DoGenerator(x,y,dir,gendir)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if dir%2 == 1 or cells[y][x].ctype == 2 then
		cells[cy][cx].updated = true
	end
	while true do							--what cell to copy?
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].ctype == 15 then
			local olddir = direction
			if direction == 0 and cells[cy][cx].rot == 1 or direction == 2 and cells[cy][cx].rot == 0 then
				direction = 1
				addedrot = addedrot - (direction - olddir)
			elseif direction == 1 and cells[cy][cx].rot == 3 or direction == 3 and cells[cy][cx].rot == 0 then
				direction = 0
				addedrot = addedrot - (direction - olddir)
			elseif direction == 2 and cells[cy][cx].rot == 3 or direction == 0 and cells[cy][cx].rot == 2 then
				direction = 3
				addedrot = addedrot - (direction - olddir)
			elseif direction == 3 and cells[cy][cx].rot == 1 or direction == 1 and cells[cy][cx].rot == 2 then
				direction = 2
				addedrot = addedrot - (direction - olddir)
			else
				break
			end
		else
			break
		end
	end 
	addedrot = addedrot + (gendir-dir)
	cells[cy][cx].testvar = "gen'd"
	if cells[cy][cx].ctype ~= 0 then
		PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 2 or cells[cy][cx].ctype == 19 or cells[cy][cx].ctype == 22 or cells[cy][cx].ctype == 25 or cells[cy][cx].ctype == 26,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4})
	end
end

local function UpdateGenerators()
	for x=width-1,0,-1 do
		for y=height-1,0,-1 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 0 or cells[y][x].ctype == 22 and (cells[y][x].rot == 0 or cells[y][x].rot == 1)) then
					DoGenerator(x,y,0)
				end
			else
				y = y - 25
			end
		end
	end
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 2 or cells[y][x].ctype == 22 and (cells[y][x].rot == 2 or cells[y][x].rot == 3)) then
					DoGenerator(x,y,2)
				end
			else
				y = y + 25
			end
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 3 or cells[y][x].ctype == 22 and (cells[y][x].rot == 3 or cells[y][x].rot == 0)) then
					DoGenerator(x,y,3)
				end
			else
				x = x + 25
			end
		end
	end
	for y=height-1,0,-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 1 or cells[y][x].ctype == 22 and (cells[y][x].rot == 1 or cells[y][x].rot == 2)) then
					DoGenerator(x,y,1)
				end
			else
				x = x - 25
			end
		end
	end
	for x=width-1,0,-1 do
		for y=height-1,0,-1 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 0 then
					DoGenerator(x,y,3,0)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 0 then
					DoGenerator(x,y,1,0)
				end
			else
				y = y - 25
			end
		end
	end
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 2 then
					DoGenerator(x,y,1,2)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 2 then
					DoGenerator(x,y,3,2)
				end
			else
				y = y + 25
			end
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 3 then
					DoGenerator(x,y,2,3)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 3 then
					DoGenerator(x,y,0,3)
				end
			else
				x = x + 25
			end
		end
	end
	for y=height-1,0,-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 1 then
					DoGenerator(x,y,0,1)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 1 then
					DoGenerator(x,y,2,1)
				end
			else
				x = x - 25
			end
		end
	end
end

local function UpdateMold()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasmold then
				if cells[y][x].ctype == 19 and cells[y][x].updated then
					cells[y][x].ctype = 0
				end
			else
				x = x + 25
			end
		end
	end
end

local function UpdateRotators()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y) then
				if not cells[y][x].updated and cells[y][x].ctype == 8 then
					cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
					cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
					cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
					cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
				elseif not cells[y][x].updated and cells[y][x].ctype == 9 then
					cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
					cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
					cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
				elseif not cells[y][x].updated and cells[y][x].ctype == 10 then
					cells[y][x-1].rot = (cells[y][x-1].rot - 2)%4
					cells[y][x+1].rot = (cells[y][x+1].rot - 2)%4
					cells[y-1][x].rot = (cells[y-1][x].rot - 2)%4
					cells[y+1][x].rot = (cells[y+1][x].rot - 2)%4
				end
			else
				x = x + 25
			end
		end
	end
end

local function UpdateGears()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 17 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 then
								jammed = true
							end
						end
					end
					if not jammed then
						local storedtype = 0
						local storedrot = 0
						local storedvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
						local oldtype = cells[y][x-1].ctype 
						local oldrot = cells[y][x-1].rot
						local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
						cells[y][x-1].ctype = storedtype
						cells[y][x-1].rot = (storedrot+1)%4
						cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						for i=-1,1 do
							oldtype = cells[y-1][x+i].ctype 
							oldrot = cells[y-1][x+i].rot
							oldvars = {cells[y-1][x+i].lastvars[1],cells[y-1][x+i].lastvars[2],cells[y-1][x+i].lastvars[3]}
							cells[y-1][x+i].ctype = storedtype
							cells[y-1][x+i].rot = (storedrot+(i+1)%2)%4
							cells[y-1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
							storedtype = oldtype
							storedrot = oldrot
							storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						end
						oldtype = cells[y][x+1].ctype 
						oldrot = cells[y][x+1].rot
						oldvars = {cells[y][x-1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
						cells[y][x+1].ctype = storedtype
						cells[y][x+1].rot = (storedrot+1)%4
						cells[y][x+1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						for i=1,-1,-1 do
							oldtype = cells[y+1][x+i].ctype 
							oldrot = cells[y+1][x+i].rot
							oldvars = {cells[y+1][x+i].lastvars[1],cells[y+1][x+i].lastvars[2],cells[y+1][x+i].lastvars[3]}
							cells[y+1][x+i].ctype = storedtype
							cells[y+1][x+i].rot = (storedrot+(i+1)%2)%4
							cells[y+1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
							storedtype = oldtype
							storedrot = oldrot
							storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						end
						cells[y][x-1].ctype = storedtype
						cells[y][x-1].rot = (storedrot+1)%4
						cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
						SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
						SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
						SetChunk(x-1,y,cells[y][x-1].ctype)
					end
				end
			else
				x = x + 25
			end
		end
	end
	for y=0,height-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 18 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 then
								jammed = true
							end
						end
					end
					if not jammed then
						local storedtype = 0
						local storedrot = 0
						local storedvars = {cells[y][x+1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
						local oldtype = cells[y][x-1].ctype 
						local oldrot = cells[y][x-1].rot
						local oldvars = {cells[y][x-1].lastvars[1],cells[y][x-1].lastvars[2],cells[y][x-1].lastvars[3]}
						cells[y][x-1].ctype = storedtype
						cells[y][x-1].rot = (storedrot-1)%4
						cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						for i=-1,1 do
							oldtype = cells[y+1][x+i].ctype 
							oldrot = cells[y+1][x+i].rot
							oldvars = {cells[y+1][x+i].lastvars[1],cells[y+1][x+i].lastvars[2],cells[y+1][x+i].lastvars[3]}
							cells[y+1][x+i].ctype = storedtype
							cells[y+1][x+i].rot = (storedrot-(i+1)%2)%4
							cells[y+1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
							storedtype = oldtype
							storedrot = oldrot
							storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						end
						oldtype = cells[y][x+1].ctype 
						oldrot = cells[y][x+1].rot
						oldvars = {cells[y][x-1].lastvars[1],cells[y][x+1].lastvars[2],cells[y][x+1].lastvars[3]}
						cells[y][x+1].ctype = storedtype
						cells[y][x+1].rot = (storedrot-1)%4
						cells[y][x+1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						storedtype = oldtype
						storedrot = oldrot
						storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						for i=1,-1,-1 do
							oldtype = cells[y-1][x+i].ctype 
							oldrot = cells[y-1][x+i].rot
							oldvars = {cells[y-1][x+i].lastvars[1],cells[y-1][x+i].lastvars[2],cells[y-1][x+i].lastvars[3]}
							cells[y-1][x+i].ctype = storedtype
							cells[y-1][x+i].rot = (storedrot-(i+1)%2)%4
							cells[y-1][x+i].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
							storedtype = oldtype
							storedrot = oldrot
							storedvars = {oldvars[1],oldvars[2],oldvars[3]}
						end
						cells[y][x-1].ctype = storedtype
						cells[y][x-1].rot = (storedrot-1)%4
						cells[y][x-1].lastvars = {storedvars[1],storedvars[2],storedvars[3]}
						SetChunk(x+1,y+1,cells[y+1][x+1].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
						SetChunk(x-1,y+1,cells[y+1][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
						SetChunk(x+1,y-1,cells[y-1][x+1].ctype)
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x-1,y-1,cells[y-1][x-1].ctype)
						SetChunk(x-1,y,cells[y][x-1].ctype)
					end
				end
			else
				x = x - 25
			end
		end
	end
end

local function UpdateRedirectors()
	for y=0,height-1 do
		for x=0,width-1 do
				if cells[y][x].ctype == 16 then
			if not cells[y][x].updated and GetChunk(x,y).hasredirector then
					if cells[y][x-1].ctype ~= 16 then cells[y][x-1].rot = cells[y][x].rot end
					if cells[y][x+1].ctype ~= 16 then cells[y][x+1].rot = cells[y][x].rot end
					if cells[y-1][x].ctype ~= 16 then cells[y-1][x].rot = cells[y][x].rot end
					if cells[y+1][x].ctype ~= 16 then cells[y+1][x].rot = cells[y][x].rot end
				end
			else
				x = x + 25
			end
		end
	end
end


local function UpdateImpulsers()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					PullCell(x-2,y,0,false,1)
					PullCell(x+2,y,2,false,1)
					PullCell(x,y+2,3,false,1)
					PullCell(x,y-2,1,false,1)
				end
			else
				x = x + 25
			end
		end
	end
end

local function UpdateRepulsers()
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasrepulser then
				if not cells[y][x].updated and cells[y][x].ctype == 20 then
					PushCell(x,y,0)
					PushCell(x,y,2)
					PushCell(x,y,3)
					PushCell(x,y,1)
				end
			else
				x = x + 25
			end
		end
	end
end

local function DoAdvancer(x,y,dir)
	cells[y][x].updated = true
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	if PushCell(cx,cy,dir,true,0) then	--this is why i made pushcell return whether movement was a success or not
		PullCell(x,y,dir,true,1)
	end
end

local function UpdateAdvancers()
	for x=width-1,0,-1 do
		for y=height-1,0,-1 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 0 then
					DoAdvancer(x,y,0)
				end
			else
				y = y + 25
			end
		end
	end
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 2 then
					DoAdvancer(x,y,2)
				end
			else
				y = y - 25
			end
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 3 then
					DoAdvancer(x,y,3)
				end
			else
				x = x - 25
			end
		end
	end
	for y=height-1,0,-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).hasadvancer then
				if not cells[y][x].updated and cells[y][x].ctype == 27 and cells[y][x].rot == 1 then
					DoAdvancer(x,y,1)
				end
			else
				x = x + 25
			end
		end
	end
end

local function UpdatePullers()
	for x=width-1,0,-1 do
		for y=height-1,0,-1 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 0 then
					PullCell(x,y,0)
				end
			else
				y = y - 25
			end
		end
	end
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 2 then
					PullCell(x,y,2)
				end
			else
				y = y + 25
			end
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 3 then
					PullCell(x,y,3)
				end
			else
				x = x + 25
			end
		end
	end
	for y=height-1,0,-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).haspuller then
				if not cells[y][x].updated and cells[y][x].ctype == 13 and cells[y][x].rot == 1 then
					PullCell(x,y,1)
				end
			else
				x = x - 25
			end
		end
	end
end

local function DoMover(x,y,dir)
	cells[y][x].updated = true
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	PushCell(cx,cy,dir,true,0)	--it'll come across itself as it moves and get 1 totalforce
end

local function UpdateMovers()
	for x=0,width-1 do
		for y=0,height-1 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 0 then
					DoMover(x,y,0)
				end
			else
				y = y + 25
			end
		end
	end
	for x=width-1,0,-1 do
		for y=height-1,0,-1 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 2 then
					DoMover(x,y,2)
				end
			else
				y = y - 25
			end
		end
	end
	for y=height-1,0,-1 do
		for x=width-1,0,-1 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 3 then
					DoMover(x,y,3)
				end
			else
				x = x - 25
			end
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 1 then
					DoMover(x,y,1)
				end
			else
				x = x + 25
			end
		end
	end
end

local function DoTick()
	for y=0,height-1 do
		for x=0,width-1 do
			cells[y][x].updated = false
			cells[y][x].testvar = ""
		end
	end
	UpdateFreezers()
	UpdateMirrors()
	UpdateGenerators()
	UpdateMold()
	UpdateRotators()
	UpdateGears()
	UpdateRedirectors()
	UpdateImpulsers()
	UpdateRepulsers()
	UpdateAdvancers()
	UpdatePullers()
	UpdateMovers()
	ticknum = ticknum + 1
	if ticknum == 25 then
		RefreshChunks()
	end
end

function love.load()
	bgsprites = love.graphics.newSpriteBatch(tex[0])
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
				initial[y][x].ctype = -1
			else
				initial[y][x].ctype = 0
			end
			initial[y][x].rot = 0
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
				if y >= 180 and y <= 190 then
					delay = (x-150)/500
				elseif y >= 220 and y <= 230 then
					tpu = round((x-150)/(500/9))+1
				elseif y >= 260 and y <= 270 then
					newwidth = round((x-150)/(500/499))+1
				elseif y >= 300 and y <= 310 then
					newheight = round((x-150)/(500/499))+1
				elseif y >= 340 and y <= 350 then
					volume = (x-150)/500
					love.audio.setVolume(volume)
				end
			end
		end
	else
		if not paused then
			dtime = dtime + dt
			if updatekey > 10000000000 then updatekey = 0 end --juuuust in case
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
		if love.keyboard.isDown("lctrl") then
			if love.keyboard.isDown("w") then offy = offy - 16 end
			if love.keyboard.isDown("s") then offy = offy + 16 end
			if love.keyboard.isDown("a") then offx = offx - 16 end
			if love.keyboard.isDown("d") then offx = offx + 16 end
		else
			if love.keyboard.isDown("w") then offy = offy - 8 end
			if love.keyboard.isDown("s") then offy = offy + 8 end
			if love.keyboard.isDown("a") then offx = offx - 8 end
			if love.keyboard.isDown("d") then offx = offx + 8 end
		end
		if love.mouse.isDown(1) and placecells then
			local x = love.mouse.getX()/winxm
			local y = love.mouse.getY()/winym
			if x >= 755 and y >= 425-40*(winxm/winym) and x <= 795 and y <= 425 then
				offx = offx + 8
			elseif x >= 715 and y >= 425-80*(winxm/winym) and x <= 755 and y <= 425-40*(winxm/winym) then
				offy = offy - 8
			elseif x >= 715 and y >= 425 and x <= 755 and y <= 425+40*(winxm/winym) then
				offy = offy + 8
			elseif x >= 675 and y >= 425-40*(winxm/winym) and x <= 715 and y <= 425 then
				offx = offx - 8
			elseif selecting then
				selw = math.max(math.min(math.floor((love.mouse.getX()+offx)/zoom),width-2),selx) - selx + 1
				selh = math.max(math.min(math.floor((love.mouse.getY()+offy)/zoom),height-2),sely) - sely + 1
			else
				local x = math.floor((love.mouse.getX()+offx)/zoom)
				local y = math.floor((love.mouse.getY()+offy)/zoom)
				if x > 0 and y > 0 and x < width-1 and y < height-1 then
					if currentstate == -2 then
						if isinitial then
							placeables[y][x] = true
						end
					else
						cells[y][x].ctype = currentstate
						cells[y][x].rot = currentrot
						cells[y][x].lastvars = {x,y,currentrot}
						if isinitial then
							initial[y][x].ctype = currentstate
							initial[y][x].rot = currentrot
							initial[y][x].lastvars = {x,y,currentrot}
						end
						SetChunk(x,y,currentstate)
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
				if currentstate == -2 then
					if isinitial then
						placeables[y][x] = false
					end
				else
					cells[y][x].ctype = 0
					cells[y][x].rot = 0
					if isinitial then
						initial[y][x].ctype = 0
						initial[y][x].rot = 0
					end
				end
			end
		end
	end
	itime = math.min(itime + dt,delay)
	enemyparticles:update(dt)
end

function love.draw()
	love.graphics.setColor(1/8,1/8,1/8)
	love.graphics.rectangle("fill",-10,-10,9999,9999)
	love.graphics.setColor(1,1,1)
	love.graphics.draw(bgsprites,math.floor(zoom-offx+zoom/2),math.floor(zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10)
	if currentstate ~= -2 then
		for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
			for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
				if placeables[y][x] then 
					love.graphics.draw(tex[-2],math.floor(x*zoom-offx+zoom/2),math.floor(y*zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10)
				end
			end
		end
	end
	for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
		for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
			if cells[y][x].ctype ~= 0 then 
				love.graphics.draw(tex[cells[y][x].ctype],math.floor(lerp(cells[y][x].lastvars[1],x,itime/delay)*zoom-offx+zoom/2),math.floor(lerp(cells[y][x].lastvars[2],y,itime/delay)*zoom-offy+zoom/2),lerp(cells[y][x].lastvars[3],cells[y][x].lastvars[3]+((cells[y][x].rot-cells[y][x].lastvars[3]+2)%4-2),itime/delay)*math.pi/2,zoom/20,zoom/20,10,10)
			end
			if dodebug then
				love.graphics.print(tostring(cells[y][x].testvar),x*zoom-offx+zoom/2,y*zoom-offy+zoom/2)
			end
		end
	end
	if currentstate == -2 then
		for y=math.max(math.floor(offy/zoom)-1,0),math.min(math.floor((offy+600*winym)/zoom)+1,height-1) do
			for x=math.max(math.floor(offx/zoom)-1,0),math.min(math.floor((offx+800*winxm)/zoom)+1,width-1) do
				if placeables[y][x] then 
					love.graphics.draw(tex[-2],math.floor(x*zoom-offx+zoom/2),math.floor(y*zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10)
				end
			end
		end
	end
	love.graphics.setColor(1,1,1,0.25)
	if selecting then love.graphics.rectangle("fill",math.floor((selx)*zoom-offx),math.floor((sely)*zoom-offy),selw*zoom,selh*zoom) end
	love.graphics.setColor(1,1,1,0.5)
	if interpolate then love.graphics.draw(enemyparticles,-offx+zoom/2,-offy+zoom/2,0,zoom/20,zoom/20) end	--interpolate is the variable name for all fancy graphics now. no, im not changing it, i'm too lazy
	if pasting then
		for y=0,#copied do
			for x=0,#copied[0] do
				if copied[y][x].place then love.graphics.draw(tex[-2],math.floor((math.floor((love.mouse.getX()+offx)/zoom)+x)*zoom-offx+zoom/2),math.floor((math.floor((love.mouse.getY()+offy)/zoom)+y)*zoom-offy+zoom/2),0,zoom/20,zoom/20,10,10) end
				love.graphics.draw(tex[copied[y][x].ctype],(math.floor((love.mouse.getX()+offx)/zoom)+x)*zoom-offx+zoom/2,(math.floor((love.mouse.getY()+offy)/zoom)+y)*zoom-offy+zoom/2,copied[y][x].rot*math.pi/2,zoom/20,zoom/20,10,10)
			end
		end
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
		if currentstate == i-2 then love.graphics.setColor(1,1,1,0.5) else love.graphics.setColor(1,1,1,0.25) end
		love.graphics.draw(tex[i-2],(25+(775-25)*i/15)*winxm,575*winym,currentrot*math.pi/2,2*winxm,2*winxm,10,10)
	end
	for i=14,28 do
		if currentstate == i then love.graphics.setColor(1,1,1,0.5) else love.graphics.setColor(1,1,1,0.25) end
		love.graphics.draw(tex[i],(25+(775-25)*(i-14)/15)*winxm,525*winym,currentrot*math.pi/2,2*winxm,2*winxm,10,10)
	end
	if paused then
		love.graphics.setColor(0.5,0.5,0.5,0.75)
		love.graphics.rectangle("fill",5*winxm,5*winym,10*winxm,40*winxm)
		love.graphics.rectangle("fill",23*winxm,5*winym,10*winxm,40*winxm)
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(tex[1],725*winxm,25*winym,0,3*winxm,3*winxm)
	else
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(tex[4],785*winxm,25*winym,math.pi/2,3*winxm,3*winxm)
	end
	love.graphics.draw(tex[16],725*winxm-75*winxm,25*winym,0,3*winxm,3*winxm)
	love.graphics.draw(tex.menu,25*winxm,25*winym,0,winxm,winxm)
	love.graphics.draw(tex.zoomin,100*winxm,25*winym,0,3*winxm,3*winxm)
	love.graphics.draw(tex.zoomout,175*winxm,25*winym,0,3*winxm,3*winxm)
	if selecting then 
		love.graphics.draw(tex.copy,100*winxm,25*winym+75*winxm,0,3*winxm,3*winxm)
		love.graphics.draw(tex.cut,175*winxm,25*winym+75*winxm,0,3*winxm,3*winxm)
		love.graphics.setColor(1,1,1,0.75)
	end
	love.graphics.draw(tex.select,25*winxm,25*winym+75*winxm,0,3*winxm,3*winxm)
	love.graphics.setColor(1,1,1,0.5)
	if copied[0] then
		love.graphics.draw(tex.paste,25*winxm,25*winym+150*winxm,0,3*winxm,3*winxm)
		love.graphics.draw(tex[14],100*winxm,25*winym+150*winxm,0,3*winxm,3*winxm)
		love.graphics.draw(tex[14],235*winxm,25*winym+150*winxm,math.pi/2,3*winxm,3*winxm)
	end
	love.graphics.draw(tex[13],715*winxm,425*winym-80*winxm,-math.pi/2,2*winxm,2*winxm,20)
	love.graphics.draw(tex[13],755*winxm,425*winym-40*winxm,0,2*winxm,2*winxm)
	love.graphics.draw(tex[13],715*winxm,425*winym,math.pi/2,2*winxm,2*winxm,0,20)
	love.graphics.draw(tex[13],675*winxm,425*winym-40*winxm,math.pi,2*winxm,2*winxm,20,20)
	love.graphics.draw(tex[9],755*winxm,425*winym,0,2*winxm,2*winxm)
	love.graphics.draw(tex[8],675*winxm,425*winym,0,2*winxm,2*winxm)
	if not isinitial then
		love.graphics.draw(tex[10],725*winxm,25*winym+75*winxm,0,3*winxm,3*winxm)
		love.graphics.draw(tex.setinitial,725*winxm-150*winxm,25*winym+75*winxm,0,winxm,winxm)
	end
	local x = love.mouse.getX()/winxm
	local y = love.mouse.getY()/winym
	if inmenu then
		love.graphics.setColor(0.5,0.5,0.5,0.5)
		love.graphics.rectangle("fill",100*winxm,75*winym,600*winxm,450*winym)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("this is the menu",300*winxm,120*winym,0,2*winxm,2*winym)
		love.graphics.print("CelLua Machine v0.1.0",330*winxm,90*winym,0,winxm,winym)
		love.graphics.print("by KyYay",365*winxm,105*winym,0,winxm,winym)
		love.graphics.print("Update delay: "..string.sub(delay,1,4).."s",150*winxm,160*winym,0,winxm,winym)
		love.graphics.print("Ticks per update: "..tpu,150*winxm,200*winym,0,winxm,winym)
		love.graphics.print("Width (upon reset/clear): "..newwidth,150*winxm,240*winym,0,winxm,winym)
		love.graphics.print("Height (upon reset/clear): "..newheight,150*winxm,280*winym,0,winxm,winym)
		love.graphics.print("Volume: "..volume*100 .."%",150*winxm,320*winym,0,winxm,winym)
		love.graphics.print("Debug (Can cause lag!)",275*winxm,378*winym,0,winxm,winym)
		love.graphics.print("Fancy Graphix",475*winxm,378*winym,0,winxm,winym)
		love.graphics.setColor(1/4,1/4,1/4,1)
		love.graphics.rectangle("fill",150*winxm,180*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,220*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,260*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,300*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",150*winxm,340*winym,500*winxm,10*winym)
		love.graphics.rectangle("fill",250*winxm,375*winym,20*winxm,20*winym)
		love.graphics.rectangle("fill",450*winxm,375*winym,20*winxm,20*winym)
		love.graphics.setColor(1/2,1/2,1/2,1)
		love.graphics.rectangle("fill",lerp(149,649,delay,true)*winxm,180*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,(tpu-1)/9,true)*winxm,220*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,(newwidth-1)/499,true)*winxm,260*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,(newheight-1)/499,true)*winxm,300*winym,2*winxm,10*winym)
		love.graphics.rectangle("fill",lerp(149,649,volume,true)*winxm,340*winym,2*winxm,10*winym)
		if dodebug then love.graphics.polygon("fill",{255*winxm,378*winym ,252*winxm,380*winym ,265*winxm,393*winym ,268*winxm,390*winym}) end
		if dodebug then love.graphics.polygon("fill",{265*winxm,378*winym ,268*winxm,380*winym ,255*winxm,393*winym ,252*winxm,390*winym}) end
		if interpolate then love.graphics.polygon("fill",{455*winxm,378*winym ,452*winxm,380*winym ,465*winxm,393*winym ,468*winxm,390*winym}) end
		if interpolate then love.graphics.polygon("fill",{465*winxm,378*winym ,468*winxm,380*winym ,455*winxm,393*winym ,452*winxm,390*winym}) end
		--if dodebug then love.graphics.polygon("fill",{267,385 ,264,382 ,258,394 ,255,391}) end
		if x > 170 and y > 420 and x < 230 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Close menu\n     (Esc)",165*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[1],200*winxm,450*winym,0,3*winxm,3*winym,10,10)
		if x > 270 and y > 420 and x < 330 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Restart level\n   (Ctrl+R)",265*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[10],300*winxm,450*winym,0,3*winxm,3*winym,10,10)
		if x > 370 and y > 420 and x < 430 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Clear level",369*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[11],400*winxm,450*winym,0,3*winxm,3*winym,10,10)
		if x > 470 and y > 420 and x < 530 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Save level\n (Ctrl+S also it doesnt work yet)",470*winxm,480*winym,0,winxm,winym) else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[2],500*winxm,450*winym,math.pi*1.5,3*winym,3*winxm,10,10)
		if x > 570 and y > 420 and x < 630 and y < 480 then love.graphics.setColor(1,1,1,0.75) love.graphics.print("Load level\n  (V3/K1)",570*winxm,480*winym,0,winxm,winym)  else love.graphics.setColor(1,1,1,0.5) end
		love.graphics.draw(tex[16],600*winxm,450*winym,math.pi*0.5,3*winym,3*winxm,10,10)
	end
	if showinstructions or inmenu then
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("WASD = Move\n(Ctrl to speed up)\n\nQ/E = Rotate\n\nEsc = Menu\n\nZ/C = Change cell type\nor just click the hud\n\nSpace = Pause\n\nF = Advance one tick\n\nUp/down or mousewheel =\nZoom in/out\n\nTab = Select",10*winxm,340*winym,0,1*winxm,1*winym)
	end
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.print("FPS: ".. 1/delta,10,10)
end

function love.mousepressed(x,y,b)
	x = x/winxm
	y = y/winym
	if y > 420 and y < 480 then
		if inmenu and x > 170 and x < 230 then
			inmenu = false
			placecells = false
		elseif inmenu and x > 270 and x < 330 then
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
						initial[y][x] = {ctype = -1, rot = 0}
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
			love.audio.play(beep)
			RefreshChunks()
		elseif inmenu and x > 370 and x < 430 then
			width = newwidth+2
			height = newheight+2
			love.load()
			inmenu = false
			placecells = false
			paused = true
			isinitial = true
			love.audio.play(beep)
			RefreshChunks()
		elseif inmenu and x > 470 and x < 530 then
			EncodeK1()
			love.audio.play(beep)
		elseif inmenu and x > 570 and x < 630 then
			if string.sub(love.system.getClipboardText(),1,2) == "V3" then
				DecodeV3(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
			elseif string.sub(love.system.getClipboardText(),1,2) == "K1" then
				DecodeK1(love.system.getClipboardText())
				inmenu = false
				placecells = false
				newwidth = width-2
				newheight = height-2
				love.audio.play(beep)
			else
				love.audio.play(destroysound)
			end
		end
	elseif y > 575-20*(winxm/winym) and y < 575+20*(winxm/winym) then
		for i=0,15 do
			if x > 5+(775-25)*i/15 and x < 45+(775-25)*i/15 then
				currentstate = i-2
				placecells = false
			end
		end
	elseif y > 525-20*(winxm/winym) and y < 525+20*(winxm/winym) then
		for i=14,28 do
			if x > 5+(775-25)*(i-14)/15 and x < 45+(775-25)*(i-14)/15 then
				currentstate = i
				placecells = false
			end
		end
	elseif inmenu and y >= 375 and y <= 395 then
		if x >= 250 and x <= 270 then
			dodebug = not dodebug
			love.audio.play(beep)
		elseif x >= 450 and x <= 470 then
			interpolate = not interpolate
			love.audio.play(beep)
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
			if zoom > 4 then
				offx = (offx-400*winxm)*0.5
				offy = (offy-300*winym)*0.5
				zoom = zoom*0.5
			end
			placecells = false
		elseif x >= 25 and x <= 85 and y >= 100 and y <= 100+60*(winxm/winym) then
			selecting = not selecting
			pasting = false
			selw = 0
			selh = 0
			placecells = false
		elseif selecting and x >= 100 and x <= 160 and y >= 100 and y <= 100+60*(winxm/winym) then
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
			placecells = false
		elseif selecting and x >= 175 and x <= 175+60 and y >= 100 and y <= 100+60*(winxm/winym) then
			for y=0,selh-1 do
				copied[y] = {}
				for x=0,selw-1 do
					copied[y][x] = {}
					copied[y][x].ctype = cells[y+sely][x+selx].ctype
					copied[y][x].rot = cells[y+sely][x+selx].rot
					copied[y][x].place = placeables[y+sely][x+selx]
					cells[y+sely][x+selx].ctype = 0
					cells[y+sely][x+selx].rot = 0
					placeables[y+sely][x+selx] = false
				end
			end
			selecting = false
			placecells = false
		elseif x >= 25 and x <= 85 and y >= 175 and y <= 175+60*(winxm/winym) and #copied > 0 then
			selecting = false
			pasting = true
			placecells = false
		elseif x >= 100 and x <= 160 and y >= 175 and y <= 175+60*(winxm/winym) and #copied > 0 then
			local lastcop = {}
			for y=0,selh-1 do
				lastcop[y] = {}
				for x=0,selw-1 do
					lastcop[y][x] = {}
					lastcop[y][x].ctype = copied[y][x].ctype
					lastcop[y][x].rot = copied[y][x].rot
					lastcop[y][x].place = copied[y][x].place
				end
			end
			for y=0,selh-1 do
				for x=0,selw-1 do
					copied[y][x].ctype = lastcop[y][(selw-1)-x].ctype
					copied[y][x].rot = lastcop[y][(selw-1)-x].rot
					copied[y][x].place = lastcop[y][(selw-1)-x].place
				end
			placecells = false
			end
		elseif x >= 100 and x <= 160 and y >= 175 and y <= 175+60*(winxm/winym) and copied[0] then
			local lastcop = {}
			for y=0,selh-1 do
				lastcop[y] = {}
				for x=0,selw-1 do
					lastcop[y][x] = {}
					lastcop[y][x].ctype = copied[y][x].ctype
					lastcop[y][x].rot = copied[y][x].rot
					lastcop[y][x].place = copied[y][x].place
				end
			end
			for y=0,selh-1 do
				for x=0,selw-1 do
					copied[y][x].ctype = lastcop[(selh-1)-y][x].ctype
					copied[y][x].rot = lastcop[(selh-1)-y][x].rot
					copied[y][x].place = lastcop[(selh-1)-y][x].place
				end
			placecells = false
			end
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
			isinitial = false
			placecells = false
		elseif x >= 725 and x <= 725+60 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) then
			for y=0,newheight+1 do
				initial[y] = initial[y] or {}
				cells[y] = {}
				placeables[y] = placeables[y] or {}
				if y%25 == 0 then chunks[math.floor(y/25)] = {} end
				for x=0,newwidth+1 do
					if x == 0 or x == newwidth+1 or y == 0 or y == newheight+1 then
						initial[y][x] = {ctype = -1, rot = 0}
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
			RefreshChunks()
		elseif x >= 725-150 and x <= 725-15 and y >= 25+75*(winxm/winym) and y <= 25+75*(winxm/winym)+60*(winxm/winym) then
			for y=0,height-1 do
				for x=0,width-1 do
					initial[y][x].ctype = cells[y][x].ctype 
					initial[y][x].rot = cells[y][x].rot
				end
			end
			placecells = false
			paused = true
			isinitial = true
			RefreshChunks()
		elseif x >= 675 and y >= 425 and x <= 715 and y <= 425+40*(winxm/winym) then
			currentrot = (currentrot + 1)%4
			placecells = false
		elseif x >= 755 and y >= 425 and x <= 795 and y <= 425+40*(winxm/winym) then
			currentrot = (currentrot - 1)%4
			placecells = false
		elseif selecting then
			selx = math.max(math.min(math.floor((love.mouse.getX()+offx)/zoom),width-2),1)
			sely = math.max(math.min(math.floor((love.mouse.getY()+offy)/zoom),width-2),1)
		elseif pasting then
			pasting = false
			for y=0,#copied do
				for x=0,#copied[1] do
					cells[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].ctype = copied[y][x].ctype
					cells[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)].rot = copied[y][x].rot
					placeables[y+math.floor((love.mouse.getY()+offy)/zoom)][x+math.floor((love.mouse.getX()+offx)/zoom)] = copied[y][x].place
				end
			end
			placecells = false
		end
	end
end

function love.mousereleased()
	placecells = true
end

function love.keypressed(key)
	if key == "q" then
		currentrot = (currentrot - 1)%4
	elseif key == "e" then
		currentrot = (currentrot + 1)%4
	elseif key == "up" then
		if zoom < 160 then
			zoom = zoom*2
			offx = offx*2 + 400*winxm
			offy = offy*2 + 300*winym
		end
	elseif key == "down" then
		if zoom > 4 then
			offx = (offx-400*winxm)*0.5
			offy = (offy-300*winym)*0.5
			zoom = zoom*0.5
		end
	elseif key == "space" then
		paused = not paused
		isinitial = false
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
	elseif key == "r" then
		if love.keyboard.isDown("lctrl") then
			for y=0,newheight+1 do
				initial[y] = initial[y] or {}
				cells[y] = {}
				placeables[y] = placeables[y] or {}
				if y%25 == 0 then chunks[math.floor(y/25)] = {} end
				for x=0,newwidth+1 do
					if x == 0 or x == newwidth+1 or y == 0 or y == newheight+1 then
						initial[y][x] = {ctype = -1, rot = 0}
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
			RefreshChunks()
		end
	elseif key == "tab" then
		selecting = not selecting
		selw = 0
		selh = 0
		placecells = false
	elseif key == "c" and love.keyboard.isDown("lctrl") then
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
		placecells = false
	elseif key == "x" and love.keyboard.isDown("lctrl") then
		for y=0,selh-1 do
			copied[y] = {}
			for x=0,selw-1 do
				copied[y][x] = {}
				copied[y][x].ctype = cells[y+sely][x+selx].ctype
				copied[y][x].rot = cells[y+sely][x+selx].rot
				copied[y][x].place = placeables[y+sely][x+selx]
				cells[y+sely][x+selx].ctype = 0
				cells[y+sely][x+selx].rot = 0
			end
		end
		selecting = false
		placecells = false
	elseif key == "v" and love.keyboard.isDown("lctrl") and copied[0] then
		selecting = false
		pasting = true
		placecells = false
	end
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
			if zoom > 4 then
				offx = (offx-400*winxm)*0.5
				offy = (offy-300*winym)*0.5
				zoom = zoom*0.5
			end
		end
	end
end