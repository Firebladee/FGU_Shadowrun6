-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Program", "pointer", 3);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleAgentModifier();
end	

function onMenuSelection(selection)
	if selection == 3 then
		local wnd = list_agentmodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "agentmodifier", "string", "agentname");
			end
	end
end


function toggleDetail()
	local status = activateagentdetail.getValue();
	-- Show the power details
	agentdescription.setVisible(status);
end

function toggleAgentModifier()
	local status = activateagentmodifier.getValue();
		list_agentmodifier.setVisible(status);
	
	for k,v in pairs(list_agentmodifier.getWindows()) do
		v.updateDisplay();
	end

end

function modifierDrop(vmodifiername, vmodifier, vmodifiernode)
	local newitem = true
	for i,v in pairs(list_agentmodifier.getWindows()) do
		local a = v.getDatabaseNode().getChild("agentprogramnode").getValue();
			if a == vmodifiernode then
				v.getDatabaseNode().getChild("agentprogramname").setValue(vmodifiername);
				v.getDatabaseNode().getChild("agentprogramrating").setValue(vmodifier);
				v.getDatabaseNode().getChild("agentprogramnode").setValue(vmodifiernode);
				newitem = false
			end
		end
	if newitem == true then
		local wnd = list_agentmodifier.createWindow();
		if wnd then
			NodeManager.set(wnd.getDatabaseNode(), "agentprogramname", "string", vmodifiername);
			wnd.getDatabaseNode().getChild("agentprogramrating").setValue(vmodifier);
			wnd.getDatabaseNode().getChild("agentprogramnode").setValue(vmodifiernode);
		end
	end
end

					
