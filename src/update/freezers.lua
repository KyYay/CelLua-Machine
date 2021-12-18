function UpdateFreezers()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasfreezer then
				if cells[y][x].ctype == 24 then
					cells[y+1][x].updated = (cells[y+1][x].ctype ~= 19 and not isUnfreezable(cells[y+1][x].ctype))	--mold disappears if .updated is true
					cells[y-1][x].updated = (cells[y-1][x].ctype ~= 19 and not isUnfreezable(cells[y-1][x].ctype))
					cells[y][x+1].updated = (cells[y][x+1].ctype ~= 19 and not isUnfreezable(cells[y][x+1].ctype))
					cells[y][x-1].updated = (cells[y][x-1].ctype ~= 19 and not isUnfreezable(cells[y][x-1].ctype))
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