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
		local a = wnd.getDatabaseNode().getParent().getParent().getChild("warefilter").getValue();
		wnd.getDatabaseNode().getChild("else.filteritem").setValue(a);
		local c = "warefilter"..a
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		wnd.getDatabaseNode().getChild("else.location").setValue(b);
	elseif selection == 5 then
		local wnd = windowlist.createWindow();
		local a = wnd.getDatabaseNode().getParent().getParent().getChild("warefilter").getValue();
		wnd.getDatabaseNode().getChild("else.filteritem").setValue(a);
		local c = "warefilter"..a
		local b = wnd.getDatabaseNode().getParent().getParent().getChild(c).getValue();
		wnd.getDatabaseNode().getChild("else.location").setValue(b);
	end
end

function toggleDetail()
	local status = activatewaredetail.getValue();

	-- Show the power details
	waredescription.setVisible(status);
end


function updateStatus()
	windowlist.applyFilter();
end
