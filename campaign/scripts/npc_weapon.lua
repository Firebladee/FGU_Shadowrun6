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


function getCompletion(s)

	return "";
end

function isWeaponTypeMelee(sWeaponType)
  if sWeaponType == "Blades" or sWeaponType == "Clubs" or sWeaponType == "Exotic Melee Weapon" or sWeaponType == "Unarmed Combat" then
    return true;
  else
    return false;
  end
end

function isWeaponTypeRanged(sWeaponType)
  if sWeaponType == "Hold-out Pistols" or
    sWeaponType == "Light Pistols" or
    sWeaponType == "Heavy Pistols" or
    sWeaponType == "Machine Pistols" or
    sWeaponType == "Submachine Guns" or
    sWeaponType == "Assault Rifles" or
    sWeaponType == "Shotguns" or
    sWeaponType == "Shotgun (slug)s" or
    sWeaponType == "Sporting Rifles" or
    sWeaponType == "Sniper Rifles" or
    sWeaponType == "Light Machine Guns" or
    sWeaponType == "Medium Machine Guns" or
    sWeaponType == "Heavy Machine Guns" or
    sWeaponType == "Assault Cannons" or
    sWeaponType == "Grenade Launchers" or
    sWeaponType == "Missile Launchers" or
    sWeaponType == "Bows" or
    sWeaponType == "Light Crossbows" or
    sWeaponType == "Medium Crossbows" or
    sWeaponType == "Heavy Crossbows" or
    sWeaponType == "Thrown Knifes" or
    sWeaponType == "Shurikens" or
    sWeaponType == "Standard Grenades" or
    sWeaponType == "Aerodynamic Grenades" then
    return true;
  else
    return false;
  end
end

function parseComponents()
	aComponents = {};
	
	-- Get the comma-separated strings
	local aClauses, aClauseStats = StringManager.split(getValue(), ";\r", true);
	
	-- Check each comma-separated string for a potential skill roll or auto-complete opportunity
	for i = 1, #aClauses do
		local nStarts, nEnds, sLabel, sDesc = string.find(aClauses[i], "([%w%s-_]*)%s([%[%(].+[%]%)])");
		if nStarts then
			-- Calculate modifier based on mod value and sign value, if any
			local nAllowRoll = 0;
			local nMod = 0;
			local rWeaponData;
			local sWeaponType, dv, ap, sFireMode, rc, nAmmo, sAmmoType, sNotes, sReach;


			if sDesc ~= "" then
				sDesc = string.sub(sDesc, 2, (string.len(sDesc)-1));
				local nSt, nEn, sWeaponType, sNotes = 
					string.find(sDesc, "([%w%s]*), (.*)");
				if sWeaponType == "SMG" then
					sWeaponType = "Submachine Guns";
				elseif sWeaponType == "LMG" then
					sWeaponType = "Light Machine Guns";
				elseif sWeaponType == "MMG" then
					sWeaponType = "Medium Machine Guns";
				elseif sWeaponType == "HMG" then
					sWeaponType = "Heavy Machine Guns";
				end
				if sWeaponType and sWeaponType ~= "Unarmed Combat" and string.sub(sWeaponType, -1) ~= "s" then
					sWeaponType = sWeaponType .. "s";
				end

				if isWeaponTypeRanged(sWeaponType) then
		-- Ranged weapon  "Heavy Pistols, DV 5P, AP -1, SA, RC 0, 16(c), smartgun"
					local nSt, nEn;
					nSt, nEn, dv, ap, sFireMode, rc, nAmmo, sAmmoType, sNotes = 
								string.find(sNotes, "DV (%w*\[(ef\)]*), AP ([%d%-�]*), ([%w/]*), RC ([%d%-–]*), (%d*)%((%w*)%)(.*)");
			Debug.console("parseComponents: ", nSt, nEn, dv, ap, sFireMode, rc, nAmmo, sAmmoType, sNotes);
								elseif isWeaponTypeMelee(sWeaponType) then
			-- Melee Weapon  "Blades, Reach 0, DV 3P, AP -1"
					local nSt, nEn;
					nSt, nEn, sReach, dv, ap, sNotes = 
						string.find(sNotes, "Reach ([%w%s]*), DV (%w*), AP ([%d%-–]*)(.*)");

				end
				rWeaponData = DataCommon.weapondata[sWeaponType];
				local rWeaponDetail = {};
				if rWeaponData and dv then
					nAllowRoll = 1;      
					rWeaponDetail.type = rWeaponData.type;
					rWeaponDetail.skill = rWeaponData.skill;
					rWeaponDetail.min = rWeaponData.min;
					rWeaponDetail.short = rWeaponData.short;
					rWeaponDetail.medium = rWeaponData.medium;
					rWeaponDetail.long = rWeaponData.long;
					rWeaponDetail.extreme = rWeaponData.extreme;
					
					rWeaponDetail.sName = sLabel;
					sLabel = rWeaponData.skill;				
					nMod = window.skills.getSkillMod(sLabel);
					rWeaponDetail.sWeaponType = sWeaponType;
					rWeaponDetail.sReach = sReach;
					rWeaponDetail.dv = dv;
					rWeaponDetail.ap = ap;
					rWeaponDetail.sFireMode = sFireMode;
					rWeaponDetail.rc =  rc;
					rWeaponDetail.nAmmo = nAmmo;
					rWeaponDetail.sAmmoType = sAmmoType;
					rWeaponDetail.sNotes = sNotes;
								end
			-- Insert the possible skill into the skill list
			table.insert(aComponents, {nStart = aClauseStats[i].startpos, nLabelEnd = aClauseStats[i].startpos + nEnds, nEnd = aClauseStats[i].endpos, sLabel = sLabel, nMod = nMod, nAllowRoll = nAllowRoll, rWeaponDetail = rWeaponDetail });
			Debug.console("aComponents: ", aComponents);
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

-- Hilight skill hovered on
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
				sDragLabel = aComponents[i].sLabel;
				nDragMod = aComponents[i].nMod;
				setHoverCursor("hand");
				Debug.console("onHoverUpdate: ", i, aComponents[i].nStart, nMouseIndex, rDragDetail)
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
Debug.console("action: ", draginfo, rActor, sDragLabel, nDragMod, rDragDetail);
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
