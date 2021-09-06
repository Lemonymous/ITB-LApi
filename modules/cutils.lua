
local mod_id = modApi.currentMod
local filePath = ...
local folderPath = GetParentPath(filePath)
local parentPath = GetParentPath(folderPath)
local cutilsPath = parentPath.."cutils/cutils.dll"
local successMsg = "cutils.dll successfully loaded"
local failMsg = "Something went wrong when loading"
local NAME = "cutils-dll"

local cutils = {}

function cutils:init()
	local currentModContent = mod_loader.currentModContent
	local options = currentModContent and currentModContent[mod_id].options or {}

	local cutils_debug = options.cutils_debug or {}
	local cutils_verbose_init = options.cutils_verbose_init or {}
	local cutils_verbose_calls = options.cutils_verbose_calls or {}

	local ok, err = pcall(package.loadlib(cutilsPath, "luaopen_inspect"), {
		name = NAME,
		debug = cutils_debug.enabled or false,
		verbose = cutils_verbose_init.enabled or false,
		get = true,
		set = true,
	})

	if not ok then
		error(string.format("%s %s - %s", failMsg, cutilsPath, err))
	else
		LOGF("%s into global table _G[\"%s\"]", successMsg, NAME)
	end

	if cutils_verbose_calls.enabled then
	end
end

function cutils:get()
	return _G[NAME]
end

return cutils
