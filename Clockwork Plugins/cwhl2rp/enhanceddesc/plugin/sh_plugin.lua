local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- A function to modify a voice description.
function PLUGIN:ModifyVoiceDesc(description)
	if (string.len(description) <= 128) then
		if (!string.find(string.sub(description, -2), "%p")) then
			return description..".";
		else
			return description;
		end;
	else
		return string.sub(description, 1, 125).."...";
	end;
end;