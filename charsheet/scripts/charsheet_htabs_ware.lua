function onDrop(x,y,draginfo)
	local i = math.ceil((x-15)/67);
	local text = draginfo.getStringData();
	local c = draginfo.getCustomData();
	local count = 0;
	for n, v in ipairs(tab) do
		count = count + 1;
	end
	i = (count+1) - i;
	if i == 1 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Overview");
	elseif i == 2 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Cyberware");
	elseif i == 3 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Bioware");
	elseif i == 4 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Genetic");
	elseif i == 5 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Adv.");
	elseif i == 6 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Disadv.");
	elseif i == 7 and i < #tab+1 and draginfo.isType("string") then
		window.tabsware.renameTabText(i, "Other");
	elseif draginfo.isType("warelocation") then
		wareLocationDrop(i,c);
	end

	return true;
end

function wareLocationDrop(index,c)
	local cTab = tonumber(index);
	local tar = window.tabsware.getTarget(cTab);
	local text = window.tabsware.getTabtext(cTab);
	local newtext = window.getDatabaseNode().getChild(tar).getValue();
	if newtext == "" then
		newtext = text;
	end
	window.getDatabaseNode().getChild("else.warelist").getChild(c).getChild("location").setValue(newtext);
	window.getDatabaseNode().getChild("else.warelist").getChild(c).getChild("filteritem").setValue(cTab);
end