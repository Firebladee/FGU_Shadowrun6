-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem("Remove Modifier", "deletepointer", 3);
	registerMenuItem("Add Modifier", "pointer", 2);
	updateDisplay();

	windowlist.getOrder(getDatabaseNode());
end

function onMenuSelection(selection)
	if selection == 2 then
		local wnd = windowlist.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "dronemodifier", "string", "dronename");
			end
	elseif selection == 3 then
		getDatabaseNode().delete();
	end
end



function updateDisplay()

end


