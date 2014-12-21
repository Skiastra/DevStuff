local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

Clockwork.config:Add("minimum_voicedesc", 32, true);
Clockwork.config:Add("voiceremovedur", 3, true)
--[[
--Called to edit the detailed description of a character.
Clockwork.datastream:Hook("EditDetaDesc", function(data)
	if (data) then
	print("nigga")
		local player = Clockwork.player:FindByID( data[1] )
		player:SetCharacterData("DetailDesc", data[2]);
	end;
end);
]]--
function PLUGIN:KeyPress(ply, char)
	if (char == IN_USE) then
		local trace = ply:GetEyeTraceNoCursor();
		local target = Clockwork.entity:GetPlayer(trace.Entity);
		if target then
			ply:RunClockworkCmd("CharExamine")
		end;
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("VoiceDesc", player:GetCharacterData("VoiceDesc"));
end;

--Sets the voice desc to stay for a few seconds after the player stops typing.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	if (player:GetNWBool("showvoice", true)) then
		if (!player.removeVoice) then
			player.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
		end;
		if (curTime > player.removeVoice) then
			player:SetNWBool("showvoice", false);
		end;
	end;
end;

--Forces a player without a voiceDesc to make one.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local voiceDesc = player:GetCharacterData("VoiceDesc")
	player:SetSharedVar("VoiceDesc", voiceDesc or "");
	if (!voiceDesc or voiceDesc == "" or voiceDesc == " ") then
		player:RunClockworkCmd("CharVoiceDesc");
	end;
end;

-- A function to add a character to the character screen.
function PLUGIN:PlayerAdjustCharacterScreenInfo(player, character, info)
	if (character.data["VoiceDesc"]) then
		if (string.len(character.data["VoiceDesc"]) > 64) then
			info.voice = string.sub(character.data["VoiceDesc"], 1, 64).."...";
		else
			info.voice = character.data["VoiceDesc"];
		end;
	end;
end;