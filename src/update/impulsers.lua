function UpdateImpulsers()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if x > 1 then PullCell(x-2,y,0,false,1) end
				end
				y = y + 1
			else
				y = y + 25
			end
		end
		y = 0
		x = x + 1
	end
	x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if x < width-2 then PullCell(x+2,y,2,false,1) end
				end
				y = y - 1
			else
				y = math.floor(y/25)*25 - 1
			end
		end
		y = height-1
		x = x - 1
	end
	x,y = width-1,height-1
	while y >= 0 do
		while x >= 0 do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if y < height-2 then PullCell(x,y+2,3,false,1) end
				end
				x = x - 1
			else
				x = math.floor(x/25)*25 - 1
			end
		end
		x = width-1
		y = y - 1
	end
	x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasimpulser then
				if not cells[y][x].updated and cells[y][x].ctype == 28 then
					if y > 1 then PullCell(x,y-2,1,false,1) end
				end
				x = x + 1
			else
				x = x + 25
			end
		end
		x = 0
		y = y + 1
	end
end