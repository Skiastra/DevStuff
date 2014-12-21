
-- Called when a player's shared variables should be set.
function cwOffDuty:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("offduty", player:GetCharacterData("OffDuty"));
end;

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if ( data["OffDuty"] ) then
		data["OffDuty"] = data["OffDuty"];
	end;
	if ( data["OnDuty"] ) then
		data["OnDuty"] = data["OnDuty"];
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["OffDuty"] = data["OffDuty"];
	data["OnDuty"] = data["OnDuty"];
end;

function PLUGIN:PlayerCanUseDoor(player, door)
	if (player:GetSharedVar("tied") != 0 or (!Schema:PlayerIsCombine(player) and player:GetFaction() != FACTION_ADMIN)) and !cwOffDuty:IsOffDuty(player) then
		return false;
	else
		return true;
	end;
end;