local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- A function to get if a faction is Zombie.
function PLUGIN:IsZombieFaction(faction)
	return (faction == FACTION_ZOMB);
end;

-- A function to get if a faction is Headcrab.
function PLUGIN:IsHeadcrabFaction(faction)
	return (faction == FACTION_CRAB);
end;

--[[
--Checks if a ghost can see a player. (Broken :C)
function PLUGIN:GhostCanSee(ply)
	local isTrue = false
	for k, v in ipairs(_player.GetAll()) do
		if (Clockwork.player:CanSeePlayer(ply, v)) then
			isTrue = true
		end;
		if (ply == v) then
			isTrue = false
		end;
	end;
	
	if (isTrue == true) then
		return true
	else
		return false
	end;
end;
--]]