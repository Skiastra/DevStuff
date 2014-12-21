local PLUGIN = PLUGIN;

function PLUGIN:LoadFirepots()
	local firepots = Clockwork.kernel:RestoreSchemaData( "plugins/firepots/"..game.GetMap() );
	
	for k, v in pairs(firepots) do
		local entity = ents.Create("cw_firepot");
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
	end;
end;

function PLUGIN:SaveFirepots()
	local firepots = {};
	
	for k, v in pairs(ents.FindByClass("cw_firepot")) do
		firepots[#firepots + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID")
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/firepots/"..game.GetMap(), firepots);
end;