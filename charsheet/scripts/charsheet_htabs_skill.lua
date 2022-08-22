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
		window.tabsskill.renameTabText(i, "Overview");
	elseif i == 2 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Combat");
	elseif i == 3 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Magic");
	elseif i == 4 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Matrix");
	elseif i == 5 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Pilot");
	elseif i == 6 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Active");
	elseif i == 7 and i < #tab+1 and draginfo.isType("string") then
		window.tabsskill.renameTabText(i, "Softskill");
	elseif draginfo.isType("skill") then
		skillLocationDrop(i,c);
	end

	return true;
end

function skillLocationDrop(index,c)
	local cTab = tonumber(index);
	local tar = window.tabsskill.getTarget(cTab);
	local text = window.tabsskill.getTabtext(cTab);
	local newtext = window.getDatabaseNode().getChild(tar).getValue();
	if newtext == "" then
		newtext = text;
	end
	DB.findNode(c).getChild("skilltype").setValue(newtext);
	DB.findNode(c).getChild("filteritem").setValue(cTab);
end