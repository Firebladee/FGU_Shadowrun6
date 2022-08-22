--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

--  ACTION FLOW
--
--	1. INITIATE ACTION (DRAG OR DOUBLE-CLICK)
--	2. DETERMINE TARGETS (DROP OR TARGETING SUBSYSTEM)
--	3. APPLY MODIFIERS
--	4. PERFORM ROLLS (IF ANY)
--	5. RESOLVE ACTION

-- ROLL
--		.sType
--		.sDesc
--		.aDice
--		.nValue
--                    bEdge
--



function getRollType(sDragType, nSlot)
  for k, v in pairs(aMultiHandlers) do
    if k == sDragType then
      return v(nSlot);
    end
  end

  return sDragType;
end

--
--  INITIATE ACTION
--
function performReroll(rSource, rRoll)
  rRoll.aDice = {};
  rRoll.sDesc = rRoll.sRerollDesc;
  for i = 1, rRoll.nRerollCount do
    table.insert (rRoll.aDice, "d6");
  end

  performSingleRollAction(nil, rSource, "reroll", rRoll)
end

function performOpposedRoll(rSource, rRoll)

  rRoll.aDice = {};
  rRoll.sDesc = ""
  rRoll.sDesc = "[OPPOSED] Check"

  rRoll = ActionSkill.getSpiritOpposedRoll(rSource, rRoll);

  rRoll.nValue = 0;

  performSingleRollAction(nil,rSource,"spiritisopposed", rRoll)
end




--
--  DETERMINE TARGETS
--

function handleActionDrop(draginfo, rTarget)
  if rTarget then
    local sDragType = draginfo.getType();
    local rSource, rRolls = decodeActionFromDrag(draginfo);

    lockModifiers();
    for k,v in ipairs(rRolls) do
      local sType = getRollType(sDragType, k);
      applyModifiersAndRoll(rSource, rTarget, sType, v.sDesc, v.aDice, v.nValue, false);
    end
    unlockAndResetModifiers();
  else
    handleDragDrop(draginfo, true);
  end
end

function handleActionNonDrag(rActor, sDragType, rRolls, rTarget)
  local bSingleRoll = false;
  local aTargets = {};
  if rTarget then
    table.insert(aTargets, rTarget);
  else
    for k, v in pairs(aTargetingHandlers) do
      if k == sDragType then
        aTargets, bSingleRoll = v(rActor, rRolls);
        break;
      end
    end
  end

  lockModifiers();
  local nRerollSuccesses = 0;
  local nTotalDice = 0;
  if #aTargets == 0 or bSingleRoll then
    for k, v in ipairs(rRolls) do
      local sType = getRollType(sDragType, k);
      nRerollSuccesses = v.nRerollSuccesses;
      nTotalDice = v.nTotalDice;
      applyModifiersAndRoll(rActor, aTargets, sType, v.sDesc, v.aDice, v.nValue, true, nRerollSuccesses, nTotalDice);
    end
  else
    for i = 1, #aTargets do
      for k, v in ipairs(rRolls) do
        local sType = getRollType(sDragType, k);
        applyModifiersAndRoll(rActor, aTargets[i], sType, v.sDesc, v.aDice, v.nValue, false, nRerollSuccesses, nTotalDice);
      end
    end
  end

  unlockAndResetModifiers();
end

function performSingleRollAction(draginfo, rActor, sType, rRoll, bOverride, rTarget)
  if not rRoll then
    return;
  end

  local rRolls = {};
  table.insert(rRolls, rRoll);

  ActionsManager.performMultiAction(draginfo, rActor, sType, rRolls);
end

function createRollTable(rSource, rRoll)
  local nSuccesses = 0;
  local nFailures = 0;
  local nGlitchDice = 0;
  local bNoPrint = false;
  local bEdge = false;
  local nRerollCount = 0
  local nTotalDice = 0
  local rMessage = ChatManager.createBaseMessage(rSource);
  local bNonD6 = false
  local nSuccessesCalling = 0
  local isEdge = string.match(rRoll.sDesc, "%[EDGE]");
  if isEdge then
    bEdge = true;
  end
  if rSource and rSource.sType == "pc" then
    local rCheckbox = DB.findNode(rSource.sCreatureNode).getChild("edgecheckbox")
    if rCheckbox then
      b = rCheckbox.getValue();
      if b == 1 then
        bEdge = true;
      end
    end
  end

  if bEdge == true and rSource then
    local nEdgeUsed = 0
    nEdgeUsed = DB.findNode(rSource.sCreatureNode).getChild("base.attribute.edge.mod").getValue();
    if DB.findNode(rSource.sCreatureNode).getChild("edgecheckbox").getValue() == 1 then
      nEdgeUsed = (nEdgeUsed + 1)
      DB.findNode(rSource.sCreatureNode).getChild("base.attribute.edge.mod").setValue(nEdgeUsed);
      DB.findNode(rSource.sCreatureNode).getChild("edgecheckbox").setValue(0);
    end
  end

  -- Individual Dice Handling, Trooping the Color
  if rRoll.nTotalDice then
    nTotalDice = rRoll.nTotalDice
  end
  if rRoll.nRerollSuccesses and rRoll.nRerollSuccesses > 0 then
    nSuccesses = rRoll.nRerollSuccesses
  end


  for i , v in ipairs (rRoll.aDice) do
    if rRoll.aDice[i].type ~= "d6" or rRoll.aDice[i].type ~= "d6" or rRoll.aDice[i].type ~= "d6" or rRoll.aDice[i].type ~= "d6" then
      bNonD6 = true
    elseif rRoll.aDice[i].type == "d6" then
      nTotalDice = nTotalDice + 1
      if rRoll.aDice[i].result == 6 then
        nSuccesses = nSuccesses + 1;
        nSuccessesCalling = nSuccessesCalling + 1;
        rRoll.aDice[i].type = "ddg6";
        if bEdge == true or rRoll.sType == "reroll" then
          bNoPrint = true;
          nRerollCount = nRerollCount + 1;
        end
      elseif rRoll.aDice[i].result == 5 then
        nSuccesses = nSuccesses + 1;
        nSuccessesCalling = nSuccessesCalling + 1;
        rRoll.aDice[i].type = "dhg6";
      elseif rRoll.aDice[i].result == 1 then
        nFailures = nFailures + 1;
        rRoll.aDice[i].type = "dr6";
      end
    end
  end

  if nRerollCount == 0 then
    bNoPrint = false
  end
  if bNoPrint == true then

    if rRoll.nRerollsuccesses then
      rRoll.nRerollSuccesses = rRoll.nRerollSuccesses + nSuccesses;
    else
      rRoll.nRerollSuccesses = nSuccesses
    end
    if rRoll.nTotalDice then
      rRoll.nTotalDice = nTotalDice
    end
    local isDiceTower = string.match(rRoll.sDesc, "^%[TOWER%]");
    local isGMOnly = string.match(rRoll.sDesc, "^%[GM%]");
    if isDiceTower then
      rMessage.dicesecret = true;
      rMessage.sender = "";
      rMessage.icon = "dicetower_icon";
    elseif isGMOnly then
      rMessage.dicesecret = true;
      rMessage.text = "[GM] " .. rMessage.text;
    elseif Session.IsHost and OptionsManager.isOption("REVL", "off") then
      rMessage.dicesecret = true;
      rMessage.text = "[GM] " .. rMessage.text;
    end
    if rRoll.sType ~= "reroll" then
      -- save original roll type
      rRoll.sOriginalType = rRoll.sType;
    end
    rRoll.sRerollDesc = rRoll.sDesc;
    rRoll.sDesc = "Reroll comenced";
    rRoll.nRerollCount = nRerollCount;
    rMessage.text = rRoll.sDesc;
    rMessage.dice = rRoll.aDice;
    rRoll.sType = "reroll";
    return rMessage, rSource, rRoll;
  else
    rRoll.sDesc = rRoll.sDesc .. "Total Dice Pool: " .. nTotalDice .. " " .. "\rSUCCESSES: ".. nSuccesses .. " ";
    rRoll.nSuccessesCalling = nSuccessesCalling;
    rRoll.nSuccesses = nSuccesses;

    local nHalfDice = math.ceil(nTotalDice / 2)
    if bEdge == false then
      if OptionsManager.isOption("SHGL", "on") then
        if (nSuccesses < nFailures or nHalfDice < nFailures) and nSuccesses >= 1 then
          rRoll.sDesc = rRoll.sDesc .. " ".. "[GLITCH]"
        elseif (nSuccesses < nFailures or nHalfDice < nFailures) and nSuccesses <= 0 then
          rRoll.sDesc = rRoll.sDesc .. " ".. "[CRITICAL GLITCH]"
        end
      else
        if nHalfDice <= nFailures and nSuccesses <= 0 then
          rRoll.sDesc = rRoll.sDesc .. " ".. "[CRITICAL GLITCH]"
        elseif nHalfDice <= nFailures and nSuccesses >= 1 then
          rRoll.sDesc = rRoll.sDesc .. " ".. "[GLITCH]"
        end
      end
    end
  end

  local isSpiritOpposedCheck = string.match(rRoll.sDesc, "%[SPIRIT%]")
  if isSpiritOpposedCheck then
    local isDiceTower = string.match(rRoll.sDesc, "^%[TOWER%]");
    local isGMOnly = string.match(rRoll.sDesc, "^%[GM%]");
    if isDiceTower then
      rMessage.dicesecret = true;
      rMessage.sender = "";
      rMessage.icon = "dicetower_icon";
    elseif isGMOnly then
      rMessage.dicesecret = true;
      rMessage.text = "[GM] " .. rMessage.text;
    elseif Session.IsHost and OptionsManager.isOption("REVL", "off") then
      rMessage.dicesecret = true;
      rMessage.text = "[GM] " .. rMessage.text;
    end
    rRoll.sRerollDesc = rRoll.sDesc;
    rMessage.text = rRoll.sDesc;
    rMessage.dice = rRoll.aDice;
    rRoll.sType = "spiritopposed"
    rRoll.nRerollCount = nRerollCount;
    rRoll.nSuccessesPC = nSuccesses
    return rMessage, rSource, rRoll;
  end

  rRoll.nRerollCount = nRerollCount;
  
  return rMessage, rSource, rRoll;
end

function createActionMessage(rSource, rTarget, rRoll)
  local isDiceTower = rRoll.bTower;
  --string.match(rRoll.sDesc, "^%[TOWER%]");
  local isGMOnly = rRoll.bSecret;
  --string.match(rRoll.sDesc, "^%[GM%]");
  local isInit = string.match (rRoll.sDesc, "%[INIT]");

  if isInit then
    local nInit = 0
    local sCTRolled = DB.getValue(ActorManager.getCTNode(rSource), "ctinitrolled", "2");
    if sCTRolled == 0 then
      nInit = rRoll.nSuccessesCalling
      if rRoll.nRerollSuccesses ~= nil then
        if  rRoll.nRerollSuccesses > 0 then
          nInit = nInit + rRoll.nRerollSuccesses
        end
      end
      --			  NodeManager.set(rSource.nodeCT, "initroll", "number", nInit)
      --        NodeManager.set(rSource.nodeCT, "ctinitrolled", "number", 1)
      --			  DB.setValue(ActorManager.getCTNode(rSource), "initroll", "number", nInit);
      --        DB.setValue(ActorManager.getCTNode(rSource), "ctinitrolled", "number", 1);
      ActionInit.notifyApplyInit(rSource, nInit)
    else
      rRoll.sDesc = "Sorry, Initiative already rolled for this Round";
      rRoll.aDice = {};
    end
    --		end
  end
  -- Handle GM flag and TOWER flag

  if isDiceTower then
    rSource = nil;
  elseif isGMOnly then
    rRoll.sDesc = string.sub(rRoll.sDesc, 6);
  end


  -- Build the basic message to deliver
  local rMessage = ChatManager.createBaseMessage(rSource, rRoll.sUser);
  rMessage.text = rRoll.sDesc;
  if rTarget ~= nil then
    rMessage.text = rMessage.text .. "\nTargeting " .. rTarget.sName;
  end
  rMessage.dice = rRoll.aDice;
  rMessage.diemodifier = rRoll.nValue;

  -- Check to see if this roll should be secret (GM or dice tower tag)
  if isDiceTower then
    rMessage.dicesecret = true;
    rMessage.sender = "";
    rMessage.icon = "dicetower_icon";
  elseif isGMOnly then
    rMessage.dicesecret = true;
    rMessage.text = "[GM] " .. rMessage.text;
  elseif Session.IsHost and OptionsManager.isOption("REVL", "off") then
    rMessage.dicesecret = true;
    rMessage.text = "[GM] " .. rMessage.text;
  end

  -- Show total if option enabled
  if OptionsManager.isOption("TOTL", "on") and rRoll.aDice and #(rRoll.aDice) > 0 then
    rMessage.dicedisplay = 1;
  end
  return rMessage, rSource, rRoll;
end

function total(rRoll)
  local nTotal = 0;

  for k, v in ipairs(rRoll.aDice) do
    nTotal = nTotal + v.result;
  end
  nTotal = nTotal + rRoll.nValue;

  return nTotal;
end


