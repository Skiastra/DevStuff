local Clockwork = Clockwork;
local PLUGIN = PLUGIN;
local pairs = pairs;
local RunConsoleCommand = RunConsoleCommand;
local SysTime = SysTime;
local ScrH = ScrH;
local ScrW = ScrW;
local table = table;
local string = string;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local panel = Clockwork.character:GetPanel();
	
	self.categoryList = vgui.Create("DCategoryList", self);
 	self.categoryList:SetPadding(2);
 	self.categoryList:SizeToContents();
	
	self.overrideModel = nil;
	self.bSelectModel = nil;
	self.bPhysDesc = (Clockwork.command:FindByID("CharPhysDesc") != nil);
	self.bVoiceDesc = (Clockwork.command:FindByID("CharVoiceDesc") != nil);
	self.info = Clockwork.character:GetCreationInfo();
	
	if (!Clockwork.faction.stored[self.info.faction].GetModel) then
		self.bSelectModel = true;
	end;
	
	local genderModels = Clockwork.faction.stored[self.info.faction].models[string.lower(self.info.gender)];
	
	if (genderModels and #genderModels == 1) then
		self.bSelectModel = false;
		self.overrideModel = genderModels[1];
		
		if (!panel:FadeInModelPanel(self.overrideModel)) then
			panel:SetModelPanelModel(self.overrideModel);
		end;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		self.nameForm = vgui.Create("DForm", self);
		self.nameForm:SetPadding(4);
		self.nameForm:SetName("Name");
		
		if (Clockwork.faction.stored[self.info.faction].useFullName) then
			self.fullNameTextEntry = self.nameForm:TextEntry("Full Name");
			self.fullNameTextEntry:SetAllowNonAsciiCharacters(true);
		else
			self.forenameTextEntry = self.nameForm:TextEntry("Forename");
			self.forenameTextEntry:SetAllowNonAsciiCharacters(true);
			
			self.surnameTextEntry = self.nameForm:TextEntry("Surname");
			self.surnameTextEntry:SetAllowNonAsciiCharacters(true);
		end;
	end;
	
	if (self.bSelectModel or self.bPhysDesc) then
		self.appearanceForm = vgui.Create("DForm");
		self.appearanceForm:SetPadding(4);
		self.appearanceForm:SetName("Appearance and Voice");
		
		if (self.bPhysDesc and self.bSelectModel and self.bVoiceDesc) then
			self.appearanceForm:Help("Write a physical and voice description for your character in full English, and select an appropriate model.");
		elseif (self.bPhysDesc and self.bSelectModel) then
			self.appearanceForm:Help("Write a physical description for your character in full English, and select an appropriate model.");
		elseif (self.bVoiceDesc and self.bSelectModel) then
			self.appearanceForm:Help("Write a voice description for your character in full English, and select an appropriate model.");
		elseif (self.bPhysDesc) then
			self.appearanceForm:Help("Write a physical description for your character in full English.");
		elseif (self.bVoiceDesc) then
			self.appearanceForm:Help("Write a voice description for your character in full English.");
		end;
		
		if (self.bVoiceDesc) then
			self.voiceDescTextEntry = self.appearanceForm:TextEntry("Voice Description");
			self.voiceDescTextEntry:SetAllowNonAsciiCharacters(true);
		end;
		
		if (self.bPhysDesc) then
			self.physDescTextEntry = self.appearanceForm:TextEntry("Physical Description");
			self.physDescTextEntry:SetAllowNonAsciiCharacters(true);
		end;
		
		if (self.bSelectModel) then
			self.modelItemsList = vgui.Create("DPanelList", self);
				self.modelItemsList:SetPadding(4);
				self.modelItemsList:SetSpacing(16);
				self.modelItemsList:EnableHorizontal(true);
				self.modelItemsList:EnableVerticalScrollbar(true);
			self.appearanceForm:AddItem(self.modelItemsList);
		end;
	end;
	
	if (self.nameForm) then
		self.categoryList:AddItem(self.nameForm);
	end;
	
	if (self.appearanceForm) then
		self.categoryList:AddItem(self.appearanceForm);
	end;
	
	local informationColor = Clockwork.option:GetColor("information");
	local lowerGender = string.lower(self.info.gender);
	local spawnIcon = nil;
	
	for k, v in pairs(Clockwork.faction.stored) do
		if (v.name == self.info.faction) then
			if (self.modelItemsList and v.models[lowerGender]) then
				for k2, v2 in pairs(v.models[lowerGender]) do
					spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
					spawnIcon:SetModel(v2);
					
					-- Called when the spawn icon is clicked.
					function spawnIcon.DoClick(spawnIcon)
						if (self.selectedSpawnIcon) then
							self.selectedSpawnIcon:SetColor(nil);
						end;
						
						spawnIcon:SetColor(informationColor);
						
						if (!panel:FadeInModelPanel(v2)) then
							panel:SetModelPanelModel(v2);
						end;
						
						self.selectedSpawnIcon = spawnIcon;
						self.selectedModel = v2;
					end;
					
					self.modelItemsList:AddItem(spawnIcon);
				end;
			end;
		end;
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (self.overrideModel) then
		self.info.model = self.overrideModel;
	else
		self.info.model = self.selectedModel;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		if (IsValid(self.fullNameTextEntry)) then
			self.info.fullName = self.fullNameTextEntry:GetValue();
			
			if (self.info.fullName == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;
		else
			self.info.forename = self.forenameTextEntry:GetValue();
			self.info.surname = self.surnameTextEntry:GetValue();
			
			if (self.info.forename == "" or self.info.surname == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;
			
			if (string.find(self.info.forename, "[%p%s%d]") or string.find(self.info.surname, "[%p%s%d]")) then
				Clockwork.character:SetFault("Your forename and surname must not contain punctuation, spaces or digits!");
				return false;
			end;
			
			if (!string.find(self.info.forename, "[aeiou]") or !string.find(self.info.surname, "[aeiou]")) then
				Clockwork.character:SetFault("Your forename and surname must both contain at least one vowel!");
				return false;
			end;
			
			if (string.len(self.info.forename) < 2 or string.len(self.info.surname) < 2) then
				Clockwork.character:SetFault("Your forename and surname must both be at least 2 characters long!");
				return false;
			end;
			
			if (string.len(self.info.forename) > 16 or string.len(self.info.surname) > 16) then
				Clockwork.character:SetFault("Your forename and surname must not be greater than 16 characters long!");
				return false;
			end;
		end;
	end;
	
	if (self.bSelectModel and !self.info.model) then
		Clockwork.character:SetFault("You did not choose a model, or the model that you chose is not valid!");
		return false;
	end;
	
	if (self.bPhysDesc) then
		local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
			self.info.physDesc = self.physDescTextEntry:GetValue();
		if (string.len(self.info.physDesc) < minimumPhysDesc) then
			Clockwork.character:SetFault("The physical description must be at least "..minimumPhysDesc.." characters long!");
			return false;
		end;
	end;
	
	if (self.bVoiceDesc) then
		local minimumVoiceDesc = Clockwork.config:Get("minimum_voicedesc"):Get();
			self.info.voiceDesc = self.voiceDescTextEntry:GetValue();
		if (string.len(self.info.voiceDesc) < minimumVoiceDesc) then
			Clockwork.character:SetFault("The voice description must be at least "..minimumVoiceDesc.." characters long!");
			return false;
		end;
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h) end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("rollover");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		Clockwork.option:PlaySound("click_release");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.categoryList:StretchToParent(0, 0, 0, 0);
	
	if (IsValid(self.modelItemsList)) then
		self.modelItemsList:SetTall(256);
	end;
	
	self:SetSize(512, math.min(self.categoryList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageTwo", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local buttonsList = {};
	local colorWhite = Clockwork.option:GetColor("white");
	local buttonX = 20;
	local buttonY = 0;
	
	self.customData = self:GetParent().customData;
	self.buttonPanels = {};
	self:SetPaintBackground(false);
	
	self.nameLabel = vgui.Create("cwLabelButton", self);
	self.nameLabel:SetDisabled(true);
	self.nameLabel:SetFont(smallTextFont);
	self.nameLabel:SetText(string.upper(self.customData.name));
	self.nameLabel:SizeToContents();
	
	self.factionLabel = vgui.Create("cwLabelButton", self);
	self.factionLabel:SetDisabled(true);
	self.factionLabel:SetFont(tinyTextFont);
	self.factionLabel:SetText(string.upper(self.customData.faction));
	self.factionLabel:SizeToContents();
	self.factionLabel:SetPos(0, self.nameLabel:GetTall() + 8);
	
	self.characterModel = vgui.Create("cwCharacterModel", self);
	self.characterModel:SetModel(self.customData.model);
	self.characterModel:SetPos(0, self.factionLabel.y + self.factionLabel:GetTall() + 8);
	self.characterModel:SetSize(256, 256);
	buttonY = self.characterModel.y + self.characterModel:GetTall() + 8;
	
	local modelPanel = self.characterModel:GetModelPanel();
	local sequence = Clockwork.plugin:Call(
		"GetCharacterPanelSequence", modelPanel.Entity, self.customData.charTable
	);
	
	if (sequence) then
		modelPanel.Entity:ResetSequence(sequence);
	end;
	
	self.useButton = vgui.Create("DImageButton", self);
	self.useButton:SetToolTip("Use this character.");
	self.useButton:SetImage("icon16/tick.png");
	self.useButton:SetSize(16, 16);
	self.useButton:SetPos(0, buttonY);
	
	self.deleteButton = vgui.Create("DImageButton", self);
	self.deleteButton:SetToolTip("Delete this character.");
	self.deleteButton:SetImage("icon16/cross.png");
	self.deleteButton:SetSize(16, 16);
	self.deleteButton:SetPos(20, buttonY);
	
	Clockwork.plugin:Call(
		"GetCustomCharacterButtons", self.customData.charTable, buttonsList
	);
	
	for k, v in pairs(buttonsList) do
		local button = vgui.Create("DImageButton", self);
			buttonX = buttonX + 20;
			button:SetToolTip(v.toolTip);
			button:SetImage(v.image);
			button:SetSize(16, 16);
			button:SetPos(buttonX, buttonY);
		self.buttonPanels[#self.buttonPanels + 1] = button;
		
		-- Called when the button is clicked.
		function button.DoClick(button)
			local function Callback()
				Clockwork.datastream:Start("InteractCharacter", {
					characterID = self.customData.characterID, action = k
				});
			end;
			
			if (!v.OnClick or v.OnClick(Callback) != false) then
				Callback();
			end;
		end;
	end;
	
	-- Called when the button is clicked.
	function self.useButton.DoClick(spawnIcon)
		Clockwork.datastream:Start("InteractCharacter", {
			characterID = self.customData.characterID, action = "use"}
		);
	end;
	
	-- Called when the button is clicked.
	function self.deleteButton.DoClick(spawnIcon)
		Clockwork.kernel:AddMenuFromData(nil, {
			["Yes"] = function()
				Clockwork.datastream:Start("InteractCharacter", {
					characterID = self.customData.characterID, action = "delete"}
				);
			end,
			["No"] = function() end
		});
	end;
	
	local modelPanel = self.characterModel:GetModelPanel();
	
	-- Called when the character model is clicked.
	function modelPanel.DoClick(modelPanel)
		local activePanel = Clockwork.character:GetActivePanel();
		
		if (activePanel:GetSelectedModel() == self) then
			local options = {};
			local panel = Clockwork.character:GetPanel();
			
			options["Use"] = function()
				Clockwork.datastream:Start("InteractCharacter", {
					characterID = self.customData.characterID, action = "use"}
				);
			end;
			
			options["Delete"] = {};
			options["Delete"]["No"] = function() end;
			options["Delete"]["Yes"] = function()
				Clockwork.datastream:Start("InteractCharacter", {
					characterID = self.customData.characterID, action = "delete"}
				);
			end;
			
			Clockwork.plugin:Call(
				"GetCustomCharacterOptions", self.customData.charTable, options, menu
			);
			
			Clockwork.kernel:AddMenuFromData(nil, options, function(menu, key, value)
				menu:AddOption(key, function()
					Clockwork.datastream:Start("InteractCharacter", {
						characterID = self.customData.characterID, action = value}
					);
				end);
			end);
		else
			for k, v in pairs(activePanel:GetCharacterPanels()) do
				if (v == self) then
					activePanel:SetSelectedIdx(k);
				end;
			end;
		end;
	end;
	
	local maxWidth = math.max(buttonX, 200);
	
	if (self.nameLabel:GetWide() > maxWidth) then
		maxWidth = self.nameLabel:GetWide();
	end;
	
	if (self.factionLabel:GetWide() > maxWidth) then
		maxWidth = self.factionLabel:GetWide();
	end;
	
	self.characterModel:SetPos((maxWidth / 2) - 128, self.characterModel.y);
	self.factionLabel:SetPos((maxWidth / 2) - (self.factionLabel:GetWide() / 2), self.factionLabel.y);
	self.nameLabel:SetPos((maxWidth / 2) - (self.nameLabel:GetWide() / 2), self.nameLabel.y);
	self:SetSize(maxWidth, buttonY + 32);
	
	local buttonAddX = ((maxWidth / 2) - (buttonX / 2)) - 10;
		self.useButton:SetPos(self.useButton.x + buttonAddX, self.useButton.y);
		self.deleteButton:SetPos(self.deleteButton.x + buttonAddX, self.deleteButton.y);
	for k, v in pairs(self.buttonPanels) do
		v:SetPos(v.x + buttonAddX, v.y);
	end;
end;

-- A function to set whether the panel is active.
function PANEL:SetActive(bActive)
	if (bActive) then
		self.nameLabel:OverrideTextColor(
			Clockwork.option:GetColor("information")
		);
	else
		self.nameLabel:OverrideTextColor(false);
	end;
end;

-- Called each frame.
function PANEL:Think()
	local informationColor = Clockwork.option:GetColor("information");
	local weaponModel = Clockwork.plugin:Call(
		"GetCharacterPanelWeaponModel", self, self.customData.charTable
	);
	local toolTip = Clockwork.plugin:Call(
		"GetCharacterPanelToolTip", self, self.customData.charTable
	);
	local details = Clockwork.kernel:MarkupTextWithColor("[Details]", informationColor);
	
	details = Clockwork.kernel:AddMarkupLine(
		details, self.customData.details or "This character has no details to display."
	);
	
	if (toolTip and toolTip != "") then
		details = Clockwork.kernel:AddMarkupLine(details, "[Information]", informationColor);
		details = Clockwork.kernel:AddMarkupLine(details, toolTip);
	end;
	
	if (weaponModel) then
		self.characterModel:SetWeaponModel(weaponModel);
	else
		self.characterModel:SetWeaponModel(false);
	end;
	
	self.characterModel:SetDetails(details);
end;
	
vgui.Register("cwCharacterPanel", PANEL, "DPanel");