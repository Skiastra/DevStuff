local PLUGIN = PLUGIN;

PLUGIN.voices = Clockwork.kernel:NewLibrary("HeadcrabSounds");

PLUGIN.voices.stored = {
	headcrabSounds = {}
};

--Function to add a Headcrab Sound.
function PLUGIN.voices:AddHeadcrab(faction, command, phrase, sound, female, menu)
	self.stored.headcrabSounds[#self.stored.headcrabSounds + 1] = {
		command = command,
		faction = faction,
		phrase = phrase,
		female = female,
		sound = sound,
		menu = menu
	};
end;

--Add the voice commands here.
PLUGIN.voices:AddHeadcrab("Headcrab", "speak1", "*Purrs softly.*", "npc/headcrab/idle1.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "speak2", "*Purrs softly.*", "npc/headcrab/idle2.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "speak3", "*Makes a quiet squishing noise.*", "npc/headcrab/idle3.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "pain1", "*Screams in pain.*", "npc/headcrab/pain1.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "pain2", "*Screams in pain.*", "npc/headcrab/pain2.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "pain3", "*Screams in pain.*", "npc/headcrab/pain3.wav")
PLUGIN.voices:AddHeadcrab("Headcrab", "chitter", "*Makes chittering noises.*", "npc/headcrab/alert1.wav")

if (CLIENT) then
	table.sort(PLUGIN.voices.stored.headcrabSounds, function(a, b) return a.command < b.command; end);
	
	for k, v in pairs(PLUGIN.voices.stored.headcrabSounds) do
		Clockwork.directory:AddCode("Headcrab", [[
			<div class="auraInfoTitle">]]..string.upper(v.command)..[[</div>
			<div class="auraInfoText">]]..v.phrase..[[</div>
		]], true);
	end;
end;