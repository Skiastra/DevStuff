include("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self.fireSize = 50;
	self.nextFlicker = 0;
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;

-- Called when the entity should think.
function ENT:Think()
	local curTime = CurTime();
    local dlight = DynamicLight( self:EntIndex() );
	
	if (!self.nextFlicker) then
		self.nextFlicker = curTime + math.random(0.1, 0.15);
	end;
	
	if ( dlight ) then
		local r, g, b, a = self:GetColor();
		dlight.Pos = self:GetPos();
		dlight.r = 255;
		dlight.g = 100;
		dlight.b = 50;
		dlight.Brightness = 1;
		dlight.Size = self.fireSize * 15;
		dlight.Decay = 5;
		dlight.DieTime = CurTime() + 0.1;
		self:Flicker();
	end;
end;

function ENT:Flicker()
	local curTime = CurTime();
	
	if (curTime >= self.nextFlicker) then
		self.fireSize = math.random(35, 50);
		self.nextFlicker = nil;
	end;
end;