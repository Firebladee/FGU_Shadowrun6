-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function getCreatureType()
	return "pc";
end
function getCreatureNode()
	return window.getDatabaseNode().getChild(".....");
end

function getFocusRecord(tool_order, ability_type)
	local weapons_node = getCreatureNode().getChild("weaponlist");
	if not weapons_node then
		return nil;
	end
	
	for k, v in pairs(weapons_node.getChildren()) do
		local order_val = NodeManager.get(v, "order", 0);
		if order_val == tool_order then
			return CharSheetCommon.getFocusRecord(ability_type, v);
		end
	end
	
	return nil;
end

function getWeaponRecord(ability_type)
	return getFocusRecord(NodeManager.get(getCreatureNode(), "powerfocus.weapon.order", 0), ability_type);
end

function getImplementRecord(ability_type)
	return getFocusRecord(NodeManager.get(getCreatureNode(), "powerfocus.implement.order", 0), ability_type);
end
