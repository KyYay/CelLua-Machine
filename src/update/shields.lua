function UpdateShields()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasshield then
				if not cells[y][x].updated and cells[y][x].ctype == 42 then
					for cx=x-1,x+1 do
						for cy=y-1,y+1 do
							cells[cy][cx].protected = true
						end
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
end