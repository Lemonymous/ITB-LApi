
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
	local options = mod_loader.currentModContent[mod_id].options
	local ok, err = pcall(package.loadlib(cutilsPath, "luaopen_inspect"), {
		name = NAME,
		debug = options.cutils_debug or false,
		verbose = options.cutils_verbose_init or false,
		get = true,
		set = true,
	})

	if not ok then
		error(string.format("%s %s - %s", failMsg, cutilsPath, err))
	else
		LOGF("%s into global table _G[\"%s\"]", successMsg, NAME)
	end

	if options.cutils_verbose_calls then
		for name, fn in pairs(_G[NAME].Pawn) do
			if type(fn) == 'function' then
				local oldFn = fn
				_G[NAME].Pawn[name] = function(...)
					LOGF("Calling Pawn:%s(...)", name)
					local result = oldFn(...)
					LOGF("Called Pawn:%s(...) successfully", name)
					return result
				end
			end
		end

		for name, fn in pairs(_G[NAME].Board) do
			if type(fn) == 'function' then
				local oldFn = fn
				_G[NAME].Board[name] = function(...)
					LOGF("Calling Board:%s(...)", name)
					local result = oldFn(...)
					LOGF("Called Board:%s(...) successfully", name)
					return result
				end
			end
		end
	end
end

function cutils:get()
	return _G[NAME]
end

return cutils
