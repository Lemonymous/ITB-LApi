# ITB-LApi
 LApi is a mod loader extender for Into the Breach, intended to add functionality for mods - mainly via memory manipulation. It will add or alter existing functions for Pawn and Board, among other things.

# How to use
 In order to add the functions to your mod, all you need to do is to drop the `LApi` folder into your `scripts` folder, and then `initialize` and `load` it in your `init.lua`.

 Correct folder structure should look like this: `../Into the Breach/mods/[my mod]/scripts/LApi/`

&nbsp;

 This is an example of how to load the api in your `init.lua`:
```lua
local function init(self)
	require(self.scriptPath .."LApi/LApi"):init()
end

local function load(self, options, version)
    require(self.scriptPath .."LApi/LApi"):load()
end
```

&nbsp;

This is a work in progress. Function list will come later.
