-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	
	-- Build our own delete item menu and Add Modifier
	registerMenuItem("Add Modifier", "pointer", 8);

	toggleDetail();
	toggleLicence();
end	

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_licence.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "licencename", "string", "");
			end
	end
end

function toggleLicence()
	local status = activatelicence.getValue();
	list_licence.setVisible(status);
	
	for k,v in pairs(list_licence.getWindows()) do
		v.updateDisplay();
	end

end

function toggleDetail()
	local status = activateiddetail.getValue();
	-- Show the power details
	iddescription.setVisible(status);
end

function updateStatus()
	windowlist.applyFilter();
end



					
