function onDrop(x,y,draginfo)
	local i = math.ceil((x-15)/67);
	local text = draginfo.getStringData();
	local c = draginfo.getCustomData();
	local count = 0;
	
	for n, v in ipairs(tab) do
		count = count + 1;
	end
	i = (count+1) - i;
	
	if i > 1 and i < #tab+1 and draginfo.isType("string") then
		window.tabsinventory.renameTabText(i, text);
	elseif draginfo.isType("inventorylocation") then
		inventoryLocationDrop(i,c);
	end

	return true;
end

function inventoryLocationDrop(index,c)
	local cTab = tonumber(index);
	local tar = window.tabsinventory.getTarget(cTab);
	local text = window.tabsinventory.getTabtext(cTab);
	local newtext = window.getDatabaseNode().getChild(tar).getValue();
	if newtext == "" then
		newtext = text;
	end
	window.getDatabaseNode().getChild("inventorylist").getChild(c).getChild("inventory.location").setValue(newtext);
	window.getDatabaseNode().getChild("inventorylist").getChild(c).getChild("inventory.filteritem").setValue(cTab);
end