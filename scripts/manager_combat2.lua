--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

CT_LIST = "combattracker.list";
CT_ROUND = "combattracker.round";
CT_PASS = "combattracker.pass";

function onInit()
	CombatManager.setCustomSort(sortfunc);
	CombatManager.setCustomCombatReset(resetInit);

	CombatManager.setCustomDrop(onDropEvent);
  CombatManager.setCustomRoundStart(onRoundStartEvent);
  CombatManager.setCustomTurnStart(onTurnStartEvent);
  CombatManager.setCustomTurnEnd(onTurnEndEvent);
  CombatManager.setCustomInitChange(onInitChangeEvent);
  CombatManager.setCustomCombatReset(onCombatResetEvent);
end

--
-- CALLBACKS
--

function onDropEvent(rSource, rTarget, draginfo)
  return true;
end
function onRoundStartEvent(nCurrent)
  clearAttackAndDefense();
  rollInit("npc")end
function onTurnStartEvent(nodeCT)
  clearAttackAndDefense();
end
function onTurnEndEvent(nodeCT)
end
function onInitChangeEvent(nodeOldCT, nodeNewCT)
end
function onCombatResetEvent()
  DB.setValue(CT_PASS, "number", 1);
 for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
    DB.setValue(vChild, "initresult", "number", 0);
    DB.setValue(vChild, "initroll", "number", 0);
    DB.setValue(vChild, "ctpassleft", "number", 0);
    DB.setValue(vChild, "ctinitrolled", "number", 0);
  end
  
end


-- NOTE: Lua sort function expects the opposite boolean value compared to built-in FG sorting
function sortfunc(node1, node2)
	local nValue1 = DB.getValue(node1, "ctinitresult", 0);
	local nValue2 = DB.getValue(node2, "ctinitresult", 0);
	if nValue1 ~= nValue2 then
		return nValue1 > nValue2;
	end

	local sValue1 = DB.getValue(node1, "name", "");
	local sValue2 = DB.getValue(node2, "name", "");
	if sValue1 ~= sValue2 then
		return sValue1 < sValue2;
	end

	return node1.getNodeName() < node2.getNodeName();
end

--
-- CLEAR ATTACK AND DEFENSE
--
function clearAttackAndDefense()
  for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
    local rActor = ActorManager.getActorFromCT(vChild);
    local rCreature = ActorManager2.getActor(nil, rActor.sCreatureNode);
    
    ActorManager2.clearAttackData(rCreature);
    ActorManager2.clearDefenseData(rCreature);
  end
end

--
-- ACTIONS
--


-- post init roll
function postInit(rSource)
--  local passbase = NodeManager.get(rSource.nodeCT, "passbase", 1);
  local passbase = DB.getValue(ActorManager.getCTNode(rSource), "passbase", 1);
  passbase = passbase + DB.getValue(ActorManager.getCTNode(rSource), "passbonus", 0);
  DB.setValue(ActorManager.getCTNode(rSource), "ctpassleft", "number", passbase);
--  NodeManager.set(rSource.nodeCT, "ctpassleft", "number", passbase);
--  DB.findNode("combattracker_props").getChild("bmaxip").setValue(0);
  return true;
end

function resetInit()
	for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
		DB.setValue(vChild, "initresult", "number", 0);
	end
end

function rollEntryInit(nodeEntry, sType)
  if not nodeEntry then
    return;
  end
  local rActor = ActorManager2.getActor(sType, nodeEntry);
  local bRolled =  NodeManager.get(rActor.nodeCreature, "ctinitrolled", 0);
  if bRolled ~= 0 then
    return;
  end

  local a = NodeManager.get (rActor.nodeCreature, "initype", "0");
  if a == "0" or a == "" then
    sAttributeStat = "ctbaseini"
  elseif a == "1" then
    sAttributeStat = "ctbaseastini"
  elseif a == "2" then
    sAttributeStat = "ctbasematini"
  elseif a == "3" then
    sAttributeStat = "ctbasehotmatini"
  end
  
  ActionInit.performRoll(draginfo, rActor, sAttributeStat);
  return true;
end

function rollInit(sType)
  for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
    local bRoll = true;
    if sType then
      local sClass,_ = DB.getValue(vChild, "link", "", "");
      if sType == "npc" and sClass == "charsheet" then
        bRoll = false;
      elseif sType == "pc" and sClass ~= "charsheet" then
        bRoll = false;
      end
    end
    
    if bRoll then
      DB.setValue(vChild, "initresult", "number", -10000);
    end
  end

  for _, vChild in pairs(DB.getChildren(CombatManager.CT_LIST)) do
    local bRoll = true;
    if sType then
      local sClass,_ = DB.getValue(vChild, "link", "", "");
      if sType == "npc" and sClass == "charsheet" then
        bRoll = false;
      elseif sType == "pc" and sClass ~= "charsheet" then
        bRoll = false;
      end
    end
    
    if bRoll then
      rollEntryInit(vChild,sType);
    end
  end
end

