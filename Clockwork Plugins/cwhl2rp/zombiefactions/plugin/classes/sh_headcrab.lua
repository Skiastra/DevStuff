local CLASS = Clockwork.class:New("Headcrab");

CLASS.color = Color(255, 140, 0, 255);
CLASS.factions = {FACTION_CRAB};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "An parasitic race not from this planet.";
CLASS.defaultPhysDesc = "A small creature with pincers.";
	
CLASS_CRAB = CLASS:Register();