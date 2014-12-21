local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharVoiceDesc");
COMMAND.tip = "Change your character's voice description.";
COMMAND.text = "[string Text]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local minimumVoiceDesc = Clockwork.config:Get("minimum_voicedesc"):Get();

	if (arguments[1]) then
		local text = table.concat(arguments, " ");
		
		if (string.len(text) < minimumVoiceDesc) then
			Clockwork.player:Notify(player, "The voice description must be at least "..minimumVoiceDesc.." characters long!");
			return;
		end;
		
		player:SetCharacterData("VoiceDesc", PLUGIN:ModifyVoiceDesc(text));
	else
		Clockwork.dermaRequest:RequestString(player, "Voice Description Change", "What do you want to change your voice description to?", player:GetSharedVar("VoiceDesc"), function(result)
			player:RunClockworkCmd(self.name, result);
		end)
	end;
end;

COMMAND:Register();

if (CLIENT) then
	Clockwork.quickmenu:AddCallback("Voice Description", "Extra Descriptions", function()
		local commandTable = Clockwork.command:FindByID("CharVoiceDesc");
		
		if (commandTable) then
			return {
				toolTip = commandTable.tip,
				Callback = function(option)
					Clockwork.kernel:RunCommand("CharVoiceDesc");
				end
			};
		else
			return false;
		end;
	end);
end;