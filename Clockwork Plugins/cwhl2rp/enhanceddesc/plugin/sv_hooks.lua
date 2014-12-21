local PLUGIN = PLUGIN;

util.AddNetworkString("descSend")

function PLUGIN:Tick()
	net.Receive("descSend", function()
		local StringTable = util.JSONToTable(net.ReadString())
		local player = Clockwork.player:FindByID(StringTable.name)
		if (player) then
			player:SetCharacterData("DetailDesc", StringTable.desc);
			player:SetCharacterData("PictureDesc", StringTable.sendlink)
		end;
	end)
end;

function PLUGIN:PlayerAdjustCharacterCreationInfo(player, info, data)
	info.data["VoiceDesc"] = data.voiceDesc;
end;