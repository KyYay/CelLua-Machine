ModBinder = {}

ModBinder.version = "First-Build"

function ModBinder.bindMod(modName)
  local i = GetModIndex(modName)
  -- This function is for binding a mod
  local mod = {}
  local binding = {}
  binding.bindFunction = function(funcName, func)
    mod[funcName] = func
    return binding
  end
  modcache[i] = mod
  return binding
end