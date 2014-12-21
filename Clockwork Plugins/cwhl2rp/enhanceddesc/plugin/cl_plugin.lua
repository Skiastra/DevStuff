local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:AddToSystem("Minimum voice description length", "minimum_voicedesc", "The minimum amount of characters a player must have in their voice description.", 0, 128);
Clockwork.config:AddToSystem("VoiceDescription Show Duration", "voiceremovedur", "The amount of seconds that the voice description shows after an IC message is sent.", 0, 10)

--Called to edit the detailed description.
Clockwork.datastream:Hook("EditDetDesc", function(data)
	if (IsValid( data[1] )) then
		if (PLUGIN.editdescPanel and PLUGIN.editdescPanel:IsValid()) then
			PLUGIN.editdescPanel:Close();
			PLUGIN.editdescPanel:Remove();
		end;
		
		PLUGIN.editdescPanel = vgui.Create("cwDetDesc");
		PLUGIN.editdescPanel:Populate(data[1], data[2], data[3]);
		print(data[3])
		PLUGIN.editdescPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

--Called to view the detailed description.
Clockwork.datastream:Hook("ViewDetDesc", function(data)
	if (IsValid(data[1])) then
		if (IsValid(PLUGIN.viewdescPanel)) then
			PLUGIN.viewdescPanel:Close();
			PLUGIN.viewdescPanel:Remove();
		end;

		PLUGIN.viewdescPanel = vgui.Create("cwViewDetDesc");
		PLUGIN.viewdescPanel:Populate(data[1], data[2], data[3]);
		print(data[3])
		PLUGIN.viewdescPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

-- A function to decode a message.
function Clockwork.chatBox:Decode(speaker, name, text, data, class, multiplier)
	local filtered = nil;
	local filter = nil;
	local icon = nil;
	
	if (!IsValid(Clockwork.Client)) then
		return;
	end;
	
	if (self.classes[class]) then
		filter = self.classes[class].filter;
	elseif (class == "pm" or class == "ooc"
	or class == "roll" or class == "looc"
	or class == "priv") then
		filtered = (CW_CONVAR_SHOWOOC:GetInt() == 0);
		filter = "ooc";
	else
		filtered = (CW_CONVAR_SHOWIC:GetInt() == 0);
		filter = "ic";
	end;
	
	text = Clockwork.kernel:Replace(text, " ' ", "'");
	
	if (IsValid(speaker)) then
		if (!Clockwork.kernel:IsChoosingCharacter()) then
			if (speaker:Name() != "") then
				local unrecognised = false;
				local classIndex = speaker:Team();
				local classColor = cwTeam.GetColor(classIndex);
				local focusedOn = false;
				
				if (speaker:IsSuperAdmin()) then
					icon = "icon16/shield.png";
				elseif (speaker:IsAdmin()) then
					icon = "icon16/star.png";
				elseif (speaker:IsUserGroup("operator")) then
					icon = "icon16/emoticon_smile.png";
				else
					local faction = speaker:GetFaction();
					
					if (faction and Clockwork.faction.stored[faction]) then
						if (Clockwork.faction.stored[faction].whitelist) then
							icon = "icon16/add.png";
						end;
					end;
					
					if (!icon) then
						icon = "icon16/user.png";
					end;
				end;
				
				if (!Clockwork.player:DoesRecognise(speaker, RECOGNISE_TOTAL) and filter == "ic") then
					unrecognised = true;
				end;
				
				local trace = Clockwork.player:GetRealTrace(Clockwork.Client);
				
				if (trace and trace.Entity and IsValid(trace.Entity) and trace.Entity == speaker) then
					focusedOn = true;
				end;
				
				local info = {
					unrecognised = unrecognised,
					shouldHear = Clockwork.player:CanHearPlayer(Clockwork.Client, speaker),
					multiplier = multiplier,
					focusedOn = focusedOn,
					filtered = filtered,
					speaker = speaker,
					visible = true;
					filter = filter,
					class = class,
					icon = icon,
					name = name,
					text = text,
					data = data
				};
				
				Clockwork.plugin:Call("ChatBoxAdjustInfo", info);
				Clockwork.chatBox:SetMultiplier(info.multiplier);
				
				if (info.visible) then
					if (info.filter == "ic") then
						if (!Clockwork.Client:Alive()) then
							return;
						end;
					end;
					
					if (info.unrecognised) then
						local unrecognisedName, usedPhysDesc = PLUGIN:GetUnrecognisedName(info.speaker);
						if (info.class == "me" and !string.find(info.text, "\"")) then
							unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(info.speaker);
						end;
						if (usedPhysDesc and string.len(unrecognisedName) > 24) then
							unrecognisedName = string.sub(unrecognisedName, 1, 21).."...";
						end;
						
						info.name = "["..unrecognisedName.."]";
					end;
					
					if (self.classes[info.class]) then
						self.classes[info.class].Callback(info);
					elseif (info.class == "radio_eavesdrop") then
						if (info.shouldHear) then
							local color = Color(255, 255, 175, 255);
							
							if (info.focusedOn) then
								color = Color(175, 255, 175, 255);
							end;
							info.speaker:SetNWBool("showvoice", true)
							if (info.speaker.removeVoice) then
								info.speaker.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
							end;
							
							Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." radios in \""..info.text.."\"");
						end;
					elseif (info.class == "whisper") then
						if (info.shouldHear) then
							local color = Color(255, 255, 175, 255);
							
							if (info.focusedOn) then
								color = Color(175, 255, 175, 255);
							end;
							info.speaker:SetNWBool("showvoice", true)
							if (info.speaker.removeVoice) then
								info.speaker.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
							end;
							
							Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." whispers \""..info.text.."\"");
						end;
					elseif (info.class == "event") then
						Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), info.text);
					elseif (info.class == "radio") then
						Clockwork.chatBox:Add(info.filtered, nil, Color(75, 150, 50, 255), info.name.." radios in \""..info.text.."\"");
						info.speaker:SetNWBool("showvoice", true)
						if (info.speaker.removeVoice) then
							info.speaker.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
						end;
					elseif (info.class == "yell") then
						local color = Color(255, 255, 175, 255);
						
						if (info.focusedOn) then
							color = Color(175, 255, 175, 255);
						end;
						info.speaker:SetNWBool("showvoice", true)
						if (info.speaker.removeVoice) then
							info.speaker.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
						end;
						Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." yells \""..info.text.."\"");
					elseif (info.class == "chat") then
						Clockwork.chatBox:Add(info.filtered, nil, classColor, info.name, ": ", info.text, nil, info.filtered);
					elseif (info.class == "looc") then
						Clockwork.chatBox:Add(info.filtered, nil, Color(225, 50, 50, 255), "[LOOC] ", Color(255, 255, 150, 255), info.name..": "..info.text);
					elseif (info.class == "priv") then
						Clockwork.chatBox:Add(info.filtered, nil, Color(255, 200, 50, 255), "@"..info.data.userGroup.." ", classColor, info.name, ": ", info.text);
					elseif (info.class == "roll") then
						if (info.shouldHear) then
							Clockwork.chatBox:Add(info.filtered, nil, Color(150, 75, 75, 255), "** "..info.name.." "..info.text);
						end;
					elseif (info.class == "ooc") then
						Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", classColor, info.name, ": ", info.text);
					elseif (info.class == "pm") then
						Clockwork.chatBox:Add(info.filtered, nil, "[PM] ", Color(125, 150, 75, 255), info.name..": "..info.text);
						surface.PlaySound("hl1/fvox/bell.wav");
					elseif (info.class == "me") then
						local color = Color(255, 255, 175, 255);
						
						if (info.focusedOn) then
							color = Color(175, 255, 175, 255);
						end;
						
						if (string.sub(info.text, 1, 1) == "'") then
							Clockwork.chatBox:Add(info.filtered, nil, color, "** "..info.name..info.text);
						else
							Clockwork.chatBox:Add(info.filtered, nil, color, "** "..info.name.." "..info.text);
						end;
					elseif (info.class == "it") then
						local color = Color(255, 255, 175, 255);
						
						if (info.focusedOn) then
							color = Color(175, 255, 175, 255);
						end;
						
						Clockwork.chatBox:Add(info.filtered, nil, color, "** "..info.text);
					elseif (info.class == "ic") then
						if (info.shouldHear) then
							local color = Color(255, 255, 150, 255);
							
							if (info.focusedOn) then
								color = Color(175, 255, 150, 255);
							end;
							info.speaker:SetNWBool("showvoice", true)
							if (info.speaker.removeVoice) then
								info.speaker.removeVoice = curTime + Clockwork.config:Get("voiceremovedur"):Get();
							end;
							
							Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." says \""..info.text.."\"");
						end;
					end;
				end;
			end;
		end;
	else
		if (name == "Console" and class == "chat") then
			icon = "icon16/shield.png";
		end;
		
		local info = {
			multiplier = multiplier,
			filtered = filtered,
			visible = true;
			filter = filter,
			class = class,
			icon = icon,
			name = name,
			text = text,
			data = data
		};
		
		Clockwork.plugin:Call("ChatBoxAdjustInfo", info);
		Clockwork.chatBox:SetMultiplier(info.multiplier);
		
		if (!info.visible) then return; end;
		
		if (self.classes[info.class]) then
			self.classes[info.class].Callback(info);
		elseif (info.class == "notify_all") then
			if (Clockwork.kernel:GetNoticePanel()) then
				Clockwork.kernel:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
			end;
			
			local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
			
			if (string.sub(info.text, -1) == "!") then
				Clockwork.chatBox:Add(filtered, "icon16/error.png", Color(200, 175, 200, 255), info.text);
			else
				Clockwork.chatBox:Add(filtered, "icon16/comment.png", Color(125, 150, 175, 255), info.text);
			end;
		elseif (info.class == "disconnect") then
			local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
			
			Clockwork.chatBox:Add(filtered, "icon16/user_delete.png", Color(200, 150, 200, 255), info.text);
		elseif (info.class == "notify") then
			if (Clockwork.kernel:GetNoticePanel()) then
				Clockwork.kernel:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
			end;
			
			local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
			
			if (string.sub(info.text, -1) == "!") then
				Clockwork.chatBox:Add(filtered, "icon16/error.png", Color(200, 175, 200, 255), info.text);
			else
				Clockwork.chatBox:Add(filtered, "icon16/comment.png", Color(175, 200, 255, 255), info.text);
			end;
		elseif (info.class == "connect") then
			local filtered = (CW_CONVAR_SHOWAURA:GetInt() == 0) or info.filtered;
			Clockwork.chatBox:Add(filtered, "icon16/user_add.png", Color(150, 150, 200, 255), info.text);
		elseif (info.class == "chat") then
			Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", Color(150, 150, 150, 255), name, ": ", info.text);
		else
			local yellowColor = Color(255, 255, 150, 255);
			local blueColor = Color(125, 150, 175, 255);
			local redColor = Color(200, 25, 25, 255);
			local filtered = (CW_CONVAR_SHOWSERVER:GetInt() == 0) or info.filtered;
			local prefix;
			
			Clockwork.chatBox:Add(filtered, nil, yellowColor, info.text);
		end;
	end;
end;


-- A function to get a player's unrecognised name.
function PLUGIN:GetUnrecognisedName(player)
	local unrecognisedVoiceDesc = PLUGIN:GetVoiceDesc(player);
	local unrecognisedVoice = Clockwork.config:Get("unrecognised_name"):Get();
	local usedVoiceDesc;
	
	if (unrecognisedVoiceDesc) then
		unrecognisedVoice = unrecognisedVoiceDesc;
		usedVoiceDesc = true;
	end;
	
	return unrecognisedVoice, usedVoiceDesc;
end;

-- A function to get a player's voice description.
function PLUGIN:GetVoiceDesc(player)
	if (!player) then
		player = Clockwork.Client;
	end;
	
	local voiceDesc = player:GetSharedVar("VoiceDesc");
	local team = player:Team();
	
	if (voiceDesc == "") then
		voiceDesc = Clockwork.class:Query(team, "defaultVoiceDesc", "");
	end;
	
	if (voiceDesc == "") then
		voiceDesc = Clockwork.config:Get("default_voicedesc"):Get();
	end;
	
	if (!voiceDesc or voiceDesc == "") then
		voiceDesc = "This character has no voice description set.";
	else
		voiceDesc = PLUGIN:ModifyVoiceDesc(voiceDesc);
	end;

	return voiceDesc;
end;