local plugs = {}
local initializedInitPlugs = false
local currentPlugin = ""
local isInPlugin = false
local pluginBindings = {}

for _, name in pairs(love.filesystem.getDirectoryItems('plugins')) do
  local nameSplit = split(name, '.')
  if #nameSplit > 1 and nameSplit[#nameSplit] == 'lua' then
    local pluginName = nameSplit[1]
    plugs[pluginName] = love.filesystem.load('plugins/' .. name)
  end
end

function RunPluginBinding(functionName, ...)
  for _, binding in pairs(pluginBindings) do
    if type(binding[functionName]) == "function" then
      binding[functionName](...)
    end
  end
end

function BindPluginFunctions(functionName, func)
  if isInPlugin == false then return end

  if not pluginBindings[currentPlugin] then pluginBindings[currentPlugin] = {} end

  pluginBindings[currentPlugin][functionName] = func
end

function loadInitialPlugins()
  if initializedInitPlugs then return end
  initializedInitPlugs = true
  for plug in love.filesystem.lines("plugins/toinit.txt") do
    GetPlugin(plug)
  end
end

function hasPlugin(p)
  return (plugs[p] ~= nil)
end

function GetPlugin(plugin)
  if not plugs[plugin] then return nil end
  if plugin == currentPlugin then return nil end
  
  local copies = {
    listorder = CopyTable(listorder),
    moddedMovers = CopyTable(moddedMovers),
    moddedTrash = CopyTable(moddedTrash),
    moddedIDs = CopyTable(moddedIDs),
    moddedBombs = CopyTable(moddedBombs),
    moddedDivergers = CopyTable(moddedDivergers),
    tex = CopyTable(tex),
    plugingetter = GetPlugin,
  }

  currentPlugin = plugin
  isInPlugin = true

  local p = plugs[plugin]()

  listorder = copies.listorder
  moddedMovers = copies.moddedMovers
  moddedTrash = copies.moddedTrash
  moddedIDs = copies.moddedIDs
  moddedBombs = copies.moddedBombs

  if #(copies.tex) ~= #tex then
    tex = copies.tex
  end

  currentPlugin = ""
  isInPlugin = false

  GetPlugin = copies.plugingetter
  
  return p
end