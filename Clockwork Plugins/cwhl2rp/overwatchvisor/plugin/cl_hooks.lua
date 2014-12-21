local PLUGIN = PLUGIN;

function PLUGIN:RenderScreenspaceEffects()
	if (!Clockwork.kernel:IsScreenFadedBlack()) then		
		if (Clockwork.Client:GetFaction() == "Overwatch Transhuman Arm") then
			render.UpdateScreenEffectTexture();
			
			Schema.combineOverlay = Material("overwatchvisor/combine_tactview");
			Schema.combineOverlay:SetFloat("$refractamount", 0.3);
			Schema.combineOverlay:SetFloat("$envmaptint", 0);
			Schema.combineOverlay:SetFloat("$envmap", 0);
			Schema.combineOverlay:SetFloat("$alpha", 1);
			Schema.combineOverlay:SetInt("$ignorez", 1);
		
			render.SetMaterial(Schema.combineOverlay);
			render.DrawScreenQuad();
		end;
	end;
end;