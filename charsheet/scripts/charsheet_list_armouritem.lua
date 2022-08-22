-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 3);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleArmourModifier();
end	

function onMenuSelection(selection)
	if selection == 3 then
		local wnd = list_armourmodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "armourmodifiername", "string", "");
			end
	end
end

function toggleDetail()
	local status = activatearmourdetail.getValue();

	-- Show the power details
	armourdescription.setVisible(status);
end

function toggleArmourModifier()
	local status = activatearmourmodifier.getValue();
		list_armourmodifier.setVisible(status);
	
	for k,v in pairs(list_armourmodifier.getWindows()) do
		v.updateDisplay();
	end
end
