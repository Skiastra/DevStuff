--[[
	© 2012 Slidefuse LLC
	This plugin is released under the MIT license. Do whatever!
--]]

local PLUGIN = PLUGIN

-- A function to calculate a player's activity.
function PLUGIN:CalcMainActivity(player, velocity)
	if (self:GetPlayerMood(player) and self:GetPlayerMood(player) != "Default") then

		local mood = self:GetPlayerMood(player)
		local moodTable = self.LookupTable[mood]
		local model = player:GetModel()	
		
		player.CalcIdeal = Clockwork.animation:GetForModel(model, "stand_idle")
		player.CalcSeqOverride = -1
		
		if (!Clockwork:HandlePlayerDriving(player)
		and !Clockwork:HandlePlayerJumping(player)
		and !Clockwork:HandlePlayerDucking(player, velocity)
		and !Clockwork:HandlePlayerSwimming(player)) then
		
			if (velocity:Length2D() < 0.5) then
				player.CalcSeqOverride = moodTable["idle"];
			elseif (velocity:Length2D() >= 0.5 and !player:IsJogging() and !player:IsRunning()) then
				if (moodTable["walk"] != nil) then
					player.CalcSeqOverride = moodTable["walk"];
				end;
			end;
		end;

		if (player.CalcSeqOverride != -1) then
			player.CalcSeqOverride = player:LookupSequence(player.CalcSeqOverride);
		--	player.CalcIdeal = player:LookupSequence(player.CalcIdeal);
			print(player.CalcIdeal)
			print(player.CalcSeqOverride)
			return player.CalcIdeal, player.CalcSeqOverride;
		end;
	end;

end;