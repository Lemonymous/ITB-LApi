
local function isDirectory(path)
	return path:find("[\\/]$")
end

local function hasLuaFileExtension(path)
	return path:find("%.lua$")
end

local function hasFileExtension(path)
	return path:find("%.[^\\/]+$")
end

local function pruneExtension(file)
	return file:gsub("%.%a+$", "")
end

local function runScripts(parentPath, scripts, fn, ...)
	if type(parentPath) ~= 'string' then
		return
	end
	
	if type(scripts) ~= 'table' then
		scripts = {scripts}
	end
	
	for _, subPath in ipairs(scripts) do
		local path = parentPath .. subPath
		
		if isDirectory(path) then
			if modApi:directoryExists(path) then
				runScripts(path, mod_loader:enumerateFilesIn(path), fn, ...)
			else
				if modApi.developmentMode then
					LOGF("Failed to %s %q: Directory does not exist", fn, path)
				end
			end
			
		else
			if not hasFileExtension(path) then
				path = path ..".lua"
			end
			
			local name = pruneExtension(path)
			
			if hasLuaFileExtension(path) then
				if modApi:fileExists(path) then
					local component = require(name)
					
					if fn and type(component) == 'table' and type(component[fn]) == 'function' then
						component[fn](component, ...)
					end
				else
					if modApi.developmentMode then
						LOGF("Failed to %s %q: File does not exist", fn, path)
					end
				end
			end
		end
	end
end

local scripts = {}

function scripts:init(parentPath, scripts)
	runScripts(parentPath, scripts, 'init')
end

function scripts:load(parentPath, scripts, ...)
	runScripts(parentPath, scripts, 'load', ...)
end

return scripts
