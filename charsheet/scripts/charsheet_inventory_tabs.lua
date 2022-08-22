function onDrop(x,y,draginfo)
	local i = math.ceil((x-15)/67);
	local text = draginfo.getStringData();
	local c = draginfo.getCustomData();
	if i > 1 and i < #tab+1 and draginfo.isType("string") then
		renameTab(i, text);
	elseif draginfo.isType("inventorylocation") then
		inventoryLocationDrop(i,c);
	end

	return true;
end

function renameTab(index, newtext)
	local cTab = tonumber(index);
	local tabname = "tabtext"..cTab;
	window.getDatabaseNode().getChild(tabname).setValue(newtext);
	window.tabsinventory.renameTabText(cTab, newtext)
	return true;
end

function inventoryLocationDrop(b,c)
	window.getDatabaseNode().getChild("inventorylist").getChild(c).getChild("inventory.filteritem").setValue(b);
	local tabname = "tabtext"..b;
	local a = window.getDatabaseNode().getChild(tabname).getValue();
	if a == "" then 
		a = "Location ".. b-1;
	end
	window.getDatabaseNode().getChild("inventorylist").getChild(c).getChild("inventory.location").setValue(a);
end