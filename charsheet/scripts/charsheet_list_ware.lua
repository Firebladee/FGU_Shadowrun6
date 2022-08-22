local index = 1;

function onInit()
	registerMenuItem("Create Item", "insert", 5);
	registerMenuItem("Create Item in Location", "insert", 3);
	local a = window.getClass();
	local b = string.gsub(a, "charsheet_7_4_", "");
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
	if w1.warename.getValue() == "" then
		return true;
	elseif w2.warename.getValue() == "" then
		return false;
	end

	return w1.warename.getValue() > w2.warename.getValue();
end


function onMenuSelection(selection)
	local a = index;
	local c = "waretabtext"..a;
	if selection == 3 or selection == 5 then
		local wnd = createWindow();
		local b = wnd.getDatabaseNode().getParent().getParent().getParent().getChild(c).getValue();
		if b == "" then
			b = "Categ " .. a-1;
		end
		wnd.getDatabaseNode().getChild("filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("location").setValue(b);
	end
end

