function DoGenerator(x,y,dir,gendir,istwist,dontupdate)
	gendir = gendir or dir
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	if not dontupdate then cells[y][x].updated = true end
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
		if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
			local olddir = direction
			if (cells[cy][cx].rot+3)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif cells[cy][cx].ctype == 30 then
			local olddir = direction
			if (cells[cy][cx].rot+3)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
			local olddir = direction
			if (cells[cy][cx].rot+1)%4 == direction then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot - (direction-olddir)
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			break
		end
	end 
	addedrot = addedrot + (gendir-dir)
	cells[cy][cx].testvar = "gen'd"
	local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, gendir)
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
		if istwist then
			local gentype,genrot = cells[cy][cx].ctype,cells[cy][cx].rot+addedrot
			if cells[y][x].rot%2 == 0 then
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot + 1)%4
				-- elseif moddedDivegers[gentype] ~= nil then
				-- 	genrot = moddedDivergers[gentype](cx, cy, genrot)
				else genrot = (-genrot)%4 end
			else
				if gentype == 8 then gentype = 9 
				elseif gentype == 9 then gentype = 8 
				elseif gentype == 17 then gentype = 18
				elseif gentype == 18 then gentype = 17 
				elseif gentype == 25 then gentype = 26 genrot = (-genrot + 2)%4
				elseif gentype == 26 then gentype = 25 genrot = (-genrot + 2)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) and genrot%2 == 0 then genrot = (genrot - 1)%4
				elseif (gentype == 6 or gentype == 22 or gentype == 30 or gentype == 45 or gentype == 52) then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) and genrot%2 == 0 then genrot = (genrot + 1)%4
				elseif (gentype == 15 or gentype == 56) then genrot = (genrot - 1)%4
				-- elseif moddedDivegers[gentype] ~= nil then
				-- 	genrot = moddedDivergers[gentype](cx, cy, genrot)
				else genrot = (-genrot + 2)%4 end
			end
			local p = PushCell(x,y,gendir,false,1,gentype,genrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],genrot},cells[cy][cx].protected,false)
			if p then
				local ox, oy = cx, cy
				if direction == 0 then
					cx = x - 1	
				elseif direction == 2 then
					cx = x + 1
				elseif direction == 3 then
					cy = y + 1
				elseif direction == 1 then
					cy = y - 1
				end
				local pos = walkDivergedPath(ox, oy, cx, cy)
				cx, cy = pos.x, pos.y
				modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
			end
		else
			local p = PushCell(x,y,gendir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
			if p then
				local ox, oy = cx, cy
				if direction == 0 then
					cx = x - 1	
				elseif direction == 2 then
					cx = x + 1
				elseif direction == 3 then
					cy = y + 1
				elseif direction == 1 then
					cy = y - 1
				end
				local pos = walkDivergedPath(ox, oy, cx, cy)
				cx, cy = pos.x, pos.y
				modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
			end
		end
	end
end

function UpdateGenerators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 0 or cells[y][x].ctype == 39 and cells[y][x].rot == 0 or cells[y][x].ctype == 22 and (cells[y][x].rot == 0 or cells[y][x].rot == 1)) then
					DoGenerator(x,y,0,0,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 2 or cells[y][x].ctype == 39 and cells[y][x].rot == 2 or cells[y][x].ctype == 22 and (cells[y][x].rot == 2 or cells[y][x].rot == 3)) then
					DoGenerator(x,y,2,2,cells[y][x].ctype == 39,cells[y][x].ctype == 22)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 3 or cells[y][x].ctype == 39 and cells[y][x].rot == 3 or cells[y][x].ctype == 22 and (cells[y][x].rot == 3 or cells[y][x].rot == 0)) then
					DoGenerator(x,y,3,3,cells[y][x].ctype == 39)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasgenerator then
				if not cells[y][x].updated and (cells[y][x].ctype == 2 and cells[y][x].rot == 1 or cells[y][x].ctype == 39 and cells[y][x].rot == 1 or cells[y][x].ctype == 22 and (cells[y][x].rot == 1 or cells[y][x].rot == 2)) then
					DoGenerator(x,y,1,1,cells[y][x].ctype == 39)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	--angled
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 0 then
					DoGenerator(x,y,3,0)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 0 then
					DoGenerator(x,y,1,0)
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 2 then
					DoGenerator(x,y,1,2)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 2 then
					DoGenerator(x,y,3,2)
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 3 then
					DoGenerator(x,y,2,3)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 3 then
					DoGenerator(x,y,0,3)
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasanglegenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 25 and cells[y][x].rot == 1 then
					DoGenerator(x,y,0,1)
				elseif not cells[y][x].updated and cells[y][x].ctype == 26 and cells[y][x].rot == 1 then
					DoGenerator(x,y,2,1)
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
end