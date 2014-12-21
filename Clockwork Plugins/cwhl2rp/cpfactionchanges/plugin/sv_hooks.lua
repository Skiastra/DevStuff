local PLUGIN = PLUGIN;

local Clockwork = Clockwork;

-- Called when a player's name has changed.
function Schema:PlayerNameChanged(player, previousName, newName)
	if (Schema:PlayerIsCombine(player)) then
		local faction = player:GetFaction();
		
		if (!string.find(previousName, "C1") and string.find(newName, "C1")) then
			Clockwork.class:Set(player, CLASS_EMP);
		elseif (!string.find(previousName, "C2") and string.find(newName, "C2")) then
			Clockwork.class:Set(player, CLASS_EMP);
		elseif (!string.find(previousName, "H1") and string.find(newName, "H1")) then
			Clockwork.class:Set(player, CLASS_EMP);	
		elseif (!string.find(previousName, "H2") and string.find(newName, "H2")) then
			Clockwork.class:Set(player, CLASS_EMP);
		elseif (!string.find(previousName, "N3") and string.find(newName, "N3")) then
			Clockwork.class:Set(player, CLASS_EMP);
		end;
	end;
end;

-- Called when a player's character has initialized.
function Schema:PlayerCharacterInitialized(player)
	local faction = player:GetFaction();
	
	if (Schema:PlayerIsCombine(player)) then
		local name = player:GetName();
		
		if (string.find(name, "C1") or string.find(name, "C2")
		or string.find(name, "H1") or string.find(name, "H2")
		or string.find(name, "N3")) then
			Clockwork.class:Set(player, CLASS_EMP);
		end		
		
	elseif (faction == FACTION_CITIZEN) then
		Schema:AddCombineDisplayLine( "Rebuilding citizen manifest...", Color(255, 100, 255, 255) );
	end;
end;

-- Called when a player's typing display has started.
function Schema:PlayerStartTypingDisplay(player, code)
	if (Schema:PlayerIsCombine(player) and !player:IsNoClipping()) then
		if (code == "n" or code == "y" or code == "w" or code == "r") then
			if (!player.typingBeep) then
				player.typingBeep = true;
			end;
		end;
	end;
end;

-- Called when a player's typing display has finished.
function Schema:PlayerFinishTypingDisplay(player, textTyped)
	if (Schema:PlayerIsCombine(player) and textTyped) then
		if (player.typingBeep) then
		end;
	end;
	
	player.typingBeep = nil;
end;