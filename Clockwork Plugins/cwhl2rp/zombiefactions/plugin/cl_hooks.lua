local PLUGIN = PLUGIN;

-- Called when a player's typing display position is needed.
function PLUGIN:GetPlayerTypingDisplayPosition(player)
	if (PLUGIN:PlayerIsHeadcrab(player)) then
		local curTime = CurTime();	
		return player:GetPos() + Vector(0, 0, 30);
	elseif (PLUGIN:PlayerIsZombie(player)) then
		local curTime = CurTime();
		return player:GetPos() + Vector(0, 0, 75);
	end;
end;

function PLUGIN:RenderScreenspaceEffects()
	if (PLUGIN:PlayerIsZombie(Clockwork.Client) or PLUGIN:PlayerIsHeadcrab(Clockwork.Client)) then
		local colormod = {}		
		colormod[ "$pp_colour_contrast" ] = 1.5
		colormod[ "$pp_colour_addr" ] = 255 / 2550
		colormod[ "$pp_colour_addg" ] = 70 / 2550
		colormod[ "$pp_colour_addb" ] = 70 / 2550
		if (Clockwork.Client:GetNetworkedVar("GhostMode", true)) then
			colormod[ "$pp_colour_contrast" ] = 1.5
			colormod[ "$pp_colour_addr" ] = 0 / 2550
			colormod[ "$pp_colour_addg" ] = 230 / 2550
			colormod[ "$pp_colour_addb" ] = 255 / 2550
		end;
		DrawColorModify(colormod)
		
		for k, v in ipairs( ents.FindInSphere(Clockwork.Client:GetPos(),1000) ) do
			if (v:IsValid() and v:IsPlayer() and v:GetMoveType()==MOVETYPE_WALK 
			and !self:PlayerIsHeadcrab(v) and !self:PlayerIsZombie(v)) then
				halo.Add( { v }, Color( 0, 200, 255 ), 1, 1, 2, true, true)
			end;
		end;
		for k, v in ipairs( _player.GetAll() ) do
			if (v:IsValid() and v:IsPlayer() and v:GetMoveType()==MOVETYPE_WALK
			and (self:PlayerIsHeadcrab(v) or self:PlayerIsZombie(v))) then
				halo.Add( { v } , Color( 255, 200, 0 ), 1, 1, 2, true, true)
			end;
		end;
	end;
end;