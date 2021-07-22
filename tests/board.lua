
--[[
	untestable by automatic tests:
	GetHighlighted
	IsHighlighted - failed
	MarkGridLoss
	IsGameBoard
	IsMissionBoard
	IsTipImage
]]

Testsuites.lapi = Testsuites.lapi or Tests.Testsuite()
Testsuites.lapi.name = "LApi-related tests"
Testsuites.lapi.board = Tests.Testsuite()
Testsuites.lapi.board.name = "LApi-Board-related tests"

local testsuite = Testsuites.lapi.board

function testsuite.test_BoardSetFire()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
	Board:SetFire(loc, true);				local fire = Board:IsFire(loc) == true
	Board:SetFire(loc, false);				local notFire = Board:IsFire(loc) == false
	
	Assert.True(fire)
	Assert.True(notFire)
	
	return true
end

function testsuite.test_BoardIsForest()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
											local notForest = Board:IsForest(loc) == false
	Board:SetTerrain(loc, TERRAIN_FOREST);	local forest = Board:IsForest(loc) == true
	Board:SetFire(loc, true);				local forestFire =  Board:IsForest(loc) == true
	Board:SetFire(loc, false);				local extinguishedForestFire = Board:IsForest(loc) == true
	
	Assert.True(notForest)
	Assert.True(forest)
	Assert.True(forestFire)
	Assert.True(extinguishedForestFire)
	
	return true
end

function testsuite.test_BoardIsForestFire()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
											local notForest = Board:IsForestFire(loc) == false
	Board:SetTerrain(loc, TERRAIN_FOREST);	local forest = Board:IsForestFire(loc) == false
	Board:SetFire(loc, true);				local forestFire = Board:IsForestFire(loc) == true
	Board:SetFire(loc, false);				local isExtinguishedForestFire = Board:IsForestFire(loc) == false
	
	Assert.True(notForest)
	Assert.True(forest)
	Assert.True(forestFire)
	Assert.True(isExtinguishedForestFire)
	
	return true
end

function testsuite.test_BoardIsShield()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	local createShield = SpaceDamage(loc)
	local removeShield = SpaceDamage(loc)
	createShield.iShield = 1
	removeShield.iShield = -1
	
											local notShield = Board:IsShield(loc) == false
	Board:DamageSpace(createShield);		local createShield = Board:IsShield(loc) == true
	Board:DamageSpace(removeShield);		local removeShield = Board:IsShield(loc) == false
	
	Assert.True(notShield)
	Assert.True(createShield)
	Assert.True(removeShield)
	
	return true
end

function testsuite.test_BoardSetShield()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	
											local notShield = Board:IsShield(loc) == false
	Board:SetShield(loc, true);				local createShield = Board:IsShield(loc) == true
	Board:SetShield(loc, false);			local removeShield = Board:IsShield(loc) == false
	
	Assert.True(notShield)
	Assert.True(createShield)
	Assert.True(removeShield)
	
	return true
end

function testsuite.test_BoardGetHealth()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	local damage = SpaceDamage(loc, 1)
	
												local hp2 = Board:GetHealth(loc)
	Board:DamageSpace(damage);					local hp1 = Board:GetHealth(loc)
	Board:DamageSpace(damage);					local hp0 = Board:GetHealth(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN);	local refresh = Board:GetHealth(loc)
	
	Assert.Equals(2, hp2)
	Assert.Equals(1, hp1)
	Assert.Equals(0, hp0)
	Assert.Equals(2, refresh)
	
	return true
end

function testsuite.test_BoardGetMaxHealth()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	
	local maxHp2 = Board:GetMaxHealth(loc)
	
	Assert.Equals(2, maxHp2)
	
	return true
end

function testsuite.test_BoardSetMaxHealth()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	Board:SetTerrain(loc, TERRAIN_BUILDING)
	
												local maxHp2 = Board:GetMaxHealth(loc)
	Board:SetMaxHealth(loc, 5);					local maxHp4 = Board:GetMaxHealth(loc)
	Board:SetMaxHealth(loc, -1);				local maxHp1 = Board:GetMaxHealth(loc)
	Board:SetMaxHealth(loc, 3);					local maxHp3 = Board:GetMaxHealth(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN);	local maxHpReset = Board:GetMaxHealth(loc)
	
	Assert.Equals(2, maxHp2)
	Assert.Equals(4, maxHp4)
	Assert.Equals(1, maxHp1)
	Assert.Equals(3, maxHp3)
	Assert.Equals(2, maxHpReset)
	
	return true
end

function testsuite.test_BoardSetBuilding()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
											local road = Board:IsBuilding(loc) == false
	Board:SetBuilding(loc, 4, 4);			local building = Board:IsBuilding(loc) == true
											local hp4 = Board:GetHealth(loc)
											local maxHp4 = Board:GetMaxHealth(loc)
	Board:SetBuilding(loc, 1, 3);			local hp1 = Board:GetHealth(loc)
											local maxHp3 = Board:GetMaxHealth(loc)
	
	Assert.True(road)
	Assert.True(building)
	Assert.Equals(4, hp4)
	Assert.Equals(4, maxHp4)
	Assert.Equals(1, hp1)
	Assert.Equals(3, maxHp3)
	
	return true
end

function testsuite.test_BoardSetMountain()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
	Board:SetMountain(loc, 2);				local mountain = Board:IsTerrain(loc, TERRAIN_MOUNTAIN) == true
											local maxHp2 = Board:GetMaxHealth(loc)
											local hp2 = Board:GetHealth(loc)
	Board:SetMountain(loc, 1);				local hp1 = Board:GetHealth(loc)
	Board:SetMountain(loc, 0);				local rubble = Board:IsTerrain(loc, TERRAIN_RUBBLE) == true
											local hp0 = Board:GetHealth(loc)
	
	Assert.True(mountain)
	Assert.True(rubble)
	Assert.Equals(2, maxHp2)
	Assert.Equals(2, hp2)
	Assert.Equals(1, hp1)
	Assert.Equals(0, hp0)
	
	return true
end

function testsuite.test_BoardSetIce()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
	Board:SetIce(loc, 2);					local ice = Board:IsTerrain(loc, TERRAIN_ICE) == true
											local maxHp2 = Board:GetMaxHealth(loc)
											local hp2 = Board:GetHealth(loc)
	Board:SetIce(loc, 1);					local hp1 = Board:GetHealth(loc)
	Board:SetIce(loc, 0);					local water = Board:IsTerrain(loc, TERRAIN_WATER) == true
	
	Assert.True(ice)
	Assert.True(water)
	Assert.Equals(2, maxHp2)
	Assert.Equals(1, hp1)
	Assert.Equals(2, hp2)
	
	return true
end

function testsuite.test_BoardSetRubble()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_MOUNTAIN)
	local damage = SpaceDamage(loc, DAMAGE_DEATH)
	
	Board:SetRubble(loc, true);					local rubble = Board:IsTerrain(loc, TERRAIN_RUBBLE) == true
	Board:SetRubble(loc, false);				local mountain = Board:IsTerrain(loc, TERRAIN_MOUNTAIN) == true
	Board:SetTerrain(loc, TERRAIN_BUILDING);
	Board:DamageSpace(damage);
	Board:SetRubble(loc, false);				local building = Board:IsBuilding(loc) == true
	
	Assert.True(rubble)
	Assert.True(mountain)
	Assert.True(building)
	
	return true
end

function testsuite.test_BoardSetUniqueBuilding()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_BUILDING)
	
	Board:SetUniqueBuilding(loc, "str_bar1");	local uniqueBuilding = Board:IsUniqueBuilding(loc) == true
	Board:RemoveUniqueBuilding(loc);
	
	Assert.True(uniqueBuilding)
	
	return true
end

function testsuite.test_BoardGetUniqueBuilding()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_BUILDING)
	
	Board:SetUniqueBuilding(loc, "str_bar1");	local uniqueBuilding = Board:GetUniqueBuilding(loc)
	Board:RemoveUniqueBuilding(loc);
	
	Assert.Equals("str_bar1", uniqueBuilding)
	
	return true
end

function testsuite.test_BoardRemoveUniqueBuilding()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	Board:SetTerrain(loc, TERRAIN_BUILDING)
	
	Board:SetUniqueBuilding(loc, "str_bar1")
	Board:RemoveUniqueBuilding(loc);			local removedUniqueBuilding = Board:GetUniqueBuilding(loc)
	
	Assert.Equals("", removedUniqueBuilding)
	
	return true
end

function testsuite.test_BoardGetItemName()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
	Board:SetItem(loc, "Item_Mine");	local mine = Board:GetItemName(loc)
	
	Assert.Equals("Item_Mine", mine)
	
	return true
end

function testsuite.test_BoardRemoveItem()
	local loc = Point(0,0)
	Board:ClearSpace(loc)
	
	Board:SetItem(loc, "Item_Mine");
	Board:RemoveItem(loc);				local noMine = Board:GetItemName(loc)
	
	Assert.Equals(nil, mine)
	
	return true
end
