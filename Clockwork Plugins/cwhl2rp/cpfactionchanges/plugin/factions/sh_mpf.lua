local FACTION = Clockwork.faction:FindByID("Metropolice Force")

FACTION.models = {
	female = {
		"models/humans/group01/female_01.mdl",
		"models/humans/group01/female_02.mdl",
		"models/humans/group01/female_03.mdl",
		"models/humans/group01/female_04.mdl",
		"models/humans/group01/female_05.mdl",
		"models/humans/group01/female_06.mdl",
		"models/humans/group01/female_07.mdl",
	},
	male = {
		"models/humans/group01/male_01.mdl",
		"models/humans/group01/male_02.mdl",
		"models/humans/group01/male_03.mdl",
		"models/humans/group01/male_04.mdl",
		"models/humans/group01/male_05.mdl",
		"models/humans/group01/male_06.mdl",
		"models/humans/group01/male_07.mdl",
		"models/humans/group01/male_08.mdl",
		"models/humans/group01/male_09.mdl",
	}
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "CP.RCT-R1."..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5);
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA) then
		if (name) then
			Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d%d%d)", "CP.RCT-R1.%1"), true);
		else
			return false, "You need to specify a name as the third argument!";
		end;
	else
		Clockwork.player:SetName( player, self:GetName( player, player:GetCharacter() ) );
	end;
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
end