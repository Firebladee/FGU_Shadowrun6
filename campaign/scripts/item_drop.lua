--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onDrop(x, y, draginfo)
	local sDragType = draginfo.getType();
	if sDragType ~= "shortcut" then
		return false;
	end

	local sDropClass, sDropNodeName = draginfo.getShortcutData();
	if not StringManager.contains({"item", "referencearmor", "referenceweapon", "referenceequipment"}, sDropClass) then
		return true;
	end

	local nodeSource = draginfo.getDatabaseNode();
	local nodeTarget = window.getDatabaseNode();

	local sSourceType = DB.getValue(nodeSource, "type", "");
	local sTargetType = DB.getValue(nodeTarget, "type", "");

	local sSourceName = DB.getValue(nodeSource, "name", "");
	sSourceName = string.gsub(sSourceName, " %(" .. sSourceType .. "%)", "");
	local sTargetName = DB.getValue(nodeTarget, "name", "");
	sTargetName = string.gsub(sTargetName, " %(" .. sTargetType .. "%)", "");

	if sSourceType == sTargetType and StringManager.contains({ "Weapon", "Armor" }, sSourceType) then
		local sCost = StringManager.combine(" ", DB.getValue(nodeSource, "cost", ""), DB.getValue(nodeTarget, "cost", ""));
		DB.setValue(nodeTarget, "cost", "string", sCost);

		local nSourceBonus = DB.getValue(nodeSource, "bonus", 0);
		local nTargetBonus = DB.getValue(nodeTarget, "bonus", 0);
		DB.setValue(nodeTarget, "bonus", "number", nSourceBonus + nTargetBonus);

		if sSourceType == "Weapon" then
			DB.setValue(nodeTarget, "subtype", "string", DB.getValue(nodeSource, "subtype", ""));
      DB.setValue(nodeTarget, "category", "string", DB.getValue(nodeSource, "category", ""));
			DB.setValue(nodeTarget, "availability", "number", DB.getValue(nodeSource, "availability", 0));
      DB.setValue(nodeTarget, "restricted", "string", DB.getValue(nodeSource, "restricted", ""));
			DB.setValue(nodeTarget, "damage", "number", DB.getValue(nodeSource, "damage", ""));
			DB.setValue(nodeTarget, "damagetype", "string", DB.getValue(nodeSource, "damagetype", ""));
			DB.setValue(nodeTarget, "ap", "number", DB.getValue(nodeSource, "ap", ""));
			DB.setValue(nodeTarget, "recoil", "number", DB.getValue(nodeSource, "recoil", 0));
			DB.setValue(nodeTarget, "mode", "string", DB.getValue(nodeSource, "mode", ""));
      DB.setValue(nodeTarget, "ammo", "number", DB.getValue(nodeSource, "ammo", ""));
      DB.setValue(nodeTarget, "ammotype", "string", DB.getValue(nodeSource, "ammotype", ""));
      DB.setValue(nodeTarget, "reach", "number", DB.getValue(nodeSource, "reach", ""));
      DB.setValue(nodeTarget, "damagestrength", "number", DB.getValue(nodeSource, "damagestrength", ""));
		elseif sSourceType == "Armor" then
			DB.setValue(nodeTarget, "subtype", "string", DB.getValue(nodeSource, "subtype", ""));
			DB.setValue(nodeTarget, "ballisticrating", "number", DB.getValue(nodeSource, "ballisticrating", 0));
			DB.setValue(nodeTarget, "impactrating", "number", DB.getValue(nodeSource, "impactrating", 0));
		end
	end

	return true;
end
