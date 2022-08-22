-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	-- Build our own delete item menu and Add Modifier
	registerMenuItem("Create Item in Location", "insert", 3);
	registerMenuItem("Create Item", "insert", 5);
	toggleDetail();
end	

function onMenuSelection(selection)
	local a = self.getDatabaseNode().getChild("inventory.filteritem").getValue();
	local b = self.getDatabaseNode().getChild("inventory.location").getValue();
	if selection == 3 or selection == 5 then
		local wnd = windowlist.createWindow();
		wnd.getDatabaseNode().getChild("inventory.filteritem").setValue(a);
		wnd.getDatabaseNode().getChild("inventory.location").setValue(b);
	end
end

function toggleDetail()
	local status = activateinventorydetail.getValue();

	-- Show the power details
	inventorydescription.setVisible(status);
end


function updateStatus()
	windowlist.applyFilter();
end					

