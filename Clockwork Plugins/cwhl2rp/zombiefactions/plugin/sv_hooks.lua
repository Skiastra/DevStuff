local PLUGIN = PLUGIN;

-- A function to emit the sounds.
function PLUGIN:EmitRandomNoise(player)
	if (player:GetNetworkedVar("GhostMode", true)) then return false end
	local randomSounds = {
		"npc/headcrab/idle1.wav",
		"npc/headcrab/idle2.wav",
		"npc/headcrab/idle3.wav",
		"npc/headcrab/pain1.wav",
		"npc/headcrab/pain2.wav",
		"npc/headcrab/pain3.wav",
		"npc/headcrab/alert1.wav",
	};
	local randomSound = randomSounds[ math.random(1, #randomSounds) ];
	player:EmitSound( randomSound, 60)
end;

-- Enables ghost mode after a zombie or headcrab spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	--Fixes ability to go back into ghostmode by ragdolling.
	if lightSpawn then 
		return false 
	else		
		player:SetNetworkedVar("GhostMode", false)
		--Makes zombie characters go into ghost mode at spawn.
		if (self:PlayerIsHeadcrab(player) or self:PlayerIsZombie(player)) then
			PLUGIN:ToggleGhost(player)
		end;
		
		--Arbiter, can I have your babies and make you sandwiches and stuff? xP
		if self:PlayerIsZombie(player) then
            player:SetBodygroup( 1, 1 );
        end;
	end;
end;

-- Called when a player's death sound should be played.
function PLUGIN:PlayerPlayDeathSound(player, gender)
	local faction = player:GetFaction();
	local crabsound = "npc/headcrab/die"..math.random(1, 2)..".wav";
	local zombiesound = "npc/zombie/zombie_die"..math.random(1, 3)..".wav";
		
	if ( faction == FACTION_ZOMB ) then
		return zombiesound;
	elseif ( faction == FACTION_CRAB ) then
		return crabsound;
	end;
end;

--[[
-- Stops you from colliding with entities in ghost mode. (This is broken :C)
function PLUGIN:ShouldGhostCollide( ent1, ent2 )
	if ( ent1:IsPlayer() or ent2:IsPlayer() ) then
		if (ent1:GetNetworkedVar("GhostMode", true) or ent2:GetNetworkedVar("GhostMode", true)) then
			return false
		end;
	end;
end;
hook.Add( "ShouldCollide", "ShouldGhostCollide", ShouldGhostCollide)
--]]

-- A function to emit the zombie sounds.
function PLUGIN:EmitZombieNoise(player)
	if (player:GetNetworkedVar("GhostMode", true)) then return false end
	local zombieSounds = {
		"npc/zombie/zombie_alert1.wav",
		"npc/zombie/zombie_alert2.wav",
		"npc/zombie/zombie_alert3.wav",
		"npc/zombie/zombie_pain1.wav",
		"npc/zombie/zombie_pain2.wav",
		"npc/zombie/zombie_pain3.wav",
		"npc/zombie/zombie_pain4.wav",
		"npc/zombie/zombie_pain5.wav",
		"npc/zombie/zombie_pain6.wav",
		"npc/zombie/zombie_voice_idle1.wav",
		"npc/zombie/zombie_voice_idle2.wav",
		"npc/zombie/zombie_voice_idle3.wav",
		"npc/zombie/zombie_voice_idle4.wav",
		"npc/zombie/zombie_voice_idle5.wav",
		"npc/zombie/zombie_voice_idle6.wav",
		"npc/zombie/zombie_voice_idle7.wav",
		"npc/zombie/zombie_voice_idle8.wav",
		"npc/zombie/zombie_voice_idle9.wav",
		"npc/zombie/zombie_voice_idle10.wav",
		"npc/zombie/zombie_voice_idle11.wav",
		"npc/zombie/zombie_voice_idle12.wav",
		"npc/zombie/zombie_voice_idle13.wav",
		"npc/zombie/zombie_voice_idle14.wav",
	};
	local zombieSound = zombieSounds[ math.random(1, #zombieSounds) ];
	player:EmitSound( zombieSound, 60)
end;

-- Disables footstep sounds when in ghost mode.
function PLUGIN:PlayerFootstep(player, position, foot, sound, volume, recipientFilter)
	if (player:GetNetworkedVar("GhostMode", true) or self:PlayerIsHeadcrab(player)) then
		return true
	end;
end;

-- Called each tick.
function PLUGIN:Tick()
	for k, v in ipairs( _player.GetAll() ) do
		if (PLUGIN:PlayerIsZombie(v)) then
			local curTime = CurTime();
			
			if (!self.nextChatterEmit) then
				self.nextChatterEmit = curTime + math.random(5, 15);
			end;
			
			if ( (curTime >= self.nextChatterEmit) ) then
				self.nextChatterEmit = nil;
				
				PLUGIN:EmitZombieNoise(v);
			end;
		
		elseif (PLUGIN:PlayerIsHeadcrab(v)) then
			local curTime = CurTime();
			
			if (!self.nextChatterEmit) then
				self.nextChatterEmit = curTime + math.random(5, 15);
			end;
			
			if ( (curTime >= self.nextChatterEmit) ) then
				self.nextChatterEmit = nil;
				
				PLUGIN:EmitRandomNoise(v);
			end;
		end;
	end;
end;

-- Called when a player's pain sound should be played.
function PLUGIN:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (self:PlayerIsZombie(player)) then
		return "npc/zombie/zombie_pain"..math.random(1, 6)..".wav";
	elseif (self:PlayerIsHeadcrab(player)) then
		return "npc/headcrab/pain"..math.random(1, 3)..".wav";
	end;
end;

-- Called when chat box info should be adjusted.
function PLUGIN:ChatBoxAdjustInfo(info)
	if (info.class == "ic" or info.class == "yell" or info.class == "radio" or info.class == "whisper" or info.class == "request") then
		if (IsValid(info.speaker) and info.speaker:HasInitialized()) then
			local playerIsCrab = PLUGIN:PlayerIsHeadcrab(info.speaker);
			
			if (playerIsCrab) then
				for k, v in pairs(PLUGIN.voices.stored.headcrabSounds) do
					if (string.lower(info.text) == string.lower(v.command)) then
						local voice = {
							global = false,
							volume = 80,
							sound = v.sound
						};
						
						if (info.class == "request" or info.class == "radio") then
							voice.global = true;
						elseif (info.class == "whisper") then
							voice.volume = 60;
						elseif (info.class == "yell") then
							voice.volume = 100;
						end;
						
						info.text = v.phrase;
						
						info.voice = voice;
						
						return true;
					end;
				end;
			end;
		end;
	end;
end;