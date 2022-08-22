-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	
	-- Build our own delete item menu and Add Modifier
	registerMenuItem("Add Modifier", "pointer", 8);

	toggleDetail();
	toggleSkillmodifier();
end	

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_skillmodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "skillmodifiername", "string", "");
			end
	end
end

function toggleSkillmodifier()
	local status = activateskillmodifier.getValue();
	list_skillmodifier.setVisible(status);
	
	for k,v in pairs(list_skillmodifier.getWindows()) do
		v.updateDisplay();
	end

end

function toggleDetail()
	local status = activateskilldetail.getValue();

	-- Show the power details
	skillgroup.setVisible(status);
	skilldescription.setVisible(status);
end

function modifierDrop(vmodifiername, vmodifier)
	local wnd = list_skillmodifier.createWindow();
	if wnd then
		NodeManager.set(wnd.getDatabaseNode(), "skillmodifiername", "string", vmodifiername);
		wnd.getDatabaseNode().getChild("modifier.bonus").setValue(vmodifier);
		wnd.getDatabaseNode().getChild("skillmodifierbox").setValue(1);
	end
end

function updateStatus()
	windowlist.applyFilter();
end


