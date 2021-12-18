function UpdateGears()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 17 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							local direction = DirFromOff(cx, cy)
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
								jammed = true
							end
							if cells[y+cy][x+cx].ctype > initialCellCount then
								if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cx].ctype)(x+cx, y+cy, direction) == false) then
									jammed = true
								else
									jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
								end
							end
							if config['gears_restrictions'] ~= 'true' then
								jammed = false
							end
						end
					end
					if not jammed then
						local oldcell
						local storedcell = CopyCell(x-1,y)
						for i=-1,1 do
							oldcell = CopyCell(x+i,y-1)	
							cells[y-1][x+i] = storedcell
							if i == 0 then
								cells[y-1][x+i].rot = (storedcell.rot+1)%4
							end
							storedcell = oldcell
						end
						oldcell = CopyCell(x+1,y)	
						cells[y][x+1] = storedcell
						cells[y][x+1].rot = (storedcell.rot+1)%4
						storedcell = oldcell
						for i=1,-1,-1 do
							oldcell = CopyCell(x+i,y+1)	
							cells[y+1][x+i] = storedcell
							if i == 0 then
								cells[y+1][x+i].rot = (storedcell.rot+1)%4
							end
							storedcell = oldcell
						end
						cells[y][x-1] = storedcell
						cells[y][x-1].rot = (storedcell.rot+1)%4
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
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
	x,y = width-1,0
	while y < height do
		while x >= 0 do
			if GetChunk(x,y).hasgear then
				if not cells[y][x].updated and cells[y][x].ctype == 18 then
					local jammed = false
					for i=0,8 do
						if i ~= 4 then
							cx = i%3-1
							cy = math.floor(i/3)-1
							local direction = DirFromOff(cx, cy)
							if cells[y+cy][x+cx].ctype == -1 or cells[y+cy][x+cx].ctype == 40 or cells[y+cy][x+cx].ctype == 17 or cells[y+cy][x+cx].ctype == 18 or cells[y+cy][x+cx].ctype == 11 or cells[y+cy][x+cx].ctype == 50 then
								jammed = true
							end
							if cells[y+cy][x+cx].ctype > initialCellCount then
								if isModdedTrash(cells[y+cy][x+cx].ctype) or (GetSidedTrash(cells[y+cy][x+cx].ctype) ~= nil and GetSidedTrash(cells[y+cy][x+cy].ctype)(x+cx, y+cy, direction) == false) then
									jammed = true
								else
									jammed = not canPushCell(x+cx, y+cy, x, y, "gear")
								end
							end
							if config['gears_restrictions'] ~= 'true' then
								jammed = false
							end
						end
					end
					if not jammed then
						local oldcell
						local storedcell = CopyCell(x+1,y)
						for i=1,-1,-1 do
							oldcell = CopyCell(x+i,y-1)	
							cells[y-1][x+i] = storedcell
							if i == 0 then
								cells[y-1][x+i].rot = (storedcell.rot-1)%4
							end
							storedcell = oldcell
						end
						oldcell = CopyCell(x-1,y)	
						cells[y][x-1] = storedcell
						cells[y][x-1].rot = (storedcell.rot-1)%4
						storedcell = oldcell
						for i=-1,1 do
							oldcell = CopyCell(x+i,y+1)	
							cells[y+1][x+i] = storedcell
							if i == 0 then
								cells[y+1][x+i].rot = (storedcell.rot-1)%4
							end
							storedcell = oldcell
						end
						cells[y][x+1] = storedcell
						cells[y][x+1].rot = (storedcell.rot-1)%4
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
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		y = y + 1
		x = width-1
	end
end