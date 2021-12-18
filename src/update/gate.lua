function DoGate(x,y,dir,gtype)
	if (gtype == 1 and (cells[y][x].inl or cells[y][x].inr)) or													--or
	(gtype == 2 and cells[y][x].inl and cells[y][x].inr) or														--and
	(gtype == 3 and (cells[y][x].inl or cells[y][x].inr) and not (cells[y][x].inl and cells[y][x].inr)) or		--xor
	(gtype == 4 and not (cells[y][x].inl or cells[y][x].inr)) or												--nor
	(gtype == 5 and not (cells[y][x].inl and cells[y][x].inr)) or												--nand
	(gtype == 6 and not ((cells[y][x].inl or cells[y][x].inr) and not (cells[y][x].inl and cells[y][x].inr))) then	--xnor
		local direction = (dir+2)%4
		local cx = x
		local cy = y
		local addedrot = 0
		while true do							--what cell to copy?
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
				addedrot = addedrot - (direction-olddir)
			elseif cells[cy][cx].ctype == 30 then
				local olddir = direction
				if (cells[cy][cx].rot+3)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot - (direction-olddir)
			elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and (cells[cy][cx].rot+2)%2 ~= direction%2 then
				local olddir = direction
				if (cells[cy][cx].rot+1)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot - (direction-olddir)
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38 or (cells[cy][cx].ctype == 48 and (cells[cy][cx].rot+2)%4 == direction)) then
				break
			end
		end 
		cells[cy][cx].testvar = "gen'd"
		if cells[cy][cx].ctype ~= 0 and cells[cy][cx].ctype ~= 40 then
			PushCell(x,y,dir,false,1,cells[cy][cx].ctype,cells[cy][cx].rot+addedrot,cells[cy][cx].ctype >= 31 and cells[cy][cx].ctype <= 36,{cells[y][x].lastvars[1],cells[y][x].lastvars[2],(cells[cy][cx].rot+addedrot)%4},cells[cy][cx].protected)
		end
	end
	cells[y][x].testvar = (cells[y][x].inl and 1 or 0).. " " ..(cells[y][x].inr and 1 or 0)
end

function UpdateGates()
	local x,y = 0,0
	while x < width do
		while y < height do
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 0 then
					DoGate(x,y,0,cells[y][x].ctype-30)
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
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 2 then
					DoGate(x,y,2,cells[y][x].ctype-30)
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
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 3 then
					DoGate(x,y,3,cells[y][x].ctype-30)
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
			if GetChunk(x,y).hasgate then
				if not cells[y][x].updated and (cells[y][x].ctype >= 31 and cells[y][x].ctype <= 36) and cells[y][x].rot == 1 then
					DoGate(x,y,1,cells[y][x].ctype-30)
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