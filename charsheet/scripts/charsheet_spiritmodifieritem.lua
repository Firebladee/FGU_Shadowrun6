-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem("Remove Modifier", "deletepointer", 7);
	registerMenuItem("Add Modifier", "pointer", 8);

	updateDisplay();
	
	windowlist.getOrder(getDatabaseNode());
end

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = windowlist.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "spiritmodifier", "string", "spiritmodifier");
			end
	elseif selection == 7 then
		getDatabaseNode().delete();
	end
end



function updateDisplay()

end


