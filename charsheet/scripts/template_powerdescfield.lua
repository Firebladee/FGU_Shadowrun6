-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

local parsed = false;
local abilities = {};

local dragging = nil;
local hoverAbility = nil;
local clickAbility = nil;

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	
	if gmonly and not Session.IsHost then
		setReadOnly(true);
	end
end

function onValueChanged()
	parsed = false;
end

function onEnter()
	if Input.isShiftPressed() then
		if window.windowlist and window.windowlist.onEnter then
			window.windowlist.onEnter();
		end
		return true;
	else
		-- RETURNING FALSE DOES NOT PERFORM DEFAULT BEHAVIOR AS DOCUMENTED.
		--return false;
		
		local nCursor = getCursorPosition();
		local nSelection = getSelectionPosition();
		if nSelection >= nCursor then
			local sValue = getValue();
			sValue = string.sub(sValue, 1, nCursor - 1) .. "\r" .. string.sub(sValue, nSelection);
			setValue(sValue);
			setCursorPosition(nCursor + 1);
		else
			local sValue = getValue();
			sValue = string.sub(sValue, 1, nSelection - 1) .. "\r" .. string.sub(sValue, nCursor);
			setValue(sValue);
			setCursorPosition(nSelection + 1);
		end
		setSelectionPosition(0);
		return true;
	end
end

function onHover(oncontrol)
	if dragging then
		return;
	end

	-- Reset selection when the cursor leaves the control
	if not oncontrol then
		hoverAbility = nil;
		
		--setCursorPosition(0);
		setSelectionPosition(0);
	end
end

function parseComponents()
	local sCreatureName = "";
	if self.getCreatureName then
		sCreatureName = self.getCreatureName();
	end
	abilities = PowersManager.parsePowerDescription(window.getDatabaseNode(), sCreatureName, getName());
end

function onHoverUpdate(x, y)
	-- If we're typing or dragging, then exit
	if dragging then
		return;
	end

	-- Compute the locations of the relevant phrases, and the mouse
	if not parsed then
		parsed = true;
		parseComponents();
	end
	local mouse_index = getIndexAt(x, y);

	-- Clear any memory of the last hover update
	hoverAbility = nil;

	-- Hilight attack or damage hovered on
	for i = 1, #abilities do
		if abilities[i].startpos <= mouse_index and abilities[i].endpos > mouse_index then
			setCursorPosition(abilities[i].startpos);
			setSelectionPosition(abilities[i].endpos);

			hoverAbility = i;			

			setHoverCursor("hand");

			return;
		end
	end

	setHoverCursor("arrow");
	--setCursorPosition(0);
end

function getRollStructures(rOriginalAbility)
	local rCreature = nil;
	if self.getCreatureType and self.getCreatureNode then
		rCreature = CombatCommon.getActor(self.getCreatureType(), self.getCreatureNode());
	end
	
	local rAbility = rOriginalAbility;
	rAbility.name = NodeManager.get(window.getDatabaseNode(), "name", "");
	rAbility.range = "";
	if window.powertype then
		rAbility.range = string.upper(NodeManager.get(window.getDatabaseNode(), "powertype", ""));
	end
	if rAbility.range == "" and window.range then
		local listRangeWords = StringManager.parseWords(string.lower(NodeManager.get(window.getDatabaseNode(), "range", "")));
		if StringManager.isWord(listRangeWords[1], "melee") then
			rAbility.range = "M";
		elseif StringManager.isWord(listRangeWords[1], "ranged") then
			rAbility.range = "R";
		elseif StringManager.isWord(listRangeWords[1], "close") then
			rAbility.range = "C";
		elseif StringManager.isWord(listRangeWords[1], "area") then
			rAbility.range = "A";
		else
			rAbility.range = "";
		end
	end
	
	local rFocus = nil;
	if rAbility.type == "attack" or rAbility.type == "damage" then
		local keywords = string.lower(window.keywords.getValue());
		if string.match(keywords, "weapon") and self.getWeaponRecord then
			rFocus = self.getWeaponRecord(rAbility.type);
		end
		if string.match(keywords, "implement") and self.getImplementRecord then
			rFocus = self.getImplementRecord(rAbility.type);
		end
	end
	
	return rCreature, rAbility, rFocus;
end

function getEffectStructures(rAbility)
	local rActor = nil;
	if self.getCreatureType and self.getCreatureNode then
		rActor = CombatCommon.getActor(self.getCreatureType(), self.getCreatureNode());
	end

	local rEffect = {};
	rEffect.sName = EffectsManager.evalEffect(rActor, rAbility.name);
	rEffect.sExpire = rAbility.expire;
	rEffect.nSaveMod = rAbility.mod;
	rEffect.sApply = rAbility.sApply;
	rEffect.sTargeting = rAbility.sTargeting;
	
	if rActor and rActor.nodeCT then
		rEffect.sSource = rActor.sCTNode;
		rEffect.nInit = NodeManager.get(rActor.nodeCT, "initresult", "");
	else
		rEffect.sSource = "";
		rEffect.nInit = 0;
	end
	
	return rActor, rEffect;
end

function handleDoubleClick(rAbility)
	-- Decide what to do based on the ability type
	if rAbility.type == "attack" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildAttackRoll(rActor, rTempAbility, rFocus);
		RulesManager.dclkAction("attack", mod, label, rActor, nil, dice);

	elseif rAbility.type == "damage" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildDamageRoll(rActor, rTempAbility, rFocus);
		RulesManager.dclkAction("damage", mod, label, rActor, nil, dice);

	elseif rAbility.type == "heal" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildHealRoll(rActor, rTempAbility, rFocus);
		RulesManager.dclkAction("damage", mod, label, rActor, nil, dice);
	
	elseif rAbility.type == "effect" then
		local rActor, rEffect = getEffectStructures(rAbility);
		return RulesManager.dclkEffect(rActor, rEffect);
	end
end

function handleDrag(rAbility, draginfo)
	-- Build the draginfo basics based on the ability type
	if rAbility.type == "attack" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildAttackRoll(rActor, rTempAbility, rFocus);
		return RulesManager.dragAction(draginfo, "attack", mod, label, rActor, dice);
		
	elseif rAbility.type == "damage" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildDamageRoll(rActor, rTempAbility, rFocus);
		return RulesManager.dragAction(draginfo, "damage", mod, label, rActor, dice);
		
	elseif rAbility.type == "heal" then
		local rActor, rTempAbility, rFocus = getRollStructures(rAbility);
		local label, dice, mod = RulesManager.buildHealRoll(rActor, rTempAbility, rFocus);
		return RulesManager.dragAction(draginfo, "damage", mod, label, rActor, dice);

	elseif rAbility.type == "effect" then
		local rActor, rEffect = getEffectStructures(rAbility);
		return RulesManager.dragEffect(draginfo, rActor, rEffect);
	end
end

function onClickDown(button, x, y)
	-- Suppress default processing to support dragging
	clickAbility = hoverAbility;
	
	return true;
end

function onClickRelease(button, x, y)
	-- Enable edit mode on mouse release
	setFocus();
	
	local n = getIndexAt(x, y);
	
	setSelectionPosition(n);
	setCursorPosition(n);
	
	return true;
end

function onDoubleClick(x, y)
	if hoverAbility then
		handleDoubleClick(abilities[hoverAbility]);
		
		return true;
	end
end

function onDrag(button, x, y, draginfo)
	if dragging then
		return true;
	end

	if clickAbility then
		handleDrag(abilities[clickAbility], draginfo);
		
		clickAbility = nil;
		dragging = true;
		return true;
	end
	
	return true;
end

function onDragEnd(dragdata)
	setCursorPosition(0);
	dragging = false;
end
