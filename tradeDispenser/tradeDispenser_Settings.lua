function tradeDispenserSettings_OnUpdate()
	if (tradeDispenserSettingsChannelDDframe) then tradeDispenserSettingsChannelDDframe:Hide(); end
	if (tradeDispenserSettingsOSDscale and tradeDispenserSettingsSwatch and tD_CharDatas.OSD) then
		if ( tD_CharDatas.OSD.isEnabled ) then
			tradeDispenserSettingsOSDCheck:SetChecked(1);
			tradeDispenserSettingsOSDLock:Show();
			tradeDispenserSettingsOSDscale:Show();
			tradeDispenserSettingsSwatch:Show();
			tradeDispenserSettingsOSDborder:Show();
			tradeDispenserSettingsOSDhoriz:Show();
		else
			tradeDispenserSettingsOSDCheck:SetChecked(0);
			tradeDispenserSettingsOSDLock:Hide();
			tradeDispenserSettingsOSDscale:Hide();
			tradeDispenserSettingsSwatch:Hide();
			tradeDispenserSettingsOSDborder:Hide();	
			tradeDispenserSettingsOSDhoriz:Hide();			
		end
		tradeDispenserSettingsOSDLock:SetChecked(tD_CharDatas.OSD.locked);
	end

	if (tD_CharDatas.ChannelID) then tradeDispenser_ChannelUpdate() end
	
	if (tD_CharDatas.broadcastSlice and tradeDispenserSettingsBroadcastTimerLbl) then 
		tradeDispenserSettingsBroadcastTimerLbl:SetText(math.floor(tD_CharDatas.broadcastSlice/60).." min")
	end
	
	if (tradeDispenserSettingsBroadcastCheck) then
		if (tD_CharDatas.AutoBroadcast and tradeDispenserSettingsBroadcastTimer) then
			tradeDispenserSettingsBroadcastCheck:SetChecked(1);
			tradeDispenserSettingsBroadcastTimer:Show();
			tradeDispenserSettingsBroadcastTimer:SetValue(math.floor(tD_CharDatas.broadcastSlice/60));
		else 
			tradeDispenserSettingsBroadcastCheck:SetChecked(0);
			tradeDispenserSettingsBroadcastTimer:Hide();
			tD_CharDatas.AutoBroadcast=false;
		end
	end
	
	if (tradeDispenserSettingsTimelimitCheck) then
		if (tD_CharDatas.TimelimitCheck) then
			tradeDispenserSettingsTimelimitCheck:SetChecked(1);
			tradeDispenserSettingsTimelimitSlider:Show();
			tradeDispenserSettingsTimelimitSlider:SetValue(tD_CharDatas.Timelimit);
			tradeDispenserSettingsTimelimitSliderLbl:SetText(tD_CharDatas.Timelimit.." sec");
		else
			tradeDispenserSettingsTimelimitCheck:SetChecked(0);
			tradeDispenserSettingsTimelimitSlider:Hide();
		end
	end
	if (tradeDispenserSettingsSoundCheck) then
		tradeDispenserSettingsSoundCheck:SetChecked(tD_CharDatas.SoundCheck);
	end
	tradeDispenserVerbose(2, "Updated Settings-Frame")

end


function tradeDispenser_EditBoxUpdate()
	tradeDispenserVerbose(2,"EditBox updated")
	local temp = 480;
	if (not tradeDispenserTradeControl or not tradeDispenserSettingsText) then return end;
	
	if (tradeDispenserTradeControl:IsShown()) then temp=temp+184 end
	
	tradeDispenserSettingsText:SetWidth( temp );
	tradeDispenserSettingsText:SetHeight( 24*tD_CharDatas.Random + 6);
	
	local i;
	for i=1,8 do
		local obj = getglobal("tradeDispenserSettingsTextBroadcastText"..i);
		obj:SetWidth( temp-130 );
		getglobal("tradeDispenserSettingsTextBroadcastText"..i.."Middle"):SetWidth( temp-130 );

		if (i<=tD_CharDatas.Random) then	obj:Show()		else 	obj:Hide() 		end
		if (tD_CharDatas.RndText and tD_CharDatas.RndText[i]) then
			obj:SetText(tD_CharDatas.RndText[i]);
		else 
			obj:SetText("empty");
		end
	end	
end


function tradeDispenser_ChannelUpdate()
	tradeDispenserSettingsChannelDDTitleLbL:SetText(strupper( tradeDispenserChannelColors[tD_CharDatas.ChannelID].text ));
	local col = tradeDispenserChannelColors[tD_CharDatas.ChannelID];
	tradeDispenserSettingsChannelDDTitleLbL:SetTextColor(col.r, col.g, col.b);
end


function tradeDispenserSettings_OnColorChange(frame)
	frame.r = tD_CharDatas.OSD.r;
	frame.g = tD_CharDatas.OSD.g;
	frame.b = tD_CharDatas.OSD.b;
	frame.opacity = 1-tD_CharDatas.OSD.alpha;
	frame.opacityFunc = tradeDispenserSettings_SetAll;
	frame.swatchFunc = tradeDispenserSettings_SetAll;
	frame.hasOpacity = 1;
	ColorPickerFrame.frame = frame;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function tradeDispenserSettings_SetAll()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	local a = OpacitySliderFrame:GetValue();	
	tD_CharDatas.OSD.r=r;
	tD_CharDatas.OSD.g=g;
	tD_CharDatas.OSD.b=b;
	tD_CharDatas.OSD.alpha=1-a;	
	tradeDispenserSettings_OnUpdate();
	tradeDispenserOSD_OnUpdate();
	tradeDispenserSettingsSwatchNormalTexture:SetVertexColor(r, g, b,1-a);
end



-- FUNCTIONS to insert ITEMLINKS --
-- copied and modified from the addon "SuperMacro" --
-- really well done! thx.      
-- btw: they expands the "default" functions by some features

--[[

REMOVED!!!
After Patch 2.00, these hooking does not work any longer.


function tradeDispenserSettings_InsertItemText(link)
	if ( not link ) then return end;
	if ( IsAltKeyDown() or IsShiftKeyDown() or IsControlKeyDown() ) then
		local temp = tD_CharDatas.OnBroadcastText:GetText();
		tD_CharDatas.OnBroadcastText:Insert(link);
		tradeDispenserVerbose(1,"Added "..link);
		return 1;
	end
end

local tD_oldContainerFrameItemButton_OnClick = ContainerFrameItemButton_OnClick;
function ContainerFrameItemButton_OnClick(button, ignoreShift)
	tradeDispenserVerbose(2,"ShiftClick on Inventory-Item");
	if ( button=="LeftButton" and not ignoreShift and tD_CharDatas.OnBroadcastText~=nil ) then
		local link = GetContainerItemLink(self:GetParent():GetID(), self:GetID());
		if ( not tradeDispenserSettings_InsertItemText(link) ) then
			tD_oldContainerFrameItemButton_OnClick(button, ignoreShift);
		end
		return;
	end
	tD_oldContainerFrameItemButton_OnClick(button, ignoreShift);
end

local tD_oldPaperDollItemSlotButton_OnClick = PaperDollItemSlotButton_OnClick;
function PaperDollItemSlotButton_OnClick(button, ignoreShift)
	if ( button=="LeftButton" and not ignoreShift and tD_CharDatas.OnBroadcastText~=nil ) then
		local link = GetInventoryItemLink("player", self:GetID());
		if ( not tradeDispenserSettings_InsertItemText(link) ) then
			tD_oldPaperDollItemSlotButton_OnClick(button, ignoreShift);
		end
		return;
	end
	tD_oldPaperDollItemSlotButton_OnClick(button, ignoreShift);
end

local tD_oldBagSlotButton_OnClick = BagSlotButton_OnClick;
function BagSlotButton_OnClick()
	if ( arg1=="LeftButton" and tD_CharDatas.OnBroadcastText~=nil ) then
		self:SetChecked(not self:GetChecked());
		local link = GetInventoryItemLink("player", self:GetID());
		if ( not tradeDispenserSettings_InsertItemText(link) ) then
			tD_oldBagSlotButton_OnClick();
		end
		return;
	end
	tD_oldBagSlotButton_OnClick();
end

local tD_oldBagSlotButton_OnShiftClick = BagSlotButton_OnShiftClick;
function BagSlotButton_OnShiftClick()
	tradeDispenserVerbose(2,"ShiftClick on Inventory-Item");
	if ( tD_CharDatas.OnBroadcastText~=nil ) then
		self:SetChecked(not self:GetChecked());
		local link = GetInventoryItemLink("player", self:GetID());
		if ( not tradeDispenserSettings_InsertItemText(link) ) then
			tD_oldBagSlotButton_OnShiftClick();
		end
		return;
	end
	tD_oldBagSlotButton_OnShiftClick();
end
--]]