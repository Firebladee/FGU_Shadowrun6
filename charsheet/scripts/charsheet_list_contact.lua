local index = 1;

function onInit()
	registerMenuItem("Create Item", "insert", 5);
	registerMenuItem("Create Item in Location", "insert", 3);
	local a = window.getClass();
	local b = string.gsub(a, "charsheet_7_3_", "");
	index = tonumber(b);
end


function onFilter(w)
	local filteritem = w.getDatabaseNode().getChild("contact.filteritem").getValue();
	if index == 1 then
		return true;
	elseif filteritem == index then
		return true;
	else
		return false;
	end
end	

	
function onSortCompare(w1, w2)
	if w1.contactname.getValue() == "" then
		return true;
	elseif w2.contactname.getValue() == "" then
		return false;
	end

	return w1.contactname.getValue() > w2.contactname.getValue();
end


function onMenuSelection(selection)
	local a = index;
	local c = "contacttabtext"..a;
	if selection == 3 or selection == 5 then
		local wnd = createWindow();
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		if b == "" then
			b = "Categ " .. a-1;
		end
		wnd.getDatabaseNode().getChild("contact.filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("contact.location").setValue(b);
	end
end

