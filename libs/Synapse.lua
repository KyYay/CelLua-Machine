Synapse = {}

Synapse.version = "0.2 First-Integration"

local listeners = {}

local connections = {}

local function synError(msg)
  error("Synapse > " .. msg)
end

function Synapse.addListener(id, callback)
  if listeners[id] ~= nil then
    synError("Attempt to add a listener with duplicate id")
  end
  listeners[id] = callback
end

function Synapse.removeListener(id)
  if listeners[id] == nil then
    synError("Attempt to remove non-existant callback")
  end
  table.remove(listeners, id)
end

function Synapse.setListener(id, callback)
  listeners[id] = callback
end

function Synapse.createMessageBlock(msg, code)
  return {
    code = code,
    msg = msg
  }
end

function Synapse.isListener(id)
  return (listeners[id] ~= nil)
end

function Synapse.connect(connector, connected, connectionData)
  if Synapse.isListener(connected) then
    local accepted = listeners[connected](connector, "connection-start", connectionData)
    if accepted == false then
      return nil, nil
    end
  end 
  local connectionID = #connections + 1
  local connection = {
    connector = connector,
    connected = connected,
    signal = function(msg)
      if listeners[connected] == nil then
        synError("Attempt to signal unknown listener")
      end
      local response = listeners[connected](msg, "signal")
      if listeners[connector] ~= nil and response ~= nil then
        listeners[connector](response)
      end
      return response
    end,
    signalVanilla = function(msg)
      if sendSignal then
        sendSignal(connector, connected, msg)
      end
    end,
    dispose=function()
      if connections[connectionID] == nil then return end
      if Synapse.isListener(connected) then
        listeners[connected](connector, "connection-disposed")
      end
      table.remove(connections, connectionID)
    end,
  }
  return connection, connectionID
end

function Synapse.getCachedConnection(connectionID)
  return connections[connectionID]
end

Synapse.addListener("synapse-1", function(msg) return msg end)

return Synapse