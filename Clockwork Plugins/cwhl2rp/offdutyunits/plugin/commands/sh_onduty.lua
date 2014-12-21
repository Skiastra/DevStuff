local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("OnDuty");
COMMAND.tip = "Go on-duty.";
COMMAND.text = "<No arguments>";
COMMAND.flags = CMD_DEFAULT;

function COMMAND:OnRun(player)
	local player = player;
	for k, v in ipairs( ents.FindInSphere(player:GetPos(),350) ) do
		if v:IsValid() && v:GetClass() == "cw_terminal" then
			cwOffDuty:GoOnDuty(player);
		end;
	end;
end;

COMMAND:Register(); 