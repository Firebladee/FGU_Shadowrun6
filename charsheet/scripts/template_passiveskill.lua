-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

skillnodename = nil;

function onInit()
	-- Get any custom fields
	local skillname = "";
	local statnodename = "";
	if sourcefields then
		if sourcefields[1].skillname then
			skillname = sourcefields[1].skillname[1];
		end
		if sourcefields[1].statnodename then
			statnodename = sourcefields[1].statnodename[1];
		end
	end

	-- If we have a skill name, then find or create a skill node
	if skillname ~= "" then
		local listnode = NodeManager.createChild(window.getDatabaseNode(), "skilllist");
		if listnode then
			-- First, look for an existing skill node
			local skilllist = listnode.getChildren();
			for k,v in pairs(skilllist) do
				local name = NodeManager.get(v, "label", "");
				if name == skillname then
					skillnodename = v.getName();
					break;
				end
			end
			
			-- Or else, create a new skill node
			if not skillnodename then
				local skillnode = NodeManager.createChild(listnode);
				if skillnode then
					skillnodename = skillnode.getName();

					NodeManager.set(skillnode, "label", "string", skillname);
					NodeManager.set(skillnode, "trained", "number", 0);
					NodeManager.set(skillnode, "misc", "number", 0);
				end
			end
		end
	end

	-- Add the sources for this field to the watch list
	addSourceWithOp("levelbonus", "+");
	if statnodename == "strength" or statnodename == "dexterity" or statnodename == "constitution"  or statnodename == "intelligence" or statnodename == "wisdom"  or statnodename == "charisma" then
		addSourceWithOp("abilities." .. statnodename .. ".bonus", "+");
	end
	if skillnodename then
		addSource("skilllist." .. skillnodename .. ".trained");
		addSourceWithOp("skilllist." .. skillnodename .. ".misc", "+");
	end

	-- Call the default linkednumber init handler to make sure the field adds up correctly
	super.onInit();
end

function onSourceUpdate()
	local val = 10 + calculateSources();

	if skillnodename then
		local trainedval = NodeManager.get(window.getDatabaseNode(), "skilllist." .. skillnodename .. ".trained", 0);
		if trainedval == 1 then
			val = val + 5;
		end
	end

	setValue(val);
end

function getSkillRollStructures()
	local rCreature = CombatCommon.getActor("pc", window.getDatabaseNode());
	
	local rSkill = {};
	rSkill.name = "";
	if sourcefields then
		if sourcefields[1].skillname then
			rSkill.name = sourcefields[1].skillname[1];
		end
	end
	rSkill.mod = getValue() - 10;
	rSkill.stat = "wisdom";
	
	return rCreature, rSkill;
end

function onDrag(button, x, y, draginfo)
	if dragging then
		return true;
	end
	
	local rActor, rSkill = getSkillRollStructures();
	local skill_name, skill_dice, skill_mod = RulesManager.buildSkillRoll(rActor, rSkill);
	dragging = RulesManager.dragAction(draginfo, "skill", skill_mod, skill_name, rActor, skill_dice);
	return true;
end
					
function onDragEnd(draginfo)
	dragging = false;
end

function onDoubleClick(x,y)	
	local rActor, rSkill = getSkillRollStructures();
	local skill_name, skill_dice, skill_mod = RulesManager.buildSkillRoll(rActor, rSkill);
	return RulesManager.dclkAction("skill", skill_mod, skill_name, rActor, nil, skill_dice);
end
				
