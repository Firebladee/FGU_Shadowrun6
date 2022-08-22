-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem("Remove Modifier", "deletepointer", 8);
	registerMenuItem("Add Modifier", "pointer", 7);
	updateDisplay();
	checkLocked();
	
	windowlist.getOrder(getDatabaseNode());
end

function onMenuSelection(selection)
	if selection == 7 then
		local wnd = windowlist.createWindow();

	elseif selection == 8 then
		getDatabaseNode().delete();
	end
end

function updateDisplay()

end

function checkLocked()
  local nLocked = locked.getValue();
  if nLocked == 1 then
    ammunitionname.setReadOnly(true);
    ammodv.setReadOnly(true);
    ammodamagetype.setReadOnly(true);
    ammoap.setReadOnly(true);
    ammoarmourused.setReadOnly(true);
  end
end
