--honestly the chunk system doesn't help the lag as much as i expected it to but it helps a little bit so
function SetChunk(x,y,ctype)
	if ctype == 1 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmover = true
	elseif ctype == 2 or ctype == 22 or ctype == 39 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasgenerator = true
	elseif ctype == 13 then
		chunks[math.floor(y/25)][math.floor(x/25)].haspuller = true
	elseif ctype == 8 or ctype == 9 or ctype == 10 or ctype == 56 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasrotator = true
	elseif ctype == 14 or ctype == 55 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmirror = true
	elseif ctype == 17 or ctype == 18 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasgear = true
	elseif ctype == 20 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasrepulser = true
	elseif ctype == 19 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasmold = true
	elseif ctype == 16 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasredirector = true
	elseif ctype == 24 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasfreezer = true
	elseif ctype == 25 or ctype == 26 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasanglegenerator = true
	elseif ctype == 27 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasadvancer = true
	elseif ctype == 28 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasimpulser = true
	elseif ctype == 29 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasflipper = true
	elseif ctype >= 31 and ctype <= 36 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasgate = true
	elseif ctype == 42 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasshield = true
	elseif ctype == 43 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasintaker = true
	elseif ctype == 44 or ctype == 45 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasreplicator = true
	elseif ctype == 49 then
		chunks[math.floor(y/25)][math.floor(x/25)].hassuperrep = true
	elseif ctype == 54 then
		chunks[math.floor(y/25)][math.floor(x/25)].hassupergenerator = true
	elseif ctype == 57 then
		chunks[math.floor(y/25)][math.floor(x/25)].hasdriller = true
	elseif ctype > initialCellCount then
		if not chunks[math.floor(y/25)][math.floor(x/25)].hasmodded then chunks[math.floor(y/25)][math.floor(x/25)].hasmodded = {} end
		chunks[math.floor(y/25)][math.floor(x/25)].hasmodded[ctype] = true
	end
end

function RefreshChunks()
	for y=0,(height-1)/25 do
		for x=0,(width-1)/25 do
			chunks[math.floor(y)][math.floor(x)] = {}
		end
	end
	for y=0,height-1 do
		for x=0,width-1 do
			SetChunk(x,y,cells[y][x].ctype)
		end
	end
	ticknum = 0
end

function GetChunk(x,y)
	return chunks[math.floor(y/25)][math.floor(x/25)]
end