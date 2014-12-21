local ITEM = Clockwork.item:New();
ITEM.name = "PDA";
ITEM.cost = 15;
ITEM.model = "models/gibs/shield_scanner_gib1.mdl";
ITEM.weight = 0.8;
ITEM.access = "1";
ITEM.category = "Communication";
ITEM.factions = {FACTION_MPF};
ITEM.business = true;
ITEM.description = "It looks exactly like a request device, but has extra functionality.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();