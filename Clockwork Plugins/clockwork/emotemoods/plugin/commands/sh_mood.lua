--[[
	© 2012 Slidefuse LLC
	This plugin is released under the MIT license. Do whatever!
--]]

local PLUGIN = PLUGIN

local COMMAND = Clockwork.command:New("Mood");
COMMAND.tip = "Puts your character into a mood."
COMMAND.text = "<string moodType>"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)		
	if (table.HasValue(PLUGIN.PersonalityTypes, arguments[1])) then
		player:SetSharedVar("emoteMood", arguments[1])
	else
		Clockwork.player:Notify(player, "That is not a valid mood!")
	end
end

COMMAND:Register();

if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Set Mood", nil, "Mood", PLUGIN.PersonalityTypes)
end