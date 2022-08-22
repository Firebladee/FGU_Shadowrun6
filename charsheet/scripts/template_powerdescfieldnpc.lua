-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function getCreatureType()
	return "npc";
end
function getCreatureNode()
	return window.getDatabaseNode().getChild("...");
end
function getCreatureName()
	return NodeManager.get(getCreatureNode(), "name", "");
end

function getFocusRecord(ability_type)
	local rFocus = {};

	rFocus.name = "";
	rFocus.range = "";

	local rFocusClause = {};
	rFocusClause.stat = {};
	rFocusClause.mod = 0;

	if ability_type == "attack" then
		rFocus.properties = "";
		rFocus.defense = "";
	elseif ability_type == "damage" then
		rFocus.properties = "";
		rFocus.basedice = NodeManager.get(window.getDatabaseNode(), "dice", {});
		rFocus.critdice = {};
		rFocus.critmod = 0;
		rFocus.crittype = "";

		rFocusClause.dicestr = StringManager.convertDiceToString(rFocus.basedice);
		rFocusClause.subtype = "";
	end
	
	rFocus.clauses = { rFocusClause };

	return rFocus;
end

function getWeaponRecord(ability_type)
	return getFocusRecord(ability_type);
end
function getImplementRecord(ability_type)
	return getFocusRecord(ability_type);
end
