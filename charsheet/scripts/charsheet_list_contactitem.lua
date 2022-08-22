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
	if selection == 3 then
		local wnd = windowlist.createWindow();
		local a = wnd.getDatabaseNode().getParent().getParent().getChild("contactfilter").getValue();
		wnd.getDatabaseNode().getChild("contact.filteritem").setValue(a);
		local c = "contactfilter"..a
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		wnd.getDatabaseNode().getChild("contact.location").setValue(b);
	elseif selection == 5 then
		local wnd = windowlist.createWindow();
		local a = wnd.getDatabaseNode().getParent().getParent().getChild("contactfilter").getValue();
		wnd.getDatabaseNode().getChild("contact.filteritem").setValue(a);
		local c = "contactfilter"..a
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		wnd.getDatabaseNode().getChild("contact.location").setValue(b);
	end
end

function toggleDetail()
	local status = activatecontactdetail.getValue();

	-- Show the power details
	contactdescription.setVisible(status);
end


function updateStatus()
	windowlist.applyFilter();
end