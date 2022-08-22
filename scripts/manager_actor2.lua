-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--  DATA STRUCTURES
--
-- rActor
--		sType
--		sName
--		nodeCreature
--		sCreatureNode
--		nodeCT
-- 		sCTNode
--



function getPercentWounded(sNodeType, node)
	local nHP = 0;
	local nTemp = 0;
	local nWounds = 0;
	local nNonlethal = 0;
	
	if sNodeType == "ct" then
		nHP = NodeManager.get(node, "hp", 0);
		nTemp = NodeManager.get(node, "hptemp", 0);
		nWounds = NodeManager.get(node, "wounds", 0);
		nNonlethal = NodeManager.get(node, "nonlethal", 0);
	elseif sNodeType == "pc" then
		nHP = NodeManager.get(node, "hp.total", 0);
		nTemp = NodeManager.get(node, "hp.temporary", 0);
		nWounds = NodeManager.get(node, "hp.wounds", 0)
		nNonlethal = NodeManager.get(node, "hp.nonlethal", 0);
	end
	
	local nPercentWounded = 0;
	local nPercentNonlethal = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / nHP;

		if nTemp > 0 then
			nPercentNonlethal = (nWounds + nNonlethal) / (nHP + nTemp);
		else
			nPercentNonlethal = (nWounds + nNonlethal) / nHP;
		end
	end
	
	return nPercentWounded, nPercentNonlethal;
end

function getattributeEffectsBonus(rActor, sAttribute)
	if not rActor or not sAttribute then
		return 0, 0;
	end
	
	local sAttributeEffect = DataCommon.attribute_ltos[sAttribute];
	if not sAttributeEffect then
		return 0, 0;
	end
	
	local nattributeMod, nattributeEffects = EffectsManager.getEffectsBonus(rActor.nodeCT, sAttributeEffect, true);
	
	if EffectsManager.hasEffectCondition(rActor, "Entangled") and sAttribute == "dexterity" then
		nattributeMod = nattributeMod - 4;
		nattributeEffects = nattributeEffects + 1;
	end
	if sAttribute == "dexterity" or sAttribute == "strength" then
		if EffectsManager.hasEffectCondition(rActor, "Exhausted") then
			nattributeMod = nattributeMod - 6;
			nattributeEffects = nattributeEffects + 1;
		elseif EffectsManager.hasEffectCondition(rActor, "Fatigued") then
			nattributeMod = nattributeMod - 2;
			nattributeEffects = nattributeEffects + 1;
		end
	end
	
	local nattributeScore = getAttributeScore(rActor, sAttribute);
	if nattributeScore > 0 then
		local nAffectedScore = math.max(nattributeScore + nattributeMod, 0);
		
		local nCurrentBonus = math.floor((nattributeScore - 10) / 2);
		local nAffectedBonus = math.floor((nAffectedScore - 10) / 2);
		
		nattributeMod = nAffectedBonus - nCurrentBonus;
	else
		if nattributeMod > 0 then
			nattributeMod = math.floor(nattributeMod / 2);
		else
			nattributeMod = math.ceil(nattributeMod / 2);
		end
	end

	return nattributeMod, nattributeEffects;
end

function getSkillNodeSearch(rActor, sStatName)
  for identityname,nodeSkill in pairs(rActor.nodeCreature.getChild("skills").getChildren()) do
    if identityname ~= "holder" then
      local skillname = nodeSkill.getChild("skillname");
      if skillname and (skillname.getValue() == sStatName) then
        return nodeSkill;
      end
    end
  end
  return;
end


function getSkillScoreSearch(rActor, sStatName, sSkillMod, sDesc)
  if not rActor or not rActor.nodeCreature or not sStatName  or not sSkillMod then
    return "", 0;
  end
  local sStat = sStatName;
  local nStatScore = 0;
  if rActor.sType == "npc" then
    return   sDesc, getSkillScore(rActor, sStatName, sSkillMod, sDesc)
  elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
    for identityname,nodeSkill in pairs(rActor.nodeCreature.getChild("skills").getChildren()) do
      if identityname ~= "holder" then
        local skillname = nodeSkill.getChild("skillname");
        if skillname and (skillname.getValue() == sStatName) then
          local skillbase = nodeSkill.getChild("skillbase");
          if skillbase ~= nil then
            nStatScore = skillbase.getValue();
          end
        end
      end
    end
  elseif rActor.sType == "ct" then
 
  end
 
  return  sDesc, nStatScore;
end

function getAttribCheck(rActor, sAttrib)
    local sAttribNode = "base.attribute." .. sAttrib .. ".check"
    local sAttribCheck = NodeManager.get(rActor.nodeCreature, sAttribNode, 0);

    return sAttribCheck;
end


function getSkillScore(rActor, sStatName, sSkillMod, sDesc)
	if not rActor or not rActor.nodeCreature or not sStatName  or not sSkillMod then
		return 0;
	end
	local sStat = sStatName
	local nStatScore = 0;
	
	if rActor.sType == "npc" then
	  x = string.gsub(sStatName, "(%w+)%s+\(%w+\)", "%1");
	  local sBaseSkillName = string.gsub(sStatName, "([%w%s]*)%s%(.*%)", "%1");
    local rSkill = DataCommon.skilldata[sBaseSkillName];
    local sAttrib;
    if rSkill then
      sAttrib = rSkill.stat;
    end
    if not sAttrib then
      nStatScore = sSkillMod;
    else
      local sAttribNode = "base.attribute." .. sAttrib .. ".check"
      local sAttribCheck = NodeManager.get(rActor.nodeCreature, sAttribNode, 0);
      nStatScore = sAttribCheck + sSkillMod;
	  end
	elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
		nStatScore = NodeManager.get(rActor.nodeSkill, "skillcheck", 0);
	elseif rActor.sType == "ct" then
	
	end
	
	sDesc = sDesc .." " .. sStat .. " (" .. nStatScore .. ") "

	return sDesc, nStatScore;
end

function getPureSkillScore(rActor, sStatName, sDesc)
	if not rActor or not rActor.nodeCreature or not sStatName then
		return 0;
	end
	local sStat = sStatName
	local nStatScore = 0;
	
	if rActor.sType == "npc" then
	
	elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
			nStatScore = NodeManager.get(rActor.nodeSkill, "skillbase", 0);
			nStatScore = nStatScore + NodeManager.get(rActor.nodeSkill, "skillbonus", 0);
	elseif rActor.sType == "ct" then
	
	end
	
	sDesc = sDesc .." " .. sStat .. " (" .. nStatScore .. ") "

	return sDesc, nStatScore;
end

function getArmorRating(rActor, sArmorType)
  local nArmorValue = 0;
  if sArmorType == "Balistic Armor" then
    nArmorValue = NodeManager.get(rActor.nodeCreature, "armor.hiddenballisticvalue", 0)
  else
    nArmorValue = NodeManager.get(rActor.nodeCreature, "armor.hiddenimpactvalue", 0);
  end
  return nArmorValue;
end

function getResistScore(rActor, sStatName, sDesc)
	local sStat = sStatName
	local nStatScore = 0;
	local nModifier = 0;
  if not rActor or not rActor.sCreatureNode or not sStatName then
    return sDesc, nStatScore;
  end
  if sStatName == "Physical Spell Resist" then
    nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.body.check", 0);
    sDesc  = "Body (" .. nStatScore .. ") ";
  elseif sStatName == "Mana Spell Resist" then
    nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.willpower.check", 0);
    sDesc  = "Willpower (" .. nStatScore .. ") ";
  elseif sStatName == "Drain Resist" then
    local nWillpower = NodeManager.get(rActor.nodeCreature, "base.attribute.willpower.check", 0);
    local nAttribute = NodeManager.get(rActor.nodeCreature, "base.special.drainresistvalue", 0);
    local sAttribute = NodeManager.get(rActor.nodeCreature, "drainattributecycler", 0);
    nStatScore = nAttribute;
    sDesc  = "Willpower("..nWillpower ..")+" .. sAttribute .."(" .. nStatScore-nWillpower .. ")";
  elseif sStatName == "Ballistic Armor" then
		nStatScore = NodeManager.get(rActor.nodeCreature, "base.special.ballisticvalue", 0);
		if NodeManager.get(rActor.nodeCreature, "armorcheckmode", 0) == 1 then
			nModifier = math.ceil (NodeManager.get(rActor.nodeCreature, "armor.hiddenballisticvalue", 0) / 2);
			nStatScore = nStatScore - nModifier
			sDesc = "(half Armor -"..nModifier..")";
	  else
      sDesc = "(Ballistic Armor -"..nModifier..")";
    end
	elseif sStatName == "Impact Armor" then
		nStatScore = NodeManager.get(rActor.nodeCreature, "base.special.impactvalue", 0);
		if NodeManager.get(rActor.nodeCreature, "armorcheckmode", 0) == 1 then
			nModifier = math.ceil (NodeManager.get(rActor.nodeCreature, "armor.hiddenimpactvalue", 0) / 2);
			nStatScore = nStatScore - nModifier;
			sDesc = "(half Armor -"..nModifier..")";
		else
		  sDesc = "(Impact Armor -"..nModifier..")";
		end
  elseif sStatName == "Melee Resist" then
    nStatScore = NodeManager.get(rActor.nodeCreature, "base.special.resistvalue", 0);
    -- Melee, add WeaponSkill (Parry), Dodge skill (Dodge) or Unarmed Combat (Block)
    if rActor.sType == "pc" or rActor.sType == "charsheet" then
    -- If current weapon in a melee weapon the parry
      local nodeActiveWeapon = rActor.nodeCreature.getChild("node.activeweapon").getValue();
      local sActiveWeaponSubType = DB.findNode(nodeActiveWeapon).getChild("weaponsubtype").getValue();
      local rActiveWeapon = DataCommon.weapondata[sActiveWeaponSubType];
      if rActiveWeapon and rActiveWeapon.type == "Melee" then
        local sSkillName = rActiveWeapon.skill;
        local sDesc, nSkill = getSkillScoreSearch(rActor, sSkillName, 0, sDesc);
        
        sDesc = "Parrying"
        nStatScore = nSkill;
      end
    end
    if sDesc == "" then
      -- If Unarmed Combat skill > Dodge skill then dodge
      local nDodge = getSkillScore(rActor, "Dodge", 0, sDesc);
      local nUnarmedCombat = getSkillScore(rActor, "Unarmed Combat", 0, sDesc);
      if nDodge > nUnarmedCombat then
        sDesc = "Dodging"
        nStatScore = nDodge;
      else
      -- Otherwise block
        sDesc = "Blocking"
        nStatScore = nUnarmedCombat;
      end
    end
  elseif sStatName == "Ranged Resist" then
    nStatScore = NodeManager.get(rActor.nodeCreature, "base.special.resistvalue", 0);
	elseif sStatName == "resist Drain" then
		nStatScore = NodeManager.get(rActor.nodeCreature, "base.special.drainresistvalue", 0);
	end

	sDesc = "[Resist-Check] " .. sStat .. " (" .. nModifier .. ") Resist Value (".. nStatScore .. ") ".. sDesc .. "\n";

	return sDesc, nStatScore;
end


-- Checking if Edge is active
function getEdge(rActor, sDesc)
	local nEdgeVal = 0
	
	if not rActor or not rActor.nodeCreature then
		return sDesc, false, nEdgeVal;
	end
	bEdge = false;
	local check = 0;
	if rActor.sType == "npc" then
    check = NodeManager.get(rActor.nodeCreature, "edgecheckbox",0);
	elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
		check = NodeManager.get(rActor.nodeCreature, "edgecheckbox",0);
	elseif rActor.nodeCT then
    check = NodeManager.get(rActor.nodeCreature, "edgecheckbox",0);
	end
	
	if check == 1 then
		bEdge = true;
	else
		bEdge = false;
	end
	
	if bEdge == true then
		if NodeManager.get(rActor.nodeCreature, "base.attribute.edge.check",0) <= 0 then
		nEdgeVal = 0;
		sDesc = "[Warning! - no Edge left" .. " " .. sDesc;
		DB.findNode(rActor.sCreatureNode).getChild("edgecheckbox").setValue(0);
		else
		sDesc = "[EDGE]".." "..sDesc;
		nEdgeVal = NodeManager.get(rActor.nodeCreature, "base.attribute.edge.score",0);
		end
	end 
	
	return sDesc, bEdge, nEdgeVal;
end



function getSpecialAttributeScore(rActor, sSpecialAttribute, sDesc)
	if not rActor or not rActor.nodeCreature or not sSpecialAttribute then
		return 0;
	end
	local sStat = sSpecialAttribute
	local nStatScore = 0;
	if rActor.sType == "npc" then
	
	elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
		if sSpecialAttribute == "Composure" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.composure.check", 0);
		elseif sSpecialAttribute == "Memory" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.memory.check", 0);
		elseif sSpecialAttribute == "Judge" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.judge.check", 0);
		elseif sSpecialAttribute == "Lift" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.lift.check", 0);
		end
	elseif rActor.sType == "ct" then
	
	end
		sDesc = sDesc .. "[Spec.-ATTRIBUTE-Check] " .. sStat .. " (" .. nStatScore .. ") "
	return sDesc, nStatScore;
end


function getAttributeScore(rActor, sAttribute, sDesc)
	if not rActor or not rActor.nodeCreature or not sAttribute then
		return 0;
	end
	
	local nStatScore = 0;
	if rActor.sType == "npc" then
		if sAttribute == "Body" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.body.check", 0);
		elseif sAttribute == "Agility" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.agility.check", 0);
		elseif sAttribute == "Reaction" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.reaction.check", 0);
		elseif sAttribute == "Strength" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.strength.check", 0);
		elseif sAttribute == "Willpower" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.willpower.check", 0);
		elseif sAttribute == "Logic" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.logic.check", 0);
		elseif sAttribute == "Intuition" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.intuition.check", 0);
		elseif sAttribute == "Charisma" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.charisma.check", 0);
    elseif sAttribute == "Magic" then
      nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.magic.check",0);
    elseif sAttribute == "Edge" then
      nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.edge.check",0);
    end
	elseif rActor.sType == "pc" or rActor.sType == "charsheet" then
		if sAttribute == "Body" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.body.check", 0);
		elseif sAttribute == "Agility" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.agility.check", 0);
		elseif sAttribute == "Reaction" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.reaction.check", 0);
		elseif sAttribute == "Strength" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.strength.check", 0);
		elseif sAttribute == "Willpower" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.willpower.check", 0);
		elseif sAttribute == "Logic" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.logic.check", 0);
		elseif sAttribute == "Intuition" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.intuition.check", 0);
		elseif sAttribute == "Charisma" then
			nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.charisma.check", 0);
    elseif sAttribute == "Magic" then
      nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.magic.check",0);
    elseif sAttribute == "Edge" then
      nStatScore = NodeManager.get(rActor.nodeCreature, "base.attribute.edge.check",0);
		end
	elseif rActor.sType == "ct" then
	
	end
	return nStatScore;
end

function getAttributeBonus(rActor, sAttribute, sDesc)

	-- VALIDATE
	if not rActor or not rActor.nodeCreature or not sAttribute then
		return sDesc, 0;
	end

	-- SETUP
	local sStat = sAttribute;
	local nStatVal = 0;
	
	-- GET base.attribute VALUE
	local nStatScore = getAttributeScore(rActor, sStat);
	if nStatScore < 0 then
		return sDesc, 0;
	end
	-- Get Roll Normal, Default, Double	
	local sNDD = "1"  -- Normal Double or Default Checkmode
	sNDD = NodeManager.get(rActor.nodeCreature, "checkmode", 1);
	if sNDD ~="1" and sNDD ~="2" and sNDD ~="3" then 
		sNDD = "1"
	end
	if sNDD == "1" then
	nStatVal = nStatScore;
	sDesc = sDesc .. "[ATTRIBUTE-Check] " .. sStat .. " (" .. nStatVal .. ") "
	elseif sNDD == "2" then
	nStatVal = nStatScore - 1;
	sDesc = sDesc .."[DEFAULT-Check]" .. sStat.. "(" .. nStatVal .. ") "
	elseif sNDD == "3" then
	nStatVal = nStatScore * 2;
	sDesc = sDesc .."[DOUBLE-Check]" .. sStat.. "(" .. nStatVal .. ") "
	end	
	 if rActor.sType == "npc" then
		sDesc = rActor.sName .. ": " .. sDesc .. "\n";
	 end
	
	return sDesc, nStatVal
end

function getSustainingPenalty(rActor, nStatVal, sDesc, sStatName)
	if not StringManager.contains(DataCommon.sustainingpenalty, sStatName) then
		local sustainingpenalty = 0;
		sustainingpenalty = NodeManager.get(rActor.nodeCreature, "base.special.spellsustainedpenalty", 0);
		nStatVal = nStatVal + sustainingpenalty
			if sustainingpenalty < 0 then
			sDesc = sDesc .. " (SUST-Penalty: ".. sustainingpenalty .. ")"
			end
	end
	return sDesc, nStatVal;	
end

-- Define a shortcut function for testing
function dump(...)
  print(DataDumper.DataDumper(...), "\n---")
end


function getPenalty(rActor, nStatVal, sDesc, sStatName)
	if not StringManager.contains(DataCommon.damagepenalty, sStatName) then
		local damagepenalty = 0;
		damagepenalty = NodeManager.get(rActor.nodeCreature, "damage.all.modifier", 0);
		nStatVal = nStatVal + damagepenalty
		if damagepenalty < 0 then
		sDesc = sDesc .. "Wound Modifier: ".. damagepenalty .. "\r";
		end
	end
	return sDesc, nStatVal;
end

function getArmorPenalty(rActor, nStatVal, sDesc, sStat)
	local armorpenalty = 0;
	if sStat == "Agility" or sStat == "Reaction" then
	armorpenalty = NodeManager.get(rActor.nodeCreature, "armor.penalty", 0);
	nStatVal = nStatVal + armorpenalty
		if armorpenalty < 0 then
			sDesc = sDesc .. " (ENC-Penalty ".. armorpenalty .. ")"
		end
	end

	return sDesc, nStatVal;
end

function getRangePenalty(rActor, nValue, sDesc, sStatName, rWeaponData)
  local bCanFire = true;
  local rActorCT = ActorManager.getCTNode(rActor);
  local tokenCT = CombatManager.getTokenFromCT(rActorCT);
  
  if rActorCT and tokenCT then
    local nMinimumRange, nShortRange, nMediumRange, nLongRange, nExtremeRange  = 0,0,0,0,0;
  
    if rActor.sType == "pc" or rActor.sType == "charsheet" then
      local nodeActiveWeapon = rActor.nodeCreature.getChild("node.activeweapon").getValue();
      if nodeActiveWeapon  and DB.findNode(nodeActiveWeapon) then
        nMinimumRange =  DB.findNode(nodeActiveWeapon).getChild("weapon.minumumrange").getValue();
        nShortRange  = DB.findNode(nodeActiveWeapon).getChild("weapon.shortrange").getValue();
        nMediumRange  = DB.findNode(nodeActiveWeapon).getChild("weapon.mediumrange").getValue();
        nLongRange  = DB.findNode(nodeActiveWeapon).getChild("weapon.longrange").getValue();
        nExtremeRange  = DB.findNode(nodeActiveWeapon).getChild("weapon.extremerange").getValue();
      end
    elseif rActor.sType == "npc" then
      if rWeaponData then
        nMinimumRange =  tonumber(rWeaponData.min);
        nShortRange  = tonumber(rWeaponData.short);
        nMediumRange  = tonumber(rWeaponData.medium);
        nLongRange  = tonumber(rWeaponData.long);
        nExtremeRange  = tonumber(rWeaponData.extreme);
      else
        nMinimumRange = -1;
      end
    end
      
    local x,y = tokenCT.getPosition();
    local sImageNode = tokenCT.getContainerNode();
    local sImageNodeName = sImageNode.getNodeName();
    local rImage = NodeManager.get(sImageNodeName, "gridsize", 1);
    local sGridSize = rImage.gridsize;
    local scale = tokenCT.getScale()
  
    local aTempTargets = TargetingManager.getFullTargets(rActor);
    if #aTempTargets >= 1 then
      rActorCT = ActorManager.getCTNode(aTempTargets[1]);
      local sTargetName = aTempTargets[1].sName;
      tokenCT = CombatManager.getTokenFromCT(rActorCT);
      local tx,ty = tokenCT.getPosition();
      local dx = math.abs(tx-x)/sGridSize;
      local dy = math.abs(ty-y)/sGridSize;
      local nRange = math.floor(math.sqrt((dx*dx)+(dy*dy)));
      sDesc = sDesc .. "\nTargeting " ..  sTargetName .. " at a range of " .. nRange .."m";
 
      if nMinimumRange == -1 then
        sDesc = sDesc .. "\r";
      else
        if nRange < nMinimumRange then
          sDesc = sDesc .. " which is below the weapon's minumum range of " .. nMinimumRange .. "m\r";
          bCanFire = false;
        elseif nRange <= nShortRange then
          sDesc = sDesc .. " (short range: no penalty)\r";   
        elseif nRange <= nMediumRange then
          sDesc = sDesc .. " (medium range: -1)\r";
          nValue = nValue - 1;
        elseif nRange <= nLongRange then
          sDesc = sDesc .. " (long range: -3)\r";
          nValue = nValue - 3;
        elseif nRange <= nExtremeRange then
          sDesc = sDesc .. " (extreme range: -6)\r";
          nValue = nValue - 6;
        else
          sDesc = sDesc .. " which is beyond the weapon's extreme range of " .. nExtremeRange .. "m\r";
          bCanFire = false;
        end
      end
    end
  end
  return sDesc, nValue, bCanFire;
end

function getResistDefenseModifiers(sDesc, nStatVal, rActor, sStatName)
  if sStatName == "Impact Armor" or sStatName == "Ballistic Armor" then
    local nDefenseArmorMod = getDefenseArmorMod(rActor);
    if nDefenseArmorMod ~= 0 then
      sDesc = sDesc .. " Defense Weapon Modifier: " .. tostring(nDefenseArmorMod);
      nStatVal = nStatVal + nDefenseArmorMod;
    end
  else  
    local nDefenseResistMod = getDefenseResistMod(rActor);
    if nDefenseResistMod ~= 0 then
      sDesc = sDesc .. " Defense Weapon Modifier: " .. tostring(nDefenseResistMod);
      nStatVal = nStatVal + nDefenseResistMod;
    end
  end
   -- RESULTS
  return sDesc , nStatVal;
end

function getResistAttackModifiers(sDesc, nStatVal, rSource, sStatName)
  if sStatName == "Impact Armor" or sStatName == "Ballistic Armor" then
    local nAttackArmorMod = getAttackArmorMod(rSource);
    if nAttackArmorMod ~= 0 then
      sDesc = sDesc .. " Attack Weapon Modifier: " .. tostring(nAttackArmorMod);
      nStatVal = nStatVal + nAttackArmorMod;
    end
  else  
    local nAttackResistMod = getAttackResistMod(rSource);
    if nAttackResistMod ~= 0 then
      sDesc = sDesc .. " Attack Weapon Modifier: " .. tostring(nAttackResistMod);
      nStatVal = nStatVal + nAttackResistMod;
    end
  end
   -- RESULTS
  return sDesc , nStatVal;
end

function getModifiers(sDesc, nStatVal)
	local sStackDesc, nStackMod = ModifierStack.getStack();
		
		if sStackDesc ~= "" then
			if sDesc ~= "" then
				sDesc = sDesc .. " other Modifiers(" .. sStackDesc .. ")";
			else
				sDesc = sDesc .. " " .. sStackDesc;
			end
		end
		nStatVal = nStatVal + nStackMod
	-- RESULTS
	return sDesc , nStatVal;
end

function clearAttackData(rActor)

  local src = rActor.nodeCreature;
  NodeManager.createChild(src, "attack.damage.current", "number");
  NodeManager.set(src, "attack.damage.current", "number", 0);  
  NodeManager.createChild(src, "attack.damage.type", "string");
  NodeManager.set(src, "attack.damage.type", "string", "");  
  NodeManager.createChild(src, "attack.resistmod", "number");
  NodeManager.set(src, "attack.resistmod", "number", 0);
  NodeManager.createChild(src, "attack.type", "string");
  NodeManager.set(src, "attack.type", "string", "");  
  NodeManager.createChild(src, "attack.armormod", "number");
  NodeManager.set(src, "attack.armormod", "number", 0);  
  NodeManager.createChild(src, "attack.hits", "number");
  NodeManager.set(src, "attack.hits", "number", 0);  
  NodeManager.createChild(src, "attack.armortype", "string");
  NodeManager.set(src, "attack.armortype", "string", "");
end

function clearDefenseData(rActor)

  local src = rActor.nodeCreature;
  NodeManager.createChild(src, "defense.damage.current", "number");
  NodeManager.set(src, "defense.damage.current", "number", 0);  
  NodeManager.createChild(src, "defense.damage.type", "string");
  NodeManager.set(src, "defense.damage.type", "string", "");  
  NodeManager.createChild(src, "defense.resistmod", "number");
  NodeManager.set(src, "defense.resistmod", "number", 0);
  NodeManager.createChild(src, "defense.type", "string");
  NodeManager.set(src, "defense.type", "string", "");  
  NodeManager.createChild(src, "defense.armormod", "number");
  NodeManager.set(src, "defense.armormod", "number", 0);  
  NodeManager.createChild(src, "defense.hits", "number");
  NodeManager.set(src, "defense.hits", "number", 0);  
  NodeManager.createChild(src, "defense.armortype", "string");
  NodeManager.set(src, "defense.armortype", "string", "");

end

function copyDefenseData(rActor, rAttacker)

  local dst = DB.findNode(rActor.sCreatureNode)
  local src = DB.findNode(rAttacker.sCreatureNode);
  local nVal = 0;
  local sVal = "";
  nVal = NodeManager.get(src, "attack.damage.current", 0);
  NodeManager.createChild(dst, "defense.damage.current", "number");
  NodeManager.set(dst, "defense.damage.current", "number", nVal);
  sVal = NodeManager.get(src, "attack.damage.type", "");
  NodeManager.createChild(dst, "defense.damage.type", "string");
  NodeManager.set(dst, "defense.damage.type", "string", sVal);
  nVal = NodeManager.get(src, "attack.resistmod", 0);
  NodeManager.createChild(dst, "defense.resistmod", "number");
  NodeManager.set(dst, "defense.resistmod", "number", nVal);
  sVal = NodeManager.get(src, "attack.type", "");
  NodeManager.createChild(dst, "defense.type", "string");
  NodeManager.set(dst, "defense.type", "string", sVal);
  nVal = NodeManager.get(src, "attack.armormod", 0);
  NodeManager.createChild(dst, "defense.armormod", "number");
  NodeManager.set(dst, "defense.armormod", "number", nVal);
  nVal = NodeManager.get(src, "attack.hits", 0);
  NodeManager.createChild(dst, "defense.hits", "number");
  NodeManager.set(dst, "defense.hits", "number", nVal);
  sVal = NodeManager.get(src, "attack.armortype", "");
  NodeManager.createChild(dst, "defense.armortype", "string");
  NodeManager.set(dst, "defense.armortype", "string", sVal);
end

function setAttackDamage(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.damage.current", "number", nVal);  
end

function setAttackResistMod(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.resistmod", "number", nVal);  
end

function setAttackArmorMod(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.armormod", "number", nVal);  
end

function setAttackArmorType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.armortype", "string", sVal);
end

function setAttackHits(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.hits", "number", nVal);  
end

function setAttackDamageType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.damage.type", "string", sVal);
end

function setAttackType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.type", "string", sVal);
end

function getAttackDamage(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "attack.damage.current", 0);
  return nVal;  
end

function getAttackResistMod(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "attack.resistmod", 0);
  return nVal;  
end

function getAttackArmorMod(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "attack.armormod", 0);  
  return nVal;  
end

function getAttackArmorType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "attack.armortype", "");
  return sVal;  
end

function getAttackHits(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "attack.hits", 0);  
  return nVal;  
end

function getAttackDamageType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "attack.damage.type", "");
  return sVal;  
end

function getAttackType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "attack.type", "");
  return sVal;  
end

function setDefenseDamage(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.damage.current", "number", nVal);  
end

function setDefenseResistMod(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.resistmod", "number", nVal);  
end

function setDefenseArmorMod(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.armormod", "number", nVal);  
end

function setDefenseArmorType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.armortype", "string", sVal);
end

function setDefenseHits(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.hits", "number", nVal);  
end

function setDefenseDamageType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.damage.type", "string", sVal);
end

function setDefenseType(rActor, sVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "defense.type", "string", sVal);
end

function getDefenseDamage(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "defense.damage.current", 0);
  return nVal;  
end

function getDefenseResistMod(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "defense.resistmod", 0);
  return nVal;  
end

function getDefenseArmorMod(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "defense.armormod", 0);  
  return nVal;  
end

function getDefenseArmorType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "defense.armortype", "");
  return sVal;  
end

function getDefenseHits(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "defense.hits", 0);  
  return nVal;  
end

function getDefenseDamageType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "defense.damage.type", "");
  return sVal;  
end

function getDefenseType(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local sVal = NodeManager.get(src, "defense.type", "");
  return sVal;  
end

function setSpellDrain(rActor, nDrainVal, sDrainType)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "attack.drain", "number", nDrainVal);
  NodeManager.set(src, "attack.draintype", "string", sDrainType);
end

function getSpellDrain(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nDrainVal = NodeManager.get(src, "attack.drain", 0);
  local sDrainType = NodeManager.get(src, "attack.draintype", "");
  return nDrainVal, sDrainType;  
end

function decreaseAttackHits(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  local nHits = getAttackHits(rActor)-nVal;
  if nHits < 0 then
    nHits = 0;
  end
  setAttackHits(nHits);
end

function increaseAttackHits(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  setAttackHits(getAttackHits(rActor)+nVal)
end

function getPhysicalDamage(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "damage.physical.current", 0);
  return nVal;
end

function setPhysicalDamage(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  NodeManager.set(src, "damage.physical.current", "number", nVal);
end

function getStunDamage(rActor)
  local src = DB.findNode(rActor.sCreatureNode);
  local nVal = NodeManager.get(src, "damage.stun.current", 0);

  return nVal;
end

function setStunDamage(rActor, nVal)
  local src = DB.findNode(rActor.sCreatureNode);
  local nMax = NodeManager.get(src, "damage.stun.max", 0);
  if nVal > nMax then
    local nPhysVal = nVal - nMax;
    nVal = nMax;
    local nPhys = NodeManager.get(src, "damage.physical.current", 0);
    nPhysVal = nPhysVal + nPhys;
    setPhysicalDamage(rActor, nPhysVal);
  end
  NodeManager.set(src, "damage.stun.current", "number", nVal);
end


function getActor(sActorType, varActor)
  local rActor = ActorManager.getActor(sActorType, varActor)
  rActor.nodeCreature = DB.findNode(rActor.sCreatureNode);

  if rActor.sCTNode and rActor.sCTNode ~= "" then
    rActor.nodeCT = DB.findNode(rActor.sCTNode);
  else
    rActor.nodeCT = nil;
  end
     
  return rActor;
end

function safe()

  if type(varActor) == "string" then
    if varActor ~= "" then
      nodeActor = DB.findNode(varActor);

      -- Note: Handle cases where PC targets another PC they do not own, 
      --      which means they do not have access to PC record but they
      --    do have access to CT record.
      if not nodeActor and sActorType == "pc" then
        sActorType = "ct";
        nodeActor = CombatManager.getCTFromNode(varActor);
      end
    end
  elseif type(varActor) == "databasenode" then
    nodeActor = varActor;
  end

  if (sActorType == "npc") then
    rActor.sCTNode = CombatManager.getCTFromNode(nodeActor);
  end
 end
