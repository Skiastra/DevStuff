local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("SelfExamine");
COMMAND.tip = "Look at yourself";
COMMAND.text = "[No Text]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player;
	if (target) then
		if (target:GetSharedVar("tied") == 0) then
			Clockwork.datastream:Start( player, "ViewDetDesc", { target, target:GetCharacterData("DetailDesc") or target:GetCharacterData("PhysDesc"), target:GetCharacterData("PictureDesc") or ""} );
		end;
	end;
end;

COMMAND:Register();