function UpdateFlippers()
	local x,y = 0,0
	while y < height do
		while x < width do
			if GetChunk(x,y).hasflipper then
				if not cells[y][x].updated and cells[y][x].ctype == 29 and cells[y][x].rot%2 == 0 then
					for i=-1,1,2 do	--when lazy
						if cells[y][x+i].ctype == 8 then cells[y][x+i].ctype = 9 
						elseif cells[y][x+i].ctype == 9 then cells[y][x+i].ctype = 8 
						elseif cells[y][x+i].ctype == 17 then cells[y][x+i].ctype = 18
						elseif cells[y][x+i].ctype == 18 then cells[y][x+i].ctype = 17 
						elseif cells[y][x+i].ctype == 25 then cells[y][x+i].ctype = 26 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
						elseif cells[y][x+i].ctype == 26 then cells[y][x+i].ctype = 25 cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 1 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif hasFlipperTranslation(cells[y][x+i].ctype) then cells[y][x+i].ctype = makeFlipperTranslation(cells[y][x+i].ctype) SetChunk(x+i, y, cells[y][x+i].ctype)
						else cells[y][x+i].rot = (-cells[y][x+i].rot + 2)%4 end
					end
					for i=-1,1,2 do
						if cells[y+i][x].ctype == 8 then cells[y+i][x].ctype = 9 
						elseif cells[y+i][x].ctype == 9 then cells[y+i][x].ctype = 8 
						elseif cells[y+i][x].ctype == 17 then cells[y+i][x].ctype = 18
						elseif cells[y+i][x].ctype == 18 then cells[y+i][x].ctype = 17 
						elseif cells[y+i][x].ctype == 25 then cells[y+i][x].ctype = 26 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
						elseif cells[y+i][x].ctype == 26 then cells[y+i][x].ctype = 25 cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif hasFlipperTranslation(cells[y+i][x].ctype) then cells[y+i][x].ctype = makeFlipperTranslation(cells[y+i][x].ctype) SetChunk(x, y+i, cells[y+i][x].ctype)
						else cells[y+i][x].rot = (-cells[y+i][x].rot + 2)%4 end
					end
				elseif not cells[y][x].updated and cells[y][x].ctype == 29 then
					for i=-1,1,2 do	--when lazy
						if cells[y][x+i].ctype == 8 then cells[y][x+i].ctype = 9 
						elseif cells[y][x+i].ctype == 9 then cells[y][x+i].ctype = 8 
						elseif cells[y][x+i].ctype == 17 then cells[y][x+i].ctype = 18
						elseif cells[y][x+i].ctype == 18 then cells[y][x+i].ctype = 17 
						elseif cells[y][x+i].ctype == 25 then cells[y][x+i].ctype = 26 cells[y][x+i].rot = (-cells[y][x+i].rot - 2)%4
						elseif cells[y][x+i].ctype == 26 then cells[y][x+i].ctype = 25 cells[y][x+i].rot = (-cells[y][x+i].rot - 2)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif (cells[y][x+i].ctype == 6 or cells[y][x+i].ctype == 22 or cells[y][x+i].ctype == 30 or cells[y][x+i].ctype == 45 or cells[y][x+i].ctype == 52) then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) and cells[y][x+i].rot%2 == 0 then cells[y][x+i].rot = (cells[y][x+i].rot - 1)%4
						elseif (cells[y][x+i].ctype == 15 or cells[y][x+i].ctype == 56) then cells[y][x+i].rot = (cells[y][x+i].rot + 1)%4
						elseif hasFlipperTranslation(cells[y][x+i].ctype) then cells[y][x+i].ctype = makeFlipperTranslation(cells[y][x+i].ctype) SetChunk(x+i, y, cells[y][x+i].ctype)
						else cells[y][x+i].rot = (-cells[y][x+i].rot)%4 end
					end
					for i=-1,1,2 do
						if cells[y+i][x].ctype == 8 then cells[y+i][x].ctype = 9 
						elseif cells[y+i][x].ctype == 9 then cells[y+i][x].ctype = 8 
						elseif cells[y+i][x].ctype == 17 then cells[y+i][x].ctype = 18
						elseif cells[y+i][x].ctype == 18 then cells[y+i][x].ctype = 17 
						elseif cells[y+i][x].ctype == 25 then cells[y+i][x].ctype = 26 cells[y+i][x].rot = (-cells[y+i][x].rot)%4
						elseif cells[y+i][x].ctype == 26 then cells[y+i][x].ctype = 25 cells[y+i][x].rot = (-cells[y+i][x].rot)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif (cells[y+i][x].ctype == 6 or cells[y+i][x].ctype == 22 or cells[y+i][x].ctype == 30 or cells[y+i][x].ctype == 45 or cells[y+i][x].ctype == 52) then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) and cells[y+i][x].rot%2 == 0 then cells[y+i][x].rot = (cells[y+i][x].rot - 1)%4
						elseif (cells[y+i][x].ctype == 15 or cells[y+i][x].ctype == 56) then cells[y+i][x].rot = (cells[y+i][x].rot + 1)%4
						elseif hasFlipperTranslation(cells[y+i][x].ctype) then cells[y+i][x].ctype = makeFlipperTranslation(cells[y+i][x].ctype) SetChunk(x, y+i, cells[y+i][x].ctype)
						else cells[y+i][x].rot = (-cells[y+i][x].rot)%4 end
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