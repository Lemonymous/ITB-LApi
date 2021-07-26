
local cutils = LApi.cutils:get()

BoardPawn.ClearUndoMove = function(self)
	Assert.Equals("userdata", type(self), "Argument #0")
	
	cutils.Pawn.SetUndoX(self, -1)
	cutils.Pawn.SetUndoY(self, -1)
end

BoardPawn.SetUndoLoc = function(self, loc)
	Assert.Signature{
		ret = "void",
		func = "SetUndoLoc",
		params = { self, loc },
		{ "userdata|BoardPawn&", "userdata|Point" },
	}
	
	cutils.Pawn.SetUndoX(self, loc.x)
	cutils.Pawn.SetUndoY(self, loc.y)
end

BoardPawn.GetUndoLoc = function(self)
	Assert.Signature{
		ret = "Point",
		func = "GetUndoLoc",
		params = { self },
		{ "userdata|BoardPawn&" },
	}
	
	return Point(
		cutils.Pawn.GetUndoX(self),
		cutils.Pawn.GetUndoY(self)
	)
end

BoardPawn.GetOwner = function(self)
	Assert.Signature{
		ret = "int",
		func = "GetOwner",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Pawn.GetOwner(self)
end

BoardPawn.SetOwner = function(self, iOwner)
	Assert.Signature{
		ret = "void",
		func = "SetOwner",
		params = { self, iOwner },
		{ "userdata|BoardPawn&", "number|int" }
	}
	
	if self:IsMech() or self:GetId() == iOwner then
		return
	end
	
	local pawn = Board:GetPawn(iOwner)
	
	if not pawn then
		return
	end
	
	return cutils.Pawn.SetOwner(self, iOwner)
end

BoardPawn.SetFire = function(self, fire)
	Assert.Signature{
		ret = "void",
		func = "SetFire",
		params = { self, fire },
		{ "userdata|BoardPawn&", "boolean|bool" }
	}
	
	if fire == nil then
		fire = true
	end
	
	cutils.Pawn.SetFire(self, fire)
end

BoardPawn.IsHighlighted = function(self)
	Assert.Signature{
		ret = "Point",
		func = "IsHighlighted",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Board.IsHighlighted(self:GetSpace())
end

BoardPawn.GetImpactMaterial = function(self)
	Assert.Signature{
		ret = "int",
		func = "GetImpactMaterial",
		params = { self, impactMaterial },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Pawn.GetImpactMaterial(self)
end

BoardPawn.SetImpactMaterial = function(self, impactMaterial)
	Assert.Signature{
		ret = "void",
		func = "SetImpactMaterial",
		params = { self, impactMaterial },
		{ "userdata|BoardPawn&", "number|int" }
	}
	
	cutils.Pawn.SetImpactMaterial(self, impactMaterial)
end

BoardPawn.IsMassive = function(self)
	Assert.Signature{
		ret = "bool",
		func = "IsMassive",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Pawn.IsMassive(self)
end

BoardPawn.SetMassive = function(self, massive)
	Assert.Signature{
		ret = "void",
		func = "SetMassive",
		params = { self, massive },
		{ "userdata|BoardPawn&", "boolean|bool" },
		{ "userdata|BoardPawn&" }
	}
	
	if massive == nil then
		massive = true
	end
	
	cutils.Pawn.SetMassive(self, massive)
end

BoardPawn.IsMovementAvailable = function(self)
	Assert.Signature{
		ret = "bool",
		func = "IsMovementAvailable",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return not cutils.Pawn.IsMoveSpent(self)
end

BoardPawn.SetMovementAvailable = function(self, movementAvailable)
	Assert.Signature{
		ret = "void",
		func = "SetMovementAvailable",
		params = { self, movementAvailable },
		{ "userdata|BoardPawn&", "boolean|bool" },
		{ "userdata|BoardPawn&" }
	}
	
	if movementAvailable == nil then
		movementAvailable = true
	end
	
	cutils.Pawn.SetMoveSpent(self, not movementAvailable)
end

BoardPawn.SetFlying = function(self, flying)
	Assert.Signature{
		ret = "void",
		func = "SetFlying",
		params = { self, flying },
		{ "userdata|BoardPawn&", "boolean|bool" },
		{ "userdata|BoardPawn&" }
	}
	
	if flag == nil then
		flag = true
	end
	
	cutils.Pawn.SetFlying(self, flying)
end

BoardPawn.SetTeleporter = function(self, teleporter)
	Assert.Signature{
		ret = "void",
		func = "SetTeleporter",
		params = { self, teleporter },
		{ "userdata|BoardPawn&", "boolean|bool" },
		{ "userdata|BoardPawn&" }
	}
	
	if teleporter == nil then
		teleporter = true
	end
	
	cutils.Pawn.SetTeleporter(self, teleporter)
end

BoardPawn.SetJumper = function(self, jumper)
	Assert.Signature{
		ret = "void",
		func = "SetJumper",
		params = { self, jumper },
		{ "userdata|BoardPawn&", "boolean|bool" },
		{ "userdata|BoardPawn&" }
	}
	
	if jumper == nil then
		jumper = true
	end
	
	cutils.Pawn.SetJumper(self, jumper)
end

BoardPawn.GetMaxHealth = function(self)
	Assert.Signature{
		ret = "int",
		func = "GetMaxHealth",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Pawn.GetMaxHealth(self)
end

BoardPawn.GetBaseMaxHealth = function(self)
	Assert.Signature{
		ret = "int",
		func = "GetBaseMaxHealth",
		params = { self },
		{ "userdata|BoardPawn&" }
	}
	
	return cutils.Pawn.GetBaseMaxHealth(self)
end

BoardPawn.SetHealth = function(self, hp)
	Assert.Signature{
		ret = "void",
		func = "SetHealth",
		params = { self, hp },
		{ "userdata|BoardPawn&", "number|int" }
	}
	
	local hp_max = self:GetMaxHealth()
	hp = math.max(0, math.min(hp, hp_max))
	
	cutils.Pawn.SetHealth(self, hp)
end

BoardPawn.SetMaxHealth = function(self, hp_max)
	Assert.Signature{
		ret = "void",
		func = "SetMaxHealth",
		params = { self, hp_max },
		{ "userdata|BoardPawn&", "number|int" }
	}
	
	cutils.Pawn.SetMaxHealth(self, hp_max)
end

BoardPawn.SetBaseMaxHealth = function(self, hp_max_base)
	Assert.Signature{
		ret = "void",
		func = "SetBaseMaxHealth",
		params = { self, hp_max_base },
		{ "userdata|BoardPawn&", "number|int" }
	}
	
	cutils.Pawn.SetBaseMaxHealth(self, hp_max_base)
end


local modloaderInitializeBoardPawn = InitializeBoardPawn
function InitializeBoardPawn()
	modloaderInitializeBoardPawn()
	
	local pawn = PAWN_FACTORY:CreatePawn("PunchMech")
	
	local function getMechCount()
		if not Board then
			return 0
		end
		
		local pawns = Board:GetPawns(TEAM_ANY)
		local count = 0
		
		for i = 1, pawns:size() do
			if Board:GetPawn(pawns:index(i)):IsMech() then
				count = count + 1
			end
		end
		
		return count
	end
	
	-- this is a very dangerous function to work with.
	-- loading a game with less than 3 mechs will crash the game.
	-- having more than 3 mechs at any point will crash the game.
	-- not sure if it is possible to use this in any safe way,
	-- but leaving it here because the ability to swap out mechs
	-- could potentially lead to some very cool mods.
	local oldSetMech = pawn.SetMech
	BoardPawn.SetMech = function(self, isMech)
		Assert.Signature{
			ret = "void",
			func = "SetMech",
			params = { self, isMech },
			{ "userdata|BoardPawn&", "boolean|bool" },
			{ "userdata|BoardPawn&" }
		}
		
		if isMech == false then
			cutils.Pawn.SetMech(self, isMech)
		elseif getMechCount() < 3 then
			oldSetMech(self)
		end
	end
	
	-- vanilla function only looks in pawn type table.
	BoardPawn.IsTeleporter = function(self)
		Assert.Signature{
			ret = "bool",
			func = "IsTeleporter",
			params = { self },
			{ "userdata|BoardPawn&" }
		}
		
		return cutils.Pawn.IsTeleporter(self)
	end
	
	-- vanilla function only looks in pawn type table.
	BoardPawn.IsJumper = function(self)
		Assert.Signature{
			ret = "bool",
			func = "IsJumper",
			params = { self },
			{ "userdata|BoardPawn&" }
		}
		
		return cutils.Pawn.IsJumper(self)
	end
	
	-- extend vanilla function to apply status without animation
	local oldSetFrozen = pawn.SetFrozen
	BoardPawn.SetFrozen = function(self, frozen, no_animation)
		if no_animation then
			return cutils.Pawn.SetFrozen(self, frozen)
		end
		
		return oldSetFrozen(self, frozen)
	end
	
	-- extend vanilla function to apply status without animation
	local oldSetShield = pawn.SetShield
	BoardPawn.SetShield = function(self, shield, no_animation)
		if no_animation then
			return cutils.Pawn.SetShield(self, shield)
		end
		
		return oldSetShield(self, shield)
	end
	
	-- extend vanilla function to apply status without animation
	local oldSetAcid = pawn.SetAcid
	BoardPawn.SetAcid = function(self, acid, no_animation)
		if no_animation then
			return cutils.Pawn.SetAcid(self, acid)
		end
		
		return oldSetAcid(self, acid)
	end
end
