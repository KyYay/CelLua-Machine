function DoSuperGenerator(x,y,dir)
	local direction = (dir+2)%4
	local cx = x
	local cy = y
	local addedrot = 0
	local copied = {}
	while true do							--what cells to copy?
		cells[cy][cx].scrosses = (cells[cy][cx].supdatekey or -1) == supdatekey and cells[cy][cx].scrosses or 0
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if (cells[cy][cx].supdatekey or -1) == supdatekey and cells[cy][cx].scrosses >= 3 then
			copied = {}
			cells[cy][cx].testvar = "genbreak"
			break
		elseif cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
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
		elseif cx == 0 or cx == width - 1 or cy == 0 or cy == height - 1 then
			if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 then
				local c = CopyCell(cx,cy)
				c.rot = (c.rot+addedrot)%4
				table.insert(copied,c)
			end
			cells[cy][cx].testvar = "genbreak"
			break
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, dir)
			if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
				local c = CopyCell(cx,cy)
				c.rot = (c.rot+addedrot)%4
				table.insert(copied,c)
				cells[cy][cx].testvar = "gen'd"
			else
				cells[cy][cx].testvar = "genbreak"
				break
			end
		end
		cells[cy][cx].scrosses = (cells[cy][cx].supdatekey == supdatekey and cells[cy][cx].scrosses or 0) + 1
		cells[cy][cx].supdatekey = supdatekey
	end 
	local self = CopyCell(x,y)
	for i=1,#copied do
		if not PushCell(x,y,dir,false,1,copied[i].ctype,copied[i].rot,copied[i].ctype == 19,{self.lastvars[1],self.lastvars[2],copied[i].rot},copied[i].protected,false) then
			break
		end
	end
end

function UpdateSuperGenerators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 0 then
					DoSuperGenerator(x,y,0)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 2 then
					DoSuperGenerator(x,y,2)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 3 then
					DoSuperGenerator(x,y,3)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassupergenerator then
				if not cells[y][x].updated and cells[y][x].ctype == 54 and cells[y][x].rot == 1 then
					DoSuperGenerator(x,y,1)
					supdatekey = supdatekey + 1
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