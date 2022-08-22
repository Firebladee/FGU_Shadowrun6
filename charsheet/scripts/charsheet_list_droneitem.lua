-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 8);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleDroneModifier();
end	

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_dronemodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "dronemodifier", "string", "dronename");
			end
	end
end


function toggleDetail()
	local status = activatedronedetail.getValue();

	-- Show the power details
	dronedescription.setVisible(status);
	--These checks are causing an error and do not seem to have usability assigned to them, disabled until further notice
	--skillinuse.setVisible(status);
	--skillinusescore.setVisible(status);
end

function toggleDroneModifier()
	local status = activatedronemodifier.getValue();
		list_dronemodifier.setVisible(status);
	
	for k,v in pairs(list_dronemodifier.getWindows()) do
		v.updateDisplay();
	end

end


function droneSkillInUseDrop(desc, cust, node)
			getDatabaseNode().getChild("drone.skillinuse").setValue(desc);
			getDatabaseNode().getChild("drone.skillinusescore").setValue(cust);
			getDatabaseNode().getChild("drone.skillinusenode").setValue(node);
end


					
