include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_c17/metalPot001a.mdl") ;
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then
		phys:Wake();
		phys:EnableMotion(true);
	end;
	self:startFire();
end;

function ENT:OnRemove()
	self:stopFire();
end;

function ENT:startFire()
--	self:SetNWBool("lit", true")
	self:Ignite(1);
	timer.Create( tostring(self:GetCreationID()), 1, 0,
	function()
		self:Ignite(1);
	end);
end;

function ENT:stopFire()
--	self:SetNWBool("lit", false")
	timer.Destroy( tostring(self:GetCreationID()) )
	self:Extinguish();
end;