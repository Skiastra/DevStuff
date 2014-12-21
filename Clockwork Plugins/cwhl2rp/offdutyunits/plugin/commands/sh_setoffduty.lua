local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SetOffDuty");
COMMAND.tip = "Sets a character to be the offduty version of a unit.";
COMMAND.text = "<string player> <string tags>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local characters = target:GetCharacters();
	if target then
		if (target:GetCharacterData("OffDuty")) then
			target:SetCharacterData("OffDuty", nil);
			player:Notify("You removed "..target:Name().."'s pairing with their unit character!");
			target:Notify("The pairing with your unit character was removed by "..player:Name().."!");
		else
			local failure;
			for k, v in pairs (characters) do
				if (cwOffDuty:IsUnit(arguments[2], v.name)) then
					if (!target:GetCharacterData("OffDuty") or target:GetCharacterData("OffDuty") == "") then
						target:SetCharacterData("OffDuty", v.characterID);
						Clockwork.kernel:PrintLog(LOGTYPE_URGENT, player:Name().." has made "..target:Name().." the off-duty character of "..v.name..".");
						target:Notify("You were made the off-duty character of "..v.name..".");
						player:Notify("You made "..target:Name().." the off-duty character of "..v.name..".");
						failure = false
						break;
					end;
				end;	
				failure = true
			end;
			
			if (failure == true) then
				player:Notify("The unit specified could not be found!")
			end;
		end;
	else
		player:Notify(arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register(); 