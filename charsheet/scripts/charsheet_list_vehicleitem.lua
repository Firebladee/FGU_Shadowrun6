-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 8);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleVehicleModifier();
end	

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_vehiclemodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "vehiclemodifier", "string", "vehiclename");
			end
	end
end


function toggleDetail()
	local status = activatevehicledetail.getValue();

	-- Show the power details
	vehicledescription.setVisible(status);
end

function toggleVehicleModifier()
	local status = activatevehiclemodifier.getValue();
		list_vehiclemodifier.setVisible(status);
	
	for k,v in pairs(list_vehiclemodifier.getWindows()) do
		v.updateDisplay();
	end

end

