
local searchLocations = {
	"lib/",
	"libs/",
	"library/",
	"libraries/",
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

local function fetchlib(lib_id, mod, searchingMod)
	local lib

	if searchingMod == nil then
		searchingMod = mod
	end

	if mod.parent then
		local parentMod = mod_loader.mods[mod.parent]
		lib = fetchlib(lib_id, parentMod, searchingMod)
	end

	if lib == nil then
		LOGDF("Mod %s (%s) searching for library '%s' in mod %s (%s)...",
			searchingMod.name,
			searchingMod.id,
			lib_id,
			mod.name,
			mod.id
		)
		for _, subpath in ipairs(searchLocations) do
			local libraryPath = mod.scriptPath..subpath..lib_id
			LOGDF("Searching for %s.lua...", libraryPath)
			if modApi:fileExists(libraryPath..".lua") then
				lib, err = prequire(libraryPath)
				if lib then
					LOGDF("Mod %s (%s) successully found library '%s': %s.lua",
						searchingMod.name,
						searchingMod.id,
						lib_id,
						libraryPath
					)

					break
				else
					LOGDF("Mod %s (%s) failed to read library '%s': %s.lua.\n%s",
						searchingMod.name,
						searchingMod.id,
						lib_id,
						libraryPath,
						err
					)
				end
			end
		end
	end

	return lib
end

function library:fetch(lib_id, mod_id)
	Assert.Equals('string', type(lib_id), "Argument #1")
	Assert.Equals({'nil', 'string'}, type(mod_id), "Argument #2")

	if mod_id == nil then
		Assert.ModInitializingOrLoading("Fetch library")
		mod_id = modApi.currentMod
	end

	local mod = mod_loader.mods[mod_id]

	if self.mods[mod_id] == nil then
		self.mods[mod_id] = {}
	end

	local lib = self.mods[mod_id][lib_id]

	if lib == nil then
		lib = fetchlib(lib_id, mod, nil)

		self.mods[mod_id][lib_id] = lib
	end

	if lib == nil then
		error(string.format("Mod %s (%s) could not find library '%s'",
			mod.name,
			mod_id,
			lib_id
		))
	end

	return lib
end

return library
