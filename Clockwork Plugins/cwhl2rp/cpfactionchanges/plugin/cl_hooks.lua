local PLUGIN = PLUGIN;

-- Called when a player's scoreboard class is needed.
function PLUGIN:GetPlayerScoreboardClass(player)
	local customClass = player:GetSharedVar("customClass");
	local faction = player:GetFaction();
	local class = player:GetClass();
	local name = player:GetName();
	
	if (customClass != "") then
		return customClass;
	end;
	
	if (faction == FACTION_MPF) then
		if (string.find(name, "RCT")) then
			return "Civil Protection Recruit";
		elseif (string.find(name, "C1") or string.find(name, "C2")) then
			return "Civil Protection Command Unit";
		elseif (string.find(name, "H1") or string.find(name, "H2")) then
			return "Civil Protection High Command Unit";
		elseif (faction == FACTION_OTA) then
			return "Overwatch Transhuman Arm";
		else
			return "Civil Protection Ground Unit";
		end;
	end
end;