-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem("Remove Modifier", "deletepointer", 8);
	registerMenuItem("Add Modifier", "pointer", 7);
	updateDisplay();

	windowlist.getOrder(getDatabaseNode());
	updateProgramCount();
end

function onMenuSelection(selection)
	if selection == 7 then
		local wnd = windowlist.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "agentmodifier", "string", "agentname");
			end
		updateProgramCount(7);
	elseif selection == 8 then
		updateProgramCount(8);
		getDatabaseNode().delete();
		
	end
end



function updateDisplay()

end

function updateProgramCount(b)
	local a = 1
	if b == 4 then 
		a = -1
	elseif b == 3 then 
		a = 0 
	end
	for i,v in pairs(windowlist.getWindows()) do
	a = a + 1
	end
	windowlist.window.getDatabaseNode().getChild("agentprogramcount").setValue(a);
end
					
