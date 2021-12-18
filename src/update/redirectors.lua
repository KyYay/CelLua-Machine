function UpdateRedirectors()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasredirector then
				if not cells[y][x].updated and cells[y][x].ctype == 16 then
					if cells[y][x-1].ctype ~= 16 then cells[y][x-1].rot = cells[y][x].rot end
					if cells[y][x+1].ctype ~= 16 then cells[y][x+1].rot = cells[y][x].rot end
					if cells[y-1][x].ctype ~= 16 then cells[y-1][x].rot = cells[y][x].rot end
					if cells[y+1][x].ctype ~= 16 then cells[y+1][x].rot = cells[y][x].rot end
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