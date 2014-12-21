local PLUGIN = PLUGIN;

-- Called when the voice descript should be drawn.
function PLUGIN:DrawTargetPlayerStatus(target, alpha, x, y)
	local informationColor = Clockwork.option:GetColor("information");
	if (target:GetSharedVar("Typing") == TYPING_NORMAL or target:GetSharedVar("Typing") == TYPING_WHISPER
	or target:GetSharedVar("Typing") == TYPING_RADIO or target:GetSharedVar("Typing") == TYPING_YELL 
	or (target:GetNWBool("showvoice", true)) or Clockwork.player:DoesRecognise(target, RECOGNISE_TOTAL)) then
		local VoiceDesc = target:GetSharedVar("VoiceDesc");
		if (VoiceDesc != "") then
			if (Clockwork.player:DoesRecognise(target, RECOGNISE_TOTAL)) then
				y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(VoiceDesc), x , y + 90, informationColor, alpha);
			else
				y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(VoiceDesc), x , y + 70, informationColor, alpha);
			end;
		end;
	end;
end;