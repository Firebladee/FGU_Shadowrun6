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
		window.tabsnote.renameTabText(i, text);
	elseif draginfo.isType("notelocation") then
		noteLocationDrop(i,c);
	end

	return true;
end

function noteLocationDrop(index,c)
	local cTab = tonumber(index);
	local tar = window.tabsnote.getTarget(cTab);
	local text = window.tabsnote.getTabtext(cTab);
	local newtext = window.getDatabaseNode().getChild(tar).getValue();
	if newtext == "" then
		newtext = text;
	end
	window.getDatabaseNode().getChild("notelist").getChild(c).getChild("note.location").setValue(newtext);
	window.getDatabaseNode().getChild("notelist").getChild(c).getChild("note.filteritem").setValue(cTab);
end