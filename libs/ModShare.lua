ModShare = {}

local stores = {}
local auths = {}

--- @class Store
--- @field current any
--- @field handler function|nil
--- @field dispatch function:Store
--- @field notifyListeners function
--- @field addListeners function
local function Store(default, handler)
  return {
    current = default,
    handler = handler,
    --- @param self Store Our current self
    --- @param event string The event to dispatch
    --- @param payload any|nil Optional
    --- @return Store
    dispatch = function(self, event, payload)
      self.current = self.handler(self.current, event, payload)
      return self
    end,
    notifyListeners = function(self)
      local listeners = self.listeners
      for _, listener in ipairs(listeners) do
        listener(self.current)
      end
    end,
    listeners = {},
    --- @param self Store itself
    --- @param listener function
    --- @return Store
    addListener = function(self, listener)
      table.insert(self.listeners, listener)
      return self
    end
  }
end

--- @param label string Identifier
--- @param defaultValue any Default value
--- @param auth string Optional, for restricting usage to only those who know the correct password.
--- @param handler string Optional, handler callback for event dispatchs.
--- @return Store
function ModShare.createStore(label, defaultValue, auth, handler)
  if stores[label] ~= nil then error("Attempt to create duplicate values.") end
  local store = Store(defaultValue, handler)
  stores[label] = store
  auths[label] = auth
  return store
end

--- @param label string Identifier
--- @param auth string Optional, in case your store has a password.
--- @return Store
function ModShare.getStore(label, auth)
  if stores[label] == nil then return nil end
  if auths[label] ~= nil and auths[label] ~= auth then return nil end

  local store = stores[label]

  return store
end

return ModShare