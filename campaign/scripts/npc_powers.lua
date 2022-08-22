-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bParsed = false;
local aComponents = {};

-- The nDragMod and sDragLabel fields keep track of the entry under the cursor
local sDragLabel = nil;
local nDragMod = nil;
local bDragging = false;
local rDragDetail = nil;

function onInit()
  super.onInit();

end

function getCompletion(s)

	return "";
end

function parseComponents()
	aComponents = {};
	
	-- Get the comma-separated strings
	local aClauses, aClauseStats = StringManager.split(getValue(), ";\r", true);
	
	-- Check each comma-separated string for a potential skill roll or auto-complete opportunity
	for i = 1, #aClauses do
	  local nStarts, nEnds, sPower, sDetail = string.find(aClauses[i], "(%w[%w%s]*)%s%(([%w%s:/,%-%+––]*)%)");
Debug.console("nStarts, nEnds, sPower, sDetail ", nStarts, nEnds, sPower, sDetail);
    if not nStarts then 
		  nStarts, nEnds, sPower = string.find(aClauses[i], "(%w[%w%s%(%):/]*)");
      sDetail = "";
    end
		local sLabel = sPower;
		if nStarts then
			-- Calculate modifier based on mod value and sign value, if any
			local nAllowRoll = 1;
			local nMod = 0;
			if sPower == "Natural Weapon" then
        local sWeapon, dv, ap, sNotes, sReach;
        nStarts, nEnds, sWeapon, dv, ap, sNotes = 
            string.find(sDetail, "([%w%s/]*): DV (%w*), AP ([%d%-]*),?(.*)");
Debug.console("nStarts, nEnds, sWeapon, dv, ap, sNotes ", nStarts, nEnds, sWeapon, dv, ap, sNotes)
        if sNotes then
  			  local nSt, nEn, sNotes2;
  			  nSt, nEn, sReach, sNotes2 = string.find(sNotes, "%s*([%+%-––]?%d*)[%s,]?(.*)");
  			  if sSt then
Debug.console("nSt, nEn, sReach, sNotes2 ", nSt, nEn, sReach, sNotes2)
            sNotes = sNotes2;
  			  end
          local rWeaponData = {};
          nAllowRoll = 1;      
          rWeaponData.sName = sWeapon;
          sLabel = "Unarmed Combat";
          nMod = window.skills.getSkillMod(sLabel);
          rWeaponData.sWeaponType = "Melee Weapon";
          rWeaponData.sReach = sReach;
          rWeaponData.dv = dv;
          rWeaponData.ap = ap;
          rWeaponData.sFireMode = "";
          rWeaponData.rc =  "";
          rWeaponData.nAmmo = "";
          rWeaponData.sAmmoType = "";
          rWeaponData.sNotes = sNotes;
Debug.console("rWeaponData ", rWeaponData)

          table.insert(aComponents, {nStart = aClauseStats[i].startpos, nLabelEnd = aClauseStats[i].startpos + nEnds, nEnd = aClauseStats[i].endpos, sLabel = sLabel, nMod = nMod, nAllowRoll = nAllowRoll, rWeaponDetail = rWeaponData });
        else
          table.insert(aComponents, {nStart = aClauseStats[i].startpos, nLabelEnd = aClauseStats[i].startpos + nEnds, nEnd = aClauseStats[i].endpos, sLabel = sLabel, nMod = nMod, nAllowRoll = nAllowRoll });
        end
      else
        table.insert(aComponents, {nStart = aClauseStats[i].startpos, nLabelEnd = aClauseStats[i].startpos + nEnds, nEnd = aClauseStats[i].endpos, sLabel = sLabel, nMod = nMod, nAllowRoll = nAllowRoll });
			end
		end
	end
	
	bParsed = true;
end

function onChar(nKeyCode)
	bParsed = false;
	
	local nCursor = getCursorPosition();
	local sValue = getValue();
	local sCompletion;
	
	-- If alpha character, then build a potential autocomplete
	if ((nKeyCode >= 65) and (nKeyCode <= 90)) or ((nKeyCode >= 97) and (nKeyCode <= 122)) then
		-- Parse the value string
		parseComponents();

		-- Build auto-complete for the current string
		for i = 1, #aComponents, 1 do
			if nCursor == aComponents[i].nLabelEnd then
				sCompletion = getCompletion(aComponents[i].sLabel);
				if sCompletion ~= "" then
					local sNewValue = sValue:sub(1, getCursorPosition()-1) .. sCompletion .. sValue:sub(getCursorPosition());
					setValue(sNewValue);
					setSelectionPosition(nCursor + #sCompletion);
				end

				return;
			end
		end

	-- Or else if space character, then finish the autocomplete
	else
		if ((nKeyCode == 32) and (nCursor >= 2)) then
			-- Parse the value string
			parseComponents();
			
			-- Find any string we may have just auto-completed
			local nLastCursor = nCursor - 1;
			for i = 1, #aComponents, 1 do
				if nCursor - 1 == aComponents[i].nLabelEnd then
					sCompletion = getCompletion(aComponents[i].sLabel);
					if sCompletion ~= "" then
						local sNewValue = string.sub(sValue, 1, nLastCursor - 1) .. sCompletion .. string.sub(sValue, nLastCursor);
						setValue(sNewValue);
						setCursorPosition(nCursor + #sCompletion);
						setSelectionPosition(nCursor + #sCompletion);
					end

					return;
				end
			end
		end
	end
end

-- Reset selection when the cursor leaves the control
function onHover(bOnControl)
	if bDragging or bOnControl then
		return;
	end

	sDragLabel = nil;
	nDragMod = nil;
	setSelectionPosition(0);
end

-- Highlight skill hovered on
function onHoverUpdate(x, y)
	if bDragging then
		return;
	end

	if not bParsed then
		parseComponents();
	end
	local nMouseIndex = getIndexAt(x, y);

	for i = 1, #aComponents, 1 do
		if aComponents[i].nAllowRoll == 1 then
			if aComponents[i].nStart <= nMouseIndex and aComponents[i].nEnd > nMouseIndex then
				setCursorPosition(aComponents[i].nStart);
				setSelectionPosition(aComponents[i].nEnd);

        rDragDetail = aComponents[i].rWeaponDetail; 
        if rDragDetail then 
          sDragLabel = aComponents[i].sLabel;
          nDragMod = aComponents[i].nMod;
          setHoverCursor("hand");
        end
				return;
			end
		end
	end
	
	sDragLabel = nil;
	nDragMod = nil;
	setHoverCursor("arrow");
end

function action(draginfo)
  if sDragLabel then
    local rActor = ActorManager2.getActor("npc", window.getDatabaseNode());
    ActionSkill.performRoll(draginfo, rActor, sDragLabel, nDragMod, rDragDetail);
  end
end

function onDoubleClick(x, y)
	action();
	return true;
end

function onDragStart(button, x, y, draginfo)
	action(draginfo);

	bDragging = true;
	setCursorPosition(0);
	
	return true;
end

function onDragEnd(draginfo)
	bDragging = false;
end

-- Suppress default processing to support dragging
function onClickDown(button, x, y)
  parseComponents();
	return true;
end

-- On mouse click, set focus, set cursor position and clear selection
function onClickRelease(button, x, y)
	setFocus();
	
	local n = getIndexAt(x, y);
	setSelectionPosition(n);
	setCursorPosition(n);
	
	return true;
end
