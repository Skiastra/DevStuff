local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the HUD should be painted.
function cwHeartBeat:HUDPaint()
	local colorWhite = Clockwork.option:GetColor("white");
	local curTime = CurTime();
	local info = {
		alpha = 255 - Clockwork.kernel:GetBlackFadeAlpha(),
		x = ScrW() - 208,
		y = 8
	};
	
	local inventory = Clockwork.inventory:GetClient();

	if (Clockwork.inventory:HasItemByID(inventory, "motion_scanner") and info.alpha > 0) then
		if (Clockwork.Client:GetSharedVar("implant")) then
			local aimVector = Clockwork.Client:GetAimVector();
			local position = Clockwork.Client:GetPos();
			local curTime = UnPredictedCurTime();

			self.heartbeatOverlay:SetFloat("$alpha", math.min(0.5, (info.alpha / 255) * 0.5));
			
			surface.SetDrawColor(255, 255, 255, math.min(150, info.alpha / 2));
				surface.SetMaterial(self.heartbeatOverlay);
			surface.DrawTexturedRect(info.x, info.y, 200, 200);
			
			surface.SetDrawColor(0, 200, 0, info.alpha);
				surface.SetMaterial(self.heartbeatPoint);
			surface.DrawTexturedRect(info.x + 84, info.y + 84, 32, 32);
			
			if (self.heartbeatScan) then
				local scanAlpha = math.min(255 * math.max(self.heartbeatScan.fadeOutTime - curTime, 0), info.alpha);
				local y = self.heartbeatScan.y + ((184 / 255) * (255 - scanAlpha));
				
				if (scanAlpha > 0) then
					surface.SetDrawColor(100, 0, 0, scanAlpha * 0.5);
						surface.SetMaterial(self.heartbeatGradient);
					surface.DrawTexturedRect(self.heartbeatScan.x, y, self.heartbeatScan.width, self.heartbeatScan.height);
				else
					self.heartbeatScan = nil;
				end;
			end;
			
			if (curTime >= self.nextHeartbeatCheck) then
				self.nextHeartbeatCheck = curTime + 1;
				self.oldHeartbeatPoints = self.heartbeatPoints;
				self.heartbeatPoints = {};
				self.heartbeatScan = {
					fadeOutTime = curTime + 1,
					height = 16,
					width = 200,
					y = info.y,
					x = info.x
				};
				
				local centerY = info.y + 100;
				local centerX = info.x + 100;
				
				local closestPoint = nil;
				
				for k, v in ipairs(ents.FindInSphere(position, 768)) do
					if ((v:IsPlayer() and v:Alive() and v:HasInitialized()) or string.find(v:GetClass(), "npc_")) then
						if (Clockwork.Client != v and !Clockwork.player:IsNoClipping(v) and v:GetVelocity() != Vector(0, 0, 0)) then
							local playerPosition = v:GetPos();
							local difference = playerPosition - position;
							local pointX = (difference.x / 768);
							local pointY = (difference.y / 768);
							local pointZ = math.sqrt(pointX * pointX + pointY * pointY);
							local color = Color(255, 0, 0, 255);
							local phi = math.rad(math.deg(math.atan2(pointX, pointY)) - math.deg(math.atan2(aimVector.x, aimVector.y)) - 90);
							pointX = math.cos(phi) * pointZ;
							pointY = math.sin(phi) * pointZ;
								
							if (v:IsPlayer()) then
								if (!v:Crouching()) then
									color = Color(0, 150, 255, 255);
								else
									return false
								end
							end;
							
							--[[
							print(closestPoint)
							if (closestPoint == nil) then
								closestPoint = difference
							elseif 
								difference:Distance(closestPoint)
							end;
							print(closestPoint)
							]]--
							self.heartbeatPoints[#self.heartbeatPoints + 1] = {
								fadeInTime = curTime + 1,
								height = 32,
								width = 32,
								color = color,
								x = centerX + (pointX * 100) - 16,
								y = centerY + (pointY * 100) - 16
							};
						end;
					end;
				end;
				
				for k, v in ipairs(self.oldHeartbeatPoints) do
					v.fadeOutTime = curTime + 1;
					v.fadeInTime = nil;
				end;
				
				self.lastHeartbeatAmount = #self.heartbeatPoints;
				Clockwork.Client:EmitSound("ui/buttonrollover.wav", 30);
				--, math.Clamp(closestPoint, 100, 255)			
			end;
			
			for k, v in ipairs(self.oldHeartbeatPoints) do
				local pointAlpha;
				
				if (v.fadeOutTime) then
					pointAlpha = 255 * math.max(v.fadeOutTime - curTime, 0);
				else
					pointAlpha = 255
				end;
				
				local pointX = math.Clamp(v.x, info.x, (info.x + 200) - 32);
				local pointY = math.Clamp(v.y, info.y, (info.y + 200) - 32);
				
				surface.SetDrawColor(v.color.r, v.color.g, v.color.b, math.min(pointAlpha, info.alpha));
					surface.SetMaterial(self.heartbeatPoint);
				surface.DrawTexturedRect(pointX, pointY, v.width, v.height);
			end;
			
			for k, v in ipairs(self.heartbeatPoints) do
				local pointAlpha = 255 - (255 * math.max(v.fadeInTime - curTime, 0));
				local pointX = math.Clamp(v.x, info.x, (info.x + 200) - 32);
				local pointY = math.Clamp(v.y, info.y, (info.y + 200) - 32);
				
				surface.SetDrawColor(v.color.r, v.color.g, v.color.b, math.min(pointAlpha, info.alpha));
					surface.SetMaterial(self.heartbeatPoint);
				surface.DrawTexturedRect(pointX, pointY, v.width, v.height);
												
			end;		
						
			info.y = info.y + 212;
		end;
	end;
end;