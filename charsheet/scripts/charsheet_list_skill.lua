local index = 1;

function onInit()
	registerMenuItem("Create Item", "insert", 5);
	registerMenuItem("Create Item in Location", "insert", 3);
	local a = window.getClass();
	local b = string.gsub(a, "charsheet_2_", "");
	index = tonumber(b);
end


function onFilter(w)
	local filteritem = w.getDatabaseNode().getChild("filteritem").getValue();
	if index == 1 then
		return true;
	elseif filteritem == index then
		return true;
	else
		return false;
	end
end


function onSortCompare(w1, w2)
	local sSort1 = "";
	local sSort2 = "";

	if w1.skillsort and w1.skillsort.getValue() ~= "" then
		sSort1 = w1.skillsort.getValue() .. w1.skillname.getValue();
	else
		sSort1 = w1.skillname.getValue();
	end
	if w2.skillsort and w2.skillsort.getValue() ~= "" then
		sSort2 = w2.skillsort.getValue() .. w2.skillname.getValue();
	else
		sSort1 = w2.skillname.getValue();
	end

	if sSort1 == "" then
		return true;
	elseif sSort2 == "" then
		return false;
	end

	return sSort1 > sSort2;
end


function onMenuSelection(selection)
	local a = index;
	local c = "skilltabtext"..a;
	if selection == 3 or selection == 5 then
		local wnd = createWindow();
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		if b == "" then
			b = "Categ " .. a-1;
		end
		wnd.getDatabaseNode().getChild("filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("skilltype").setValue(b);
	end
end

function onDrop(x, y, draginfo)
  Debug.console("onDrop: ", draginfo);
  local sDragType = draginfo.getType();
  if sDragType ~= "shortcut" then
    return false;
  end
  local sDropClass, sDropNodeName = draginfo.getShortcutData();
  if not StringManager.contains({ "referenceactiveskill"}, sDropClass) then
    return false;
  end
  local nodeSource = draginfo.getDatabaseNode();

  local sSourceName = DB.getValue(nodeSource, "name", "");
  local sSourceCategory = DB.getValue(nodeSource, "category", "");
  local sSourceAbility = DB.getValue(nodeSource, "ability", "");

  Debug.console("onDrop: ", nodeSource, sSourceType, sSourceName);
  local w = createWindow();
  w.skillname.setValue(sSourceName);
  w.skilltype.setStringValue(sSourceCategory);
  w.skillattribute.setStringValue(string.lower(sSourceAbility));

  w.shortcut.setValue(draginfo.getShortcutData());

  return true;
end
