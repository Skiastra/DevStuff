local ITEM = Clockwork.item:New();
ITEM.name = "Can of Heroin Syringes";
ITEM.cost = 10;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.useText = "Take";
ITEM.category = "Drugs";
ITEM.business = true;
ITEM.description = "A small can of Heroin syringes.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity) end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();