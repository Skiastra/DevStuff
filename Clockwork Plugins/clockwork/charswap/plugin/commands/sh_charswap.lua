local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharSwap");
COMMAND.tip = "Switch to another character.";
COMMAND.text = "<string char>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
	local characters = player:GetCharacters();
	local failure = true
	for k, v in pairs (characters) do
		if (PLUGIN:IsChar(string.lower(arguments[1]), string.lower(v.name))) then
			if (player:GetName() == v.name) then
				player:Notify("You are already using that character!")
				failure = false
				break;
			else
				local charID = v.characterID
				Clockwork.player:LoadCharacter(player, charID, nil, nil, true);
				failure = false
				break;
			end;			
		end;
	end;
			
	if (failure == true) then
		player:Notify("The character specified could not be found!")
	end;
end;

COMMAND:Register(); 