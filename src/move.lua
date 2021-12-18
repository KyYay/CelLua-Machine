function PushCell(x,y,dir,updateforces,force,replacetype,replacerot,replaceupdated,replacelastvars,replaceprot,dontpull)	--replacetype/replacerot/etc is the cell that's going to replace the first one- needed for generator cells 
																						--note that cx/cy is the ORIGIN of the force; not the first cell that's going to be replaced
																						--which is why movers have it 1 cell behind them
																						--dontpull dictates whether this cell should not be pullable upon moving
																						--to prevent double movement with advancers and pullers, but generator-like cells should have it as false
																						--also the function returns whether the movement was a success
	replacetype = replacetype or 0
	replacerot = replacerot or 0
	replaceupdated = replaceupdated or false
	replacelastvars = replacelastvars or {x,y,dir}
	replaceprot = replaceprot or false
	updateforces = (updateforces == nil and true) or updateforces	--if it's nothing, set to true. this lets it have a default value without overwriting false with true
	dontpull = (dontpull == nil and true) or dontpull
	local cx = x
	local cy = y
	local direction = dir
	local addedrot = 0
	local totalforce = force or 1
	local pushingdiverger = false
	local lasttype = replacetype
	local lastrot = replacerot
	local lastprot = replaceprot
	local reps = 0
	local prevx, prevy
	repeat							--check for forces or blockages before doing movement
		reps = reps + 1
		prevx = cx
		prevy = cy
		if direction == 0 then
			cx = cx + 1	
		elseif direction == 2 then
			cx = cx - 1
		elseif direction == 3 then
			cy = cy - 1
		elseif direction == 1 then
			cy = cy + 1
		end
		if cells[cy][cx].updatekey ~= updatekey then
			cells[cy][cx].projectedtype = cells[cy][cx].ctype
			cells[cy][cx].projectedrot = cells[cy][cx].rot
			cells[cy][cx].projectedupd = cells[cy][cx].updated
			cells[cy][cx].projectedprot = cells[cy][cx].protected
		end
		local checkedtype = cells[cy][cx].projectedtype
		local checkedrot = cells[cy][cx].projectedrot
		local checkedupd = cells[cy][cx].projectedupd
		local checkedprot = cells[cy][cx].projectedprot
		local moddedCanPush = false
		if checkedtype > initialCellCount then
			moddedCanPush = canPushCell(cx, cy, prevx, prevy, "push", totalforce)
		end
		-- local pushData = {
		-- 	px = prevx,
		-- 	py = prevy,
		-- 	cx = cx,
		-- 	cy = cy,
		-- 	direction = direction,
		-- 	celltype = checkedtype,
		-- 	cellrot = checkedrot,
		-- 	cellupdate = checkedupd,
		-- 	cellport = checkedprot,
		-- 	addedrot = addedrot,
		-- }
		if checkedtype == 1 or checkedtype == 13 or checkedtype == 27 or checkedtype == 41 or moddedMovers[checkedtype] ~= nil then
			if reps ~= 1 and not checkedprot and (lasttype == 12 or lasttype == 23 or isModdedBomb(lasttype) or ((GetSidedEnemy(lasttype) ~= nil and GetSidedEnemy(lasttype)(prevx, prevy, direction) == true))) then
				break
			else
				if not pushingdiverger then	--any force towards the mover would go into the diverger so it doesnt count (also it makes some interactions symmetrical-er)
					if checkedrot == direction and checkedtype ~= 13 then
						totalforce = totalforce + GetBias(checkedtype)
					elseif checkedrot == (direction+2)%4 and checkedtype ~= 13 then
						totalforce = totalforce - GetBias(checkedtype)
					end
					if updateforces and direction%2 == checkedrot%2 then
						cells[cy][cx].updated = true
					end
				end
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				cells[cy][cx].projectedupd = lastupd
				cells[cy][cx].projectedprot = lastprot
				lasttype = checkedtype
				lastrot = checkedrot
				lastupd = checkedupd
				lastprot = checkedprot
				addedrot = 0
			end
		elseif checkedtype == -1 or checkedtype == 40 or checkedtype == 4 and direction%2 ~= checkedrot%2
		or checkedtype == 5 and direction ~= checkedrot
		or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
		or checkedtype == 7 and direction == (checkedrot+2)%4 
		or checkedtype == 51 and direction ~= checkedrot 
		or checkedtype == 52 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
		or checkedtype == 53 and direction == (checkedrot+2)%4
		or checkedtype > initialCellCount and not canPushCell(cx, cy, prevx, prevy, "push", totalforce) then
			if checkedtype ~= -1 and checkedtype ~= 40 and reps ~= 1 and not checkedprot and (lasttype == 12 or lasttype == 23 or isModdedBomb(lasttype) or ((GetSidedEnemy(lasttype) ~= nil and GetSidedEnemy(lasttype)(prevx, prevy, direction) == true))) then
				break
			else
				totalforce = 0
			end
		elseif checkedtype == 15 and ((checkedrot+3)%4 == direction or (checkedrot+2)%4 == direction) then
			local olddir = direction
			if (checkedrot+3)%4 == direction then
				direction = (direction+1)%4
			elseif (checkedrot+2)%4 == direction then
				direction = (direction-1)%4
			end
			addedrot = addedrot + (direction-olddir)
		elseif checkedtype == 30 then
			local olddir = direction
			if (checkedrot+1)%2 == direction%2 then
				direction = (direction+1)%4
			else
				direction = (direction-1)%4
			end
			addedrot = addedrot + (direction-olddir)
		elseif moddedDivergers[checkedtype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
			local olddir = direction
			direction = moddedDivergers[checkedtype](cx, cy, direction)
			addedrot = addedrot - (direction-olddir)
		elseif checkedtype >= 31 and checkedtype <= 36 then
			if (checkedrot-1)%2 == direction%2 then
				break
			else
				totalforce = 0
			end
		elseif not lastprot and (checkedtype == 12 or checkedtype == 23 or isModdedBomb(checkedtype) or ((GetSidedEnemy(checkedtype) ~= nil and GetSidedEnemy(checkedtype)(cx, cy, direction) == true))) then
			break
		elseif not ((checkedtype == 37 and checkedrot%2 == direction%2) or checkedtype == 38) then
			if reps ~= 1 and not checkedprot and (lasttype == 12 or lasttype == 23 or isModdedBomb(lasttype) or (GetSidedEnemy(lasttype) ~= nil and GetSidedEnemy(lasttype)(prevx, prevy, direction) == true)) then
				break
			else
				cells[cy][cx].projectedtype = lasttype
				cells[cy][cx].projectedrot = (lastrot+addedrot)%4
				cells[cy][cx].projectedupd = lastupd
				cells[cy][cx].projectedprot = lastprot
				lasttype = checkedtype
				lastrot = checkedrot
				lastupd = checkedupd
				lastprot = checkedprot
				addedrot = 0
				if (checkedtype == 20 and not pushingdiverger) or checkedtype == 21 or cellWeights[checkedtype] ~= nil then
					if checkedtype > initialCellCount then
						totalforce = totalforce - cellWeights[checkedtype]
					else
						totalforce = totalforce - 1
					end
				elseif checkedtype == 49 and not pushingdiverger then
					totalforce = 0
				elseif checkedtype == 15 or (checkedtype == 47 or checkedtype == 48) and checkedrot == (direction+2)%4 then 
					pushingdiverger = true
				elseif checkedtype == 46 then 
					cells[cy][cx].projectedtype = checkedtype
					cells[cy][cx].projectedrot = checkedrot
					cells[cy][cx].projectedupd = checkedupd
					cells[cy][cx].projectedprot = checkedprot
				end
			end
		end
		cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
		if cells[cy][cx].crosses >= 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop
			totalforce = 0
		end
		if cx == x and cy == y and direction == dir and replacetype == 0 then		--if a cell isn't generated, let logical infinite loops work
			break
		end
		cells[cy][cx].updatekey = updatekey
	until totalforce <= 0 or checkedtype == 0 or checkedtype == 11 or isModdedTrash(checkedtype) or (GetSidedTrash(checkedtype) ~= nil and GetSidedTrash(checkedtype)(cx, cy, direction)) or checkedtype == 50 or checkedtype == 43 and checkedrot == (direction+2)%4 or (checkedtype == 47 or checkedtype == 48) and checkedrot == direction and not checkedupd
	--movement time
	cells[cy][cx].testvar = "end"
	if totalforce > 0 then
		local direction = dir
		local cx = x
		local cy = y
		local storedcell = {ctype = replacetype, rot = replacerot, updated = replaceupdated, lastvars = replacelastvars, protected = replaceprot}
		local addedrot = 0
		local reps = 0
		local prevx, prevy = x, y
		repeat
			reps = reps + 1
			if reps == 999999 then cells[cy][cx].ctype = 11 break end
			prevx = cx
			prevy = cy
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cx < 0 or cy < 0 then error(cx.." "..cy..":"..x.." "..y) end
			if cells[cy][cx].ctype == 11 or isModdedTrash(cells[cy][cx].ctype) or (GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true) or  cells[cy][cx].ctype == 50 or cells[cy][cx].ctype == 43 and cells[cy][cx].rot == (direction+2)%4 then
				if storedcell.ctype ~= 0 then
					if not IsSilent(cells[cy][cx].ctype) then
						love.audio.play(destroysound)
					end
					if isModdedTrash(cells[cy][cx].ctype) or (GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true) then
						modsOnTrashEat(cells[cy][cx].ctype, cx, cy, storedcell, prevx, prevy)
					end
					canPushCell(cx, cy, prevx, prevy, "push", totalforce)
					if cells[cy][cx].ctype == 50 then
						if cx < width-1 and (not cells[cy][cx+1].protected and cells[cy][cx+1].ctype ~= -1 and cells[cy][cx+1].ctype ~= 11 and not isModdedTrash(cells[cy][cx+1].ctype) and cells[cy][cx+1].ctype ~= 40 and cells[cy][cx+1].ctype ~= 50) then cells[cy][cx+1].ctype = 0 end
						if cx > 0 and (not cells[cy][cx-1].protected and cells[cy][cx-1].ctype ~= -1 and cells[cy][cx-1].ctype ~= 11 and not isModdedTrash(cells[cy][cx-1].ctype) and cells[cy][cx-1].ctype ~= 40 and cells[cy][cx-1].ctype ~= 50) then cells[cy][cx-1].ctype = 0 end
						if cy < height-1 and (not cells[cy+1][cx].protected and cells[cy+1][cx].ctype ~= -1 and cells[cy+1][cx].ctype ~= 11 and not isModdedTrash(cells[cy+1][cx].ctype) and cells[cy+1][cx].ctype ~= 40 and cells[cy+1][cx].ctype ~= 50) then cells[cy+1][cx].ctype = 0 end
						if cy > 0 and (not cells[cy-1][cx].protected and cells[cy-1][cx].ctype ~= -1 and cells[cy-1][cx].ctype ~= 11 and not isModdedTrash(cells[cy-1][cx].ctype) and cells[cy-1][cx].ctype ~= 40 and cells[cy-1][cx].ctype ~= 50) then cells[cy-1][cx].ctype = 0 end
					end
				end
				break
			elseif (cells[cy][cx].ctype == 47 or cells[cy][cx].ctype == 48) and cells[cy][cx].rot == direction and not cells[cy][cx].updated then
				cells[cy][cx].updated = true
				updatekey = updatekey + 1
				if cells[cy][cx].ctype == 48 then
					PushCell(cx,cy,direction,updateforces,totalforce,storedcell.ctype,storedcell.rot,storedcell.updated,{storedcell.lastvars[1],storedcell.lastvars[2],storedcell.lastvars[3]},storedcell.protected,dontpull)
				end
				PushCell(cx,cy,(direction+1)%4,updateforces,totalforce,storedcell.ctype,(storedcell.rot+1)%4,storedcell.updated,{storedcell.lastvars[1],storedcell.lastvars[2],storedcell.lastvars[3]},storedcell.protected,dontpull)
				PushCell(cx,cy,(direction-1)%4,updateforces,totalforce,storedcell.ctype,(storedcell.rot-1)%4,storedcell.updated,{storedcell.lastvars[1],storedcell.lastvars[2],storedcell.lastvars[3]},storedcell.protected,dontpull)
				cells[cy][cx].updated = false
				break
			elseif not storedcell.protected and cells[cy][cx].ctype == 12 then
				if storedcell.ctype == 23 then 
					cells[cy][cx] = storedcell
					cells[cy][cx].ctype = 12
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				elseif storedcell.ctype ~= 0 then 
					cells[cy][cx].ctype = 0
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				end
				break
			elseif not storedcell.protected and cells[cy][cx].ctype == 23 then
				if storedcell.ctype == 23 then 
					cells[cy][cx].ctype = 0
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				elseif storedcell.ctype ~= 0 then 
					cells[cy][cx].ctype = 12
					love.audio.play(destroysound)
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				end
				break
			elseif not storedcell.protected and (isModdedBomb(cells[cy][cx].ctype) or (GetSidedEnemy(cells[cy][cx].ctype) ~= nil and GetSidedEnemy(cells[cy][cx].ctype)(cx, cy, direction) == true)) then
				if storedcell.ctype ~= 0 then
					local bombID = cells[cy][cx].ctype
					cells[cy][cx].ctype = 0
					if storedcell.ctype == 23 then cells[cy][cx].ctype = 12 end
					canPushCell(cx, cy, prevx, prevy, "push", totalforce)
					modsOnModEnemyDed(bombID, cx, cy, storedcell, prevx, prevy)
					if not IsSilent(cells[cy][cx].ctype) then
						love.audio.play(destroysound)
					end
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
				end
				break
			elseif cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
				local olddir = direction
				if (cells[cy][cx].rot+3)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot + (direction-olddir)
			elseif cells[cy][cx].ctype == 30 then
				local olddir = direction
				if (cells[cy][cx].rot+3)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot + (direction-olddir)
			elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
				local olddir = direction
				direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
				addedrot = addedrot + (direction-olddir)
			elseif cells[cy][cx].ctype >= 31 and cells[cy][cx].ctype <= 36 then
				if (cells[cy][cx].rot-1)%4 == direction then
					cells[cy][cx].inr = true
					break
				elseif (cells[cy][cx].rot+1)%4 == direction then
					cells[cy][cx].inl = true
					break
				end
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38) then
				if reps ~= 1 and cells[cy][cx].ctype ~= 0 and not cells[cy][cx].protected and (storedcell.ctype == 12 or storedcell.ctype == 23 or isModdedBomb(storedcell.ctype) or (GetSidedEnemy(storedcell.ctype) ~= nil and GetSidedEnemy(storedcell.ctype)(prevx, prevy, direction) == true)) then
					if storedcell.ctype == 23 then
						if cells[cy][cx].ctype == 23 then
							cells[cy][cx].ctype = 0
						else
							cells[cy][cx].ctype = 12
							cells[cy][cx].rot = (storedcell.rot + addedrot)%4
							cells[cy][cx].updated = storedcell.updated
							cells[cy][cx].lastvars = {storedcell.lastvars[1],storedcell.lastvars[2],storedcell.lastvars[3]}
						end
					elseif isModdedBomb(storedcell.ctype) or (GetSidedEnemy(storedcell.ctype) ~= nil and GetSidedEnemy(storedcell.ctype)(prevx, prevy, direction) == true) then
						modsOnModEnemyDed(storedcell.ctype, prevx, prevy, cells[cy][cx], cx, cy)
						if cells[cy][cx].ctype == 23 then
							cells[cy][cx].ctype = 12
						else
							cells[cy][cx].ctype = 0
						end
					else
						if cells[cy][cx].ctype == 23 then
							cells[cy][cx].ctype = 12
						else
							cells[cy][cx].ctype = 0
						end
					end
					if not IsSilent(storedcell.ctype) then
						love.audio.play(destroysound)
					end
					enemyparticles:setPosition(cx*20,cy*20)
					enemyparticles:emit(50)
					canPushCell(prevx, prevy, 0, 0, "push", totalforce)
					break
				else
					storedcell.rot = (storedcell.rot + addedrot) % 4
					local oldcell = CopyTable(cells[cy][cx]) -- Modified by CelLuAPI for better things
					--Added because of Qwerty.R_Dev#9850
					nilifyData(storedcell)
					if cells[cy][cx].ctype ~= 46 or storedcell.ctype == 0 or storedcell.protected then
						cells[cy][cx].ctype = storedcell.ctype
						cells[cy][cx].updated = storedcell.updated
						cells[cy][cx].protected = storedcell.protected
					end
					cells[cy][cx].rot = storedcell.rot
					cells[cy][cx].lastvars = CopyTable(storedcell.lastvars)
					local storedCopy = CopyTable(storedcell)
					for k, v in pairs(storedCopy) do
						if k ~= "rot" and k ~= "ctype" and k ~= "protected" and k ~= "updated" and k ~= "lastvars" then
							cells[cy][cx][k] = v
						end
					end
					if dontpull then cells[cy][cx].pulleddir = direction end --thank you advancers, very cool
					storedcell = oldcell
					addedrot = 0
				end
			end
			SetChunk(cx,cy,cells[cy][cx].ctype)
			modsOnMove(cells[cy][cx].ctype, cx, cy, cells[cy][cx].rot, direction, totalforce)
		until storedcell.ctype == 0
	else
		updatekey = updatekey + 1
		return false
	end
	updatekey = updatekey + 1
	return true,cx,cy,direction
end

function PullCell(x,y,dir,ignoreblockage,force,updateforces,dontpull,advancer)	--same story as pushcell, but pulls; x/y is the actual cell you want to be the puller here, instead of the origin
																	--also ignoreblockage is only useful for advancer-like cells
																	--"dontpull"s name is a bit misleading but egh
																	--advancer is just for symmetry when dealing with advancers dont worry about it
	updateforces = (updateforces == nil and true) or updateforces
	dontpull = (dontpull == nil and true) or dontpull
	local direction = dir
	local cx = x
	local cy = y
	local blocked = false

	local moved = {} -- For mods

	if not ignoreblockage then
		while true do
			local prevx, prevy = cx, cy
			if direction == 0 then
				cx = cx + 1	
			elseif direction == 2 then
				cx = cx - 1
			elseif direction == 3 then
				cy = cy - 1
			elseif direction == 1 then
				cy = cy + 1
			end
			if cells[cy][cx].ctype == 0 or cells[cy][cx].ctype == 11 or isModdedTrash(cells[cy][cx].ctype) or (GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true) or cells[cy][cx].ctype == 50 or not cells[y][x].protected and (cells[cy][cx].ctype == 12 or cells[cy][cx].ctype == 23)
			or (cells[cy][cx].ctype >= 31 and cells[cy][cx].ctype <= 36 and cells[cy][cx].rot%2 == (direction+1)%2) or cells[cy][cx].ctype == 43 and cells[cy][cx].rot == (direction+2)%4 then
				if isModdedTrash(cells[cy][cx].ctype) then
					modsOnTrashEat(cells[cy][cx].ctype, cx, cy, cells[prevy][prevx], prevx, prevy)
				end
				if GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true then
					modsOnTrashEat(cells[cy][cx].ctype, cx, cy, cells[prevy][prevx], prevx, prevy)
				end
				break
			elseif cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot+2)%4 == direction or (cells[cy][cx].rot+3)%4 == direction) then
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
			elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
				local olddir = direction
				direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38) then
				blocked = true
				break
			end
		end
	end
	cells[cy][cx].testvar = "front"
	if not blocked then
		local frontcx = cx
		local frontcy = cy
		local frontdir = direction
		local totalforce = force or 0
		local addedrot = 0
		local lastcx = cx
		local lastcy = cy
		local ignoreforce = false	--onedirectional shenanigans
		repeat							--check for forces or blockages before doing movement
			if direction == 0 then
				cx = cx - 1	
			elseif direction == 2 then
				cx = cx + 1
			elseif direction == 3 then
				cy = cy + 1
			elseif direction == 1 then
				cy = cy - 1
			end
			if cells[cy][cx].updatekey ~= updatekey then
				cells[cy][cx].projectedtype = cells[cy][cx].ctype
				cells[cy][cx].projectedrot = cells[cy][cx].rot
			end
			local checkedtype = cells[cy][cx].projectedtype
			local checkedrot = cells[cy][cx].projectedrot
			if checkedtype == 1 or checkedtype == 13 or checkedtype == 27 or checkedtype == 41 or moddedMovers[checkedtype] ~= nil then
				if not ignoreforce then
					if checkedrot == direction then
						totalforce = totalforce + 1
					elseif checkedrot == (direction+2)%4 then
						totalforce = totalforce - 1
					end
					if updateforces and checkedrot%2 == direction%2 and (not advancer or (checkedtype ~= 27 or checkedrot == direction)) then
						cells[cy][cx].updated = true
					end
				else
					if updateforces and checkedrot == direction and checkedtype ~= 13 then
						cells[cy][cx].updated = true
					end
				end
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			elseif checkedtype == -1 or checkedtype == 40 or checkedtype == 4 and direction%2 ~= checkedrot%2
			or checkedtype == 5 and direction ~= checkedrot
			or checkedtype == 6 and (direction ~= checkedrot and direction ~= (checkedrot-1)%4)
			or checkedtype == 7 and direction == (checkedrot+2)%4
			or checkedtype == 51 and direction ~= (checkedrot+2)%4
			or checkedtype == 52 and (direction ~= (checkedrot+1)%4 and direction ~= (checkedrot+2)%4)
			or checkedtype == 53 and direction == checkedrot then
				break
			elseif checkedtype == 5 or checkedtype == 6 or checkedtype == 51 or checkedtype == 52 --if these dont stop the puller, then they face towards it with the other side unpullable, so we dont need to check their rotation
			or checkedtype == 7 and direction == checkedrot
			or checkedtype == 53 and direction == (checkedrot+2)%4 then
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
				ignoreforce = true
			elseif checkedtype == 15 and ((checkedrot)%4 == direction or (checkedrot+1)%4 == direction) then
				local olddir = direction
				if (checkedrot+1)%4 == direction then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot + (direction-olddir)
			elseif checkedtype == 30 then
				local olddir = direction
				if (checkedrot+1)%2 == direction%2 then
					direction = (direction+1)%4
				else
					direction = (direction-1)%4
				end
				addedrot = addedrot + (direction-olddir)
			elseif moddedDivergers[checkedtype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
				local olddir = direction
				direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
			elseif checkedtype == 21 or (checkedtype == 28 and not ignoreforce) or (cellWeights[checkedtype] ~= nil) then
				if checkedtype > initialCellCount then
					totalforce = totalforce - cellWeights[checkedtype]
				else
					totalforce = totalforce - 1
				end
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			elseif checkedtype >= 31 and checkedtype <= 36 then
				break
			elseif not ((checkedtype == 37 and checkedrot%2 == direction%2) or checkedtype == 38) then
				cells[lastcy][lastcx].projectedtype = checkedtype
				cells[lastcy][lastcx].projectedrot = (checkedrot-addedrot)%4
				addedrot = 0
				lastcx = cx
				lastcy = cy
			end
			cells[cy][cx].crosses = ((cells[cy][cx].updatekey == updatekey and cells[cy][cx].crosses) or 0) + 1
			if cells[cy][cx].crosses == 3 then		--a cell being checked 3 times in one subtick means it's in an infinite loop, and a bad one at that; the chain will stop in case of this emergency.
				totalforce = 0
				break
			end
			cells[cy][cx].updatekey = updatekey
		until (totalforce <= 0 and checkedtype ~= 15 and checkedtype ~= 30 and checkedtype ~= 37 and checkedtype ~= 38 and moddedDivergers[checkedtype] == nil) or checkedtype == 0 or checkedtype == 11 or checkedtype == 50 or checkedtype == 12 or checkedtype == 23 or isModdedBomb(checkedtype) or isModdedTrash(checkedtype) or (GetSidedTrash(checkedtype) ~= nil and GetSidedTrash(checkedtype)(lastcx, lastcy, direction) == true) or (GetSidedEnemy(checkedtype) ~= nil and GetSidedEnemy(checkedtype)(lastcx, lastcy, direction) == true)
		--movement time
		cells[cy][cx].testvar = "end"
		if totalforce > 0 then
			local cx = frontcx
			local cy = frontcy
			local direction = frontdir
			local addedrot = 0
			local lastcx = frontcx
			local lastcy = frontcy
			local reps = 0
			repeat
				reps = reps + 1
				if reps == 999999 then cells[cy][cx].ctype = 11 end
				if direction == 0 then
					cx = cx - 1	
				elseif direction == 2 then
					cx = cx + 1
				elseif direction == 3 then
					cy = cy + 1
				elseif direction == 1 then
					cy = cy - 1
				end
				if cells[cy][cx].ctype == 11 or isModdedTrash(cells[cy][cx].ctype) or cells[cy][cx].ctype == 50 or cells[cy][cx].ctype == 12 or cells[cy][cx].ctype == 23 or (GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true) or moddedBombs[cells[cy][cx].ctype] ~= nil or cells[cy][cx].ctype >= 31 and cells[cy][cx].ctype <= 36 then
					if reps ~= 1 then
						-- if isModdedTrash(cells[cy][cx].ctype) or (GetSidedTrash(cells[cy][cx].ctype) ~= nil and GetSidedTrash(cells[cy][cx].ctype)(cx, cy, direction) == true) then
						-- 	modsOnTrashEat(cells[cy][cx].ctype, cx, cy, cells[lastcy][lastcx], lastcx, lastcy)
						-- end
						cells[lastcy][lastcx].ctype = 0
					end
					break
				elseif cells[cy][cx].ctype > initialCellCount and not canPushCell(cx, cy, lastcx, lastcy, "pull", totalforce) then
					if reps ~= 1 then
						cells[lastcy][lastcx].ctype = 0
					end
					break
				elseif cells[cy][cx].ctype == 15 and ((cells[cy][cx].rot)%4 == direction or (cells[cy][cx].rot+1)%4 == direction) then
					local olddir = direction
					if (cells[cy][cx].rot+1)%4 == direction then
						direction = (direction+1)%4
					else
						direction = (direction-1)%4
					end
					addedrot = addedrot + (direction-olddir)
				elseif cells[cy][cx].ctype == 30 then
					local olddir = direction
					if (cells[cy][cx].rot+1)%2 == direction%2 then
						direction = (direction+1)%4
					else
						direction = (direction-1)%4
					end
					addedrot = addedrot + (direction-olddir)
				elseif moddedDivergers[cells[cy][cx].ctype] ~= nil and moddedDivergers[cells[cy][cx].ctype](cx, cy, direction) ~= nil then
					local olddir = direction
					direction = moddedDivergers[cells[cy][cx].ctype](cx, cy, direction)
					addedrot = addedrot + (direction-olddir)
				elseif cells[cy][cx].ctype == -1 or cells[cy][cx].ctype == 40 or cells[cy][cx].ctype == 4 and direction%2 ~= cells[cy][cx].rot%2
				or cells[cy][cx].ctype == 5 and direction ~= cells[cy][cx].rot
				or cells[cy][cx].ctype == 6 and (direction ~= cells[cy][cx].rot and direction ~= (cells[cy][cx].rot-1)%4)
				or cells[cy][cx].ctype == 7 and direction == (cells[cy][cx].rot+2)%4
				or cells[cy][cx].ctype == 51 and direction ~= (cells[cy][cx].rot+2)%4
				or cells[cy][cx].ctype == 52 and (direction ~= (cells[cy][cx].rot+1)%4 and direction ~= (cells[cy][cx].rot+2)%4)
				or cells[cy][cx].ctype == 53 and direction == cells[cy][cx].rot then
					if reps ~= 1 then
						cells[lastcy][lastcx].ctype = 0
					end
					break
				elseif cells[cy][cx].pulleddir == direction then
					cells[lastcy][lastcx].ctype = 0
					break
				elseif not ((cells[cy][cx].ctype == 37 and cells[cy][cx].rot%2 == direction%2) or cells[cy][cx].ctype == 38) then
					if lastcx == frontcx and lastcy == frontcy then
						if cells[frontcy][frontcx].ctype == 11 or isModdedTrash(cells[frontcy][frontcx].ctype) or (GetSidedTrash(cells[frontcy][frontcx].ctype) ~= nil and GetSidedTrash(cells[frontcy][frontcx].ctype)(frontcx, frontcy, direction)) or cells[frontcy][frontcx].ctype == 50 or cells[frontcy][frontcx].ctype == 43 and (cells[frontcy][frontcx].rot+addedrot)%4 == (direction+2)%4 then
							if cells[cy][cx].ctype ~= 0 then
								if not IsSilent(cells[frontcy][frontcx].ctype) then
									love.audio.play(destroysound)
								end
								-- if isModdedTrash(cells[frontcy][frontcx].ctype) then
								-- 	modsOnTrashEat(cells[frontcy][frontcx].ctype, frontcx, frontcy, cells[cy][cx], cx, cy)
								-- end
								if cells[frontcy][frontcx].ctype == 50 then
									if frontcx < width-1 and (not cells[frontcy][frontcx+1].protected and cells[frontcy][frontcx+1].ctype ~= -1 and cells[frontcy][frontcx+1].ctype ~= 11 and not isModdedTrash(cells[frontcy][frontcx+1].ctype) or (GetSidedTrash(cells[frontcy][frontcx+1].ctype) ~= nil and GetSidedTrash(cells[frontcy][frontcx+1].ctype)(frontcx+1, frontcy, 0)) and cells[frontcy][frontcx+1].ctype ~= 40 and cells[frontcy][frontcx+1].ctype ~= 50) then cells[frontcy][frontcx+1].ctype = 0 end
									if frontcx > 0 and (not cells[frontcy][frontcx-1].protected and cells[frontcy][frontcx-1].ctype ~= -1 and cells[frontcy][frontcx-1].ctype ~= 11 and not isModdedTrash(cells[frontcy][frontcx-1].ctype) or (GetSidedTrash(cells[frontcy][frontcx-1].ctype) ~= nil and GetSidedTrash(cells[frontcy][frontcx-1].ctype)(frontcx-1, frontcy, 2)) and cells[frontcy][frontcx-1].ctype ~= 40 and cells[frontcy][frontcx-1].ctype ~= 50) then cells[frontcy][frontcx-1].ctype = 0 end
									if frontcy < height-1 and (not cells[frontcy+1][frontcx].protected and cells[frontcy+1][frontcx].ctype ~= -1 and cells[frontcy+1][frontcx].ctype ~= 11 and not isModdedTrash(cells[frontcy+1][frontcx].ctype)  or (GetSidedTrash(cells[frontcy+1][frontcx].ctype) ~= nil and GetSidedTrash(cells[frontcy+1][frontcx].ctype)(frontcx, frontcy+1, 1))and cells[frontcy+1][frontcx].ctype ~= 40 and cells[frontcy+1][frontcx].ctype ~= 50) then cells[frontcy+1][frontcx].ctype = 0 end
									if frontcy > 0 and (not cells[frontcy-1][frontcx].protected and cells[frontcy-1][frontcx].ctype ~= -1 and cells[frontcy-1][frontcx].ctype ~= 11 and not isModdedTrash(cells[frontcy-1][frontcx].ctype) or (GetSidedTrash(cells[frontcy-1][frontcx].ctype) ~= nil and GetSidedTrash(cells[frontcy-1][frontcx].ctype)(frontcx, frontcy-1, 3)) and cells[frontcy-1][frontcx].ctype ~= 40 and cells[frontcy-1][frontcx].ctype ~= 50) then cells[frontcy-1][frontcx].ctype = 0 end
								end
							end
						elseif cells[frontcy][frontcx].ctype == 12 then
							if cells[cy][cx].ctype ~= 0 then
								love.audio.play(destroysound)
								cells[frontcy][frontcx].ctype = 0
								enemyparticles:setPosition(frontcx*20,frontcy*20)
								enemyparticles:emit(50)
							end
						elseif isModdedBomb(cells[frontcy][frontcx].ctype) or (GetSidedEnemy(cells[frontcy][frontcx].ctype) ~= nil and GetSidedEnemy(cells[frontcy][frontcx].ctype)(frontcx, frontcy, direction)) then
							if cells[cy][cx].ctype ~= 0 then
								if not IsSilent(cells[frontcy][frontcx].ctype) then
									love.audio.play(destroysound)
								end
								cells[frontcy][frontcx].ctype = 0
								enemyparticles:setPosition(frontcx*20,frontcy*20)
								enemyparticles:emit(50)
							end
						elseif cells[frontcy][frontcx].ctype == 23 then
							if cells[cy][cx].ctype ~= 0 then
								love.audio.play(destroysound)
								cells[frontcy][frontcx].ctype = 12
								enemyparticles:setPosition(frontcx*20,frontcy*20)
								enemyparticles:emit(50)
							end
						elseif cells[frontcy][frontcx].ctype >= 31 and cells[frontcy][frontcx].ctype <= 36 then
							if (cells[frontcy][frontcx].rot-1)%4 == direction then
								cells[frontcy][frontcx].inr = true
							elseif (cells[frontcy][frontcx].rot+1)%4 == direction then
								cells[frontcy][frontcx].inl = true
							end
						else
							cells[lastcy][lastcx] = CopyCell(cx,cy)
							cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)%4
							if dontpull then cells[lastcy][lastcx].pulleddir = (direction-addedrot)%4 end
							--modsOnMove(cells[lastcy][lastcx].ctype, lastcx, lastcy, cells[lastcy][lastcx].rot, direction, totalforce)
						end
					else
						cells[lastcy][lastcx] = CopyCell(cx,cy)
						cells[lastcy][lastcx].rot = (cells[cy][cx].rot-addedrot)%4
						if dontpull then cells[lastcy][lastcx].pulleddir = (direction-addedrot)%4 end
						--modsOnMove(cells[lastcy][lastcx].ctype, lastcx, lastcy, cells[lastcy][lastcx].rot, direction, totalforce)
					end
					addedrot = 0
					SetChunk(lastcx,lastcy,cells[lastcy][lastcx].ctype)
					table.insert(moved, lastcx)
					table.insert(moved, lastcy)
					table.insert(moved, direction)
					table.insert(moved, totalforce)
					table.insert(moved, cells[lastcy][lastcx].ctype)
					table.insert(moved, cells[lastcy][lastcx].rot)
					--modsOnMove(cells[cy][cx].ctype, cx, cy, cells[cy][cx].rot, direction, totalforce)
					lastcx = cx
					lastcy = cy
				end
			until cells[cy][cx].ctype == 0
			cells[cy][cx].testvar = "moveend"
			for i=1,#moved, 6 do
				-- This idea works...
				local mcx = moved[i]
				local mcy = moved[i+1]
				local mcd = moved[i+2]
				local mctf = moved[i+3]
				local mctype = moved[i+4]
				local mcrot = moved[i+5]
				modsOnMove(mctype, mcx, mcy, mcrot, mcd, mctf)
			end
		else
			updatekey = updatekey + 1
			return false
		end
	else
		updatekey = updatekey + 1
		return false
	end
	updatekey = updatekey + 1
	return true
end