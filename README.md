# ITB-LApi
 LApi is a mod loader extender for Into the Breach, intended to add functionality for mods - mainly via memory manipulation. It will add or alter existing functions for Pawn and Board, among other things.

# How to use
 In order to add the functions, all you need to do is to drop the LApi folder into your mod, and use `require` on the file `LApi.lua`.

&nbsp;

For example if you place LApi into `../Into the Breach/mods/[my mod]/scripts/ITB-LApi/`, then your mod's `init.lua` should look like this:
```lua
local function init(self)
    require(self.scriptPath .."ITB-LApi/LApi")
end
```

&nbsp;
