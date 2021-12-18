function UpdateRotators()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasrotator then
				if not cells[y][x].updated and cells[y][x].ctype == 56 then
					if cells[y][x].rot == 0 then
						cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					elseif cells[y][x].rot == 1 then
						cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot + 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot - 1)%4
					elseif cells[y][x].rot == 2 then
						cells[y][x+1].rot = (cells[y][x+1].rot - 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot + 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
					else
						cells[y][x+1].rot = (cells[y][x+1].rot + 1)%4
						cells[y+1][x].rot = (cells[y+1][x].rot - 1)%4
						cells[y][x-1].rot = (cells[y][x-1].rot - 1)%4
						cells[y-1][x].rot = (cells[y-1][x].rot + 1)%4
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
	while y < height do
		while x < width do
			if GetChunk(x,y).hasrotator then
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
				x = x + 1
			else
				x = x + 25
			end
		end
		y = y + 1
		x = 0
	end
end