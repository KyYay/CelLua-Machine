b74cheatsheet = {}	--i dont know why, but for some god damn reason i have to seperate the cheatsheets even though they use the exact same characters
for i=0,9 do b74cheatsheet[tostring(i)] = i end
for i=0,25 do b74cheatsheet[string.char(string.byte("a")+i)] = i+10 end
for i=0,25 do b74cheatsheet[string.char(string.byte("A")+i)] = i+36 end
b74cheatsheet["!"] = 62 b74cheatsheet["$"] = 63 b74cheatsheet["%"] = 64 b74cheatsheet["&"] = 65 b74cheatsheet["+"] = 66
b74cheatsheet["-"] = 67 b74cheatsheet["."] = 68 b74cheatsheet["="] = 69 b74cheatsheet["?"] = 70 b74cheatsheet["^"] = 71
b74cheatsheet["{"] = 72 b74cheatsheet["}"] = 73
cheatsheet = {}
for i=0,9 do cheatsheet[tostring(i)] = i end
for i=0,25 do cheatsheet[string.char(string.byte("a")+i)] = i+10 end
for i=0,25 do cheatsheet[string.char(string.byte("A")+i)] = i+36 end
cheatsheet["!"] = 62 cheatsheet["$"] = 63 cheatsheet["%"] = 64 cheatsheet["&"] = 65 cheatsheet["+"] = 66
cheatsheet["-"] = 67 cheatsheet["."] = 68 cheatsheet["="] = 69 cheatsheet["?"] = 70 cheatsheet["^"] = 71
cheatsheet["{"] = 72 cheatsheet["}"] = 73 cheatsheet["/"] = 74 cheatsheet["#"] = 75 cheatsheet["_"] = 76
cheatsheet["*"] = 77 cheatsheet["'"] = 78 cheatsheet[":"] = 79 cheatsheet[","] = 80 cheatsheet["@"] = 81
cheatsheet["~"] = 82 cheatsheet["|"] = 83
for k,v in pairs(cheatsheet) do
	cheatsheet[v] = k				--basically "invert" table
end

function unbase74(origvalue)
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

function unbase84(origvalue)
	local result = 0
	local iter = 0
	local chars = string.len(origvalue)
	for i=chars,1,-1 do
		iter = iter + 1
		local mult = 84^(iter-1)
		result = result + cheatsheet[string.sub(origvalue,i,i)] * mult
	end
	return result
end

function base84(origvalue)
	if origvalue == 0 then return 0 else
	local result = ""
	local iter = 0
	while true do
		iter = iter + 1
		local lowermult = 84^(iter-1)
		local mult = 84^(iter)
		if lowermult > origvalue then
			break
		else
			result = cheatsheet[math.floor(origvalue/lowermult)%84] .. result
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
V3Cells["{"] = {0,0,false} V3Cells["}"] = {0,0,true} V3Cells["^"] = {0,0,false} V3Cells[":"] = {0,0,false}

function CellToNum(y,x,hasplaceables)
	if x >= 1 and y >= 1 and x < width-1 and y < height-1 then
		if hasplaceables then
			if initial[y][x].ctype == 0 or initial[y][x].ctype == -1 or cells[y][x].ctype == 40 or initial[y][x].ctype == 3 or initial[y][x].ctype == 11 or initial[y][x].ctype == 12 or initial[y][x].ctype == 23
			or initial[y][x].ctype == 20 or initial[y][x].ctype == 28 or initial[y][x].ctype == 21 or initial[y][x].ctype == 24 or initial[y][x].ctype == 8 or initial[y][x].ctype == 9 or initial[y][x].ctype == 10
			or initial[y][x].ctype == 19 or initial[y][x].ctype == 17 or initial[y][x].ctype == 18 or initial[y][x].ctype == 38 or initial[y][x].ctype == 42 or initial[y][x].ctype == 46 or initial[y][x].ctype == 49
			or initial[y][x].ctype == 50 or initial[y][x].ctype == 55 then	--cells who dont care about rotations
				return (initial[y][x].ctype+1)*8 + ((placeables[y][x] and 1) or 0)
			elseif initial[y][x].ctype == 4 or initial[y][x].ctype == 14 or initial[y][x].ctype == 29 or initial[y][x].ctype == 30 or initial[y][x].ctype == 37 then	--cells who effectively only have 2 rotations
				return (initial[y][x].ctype+1)*8 + (initial[y][x].rot)%2*2 + ((placeables[y][x] and 1) or 0)
			else
				return (initial[y][x].ctype+1)*8 + initial[y][x].rot*2 + ((placeables[y][x] and 1) or 0)
			end
		else
			if initial[y][x].ctype == 0 or initial[y][x].ctype == -1 or cells[y][x].ctype == 40 or initial[y][x].ctype == 3 or initial[y][x].ctype == 11 or initial[y][x].ctype == 12 or initial[y][x].ctype == 23
			or initial[y][x].ctype == 20 or initial[y][x].ctype == 28 or initial[y][x].ctype == 21 or initial[y][x].ctype == 24 or initial[y][x].ctype == 8 or initial[y][x].ctype == 9 or initial[y][x].ctype == 10
			or initial[y][x].ctype == 19 or initial[y][x].ctype == 17 or initial[y][x].ctype == 18 or initial[y][x].ctype == 38 or initial[y][x].ctype == 42 or initial[y][x].ctype == 46 or initial[y][x].ctype == 49
			or initial[y][x].ctype == 50 or initial[y][x].ctype == 55 then	--cells who dont care about rotations
				return (initial[y][x].ctype+1)*4 + ((placeables[y][x] and 1) or 0)
			elseif initial[y][x].ctype == 4 or initial[y][x].ctype == 14 or initial[y][x].ctype == 29 or initial[y][x].ctype == 30 or initial[y][x].ctype == 37 then	--cells who effectively only have 2 rotations
				return (initial[y][x].ctype+1)*4 + initial[y][x].rot%2
			else
				return (initial[y][x].ctype+1)*4 + initial[y][x].rot
			end
		end
	else return -99 end
end

function NumToCell(num,hasplaceables)
	if hasplaceables then
		return (math.floor(num/8)-1), math.floor(num/2)%4, num%2==1		--ctype, rot, placeable
	else
		return (math.floor(num/4)-1), num%4, false
	end
end

function DecodeV3(code)
	local currentspot = 0
	local currentcharacter = 3 --start right after V3;
	local storedstring = ""
	undocells = nil
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
				initial[y][x].ctype = 40
			end
			cells[y][x].ctype = initial[y][x].ctype
			cells[y][x].rot = initial[y][x].rot
			cells[y][x].lastvars = {x,y,cells[y][x].rot}
			cells[y][x].testvar = ""
			bgsprites:add((x-1)*20,(y-1)*20)
		end
	end
	border = 2
	RefreshChunks()
	paused = true
	isinitial = true
	subtick = subtick and 0
end

function DecodeK1(code)
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
	width = unbase84(storedstring)+2
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	height = unbase84(storedstring)+2
	local hasplaceables
	if string.sub(code,currentcharacter+1,currentcharacter+1) == "0" then
		hasplaceables = false
	else
		hasplaceables = true
	end
	border = 1
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*6
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*6
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*5
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*5
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*4
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*4
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*3
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*3
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*2
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*2
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
				celltype,cellrot,place = NumToCell(unbase84(string.sub(code,currentcharacter+1,currentcharacter+2)),hasplaceables)
				currentcharacter = currentcharacter + 2
			else
				celltype,cellrot,place = NumToCell(unbase84(string.sub(code,currentcharacter,currentcharacter)),hasplaceables)
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
	subtick = subtick and 0
end


function DecodeK2(code)
	local currentspot = 0
	local currentcharacter = 3 --start right after K2;
	local storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	width = unbase84(storedstring)+2
	storedstring = ""
	while true do
		currentcharacter = currentcharacter + 1
		if string.sub(code,currentcharacter,currentcharacter) == ";" then
			break
		else
			storedstring = storedstring..string.sub(code,currentcharacter,currentcharacter) 
		end
	end
	height = unbase84(storedstring)+2
	local hasplaceables
	if unbase84(string.sub(code,currentcharacter+1,currentcharacter+1))%2 == 0 then
		hasplaceables = false
	else
		hasplaceables = true
	end
	border = math.floor(unbase84(string.sub(code,currentcharacter+1,currentcharacter+1))/2)+1
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
		if string.sub(code,currentcharacter,currentcharacter) == "<" then							--duplicate arbitrary amount of cells
			local howmany = 0
			local howmuch = 0
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmany = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))
				currentcharacter = currentcharacter + 2
			else
				howmany = unbase84(string.sub(code,currentcharacter,currentcharacter))
			end
			currentcharacter = currentcharacter + 1
			if string.sub(code,currentcharacter,currentcharacter) == "(" then
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*howmany
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*howmany
			end
			local startspot = currentspot
			local curcell = 1
			for i=1,howmuch do
				if curcell == 1 then
					curcell = howmany
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*5
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*5
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*4
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*4
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*3
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*3
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
				howmuch = unbase84(string.sub(code,currentcharacter+1,currentcharacter+2))*2
				currentcharacter = currentcharacter + 2
			else
				howmuch = unbase84(string.sub(code,currentcharacter,currentcharacter))*2
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
				celltype,cellrot,place = NumToCell(unbase84(string.sub(code,currentcharacter+1,currentcharacter+2)),hasplaceables)
				currentcharacter = currentcharacter + 2
			else
				celltype,cellrot,place = NumToCell(unbase84(string.sub(code,currentcharacter,currentcharacter)),hasplaceables)
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
				initial[y][x].ctype = walls[border]
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
	subtick = subtick and 0
end

function EncodeK2()
	local currentcell = 0
	local result = "K2;"
	local hasplaceables = false
	for x=0,width-1 do
		for y=0,height-1 do
			hasplaceables = hasplaceables or placeables[y][x]
		end
	end
	result = result..base84(width-2)..";"..base84(height-2)..";"
	if hasplaceables then
		result = result..base84((border-1)*2+1)..";"
	else
		result = result..base84((border-1)*2)..";"
	end
	local currentloopmode = false
	local reps = 0
	while currentcell <= (width-2)*(height-2) do
		if (currentloopmode == 2 or currentloopmode == false) and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and				--if the next 2 cells are the same as the last 5 cells, compress
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7055 then
			if reps == 0 then
				result = result..")"
			end
			reps = reps + 1
			currentcell = currentcell + 2
			currentloopmode = 2
		elseif (currentloopmode == 3 or currentloopmode == false) and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and				--or the next 3
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7055 then
			if reps == 0 then
				result = result.."]"
			end
			reps = reps + 1
			currentcell = currentcell + 3
			currentloopmode = 3
		elseif (currentloopmode == 4 or currentloopmode == false) and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-4)/(width-2)+1),(currentcell-4)%(width-2)+1,hasplaceables) and				--or the next 4
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+3)/(width-2)+1),(currentcell+3)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7055 then
			if reps == 0 then
				result = result.."["
			end
			reps = reps + 1
			currentcell = currentcell + 4
			currentloopmode = 4
		elseif (currentloopmode == 5 or currentloopmode == false) and CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-5)/(width-2)+1),(currentcell-5)%(width-2)+1,hasplaceables) and				--or the next 5
		CellToNum(math.floor((currentcell+1)/(width-2)+1),(currentcell+1)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-4)/(width-2)+1),(currentcell-4)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+2)/(width-2)+1),(currentcell+2)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-3)/(width-2)+1),(currentcell-3)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+3)/(width-2)+1),(currentcell+3)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-2)/(width-2)+1),(currentcell-2)%(width-2)+1,hasplaceables) and
		CellToNum(math.floor((currentcell+4)/(width-2)+1),(currentcell+4)%(width-2)+1,hasplaceables) == CellToNum(math.floor((currentcell-1)/(width-2)+1),(currentcell-1)%(width-2)+1,hasplaceables) and
		reps < 7055 then
			if reps == 0 then
				result = result..">"
			end
			reps = reps + 1
			currentcell = currentcell + 5
			currentloopmode = 5
		elseif currentloopmode ~= "break" and (currentloopmode or 0) > 5 and reps < 7055 then
			local itworked = true
			for j=0,(currentloopmode-1) do
				if CellToNum(math.floor((currentcell+j)/(width-2)+1),(currentcell+j)%(width-2)+1,hasplaceables) ~= CellToNum(math.floor((currentcell-(currentloopmode-j))/(width-2)+1),(currentcell-(currentloopmode-j))%(width-2)+1,hasplaceables) then
					itworked = false
					break
				end
			end
			if itworked then
				reps = reps + 1
				currentcell = currentcell + currentloopmode
			else
				currentloopmode = "break"
			end
		elseif currentloopmode == false then
			if math.min(currentcell,math.abs((width-2)*(height-2)-currentcell)) > 5 then
				local reping = false
				for i=6,math.min(math.min(currentcell,math.abs((width-2)*(height-2)-currentcell)),math.max((width-2)*2,(height-2)*2)) do
					local itworked = true
					for j=0,(i-1) do
						if CellToNum(math.floor((currentcell+j)/(width-2)+1),(currentcell+j)%(width-2)+1,hasplaceables) ~= CellToNum(math.floor((currentcell-(i-j))/(width-2)+1),(currentcell-(i-j))%(width-2)+1,hasplaceables) then
							itworked = false
							break
						end
					end
					if itworked then
						result = result.."<"
						if i >= 84 then
							result = result.."("
							result = result..base84(i)
						else
							result = result..base84(i)
						end  
						reps = reps + 1
						currentcell = currentcell + i
						currentloopmode = i
						reping = true
						break
					end
				end
				if not reping then
					if CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) >= 84 then
						result = result.."("
						result = result..base84(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
					else
						result = result..base84(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
					end
					currentcell = currentcell + 1
				end
			else
				if CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables) >= 84 then
					result = result.."("
					result = result..base84(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
				else
					result = result..base84(CellToNum(math.floor(currentcell/(width-2)+1),currentcell%(width-2)+1,hasplaceables))
				end
				currentcell = currentcell + 1
			end
		else
			if reps >= 84 then
				result = result.."("
			end
			result = result..base84(reps)
			currentloopmode = false
			reps = 0
		end
	end
	result = result..";"
	love.system.setClipboardText(result)
end