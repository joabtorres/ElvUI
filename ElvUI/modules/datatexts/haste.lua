﻿local E, L, V, P, G = unpack(select(2, ...));
local DT = E:GetModule("DataTexts");

local ATTACK_SPEED = ATTACK_SPEED;
local CR_HASTE_MELEE = CR_HASTE_MELEE;
local CR_HASTE_RANGED = CR_HASTE_RANGED;
local CR_HASTE_RATING_TOOLTIP = CR_HASTE_RATING_TOOLTIP;
local CR_HASTE_SPELL = CR_HASTE_SPELL;
local PAPERDOLLFRAME_TOOLTIP_FORMAT = PAPERDOLLFRAME_TOOLTIP_FORMAT;
local SPEED = SPEED;
local SPELL_HASTE = SPELL_HASTE;
local SPELL_HASTE_TOOLTIP = SPELL_HASTE_TOOLTIP;

local displayNumberString = "";
local format = string.format;
local join = string.join;
local lastPanel;

local function OnEvent(self, event, unit)
	local hasteRating;
	if(E.Role == "Caster") then
		hasteRating = GetCombatRating(CR_HASTE_SPELL);
	elseif(E.myclass == "HUNTER") then
		hasteRating = GetCombatRating(CR_HASTE_RANGED);
	else
		hasteRating = GetCombatRating(CR_HASTE_MELEE);
	end
	self.text:SetFormattedText(displayNumberString, SPEED, hasteRating);
	lastPanel = self;
end

local function OnEnter(self)
	DT:SetupTooltip(self);
	
	local text, tooltip;
	if(E.Role == "Caster") then
		text = SPELL_HASTE;
		tooltip = format(SPELL_HASTE_TOOLTIP, GetCombatRatingBonus(CR_HASTE_SPELL));
	elseif(E.myclass == "HUNTER") then
		text = format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..format("%.2f", UnitRangedDamage("player"));
		tooltip = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_RANGED), GetCombatRatingBonus(CR_HASTE_RANGED));
	else
		local speed, offhandSpeed = UnitAttackSpeed("player");
		speed = format("%.2f", speed);
		if(offhandSpeed) then
			offhandSpeed = format("%.2f", offhandSpeed);
		end
		local string;	
		if(offhandSpeed) then
			string = speed.." / "..offhandSpeed;
		else
			string = speed;
		end
		text = format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..string;
		tooltip = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_MELEE), GetCombatRatingBonus(CR_HASTE_MELEE));
	end
	
	DT.tooltip:AddLine(text, 1, 1, 1);
	DT.tooltip:AddLine(tooltip);
	DT.tooltip:Show();
end

local function ValueColorUpdate(hex, r, g, b)
	displayNumberString = join("", "%s: ", hex, "%d|r");
	
	if(lastPanel ~= nil)then
		OnEvent(lastPanel);
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true;

DT:RegisterDatatext(SPEED, { "UNIT_ATTACK_SPEED", "UNIT_STATS", "UNIT_AURA", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE", "UNIT_SPELL_HASTE", "PLAYER_DAMAGE_DONE_MODS" }, OnEvent, nil, nil, OnEnter);