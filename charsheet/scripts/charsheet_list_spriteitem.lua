-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Program", "pointer", 8);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleSpriteModifier();
end	

function onMenuSelection(selection)
	if selection == 8 then
		local wnd = list_spritemodifier.createWindow();
			if wnd then
				NodeManager.set(wnd.getDatabaseNode(), "spritemodifier", "string", "spritename");
			end
	end
end


function toggleDetail()
	local status = activatespritedetail.getValue();
	-- Show the power details
	spritedescription.setVisible(status);
end

function toggleSpriteModifier()
	local status = activatespritemodifier.getValue();
		list_spritemodifier.setVisible(status);
	
	for k,v in pairs(list_spritemodifier.getWindows()) do
		v.updateDisplay();
	end

end

function modifierDrop(vmodifiername, vmodifier, vmodifiernode)
	local newitem = true
	for i,v in pairs(list_spritemodifier.getWindows()) do
		local a = v.getDatabaseNode().getChild("spriteprogramnode").getValue();
			if a == vmodifiernode then
				v.getDatabaseNode().getChild("spriteprogramname").setValue(vmodifiername);
				v.getDatabaseNode().getChild("spriteprogramrating").setValue(vmodifier);
				v.getDatabaseNode().getChild("spriteprogramnode").setValue(vmodifiernode);
				newitem = false
			end
		end
	if newitem == true then
		local wnd = list_spritemodifier.createWindow();
		if wnd then
			NodeManager.set(wnd.getDatabaseNode(), "spriteprogramname", "string", vmodifiername);
			wnd.getDatabaseNode().getChild("spriteprogramrating").setValue(vmodifier);
			wnd.getDatabaseNode().getChild("spriteprogramnode").setValue(vmodifiernode);
		end
	end
end

					
