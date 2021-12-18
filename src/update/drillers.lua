function DoDriller(x,y,dir)
	local x2,y2 = x,y
	if dir == 0 then x2 = x+1 elseif dir == 2 then x2 = x-1 end
	if dir == 1 then y2 = y+1 elseif dir == 3 then y2 = y-1 end
	if cells[y2][x2].ctype ~= 11 and cells[y2][x2].ctype ~= 50 and cells[y2][x2].ctype ~= -1 and cells[y2][x2].ctype ~= 40 and not isModdedTrash(cells[y2][x2].ctype) and not (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
		if cells[y2][x2].ctype > initialCellCount then
			local canPush = canPushCell(x2, y2, x, y, "drill")
			if not canPush then
				return
			end
		end
		local oldcell = CopyCell(x,y)
		cells[y][x] = CopyCell(x2,y2)
		cells[y2][x2] = oldcell
		SetChunk(x,y,cells[y][x].ctype)
		SetChunk(x2,y2,cells[y2][x2].ctype)
	elseif cells[y2][x2].ctype == 11 or cells[y2][x2].ctype == 50 or isModdedTrash(cells[y2][x2].ctype) or (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
		cells[y][x].ctype = 0
		if cells[y2][x2].ctype == 50 then
			if x2 < width-1 and (not cells[y2][x2+1].protected and cells[y2][x2+1].ctype ~= -1 and cells[y2][x2+1].ctype ~= 11 and cells[y2][x2+1].ctype ~= 40 and cells[y2][x2+1].ctype ~= 50) then cells[y2][x2+1].ctype = 0 end
			if x2 > 0 and (not cells[y2][x2-1].protected and cells[y2][x2-1].ctype ~= -1 and cells[y2][x2-1].ctype ~= 11 and cells[y2][x2-1].ctype ~= 40 and cells[y2][x2-1].ctype ~= 50) then cells[y2][x2-1].ctype = 0 end
			if y2 < height-1 and (not cells[y2+1][x2].protected and cells[y2+1][x2].ctype ~= -1 and cells[y2+1][x2].ctype ~= 11 and cells[y2+1][x2].ctype ~= 40 and cells[y2+1][x2].ctype ~= 50) then cells[y2+1][x2].ctype = 0 end
			if y2 > 0 and (not cells[y2-1][x2].protected and cells[y2-1][x2].ctype ~= -1 and cells[y2-1][x2].ctype ~= 11 and cells[y2-1][x2].ctype ~= 40 and cells[y2-1][x2].ctype ~= 50) then cells[y2-1][x2].ctype = 0 end
		end
		if isModdedTrash(cells[y2][x2].ctype) or (GetSidedTrash(cells[y2][x2].ctype) ~= nil and GetSidedTrash(cells[y2][x2].ctype)(x2, y2, dir) == true) then
			modsOnTrashEat(cells[y2][x2].ctype, x2, y2, cells[y][x], x, y)
		end
		love.audio.play(destroysound)
	end
end

function UpdateDrillers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 0 then
					DoDriller(x,y,0)
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
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 2 then
					DoDriller(x,y,2)
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
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 3 then
					DoDriller(x,y,3)
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
			if GetChunk(x,y).hasdriller then
				if not cells[y][x].updated and cells[y][x].ctype == 57 and cells[y][x].rot == 1 then
					DoDriller(x,y,1)
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