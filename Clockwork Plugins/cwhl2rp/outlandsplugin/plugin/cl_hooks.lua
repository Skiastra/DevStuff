local PLUGIN = PLUGIN;

-- Called when a player's scoreboard class is needed.
function PLUGIN:GetPlayerScoreboardClass(player)
	if (string.lower( game.GetMap() ) != "rp_industrial17_v1") then
		local customClass = player:GetSharedVar("customClass");
		local faction = player:GetFaction();
		
		if (customClass != "") then
			return customClass;
		end;
		
		if (faction == FACTION_CITIZEN) then
			return "Survivor"
		end
	end;
end;