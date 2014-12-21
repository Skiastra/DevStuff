--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("accessory_base");
ITEM.name = "Motion Scanner";
ITEM.cost = 2000;
ITEM.model = "models/gibs/shield_scanner_gib1.mdl";
ITEM.weight = 1.5;
ITEM.category = "Tools";
ITEM.business = true;
ITEM.description = "A device that allows you to sense the movements of others.";

-- Called when a player wears the accessory.
function ITEM:OnWearAccessory(player, bIsWearing)
	if (bIsWearing) then
		player:SetSharedVar("implant", true);
	else
		player:SetSharedVar("implant", false);
	end;
end;

ITEM:Register();