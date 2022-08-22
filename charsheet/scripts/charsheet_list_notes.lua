local index = 1;

function onInit()
	registerMenuItem("Create Item", "insert", 5);
	registerMenuItem("Create Item in Location", "insert", 3);
	local a = window.getClass();
	local b = string.gsub(a, "charsheet_7_2_", "");
	index = tonumber(b);
end


function onFilter(w)
	local filteritem = w.getDatabaseNode().getChild("note.filteritem").getValue();
	if index == 1 then
		return true;
	elseif filteritem == index then
		return true;
	else
		return false;
	end
end	

	
function onSortCompare(w1, w2, fieldname)
	local returnValue = false;

	local date1 = w1.notename.getValue();
	local date2 = w2.notename.getValue();
	local loc1 = w1.notefilteritem.getValue();
	local loc2 = w2.notefilteritem.getValue();
	if loc1 == loc2 then
		returnValue = date1 > date2;
	else
		returnValue = loc1 > loc2;
	end
	return returnValue;
end	


function onMenuSelection(selection)
	local a = index;
	local c = "tabtext"..a;
	if selection == 3 or selection == 5 then
		local wnd = createWindow();
    local b = "";
    if wnd.getDatabaseNode().getParent().getParent().getChild(c) then
  		b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		end
		if b == "" then
			b = "Folder " .. a-1;
		end
		wnd.getDatabaseNode().getChild("note.filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("note.location").setValue(b);
	end
end

