local PLUGIN = PLUGIN;

function PLUGIN:IsChar(arg, char)
	if string.find(char, arg) then
		return true
	end;
end;