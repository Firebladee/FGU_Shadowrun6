-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem("Remove Modifier", "deletepointer", 8);
	registerMenuItem("Add Modifier", "pointer", 7);
	updateDisplay();

	windowlist.getOrder(getDatabaseNode());
end

function onMenuSelection(selection)
	if selection == 7 then
		local wnd = windowlist.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "comlinkmodifier", "string", "comlinkname");
			end
	elseif selection == 8 then
		getDatabaseNode().delete();
	end
end



function updateDisplay()

end


