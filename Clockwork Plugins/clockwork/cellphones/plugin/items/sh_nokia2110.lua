local ITEM = Clockwork.item:New();
ITEM.name = "Nokia 2110";
ITEM.cost = 15;
ITEM.uniqueID = "nokia";
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl";
ITEM.weight = 0.8;
ITEM.access = "1";
ITEM.category = "Cellphone";
ITEM.business = true;
ITEM.description = "It is a small phone that resembles a radio, the brand Nokia is on it.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();