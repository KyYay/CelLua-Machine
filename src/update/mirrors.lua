function UpdateMirrors()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmirror then
				if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 0 or cells[y][x].rot == 2) or cells[y][x].ctype == 55) then
					local canPushLeft = true
					local canPushRight = true
					if cells[y][x-1] ~= nil then
						if cells[y][x-1].ctype > initialCellCount then
							canPushLeft = canPushCell(x-1, y, x, y, "mirror")
						end
					end
					if cells[y][x+1] ~= nil then
						if cells[y][x+1].ctype > initialCellCount then
							canPushRight = canPushCell(x+1, y, x, y, "mirror")
						end
					end
					if isModdedTrash(cells[y][x-1].ctype) or ((GetSidedTrash(cells[y][x-1].ctype) ~= nil and GetSidedTrash(cells[y][x-1].ctype)(x-1, y, 0) == true)) then
						canPushLeft = false
					end
					if isModdedTrash(cells[y][x+1].ctype) or (GetSidedTrash(cells[y][x+1].ctype) ~= nil and GetSidedTrash(cells[y][x+1].ctype)(x+1, y, 2) == true) then
						canPushRight = false
					end
					if (cells[y][x-1].ctype ~= 11 and cells[y][x-1].ctype ~= 50 and cells[y][x-1].ctype ~= 55 and cells[y][x-1].ctype ~= -1 and cells[y][x-1].ctype ~= 40 and (cells[y][x-1].ctype ~= 14 or cells[y][x-1].rot%2 == 1) and canPushLeft
					and cells[y][x+1].ctype ~= 11 and cells[y][x+1].ctype ~= 50 and cells[y][x+1].ctype ~= 55 and cells[y][x+1].ctype ~= -1 and cells[y][x+1].ctype ~= 40 and (cells[y][x+1].ctype ~= 14 or cells[y][x+1].rot%2 == 1) and canPushRight) or config['mirror_restrictions'] ~= 'true' then
						local oldcell = CopyCell(x-1,y)
						cells[y][x-1] = CopyCell(x+1,y)
						cells[y][x+1] = oldcell
						SetChunk(x-1,y,cells[y][x-1].ctype)
						SetChunk(x+1,y,cells[y][x+1].ctype)
						modsOnMove(oldcell.ctype, x+1, y, oldcell.rot, 0, 1)
						modsOnMove(cells[y][x-1].ctype, x-1, y, cells[y][x-1].rot, 2, 1)
					end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
	x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasmirror then
				local canPushUp = true
				local canPushDown = true
				if cells[y-1] ~= nil then
					if cells[y-1][x].ctype > initialCellCount then
						canPushUp = canPushCell(x, y-1, x, y, "mirror")
					end
				end
				if cells[y+1] ~= nil then
					if cells[y+1][x].ctype > initialCellCount then
						canPushDown = canPushCell(x, y+1, x, y, "mirror")
					end
				end
				if cells[y-1] ~= nil then
					if isModdedTrash(cells[y-1][x].ctype) or ((GetSidedTrash(cells[y-1][x].ctype) ~= nil and GetSidedTrash(cells[y-1][x].ctype)(x, y-1, 3) == true)) then
						canPushUp = false
					end
				end
				if cells[y+1] ~= nil then
					if isModdedTrash(cells[y+1][x].ctype) or ((GetSidedTrash(cells[y+1][x].ctype) ~= nil and GetSidedTrash(cells[y+1][x].ctype)(x, y+1, 1) == true)) then
						canPushDown = false
					end
				end
				if not cells[y][x].updated and (cells[y][x].ctype == 14 and (cells[y][x].rot == 1 or cells[y][x].rot == 3) or cells[y][x].ctype == 55) then
					if cells[y-1][x].ctype ~= 11 and cells[y-1][x].ctype ~= 55 and cells[y-1][x].ctype ~= 50 and cells[y-1][x].ctype ~= -1 and cells[y-1][x].ctype ~= 40 and (cells[y-1][x].ctype ~= 14 or cells[y-1][x].rot%2 == 0)
					and cells[y+1][x].ctype ~= 11 and cells[y+1][x].ctype ~= 55 and cells[y+1][x].ctype ~= -1 and cells[y+1][x].ctype ~= 40 and (cells[y+1][x].ctype ~= 14 or cells[y+1][x].rot%2 == 0) and canPushUp and canPushDown or config['mirror_restrictions'] ~= 'true' then
						local oldcell = CopyCell(x,y-1)
						cells[y-1][x] = CopyCell(x,y+1)
						cells[y+1][x] = oldcell
						SetChunk(x,y-1,cells[y-1][x].ctype)
						SetChunk(x,y+1,cells[y+1][x].ctype)
						modsOnMove(oldcell.ctype, x, y+1, oldcell.rot, 1, 1)
						modsOnMove(cells[y-1][x].ctype, x, y-1, cells[y-1][x].rot, 3, 1)
					end
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		x = x + 1
		y = 0
	end
end