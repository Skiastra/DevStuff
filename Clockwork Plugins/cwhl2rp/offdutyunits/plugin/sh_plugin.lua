local PLUGIN = PLUGIN;
local FindMetaTable = FindMetaTable;

PLUGIN:SetGlobalAlias("cwOffDuty");

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

function cwOffDuty:IsUnit(unit, char)
	if string.find(char, unit) then
		return true
	end;
end;

function cwOffDuty:IsOffDuty(unit)
	local unit = unit
	local onDuty = unit:GetCharacterData("OffDuty")
	if onDuty then
		return true
	else
		return false
	end;
end;

function cwOffDuty:GoOnDuty(player)
	local player = player;

	local onDuty = player:GetCharacterData("OffDuty");
	local faction = player:GetFaction();
	print(faction);
	
	if (faction == "Citizen") then
		if onDuty then
			player:Notify("You have gone on-duty!")
			local name = player:GetName();
			print(name);
			local position = player:GetPos();
			local angles = player:EyeAngles();
			local characters = player:GetCharacters();
			local charID;
			
			for k, v in pairs (characters) do
				if (v.name == name) then
					charID = v.characterID;
				end;
			end;
			
			print (charID);
			
			Clockwork.player:LoadCharacter(player, onDuty, nil, nil, true);
			player:SetPos(position);
			player:SetEyeAngles(angles);
			player:SetCharacterData("OffDuty", charID);
		else
			player:Notify("You are not a unit!");
		end;
	else
		if onDuty then
			player:Notify("You have gone off-duty!")
			local position = player:GetPos();
			local angles = player:EyeAngles();
			Clockwork.player:LoadCharacter(player, onDuty, nil, nil, true);
			player:SetPos(position);
			player:SetEyeAngles(angles);
		else
			player:Notify("You cannot do that!");
		end;
	end;
end;