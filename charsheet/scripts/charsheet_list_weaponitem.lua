--
-- Please see the readme.txt file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 8);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleAmmunition();
	checkLocked();
	toggleActive();
end

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_ammunition.createWindow();

	end
end


function toggleDetail()
	local status = activateweapondetail.getValue();

	-- Show the power details
	weapondescription.setVisible(status);
end

function toggleAmmunition()
	local status = activateammunition.getValue();
		list_ammunition.setVisible(status);

	for k,v in pairs(list_ammunition.getWindows()) do
		v.updateDisplay();
	end

end

function toggleActive()
  local active = weaponisactive.getState();

  -- Show the power details
  skillcheck.setVisible(active);
end


function updateColorframe()
	local a = getDatabaseNode().getChild("color").getValue();
	if not a or a == "" then
		getDatabaseNode().getChild("color").setValue("ffffffff");
	end
	local b = getDatabaseNode().getChild("frame").getValue();
	if not b or b == "" then
		getDatabaseNode().getChild("frame").setValue("dailyframe");
	end
end


function onDrop(x, y, draginfo)
Debug.console("onDrop: ", draginfo.getType());
  local sDragType = draginfo.getType();
  if sDragType ~= "shortcut" then
    return false;
  end
  local sDropClass, sDropNodeName = draginfo.getShortcutData();

  if not StringManager.contains({ "referenceammo"}, sDropClass) then
    return false;
  end
  local nodeSource = draginfo.getDatabaseNode();

  local sSourceName = DB.getValue(nodeSource, "name", "");
  local nSourceDamageModifier = DB.getValue(nodeSource, "damagemodifier", 0);
  local sSourceDamageType = DB.getValue(nodeSource, "damagetype", "");
  local nSourceAPModifier = DB.getValue(nodeSource, "apmodifier", 0);
  local sAmmoArmourUsed = DB.getValue(nodeSource, "armourused", 0);

  local w = list_ammunition.createWindow();
  w.ammunitionname.setValue(sSourceName);
  w.ammunitionname.setReadOnly(true);
  w.ammodv.setValue(nSourceDamageModifier);
  w.ammodv.setReadOnly(true);
  if sSourceDamageType == "P" then
    w.ammodamagetype.setStringValue("Physical");
  elseif sSourceDamageType == "S" then
    w.ammodamagetype.setStringValue("Stun");
  elseif sSourceDamageType == "f" then
    w.ammodamagetype.setStringValue("Flechette");
  elseif sSourceDamageType == "S(e)" then
    w.ammodamagetype.setStringValue("Electricity");
  elseif sSourceDamageType == "t" then
    w.ammodamagetype.setStringValue("Toxic");
  elseif sSourceDamageType == "F" then
    w.ammodamagetype.setStringValue("Fire");
  elseif sSourceDamageType == "m" then
    w.ammodamagetype.setStringValue("Magic");
  elseif sSourceDamageType == "s" then
    w.ammodamagetype.setStringValue("Special");
  end
  w.ammodamagetype.setReadOnly(true);
  w.ammoarmourused.setStringValue(sAmmoArmourUsed);
  w.ammoarmourused.setReadOnly(true);
  w.ammoap.setValue(nSourceAPModifier);
  w.ammoap.setReadOnly(true);
  w.locked.setValue(1);
  w.ammocount.onDoubleClick();

  w.shortcut.setValue(draginfo.getShortcutData());

  return true;
end

function checkLocked()
  local nLocked = locked.getValue();
  if nLocked == 1 then
    weaponsubtype.setReadOnly(true);
    weaponreach.setReadOnly(true);
    weapondamage.setReadOnly(true);
    weaponhasstrength.setReadOnly(true);
    weapondamagetype.setReadOnly(true);
    weaponarmourpenetration.setReadOnly(true);
    weaponloadcapacity.setReadOnly(true);
    weaponmagazinetype.setReadOnly(true);
  end
end

