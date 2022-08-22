local index = 1;

function onInit()
	registerMenuItem("Create Item", "insert", 5);
	registerMenuItem("Create Item in Location", "insert", 3);
	local a = window.getClass();
	local b = string.gsub(a, "charsheet_7_1_", "");
	index = tonumber(b);
end


function onFilter(w)
	local filteritem = w.getDatabaseNode().getChild("inventory.filteritem").getValue();
	if index == 1 then
		return true;
	elseif filteritem == index then
		return true;
	else
		return false;
	end
end	

	
function onSortCompare(w1, w2, fieldname)
	local a = window.inventorysort.getValue();
	local returnValue = false;

	local name1 = w1.inventoryname.getValue();
	local name2 = w2.inventoryname.getValue();
	local loc1 = "";
	local loc2 = "";
	if index == 1 then
		loc1 = w1.inventoryfilteritem.getValue();
		loc2 = w2.inventoryfilteritem.getValue();
	else
		loc1 = w1.subloc.getValue();
		loc2 = w2.subloc.getValue();
	end

	if a == 1 then
		if loc1 == loc2 then
			returnValue = name1 > name2;
		else
			returnValue = loc1 > loc2;
		end
	else
		if name1 == name2 then
			returnValue = loc1 > loc2;
		else
			returnValue = name1 > name2;
		end		
	end
	
	return returnValue;
end	


function onMenuSelection(selection)
	local a = index;
	local c = "tabtext"..a;
	if selection == 3 or selection == 5 then
		local wnd = createWindow();
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		if b == "" then
			b = "Loc " .. a-1;
		end
		wnd.getDatabaseNode().getChild("inventory.filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("inventory.location").setValue(b);
	end
end

