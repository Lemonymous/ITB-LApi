
local path = GetParentPath(...)
local VERSION = "0.2.1"
local extensions = {
	"assert",
	"board",
	"pawn",
}
local tests = {
	"board",
	"pawn",
}
local modules = {
	"scripts",
	"library",
	"cutils",
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
	LApi.loaded = nil
	LApi:finalizeLoad()
	LApi.loaded = true
end

modApi:addModsInitializedHook(onModsInitialized)

if LApi == nil or not modApi:isVersion(VERSION, LApi.version) then
	LApi = LApi or {}
	LApi.version = VERSION

	function LApi:finalizeInit()
		self.scripts:init(path.."modules/", modules)
		self.scripts:init(path.."extensions/", extensions)

		modApi:addModsLoadedHook(onModsLoaded)
	end

	function LApi:finalizeLoad()
		self.scripts:load(path.."modules/", modules)
		self.scripts:load(path.."extensions/", extensions)
		self.scripts:load(path.."tests/", tests)
	end

	-- give all modules new metatables in order to redirect all function calls
	-- to the modules of the highest version of LApi
	for _, moduleId in ipairs(modules) do
		LApi[moduleId] = LApi[moduleId] or {}
		local module = require(path.."modules/"..moduleId)
		local metatable = getmetatable(module) or {}
		rawset(metatable, "__index", module)
		setmetatable(LApi[moduleId], metatable)
	end
end

return LApi
