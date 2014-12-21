local COMMAND = Clockwork.command:FindByID("Dispatch");

function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		local name = player:GetName();
		
		if (string.find(name, "SCN") or string.find(name, "C2") or
		string.find(name, "C1") or string.find(name, "H1") or 
		string.find(name, "H2") or string.find(name, "N3") or 
		player:GetFaction() == FACTION_OTA) then
		
			local text = table.concat(arguments, " ");
			
			if (text == "") then
				Clockwork.player:Notify(player, "You did not specify enough text!");
				
				return;
			end;
			
			Schema:SayDispatch(player, text);
		else
			Clockwork.player:Notify(player, "You are not ranked high enough to use this command!");
		end;
	else
		Clockwork.player:Notify(player, "You are not the Combine!");
	end;
end;