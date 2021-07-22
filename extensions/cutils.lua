
local filePath = ...
local folderPath = GetParentPath(filePath)
local parentPath = GetParentPath(folderPath)
local cutilsPath = parentPath.."cutils/cutils.dll"

assert(package.loadlib(cutilsPath, "luaopen_utils"), "Something went wrong when loading cutils.dll")()
