
local path = GetParentPath(...)
local VERSION = "0.2.0"
local extensions = {
	"cutils",
	"assert",
	"board",
	"pawn",
}
local tests = {
	"board",
	"pawn",
}
local modules = {
	"scripts"
}

local function onModsInitialized()
	if VERSION < LApi.version then
		return
	end

	if LApi.initialized then
		return
	end

	LApi:finalizeInit()
	LApi.initialized = true
end

local function onModsLoaded()
	if VERSION < LApi.version then
		return
	end

	if LApi.loaded then
		return
	end

	LApi:finalizeLoad()
	LApi.loaded = true
end

modApi:addModsInitializedHook(onModsInitialized)

if LApi == nil or modApi:isVersion(VERSION, LApi.version) then
	LApi = LApi or {}
	LApi.version = VERSION

	function LApi:finalizeInit()
		self.scripts:init(path.."extensions/", extensions)
		self.scripts:init(path.."modules/", modules)
	end

	function LApi:finalizeLoad()
		self.scripts:load(path.."extensions/", extensions)
		self.scripts:load(path.."tests/", tests)
		self.scripts:load(path.."modules/", modules)
	end

	function LApi:load()
		self.loaded = false
		modApi:addModsLoadedHook(onModsLoaded)
	end

	-- give all modules new metatables in order to redirect all function calls
	-- to the modules of the highest version of LApi
	for _, moduleId in ipairs(modules) do
		LApi[moduleId] = LApi[moduleId] or {}
		local module = require(path.."modules/"..moduleId)
		local metatable = {}
		local oldMetatable = getmetatable(module) or {}
		for i, v in pairs(oldMetatable) do
			if i:find("^__") then
				metatable[i] = v
			end
		end
		rawset(metatable, "__index", module)
		setmetatable(LApi[moduleId], metatable)
	end
end

return LApi
