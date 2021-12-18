function DoSuperRepulser(x,y,dir)
	local cx,cy,direction = x,y,dir
	while true do
		while true do
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
				local olddir = direction
				if (cells[cy][cx].rot+3)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
			elseif cells[cy][cx].ctype == 30 then
				local olddir = direction
				if (cells[cy][cx].rot+3)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38) then
				break
			end
		end 
		local canGenCell = CanGenCell(cells[y][x].ctype, x, y, cells[cy][cx].ctype, cx, cy, direction)
		if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 11 and cells[cy][cx].ctype ~= 50 and cells[cy][cx].ctype ~= 12 and cells[cy][cx].ctype ~= 23 and (cells[cy][cx].rot ~= (direction+2)%4 or cells[cy][cx].ctype ~= 43)
		and (cells[cy][cx].ctype ~= 47 and cells[cy][cx].ctype ~= 48 or cells[cy][cx].rot ~= direction) and (cells[cy][cx].ctype < 31 or cells[cy][cx].ctype > 36 or cells[cy][cx].rot%2 == direction%2) and canGenCell then
			cells[cy][cx].scrosses = (cells[cy][cx].supdatekey == supdatekey and cells[cy][cx].scrosses or 0) + 1
			cells[cy][cx].supdatekey = supdatekey
			if cells[cy][cx].scrosses >= 999999999 then
				cells[cy][cx].testvar = "loop"
				break
			end
			if direction == 0 then cx = cx - 1 elseif direction == 2 then cx = cx + 1 end
			if direction == 1 then cy = cy - 1 elseif direction == 3 then cy = cy + 1 end
			if not PushCell(cx,cy,direction,true,999999999999999999) then
				break
			end
			if direction == 0 then cx = cx + 1 elseif direction == 2 then cx = cx - 1 end
			if direction == 1 then cy = cy + 1 elseif direction == 3 then cy = cy - 1 end
		else
			cells[cy][cx].testvar = "break"
			break
		end
	end
end

function UpdateSuperRepulsers()
	local x,y = width-1,height-1
	while x >= 0 do
		while y >= 0 do
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,0)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,2)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,3)
					supdatekey = supdatekey + 1
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
			if GetChunk(x,y).hassuperrep then
				if not cells[y][x].updated and cells[y][x].ctype == 49 then
					DoSuperRepulser(x,y,1)
					supdatekey = supdatekey + 1
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