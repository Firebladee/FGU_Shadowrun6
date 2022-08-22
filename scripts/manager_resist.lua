--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

OOB_MSGTYPE_RESIST = "resist";

function onInit()
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_RESIST, handleResist);

	ActionsManager.registerModHandler("resist", modRoll);
	ActionsManager.registerResultHandler("resist", onResist);

end

function handleResist(msgOOB)
  -- GET THE SOURCE ACTOR
  local rActor = ActorManager2.getActor(nil, msgOOB.sActorNode);

  -- GET THE TARGET ACTOR
  local rSource = ActorManager2.getActor(nil, msgOOB.sSourceNode);

  -- Apply the damage
  local sStatName = msgOOB.sStatName;
  local sSubType = msgOOB.sSubType;

  performRoll(nil, rActor, sStatName, rSource, sSubType);
end

function deliverResist(rActor, sStatName, rSource, sSubType)
  local sActorNode = rActor.sCreatureNode;
  local msgOOB = {};
  msgOOB.type = OOB_MSGTYPE_RESIST;
  msgOOB.sActorNode = rActor.sCreatureNode;
  msgOOB.sStatName = sStatName;
  msgOOB.sSubType = sSubType;
  if rSource then
    msgOOB.sSourceNode = rSource.sCreatureNode;
  end

  Comm.deliverOOBMessage(msgOOB, "");
end

function performRoll(draginfo, rActor, sStatName, rSource, sSubType)

	local rRoll = {};
	local nValue = 0;
	local aDice =  {};
	rRoll.sDesc = " ";
	if not rActor then
	  return;
	end
  if rSource then
    ActorManager2.copyDefenseData(rActor, rSource);
  end

  rRoll.sDefenseSubType = sSubType;
  rRoll.nDefenseDamage = ActorManager2.getDefenseDamage(rActor);
  rRoll.sDefenseDamageType = ActorManager2.getDefenseDamageType(rActor);

  if sStatName == "Resist" then
    -- Check rSource attack type
    if sSource then
      local sDefenseType = ActorManager2.getDefenseType(rActor);
      sStatName = sDefenseType .. " Resist";
    else
      sStatName = "Ranged Resist";
    end
  end

	rRoll.sDesc , nValue = ActorManager2.getResistScore(rActor, sStatName, rRoll.sDesc);

  if sStatName == "Impact Armor" or sStatName == "Ballistic Armor" then
    local nArmorRating = ActorManager2.getArmorRating(rActor, sStatName);
    if nArmorRating >= rRoll.nDefenseDamage and rRoll.sDefenseDamageType == "P" then
      rRoll.sDesc = rRoll.sDesc .. "Damage less than Armor Rating, converts to Stun\n";
      rRoll.sDefenseDamageType = "S";
      ActorManager2.setDefenseDamageType(rActor, rRoll.sDefenseDamageType);
    end
  end

  -- no wound modifiers for Spell Drain Resist.
  if sStatName ~= "Drain Resist" and rRoll.sSubType ~= "Drain Resist" then
  	rRoll.sDesc , nValue = ActorManager2.getPenalty(rActor, nValue, rRoll.sDesc, sStatName);
  end
 	rRoll.sDesc , nValue = ActorManager2.getSustainingPenalty(rActor, nValue, rRoll.sDesc, sStatName);
	rRoll.sDesc , nValue = ActorManager2.getArmorPenalty(rActor, nValue, rRoll.sDesc, sStatName);
	if rSource then
  	rRoll.sDesc , nValue = ActorManager2.getResistDefenseModifiers(rRoll.sDesc, nValue, rActor, sStatName)
	end
	rRoll.sDesc, nValue = ActorManager2.getModifiers(rRoll.sDesc, nValue);
	rRoll.sDesc, rRoll.bEdge , rRoll.nEdgeVal = ActorManager2.getEdge(rActor, rRoll.sDesc);
	nValue = nValue + rRoll.nEdgeVal;


  if nValue <= 0 then
    -- No dice.
    local nDefenseDamage = ActorManager2.getDefenseDamage(rActor);
    local nDefenseHits = ActorManager2.getDefenseHits(rActor);
    local sDefenseDamageType = ActorManager2.getDefenseDamageType(rActor);
    rRoll.nDefenseDamage = nDefenseDamage + nDefenseHits;
    ActorManager2.setDefenseDamage(rActor, rRoll.nDefenseDamage);
    ActorManager2.setDefenseHits(rActor, 0);

    rRoll.sDesc = rRoll.sDesc .. "\nNo defense dice...\nDamage after resist " .. rRoll.nDefenseDamage .. " " .. sDefenseDamageType;
  
    local rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rActor, nil, rRoll);
    rMessage.secret = false;
    rMessage.dicesecret = false;
    Comm.deliverChatMessage(rMessage);
    if rRoll.sSubType == "Melee Resist" or rRoll.sSubType == "Ranged Resist" then
      afterResist(rSource, nil, rRoll);
      return;
    end
    if rRoll.sSubType == "Impact Armor" or rRoll.sSubType == "Ballistic Armor" then

      afterArmor(rSource, nil, rRoll);
      return;
    end
    if rRoll.sSubType == "Physical Spell Resist" or rRoll.sSubType == "Mana Spell Resist" then
      afterSpellResist(rSource, nil, rRoll);
      return;
    end
    if rRoll.sSubType == "Drain Resist" or rRoll.sSubType == "Drain Resist" then
      afterDrain(rSource, nil, rRoll);
      return;
    end
    return;
  end

	-- SETUP
	for i = 1, nValue do
		table.insert (aDice, "d6");
	end
	rRoll.aDice = aDice;
	rRoll.nValue = 0;
  rRoll.nMod = 0;
  rRoll.sType = "resist";
  rRoll.sSubType = sStatName;

	ActionsManager2.performSingleRollAction(draginfo, rActor, "resist", rRoll);
end

function onResist(rSource, rTarget, rRoll)
  if not rSource.nodeCreature then
    rSource = ActorManager2.getActor(nil, rSource.sCreatureNode);
  end
  if rTarget and not rTarget.nodeCreature then
    rTarget = ActorManager2.getActor(nil, rTarget.sCreatureNode);
  end


  -- Apply target specific modifiers before roll
  if rTarget and rTarget.nOrder then
    ActionsManager.applyModifiers(rSource, rTarget, rRoll);
  end

  local rMessage, rSource, rRoll = ActionsManager2.createRollTable(rSource, rRoll);

  if rRoll.sSubType == "Melee Resist" or rRoll.sSubType == "Ranged Resist" then
    local nDefenseHits = ActorManager2.getDefenseHits(rSource);
    rRoll.nNetHits = nDefenseHits - rRoll.nSuccesses;

    if rRoll.nNetHits <= 0 then
      rRoll.sDesc = rRoll.sDesc .."\nDefender resists... no damage";
      rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
      Comm.deliverChatMessage(rMessage);
      return;
    else
      rRoll.sDesc = rRoll.sDesc .."\nNet hits after resist: " .. rRoll.nNetHits;
      rRoll.nDefenseDamage = ActorManager2.getDefenseDamage(rSource) + rRoll.nNetHits;
      rRoll.sDefenseDamageType = ActorManager2.getDefenseDamageType(rSource);
      rRoll.sDesc = rRoll.sDesc .."\nModified damage after resist: " .. rRoll.nDefenseDamage .. " " .. rRoll.sDefenseDamageType;
    end
  end
  if rRoll.sSubType == "Impact Armor" or rRoll.sSubType == "Ballistic Armor" then
    local nDefenseDamage = ActorManager2.getDefenseDamage(rSource);
    rRoll.nDefenseDamage = nDefenseDamage - rRoll.nSuccesses;
    if rRoll.nDefenseDamage <= 0 then
      rRoll.sDesc = rRoll.sDesc .."\nArmor resists... no damage";
      rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
      Comm.deliverChatMessage(rMessage);
      return;
    else
      rRoll.sDefenseDamageType = ActorManager2.getDefenseDamageType(rSource);
      rRoll.sDesc = rRoll.sDesc .."\nModified damage after armor resist: " .. rRoll.nDefenseDamage .. " " .. rRoll.sDefenseDamageType;
    end
  end
  if rRoll.sSubType == "Drain Resist" or rRoll.sSubType == "Drain Resist" then
    local nDrain, sDrainType = ActorManager2.getSpellDrain(rSource);
    rRoll.nDrainDamage = nDrain - rRoll.nSuccesses;
    if rRoll.nDrainDamage <= 0 then
      rRoll.sDesc = rRoll.sDesc .."\nResists drain... no damage";
      rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
      Comm.deliverChatMessage(rMessage);
      return;
    else
      rRoll.sDrainType = sDrainType;
      rRoll.sDesc = rRoll.sDesc .."\nModified damage after drain resist: " .. rRoll.nDrainDamage .. " " .. rRoll.sDrainType;
    end
  end
  if rRoll.sSubType == "Physical Spell Resist" or rRoll.sSubType == "Physical Spell Resist" or rRoll.sSubType == "Mana Spell Resist" or rRoll.sSubType == "Mana Spell Resist" then
    local nDefenseDamage = ActorManager2.getDefenseDamage(rSource);
    local nAttackHits = ActorManager2.getDefenseHits(rSource);
    local nNetHits = nAttackHits - rRoll.nSuccesses;
    if nNetHits <= 0 then
      rRoll.sDesc = rRoll.sDesc .."\nTarget resists... no damage";
      rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
      Comm.deliverChatMessage(rMessage);
      return;
    else
      rRoll.nDefenseDamage = nDefenseDamage + nNetHits -1;
      rRoll.sDefenseDamageType = ActorManager2.getDefenseDamageType(rSource);
      rRoll.sDesc = rRoll.sDesc .."\nModified damage after spell resist: " .. rRoll.nDefenseDamage .. " " .. rRoll.sDefenseDamageType;
    end
  end
  rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
  Comm.deliverChatMessage(rMessage);
  if rRoll.sType == "reroll" and rRoll.nRerollCount and rRoll.nRerollCount > 0 then
    ActionsManager2.performReroll(rSource, rRoll);
  end
  if rRoll.sType == "spiritopposed" then
    ActionsManager2.performOppossedRoll(rSource, rRoll)
  end

  if rRoll.sSubType == "Melee Resist" or rRoll.sSubType == "Ranged Resist" then
    afterResist(rSource, rTarget, rRoll);
    return;
  end
  if rRoll.sSubType == "Impact Armor" or rRoll.sSubType == "Ballistic Armor" then
    afterArmor(rSource, rTarget, rRoll);
    return;
  end
  if rRoll.sSubType == "Physical Spell Resist" or rRoll.sSubType == "Mana Spell Resist" then
    afterSpellResist(rSource, rTarget, rRoll);
    return;
  end
  if rRoll.sSubType == "Drain Resist" or rRoll.sSubType == "Drain Resist" then
    afterDrain(rSource, rTarget, rRoll);
    return;
  end

end

-- called when Resist Check has completed.
-- Reduce attack hits by resist hits
-- Calculate net damage
-- If Physical damage
--   Check if new damage greater than armor value, if so damage is Stun
-- make Armour check
function afterResist(rSource, rTarget, rRoll)
  ActorManager2.setDefenseDamage(rSource, rRoll.nDefenseDamage);
  local sArmorUsed = ActorManager2.getDefenseArmorType(rSource);
  if sArmorUsed == "B" then
    performRoll(nil, rSource, "Ballistic Armor", nil, rRoll.rDefenseSubType);
  elseif sArmorUsed == "I" then
    performRoll(nil, rSource, "Impact Armor", nil, rRoll.rDefenseSubType);
  elseif rRoll.sDefenseSubType == "Spellcasting" then
    NodeManager.set(rSource.nodeCreature, "armorcheckmode", "number", 1);
    performRoll(nil, rSource, "Impact Armor", nil, rRoll.rDefenseSubType);
  end
end

-- called after armour check
-- Reduce attack damage by armor hits
-- Apply damage to target.
function afterArmor(rSource, rTarget, rRoll)
  local nDefenseDamage = rRoll.nDefenseDamage;
  local sDefenseDamageType = rRoll.sDefenseDamageType;
  NodeManager.set(rSource.nodeCreature, "armorcheckmode", "number", 0);

  if sDefenseDamageType == "Physical" or sDefenseDamageType == "P"  then
    local nCurrentDamage = ActorManager2.getPhysicalDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDefenseDamage;

    ActorManager2.setPhysicalDamage(rSource, nCurrentDamage);
  else
    local nCurrentDamage = ActorManager2.getStunDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDefenseDamage;
    ActorManager2.setStunDamage(rSource, nCurrentDamage);
  end
end

-- called after Spell Resist check
-- Reduce attack damage by armor hits
-- Apply damage to target.
function afterSpellResist(rSource, rTarget, rRoll)

  local nDefenseDamage = rRoll.nDefenseDamage;
  local sDefenseDamageType = rRoll.sDefenseDamageType;

  if sDefenseDamageType == "P" then
    local nCurrentDamage = ActorManager2.getPhysicalDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDefenseDamage;

    ActorManager2.setPhysicalDamage(rSource, nCurrentDamage);
  else
    local nCurrentDamage = ActorManager2.getStunDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDefenseDamage;
    ActorManager2.setStunDamage(rSource, nCurrentDamage);
  end
end

-- called after Drain Resist check
-- Reduce drain damage by hits
-- Apply damage to target.
function afterDrain(rSource, rTarget, rRoll)
  local nDrainDamage = rRoll.nDrainDamage;
  local sDrainType = rRoll.sDrainType;

  if sDrainType == "Physical" then
    local nCurrentDamage = ActorManager2.getPhysicalDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDrainDamage;

    ActorManager2.setPhysicalDamage(rSource, nCurrentDamage);
  else
    local nCurrentDamage = ActorManager2.getStunDamage(rSource);
    nCurrentDamage = nCurrentDamage + nDrainDamage;
    ActorManager2.setStunDamage(rSource, nCurrentDamage);
  end
end