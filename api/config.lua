require('api/save')

function loadConfig()
	local lines = {}
  local config = {}
	for line in love.filesystem.lines("api.config") do
		table.insert(lines, line)
	end
	for i=1,#lines,1 do
		local code = split(lines[i], '=')
		config[code[1]] = code[2]
	end
  return config
end