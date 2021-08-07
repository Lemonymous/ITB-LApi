
local LOG_PATH_LEN_MAX = 55
local searchLocations = {
	"libs/",
	"lib/",
	"libraries/",
	"library/",
	""
}

local library = {
	mods = {}
}

local function prequire(m)
	local ok, err = pcall(require, m)
	if not ok then return nil, err end
	return err
end

local function ploadfile(m)
	local _, func, err = pcall(loadfile, m..".lua")
	if not func then return nil, err end
	local ok, err = pcall(func)
	if not ok then return nil, err end
	return err
end

local function fetchlib(lib_id, mod, searchingMod, newInstance)
	local lib

	if searchingMod == nil then
		searchingMod = mod
	end

	if mod.parent then
		local parentMod = mod_loader.mods[mod.parent]
		lib = fetchlib(lib_id, parentMod, searchingMod, newInstance)
	end

	if lib == nil then
		LOGDF("[%s] Scan for lib '%s.lua' in [%s] ...",
			searchingMod.id,
			lib_id,
			mod.id
		)
		for _, subpath in ipairs(searchLocations) do
			local libraryPath = mod.scriptPath..subpath..lib_id
			local libraryPathLog = libraryPath
			if libraryPath:len() > LOG_PATH_LEN_MAX then
				libraryPathLog = "..."..libraryPathLog:sub(3-LOG_PATH_LEN_MAX, -1)
			end
			if modApi:fileExists(libraryPath..".lua") then
				LOGDF("[%s] Found '%s.lua' ...",
					searchingMod.id,
					libraryPathLog
				)
				local err
				if newInstance then
					lib, err = ploadfile(libraryPath)
				else
					lib, err = prequire(libraryPath)
				end
				if lib then
					LOGDF("[%s] File read successfully!",
						searchingMod.id,
						lib_id
					)

					break
				else
					LOGDF("\n[%s] ERROR: File could not be read!\n\n%s\n",
						searchingMod.id,
						err
					)
				end
			end
		end
	end

	return lib
end

-- For libraries that are not meant to be shared between
-- mods, this method can be used to create a unique
-- instance of the library, only accessable by your mod.
-- Further calls to library.fetch will grab this instance.
-- library.new can be called again to create a new
-- instance.
function library:new(lib_id, mod_id)
	self:fetch(lib_id, mod_id, newInstance)
end

function library:fetch(lib_id, mod_id, newInstance)
	Assert.Equals('string', type(lib_id), "Argument #1")
	Assert.Equals({'nil', 'string'}, type(mod_id), "Argument #2")

	if mod_id == nil then
		Assert.ModInitializingOrLoading("Fetch library")
		mod_id = modApi.currentMod
	end

	if self.mods[mod_id] == nil then
		self.mods[mod_id] = {}
	end

	lib_id = lib_id:gsub(".lua$", "")
	local mod = mod_loader.mods[mod_id]
	local lib = self.mods[mod_id][lib_id]

	if newInstance or lib == nil then
		lib = fetchlib(lib_id, mod, nil, newInstance)

		self.mods[mod_id][lib_id] = lib
	end

	if lib == nil then
		error(string.format("[%s] ERROR: lib '%s.lua' not found!",
			mod_id,
			lib_id
		))
	end

	return lib
end

library.get = library.fetch

return library
