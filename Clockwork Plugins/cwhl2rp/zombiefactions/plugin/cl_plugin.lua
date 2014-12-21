local PLUGIN = PLUGIN;

-- A function to get whether a player is Zombie.
function PLUGIN:PlayerIsZombie(player)
	if (!IsValid(player)) then
		return;
	end;
	local faction = player:GetFaction();
	
	if (PLUGIN:IsZombieFaction(faction)) then
		if (faction == FACTION_ZOMB) then
			return true;
		else
			return false;
		end;
	end;
end;

-- A function to get whether a player is Headcrab.
function PLUGIN:PlayerIsHeadcrab(player)
	if (!IsValid(player)) then
		return;
	end;
	local faction = player:GetFaction();
	
	if (PLUGIN:IsHeadcrabFaction(faction)) then
		if (faction == FACTION_CRAB) then
			return true;
		else
			return false;
		end;
	end;
end;

--Disables ability to see IC and LOOC chat when in ghost mode to prevent metagaming.
function PLUGIN:ChatBoxAdjustInfo(info)
	if (Clockwork.Client:GetNetworkedVar("GhostMode", true) 
	and (PLUGIN:PlayerIsHeadcrab(Clockwork.Client) or PLUGIN:PlayerIsZombie(Clockwork.Client))) then
		if (info.class == "ic" or info.class == "me" or info.class == "whisper"
		or info.class == "looc" or info.class == "it" or info.class == "yell") then
			info.visible = false
		end;
	end;
end;

--Checks if a ghost can see a player.
function PLUGIN:GhostCanSee(ply)
	local isTrue = false
	for k, v in ipairs(_player.GetAll()) do
		if (Clockwork.player:CanSeePlayer(ply, v)) then
			isTrue = true
		end;
		if (ply == v) then
			isTrue = false
		end;
	end;
	
	if (isTrue == true) then
		return true
	else
		return false
	end;
end;

--Puts the text on the screen when in ghost mode.
function PLUGIN:HUDPaint()
	if (Clockwork.Client:GetNetworkedVar("GhostMode", true) and (PLUGIN:PlayerIsHeadcrab(Clockwork.Client) or PLUGIN:PlayerIsZombie(Clockwork.Client))) then
		draw.SimpleText("Find a spawn location!", "hl2_ThickArial", ScrW() / 2 - 70, ScrH() - 130, Color(0, 145, 255, 255), TEXT_ALIGN_CENTER)
		
		--Changes text based on ability to spawn.
		if (PLUGIN:GhostCanSee(Clockwork.Client)) then
			draw.SimpleText("You are in sight of a player!", "hl2_ThickArial", ScrW() / 2 - 70, ScrH() - 80, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Press 'RELOAD' to spawn in!", "hl2_ThickArial", ScrW() / 2 - 70, ScrH() - 80, Color(0, 145, 255, 255), TEXT_ALIGN_CENTER)
		end;
	end;
end;
hook.Add("HUDPaint", "GhostModeHUD", HUDPaint);