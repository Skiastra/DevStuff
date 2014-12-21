local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSetVoice");
COMMAND.tip = "Set a character's voice description permanently.";
COMMAND.text = "<string Name> <string Description>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	local minimumVoiceDesc = Clockwork.config:Get("minimum_voicedesc"):Get();
	local text = tostring(arguments[2]);
	
	if (string.len(text) < minimumVoiceDesc) then
		Clockwork.player:Notify(player, "The voice description must be at least "..minimumVoiceDesc.." characters long!");
		
		return;
	end;
	
	target:SetCharacterData("VoiceDesc", PLUGIN:ModifyVoiceDesc(text));
end;

COMMAND:Register();