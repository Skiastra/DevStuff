local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("PDA");
COMMAND.tip = "Send a private message to a unit's PDA";
COMMAND.text = "<string name> <string Msg>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local plyfaction = player:GetFaction();
	if (player:HasItemByID("PDA") or plyfaction == "Metropolice Force" 
			or plyfaction == "Overwatch Transhuman Arm") then
		local target = Clockwork.player:FindByID( arguments[1] );
		if target then
			local faction = target:GetFaction();
			if (target:HasItemByID("PDA") or faction == "Metropolice Force" 
			or faction == "Overwatch Transhuman Arm") then
				local words = arguments[2]
				Clockwork.chatBox:SendColored(player, Color(0, 128, 255, 255), "[PDA Message Sent to "..target:Name().."]: <:: "..words)
				Clockwork.chatBox:SendColored(target, Color(51, 153, 255, 255), "[PDA Message received from "..player:Name().."]: <:: "..words)
			else
				Clockwork.chatBox:SendColored(player, Color(255, 51, 0, 255), "[PDA System Error]: <:: Error, unable to send message! Error Code 462.")
			end;
		else
			Clockwork.chatBox:SendColored(player, Color(255, 51, 0, 255), "[PDA System Error]: <:: Error, unable to send message! Error Code 462.")
		end;
	else
		Clockwork.player:Notify("You don't have a PDA!")
	end;
end;

COMMAND:Register();