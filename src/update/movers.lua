function DoMover(x,y,dir)
	cells[y][x].updated = true
	local cx
	local cy
	if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 else cx = x end
	if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 else cy = y end
	PushCell(cx,cy,dir,true,0)	--it'll come across itself as it moves and get 1 totalforce
end

function UpdateMovers()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 0 then
					DoMover(x,y,0)
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
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 2 then
					DoMover(x,y,2)
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
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 3 then
					DoMover(x,y,3)
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
			if GetChunk(x,y).hasmover then
				if not cells[y][x].updated and cells[y][x].ctype == 1 and cells[y][x].rot == 1 then
					DoMover(x,y,1)
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