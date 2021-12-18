function DoReplicator(x,y,dir,update)
	local direction = dir
	local cx = x
	local cy = y
	local addedrot = 0
	if update then cells[y][x].updated = true end
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
		elseif moddedDivergers[cells[cy][cx].ctype] and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
			break
		end
	end 
	cells[cy][cx].testvar = "gen'd"
	local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, dir)
	if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 and canGenCell then
		local p = PushCell(x,y,dir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype == 19,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected,false)
		if p then
			local ox, oy = cx, cy
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			local pos = walkDivergedPath(ox, oy, cx, cy)
			cx, cy = pos.x, pos.y
			modsOnCellGenerated(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy)
		end
	end
end

function UpdateReplicators()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 0 or cells[y][x].ctype == 45 and (cells[y][x].rot == 0 or cells[y][x].rot == 1)) then
					DoReplicator(x,y,0,cells[y][x].ctype ~= 45)
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
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 2 or cells[y][x].ctype == 45 and (cells[y][x].rot == 2 or cells[y][x].rot == 3)) then
					DoReplicator(x,y,2,cells[y][x].ctype ~= 45)
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
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 3 or cells[y][x].ctype == 45 and (cells[y][x].rot == 3 or cells[y][x].rot == 0)) then
					DoReplicator(x,y,3,true)
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
			if GetChunk(x,y).hasreplicator then
				if not cells[y][x].updated and (cells[y][x].ctype == 44 and cells[y][x].rot == 1 or cells[y][x].ctype == 45 and (cells[y][x].rot == 1 or cells[y][x].rot == 2)) then
					DoReplicator(x,y,1,true)
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