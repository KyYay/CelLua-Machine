require "api.helper"

pushabilitySheet = {}
moddedMovers = {}
moddedBombs = {}
moddedTrash = {}
cellsForIDManagement = {}
cellLabels = {}
cellWeights = {}
moddedDivergers = {}
local cellTypes = {}
local unmovableData = {}
local flippered = {}
local unfreezable = {}
local fungals = {}
local sidedtrash = {}
local sidedenemy = {}
local genfuncs = {}
local silent = {}
local biases = {}

function GiveBias(id, bias)
  --if cellTypes[id] ~= "mover" then error("Attempt to give a non-mover special bias") end
  biases[id] = bias
end

function GetBias(id)
  return (biases[id] or 1)
end

function IsSilent(id)
  id = getRealID(id)

  return silent[id] == true
end

function Silence(id) -- thot
  id = getRealID(id)

  silent[id] = not (silent[id] or false)
end

function addAdvanced(options)
  if type(options) ~= "table" then error("Options table must be table") end

  return addCell(options.label, options.texture, options)
end

function CanGenCell(genID, genx, geny, gendid, gendx, gendy, gendir)
  if not genfuncs[gendid] then return true end
  return genfuncs[gendid](gendid, gendx, gendy, genID, genx, geny, gendir)
end

function SetSidedEnemy(id, callback)
  id = getRealID(id)
  if getCellType(id) ~= "sideenemy" then
    error("Attempt to add sided enemy callback to cell without sideenemy type.")
  end
  sidedenemy[id] = callback
end

function GetSidedEnemy(id)
  return sidedenemy[id]
end

function SetSidedTrash(id, callback)
  id = getRealID(id)
  if getCellType(id) ~= "sidetrash" then
    error("Attempt to add sided trash callback to cell without sidetrash type.")
  end
  sidedtrash[id] = callback
end

function GetSidedTrash(id)
  return sidedtrash[id]
end

function isFungal(id)
  return (fungals[id] ~= nil)
end

function isUnfreezable(id)
  return (unfreezable[id] == true)
end

function ToggleFreezability(id)
  id = getRealID(id)

  if not unfreezable[id] then
    unfreezable[id] = false
  end
  unfreezable[id] = not unfreezable[id]
end

function getRealID(id)
  if type(id) == "string" then
    return getCellIDByLabel(id)
  end
  return id
end

function hasFlipperTranslation(cellID)
  cellID = getRealID(cellID)

  return (flippered[cellID] ~= nil)
end

function makeFlipperTranslation(cellID)
  cellID = getRealID(cellID)

  return (flippered[cellID] or cellID)
end

function addFlipperTranslation(translator, translated, bothWays)
  if bothWays == nil then bothWays = true end
  
  translator = getRealID(translator)
  translated = getRealID(translated)
  
  flippered[translator] = translated
  if bothWays then flippered[translated] = translator end
end

function nilifyData(cell)
  for k, v in pairs(unmovableData) do
    if type(v) == "boolean" then
      cell[k] = nil
    elseif type(v) == "table" then
      cell[k] = CopyTable(v)
    else
      cell[k] = v
    end
  end
end

function addUnmovableData(data, optionalDefault)
  unmovableData[data] = optionalDefault or true
end

function removeUnmovableData(data)
  unmovableData[data] = nil
end


function getCellType(id)
  return cellTypes[id] or "unknown"
end

function bindDivergerFunction(id, divergerFunction)
  id = getRealID(id)
  if getCellType(id) ~= "diverger" then
    error("Attempt to add diverger callback to cell without diverger type.")
  end
  moddedDivergers[id] = divergerFunction
end

function setCell(x, y, id, rot, lastvars)
  local original = CopyCell(x, y)
  rot = rot or original.rot
  lastvars = lastvars or original.lastvars

  cells[y][x].ctype = id
  cells[y][x].rot = rot
  cells[y][x].lastvars = lastvars
  for _, mod in pairs(modcache) do
    if mod.onModSetCell ~= nil then
      mod.onModSetCell(id, x, y, rot, lastvars, original)
    end
  end
end

function addModdedWall(ctype)
  for i=1,#walls,1 do
    if walls[i] == ctype then
      return
    end
  end
  walls[#walls + 1] = ctype
end

--- @param label string
--- @param texture string
--- @param options table
--- @return number
function addCell(label, texture, options)
  if type(label) ~= "string" then return nil end
  if type(texture) ~= "string" then return nil end
  if label == "vanilla" or label == "unknown" then
    error("Invalid label for custom cell")
  end
  RunPluginBinding("cell-addition", label, texture, options)
  local cellID = #cellsForIDManagement+1
  tex[cellID] = love.graphics.newImage(texture)
  -- Getting options
  if type(options) ~= "table" then options = {} end
  local push = options.push or (function() return true end)
  local gen = options.gen or (function() return true end)
  local invisible = (options.invisible) or false
  local index = options.index
  local weight = options.weight
  local ctype = options.type
  local dontupdate = options.dontupdate or false
  local updateindex = options.updateindex
  local static = options.static or false
  local silent = options.silent or false
  local bias = options.bias or 1

  -- Epic cell
  if invisible == false then
    if not index then
      listorder[#listorder+1] = cellID
    elseif type(index) == "number" then
      table.insert(listorder, index, cellID)
    end
  end
  pushabilitySheet[cellID] = push
  genfuncs[cellID] = gen
  cellLabels[cellID] = label
  cellsForIDManagement[#cellsForIDManagement+1] = cellID
  if weight ~= nil then
    cellWeights[cellID] = weight
  end
  ctype = ctype or "normal"
  cellTypes[cellID] = ctype
  GiveBias(cellID, bias)
  if ctype == "mover" then
    moddedMovers[cellID] = true
  elseif ctype == "enemy" then
    moddedBombs[cellID] = true
  elseif ctype == "trash" then
    moddedTrash[cellID] = true
  elseif ctype == "diverger" then
    moddedDivergers[cellID] = function(x, y, rot) return rot end
  elseif ctype == "fungal" then
    fungals[cellID] = true
  elseif ctype == "sidetrash" then
    SetSidedTrash(cellID, function(cx, cy, direction) return true end)
  elseif ctype == "sideenemy" then
    SetSidedEnemy(cellID, function(cx, cy, direction) return true end)
  end
  texsize[cellID] = {}
  texsize[cellID].w = tex[cellID]:getWidth()
  texsize[cellID].h = tex[cellID]:getHeight()
  texsize[cellID].w2 = tex[cellID]:getWidth()/2
  texsize[cellID].h2 = tex[cellID]:getHeight()/2
  moddedIDs[#moddedIDs+1] = cellID

  if silent then
    Silence(cellID)
  end

  if dontupdate ~= true then
    local generatedSubtick = GenerateSubtick(cellID, DoModded, not static)
    if type(updateindex) == "number" then
      table.insert(subticks, updateindex, generatedSubtick)
    else
      table.insert(subticks, generatedSubtick)
    end
  end

  RunPluginBinding("post-cell-addition", cellID, label, texture, options)
  return cellID
end

function canPushCell(cx, cy, px, py, pushing, force)
  if (not cx) or (not cy) then
    return false
  end
  local cdir = cells[cy][cx].rot
  local pdir = cells[py][px].rot
  local ctype = cells[cy][cx].ctype
  if pushabilitySheet[ctype] == nil then
    return false
  end
  return pushabilitySheet[ctype](cx, cy, cdir, px, py, pdir, pushing, force)
end