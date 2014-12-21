local CLASS = Clockwork.class:New("Zombie");

CLASS.color = Color(255, 140, 0, 255);
CLASS.factions = {FACTION_ZOMB};
CLASS.isDefault = true;
CLASS.wagesName = "Supplies";
CLASS.description = "An infected human.";
CLASS.defaultPhysDesc = "A decaying corpse that still walks.";
	
CLASS_ZOMB = CLASS:Register();