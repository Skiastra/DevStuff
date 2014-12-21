local PLUGIN = PLUGIN;

-- A function to check if a player is Zombie.
function PLUGIN:PlayerIsZombie(player)
	if (IsValid(player) and player:GetCharacter()) then
		local faction = player:GetFaction();
		
		if (PLUGIN:IsZombieFaction(faction)) then
			return true;
		else
			return false;
		end;
	end;
end;

--Checks if a ghost can see a player.
function PLUGIN:GhostCanSee(ply)
	local isTrue = false
	for k, v in ipairs(_player.GetAll()) do
		if (v:IsValid() and Clockwork.player:CanSeePlayer(ply, v)) then
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

-- A function to check if a player is Headcrab.
function PLUGIN:PlayerIsHeadcrab(player)
	if (IsValid(player) and player:GetCharacter()) then
		local faction = player:GetFaction();
		
		if (PLUGIN:IsHeadcrabFaction(faction)) then
			return true;
		else
			return false;
		end;
	end;
end;

--A function that toggles a character into ghost mode.
function PLUGIN:ToggleGhost(ply)
	if (ply:GetNetworkedVar("GhostMode", true)) then
		ply:SetNetworkedVar("GhostMode", false);
		ply:DrawWorldModel(true);
		ply:DrawShadow(true);
		ply:SetNoDraw(false);
		ply:SetSolid(SOLID_VPHYSICS)
		Clockwork.player:Notify(ply, "You have spawned in!");
	else
		local color = ply:GetColor();
		ply:SetNetworkedVar("GhostMode", true)
		ply:DrawWorldModel(false);
		ply:DrawShadow(false);
		ply:SetNoDraw(true);
		ply:SetSolid(SOLID_NONE)
		ply:SetColor(Color(color.r, color.g, color.b, 0));
	end;
end;

--Called every second.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	--Slows down Zombie characters to make the animation look smoother.
	if (PLUGIN:PlayerIsZombie(player) and !player:GetNetworkedVar("GhostMode", true)) then
		if (!infoTable.isJogging) then
			infoTable.walkSpeed = 45
		end;
	--Makes ghostmode characters run sooper fast.
	elseif (player:GetNetworkedVar("GhostMode", true) and (PLUGIN:PlayerIsZombie(player) or PLUGIN:PlayerIsHeadcrab(player))) then
		infoTable.walkSpeed = 700
	end;
	--Fixes headcrabs not playing an animation when walking.
	if (PLUGIN:PlayerIsHeadcrab(player)) then
		if (player:KeyDown(IN_FORWARD) or player:KeyDown(IN_BACK) or player:KeyDown(IN_MOVELEFT)
		or player:KeyDown(IN_MOVERIGHT) and (!player:KeyDown(IN_SPEED) or !infoTable.isJogging)) then
			player:SetForcedAnimation("Run1", 0, nil)
		else
			player:SetForcedAnimation(false);
		end;
	end;
end;

--Called when a ghostmoded player presses reload.
function PLUGIN:KeyPress(ply, char)
	if (char == IN_RELOAD) then
		if (ply:GetNetworkedVar("GhostMode", true)) then
		--[[	local isTrue = false
			local target
			for k, v in ipairs(_player.GetAll()) do
				if (v:IsValid() and Clockwork.player:CanSeePlayer(ply, v)) then
					isTrue = true
					target = v
				end;
			end;
			if (isTrue == true) then
				if (!ply:GetName() == target:GetName()) then
					Clockwork.player:Notify(ply, "You're in sight of a player!");
				else
					PLUGIN:ToggleGhost(ply);
				end;
			else--]]
				PLUGIN:ToggleGhost(ply);
			--end;
		end;
	end;
end;