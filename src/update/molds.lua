function UpdateMold()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasmold then
				if cells[y][x].ctype == 19 and cells[y][x].updated then
					cells[y][x].ctype = 0
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