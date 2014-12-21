local PLUGIN = PLUGIN;

function PLUGIN:PlayerThink(player, curTime, infoTable)
	local model = string.lower(player:GetModel())
	if string.find(model, "vortigaunt") then
		if (player:KeyPressed(IN_JUMP) or !player:IsOnGround()) then
			player:SetForcedAnimation("barnaclecrunch", 0, nil)		
		elseif (!player:GetVelocity() == Vector(0,0,0) and !player:KeyPressed(IN_JUMP) and player:IsOnGround()) then
			player:SetForcedAnimation("Walk_all", 0, nil)
		elseif (player:KeyDown(IN_DUCK) or player:Crouching()) then
			player:SetForcedAnimation("CrouchIdle", 0, nil);
		else
			player:SetForcedAnimation(false)
		end;
	end;
end;