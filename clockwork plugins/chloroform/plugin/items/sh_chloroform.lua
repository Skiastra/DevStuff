local ITEM = Clockwork.item:New();
ITEM.name = "Chloroform Rag";
ITEM.cost = 100;
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
ITEM.batch = 1;
ITEM.weight = 0.1;
ITEM.access = "q";
ITEM.useText = "Knock Out";
ITEM.business = true;
ITEM.description = "A rag with chloroform on it. Once used on a person and inhaled, they will be rendered unconscious for a short amount of time.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player.isChloroforming) then
		Clockwork.player:Notify(player, "You are already chloroforming a character!");
			
		return false;
	else
		local trace = player:GetEyeTraceNoCursor();
		if (trace.Entity and trance.Entity:IsValid()) then
			local target = Clockwork.entity:GetPlayer(trace.Entity);
		else
			return false
		end;
			
		if (target and target:Alive()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				local canChloroform = (target:GetAimVector():DotProduct(player:GetAimVector()) > 0);
				local chloroformTime = Schema:GetDexterityTime(player);
					
				if (canChloroform or target:IsRagdolled()) then
					Clockwork.player:SetAction(player, "chloroform", chloroformTime);
						
					target:SetSharedVar("beingChloro", true);
						
					Clockwork.player:EntityConditionTimer(player, target, trace.Entity, chloroformTime, 192, function()
						local canChloroform = (target:GetAimVector():DotProduct(player:GetAimVector()) > 0);
							
						if ((canChloroform or target:IsRagdolled()) and player:Alive() and !player:IsRagdolled()) then
							return true;
						end;
					end, function(success)
						if (success) then
							player.isChloroforming = nil;
								
							Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, 60);
								
							player:TakeItem(self);
							player:ProgressAttribute(ATB_DEXTERITY, 15, true);
						else
							player.isChloroforming = nil;
						end;
							
						Clockwork.player:SetAction(player, "chloroform", false);
							
						if (IsValid(target)) then
							target:SetSharedVar("beingChloro", false);
						end;
					end);
				else
					Clockwork.player:Notify(player, "You cannot use chloroform on characters that are facing you!");
					
					return false;
				end;
					
				Clockwork.player:SetMenuOpen(player, false);
					
				player.isChloroforming = true;
				
				return false;
			else
				Clockwork.player:Notify(player, "This character is too far away!");
					
				return false;
			end;
		else
			Clockwork.player:Notify(player, "That is not a valid character!");
			
			return false;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;
ITEM:Register();