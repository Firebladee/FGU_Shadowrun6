-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
OOB_MSGTYPE_APPLYINIT = "applyinit";

function onInit()
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYINIT, handleApplyInit);

  ActionsManager.registerResultHandler("init", onInitiative);
end


function handleApplyInit(msgOOB)
  local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
  local nSuccesses = tonumber(msgOOB.nSuccesses) or 0;

  DB.setValue(ActorManager.getCTNode(rSource), "initroll", "number", nSuccesses);
  DB.setValue(ActorManager.getCTNode(rSource), "ctinitrolled", "number", 1);
  local passbase = DB.getValue(ActorManager.getCTNode(rSource), "passbase", 1);
  passbase = passbase + DB.getValue(ActorManager.getCTNode(rSource), "passbonus", 0);
  DB.setValue(ActorManager.getCTNode(rSource), "ctpassleft", "number", passbase);
end

function notifyApplyInit(rSource, nSuccesses)
  if not rSource then
    return;
  end
  
  local msgOOB = {};
  msgOOB.type = OOB_MSGTYPE_APPLYINIT;
  
  msgOOB.nSuccesses = nSuccesses;

  local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
  msgOOB.sSourceType = sSourceType;
  msgOOB.sSourceNode = sSourceNode;

  Comm.deliverOOBMessage(msgOOB, "");
end

function performRoll(draginfo, rActor, sAttributeStat)
	local rRoll = {};
	local nValue = 0;
	local aDice =  {};
	local sInitType = " "
	
  nValue = NodeManager.get (rActor.nodeCreature, sAttributeStat, "0");
	if sAttributeStat == "base.attribute.ini.check" or sAttributeStat == "ctbaseini" then
		sInitType = NodeManager.set(rActor.nodeCreature, "initype", "string" , "0");
		rRoll.sDesc = "[INIT] Check Mundane "
	elseif sAttributeStat == "base.attribute.astini.check" or sAttributeStat == "ctbaseastini" then
		sInitType = NodeManager.set(rActor.nodeCreature, "initype", "string" , "1");
		rRoll.sDesc = "[INIT] Check Astral "
	elseif sAttributeStat == "base.attribute.matini.check" or sAttributeStat == "ctbasematini" then
		sInitType = NodeManager.set(rActor.nodeCreature, "initype", "string" , "2");
		rRoll.sDesc = "[INIT] Check Matrix "
	elseif sAttributeStat == "base.attribute.hotmatini.check" or sAttributeStat == "ctbasehotmatini" then
		sInitType = NodeManager.set(rActor.nodeCreature, "initype", "string" ,"3");
		rRoll.sDesc = "[INIT] Check Matrix (HOTSIM)"
	end

	
	rRoll.sDesc , nValue = ActorManager2.getPenalty(rActor, nValue, rRoll.sDesc);
	rRoll.sDesc , nValue = ActorManager2.getSustainingPenalty(rActor, nValue, rRoll.sDesc);
	rRoll.sDesc , nValue = ActorManager2.getArmorPenalty(rActor, nValue, rRoll.sDesc, sAttributeStat);	
	rRoll.sDesc, nValue = ActorManager2.getModifiers(rRoll.sDesc, nValue)
	rRoll.sDesc, rRoll.bEdge , rRoll.nEdgeVal = ActorManager2.getEdge(rActor, rRoll.sDesc);
	nValue = nValue + rRoll.nEdgeVal
	-- SETUP
	for i = 1, nValue do
		table.insert (aDice, "d6");
	end
	rRoll.aDice = aDice;
	rRoll.nValue = 0;
	rRoll.nMod = 0;
	rRoll.sType = "init";
	
	ActionsManager2.performSingleRollAction(draginfo, rActor, "init", rRoll);
end



function onInitiative(rSource, rTarget, rRoll)
  -- Apply target specific modifiers before roll
  rSource.nodeCreature = DB.findNode(rSource.sCreatureNode);
  if rSource.sCTNode ~= "" then
    rSource.nodeCT = DB.findNode(rSource.sCTNode);
  else
    rSource.nodeCT = nil;
  end
  if rTarget ~= nil then
    rTarget.nodeCreature = DB.findNode(rTarget.sCreatureNode);
    if rTarget.sCTNode ~= "" then
      rTarget.nodeCT = DB.findNode(rTarget.sCTNode);
    else
      rTarget.nodeCT = nil;
    end
  end
  if rTarget and rTarget.nOrder then
    ActionsManager.applyModifiers(rSource, rTarget, rRoll);
  end

  local rMessage, rSource, rRoll = ActionsManager2.createRollTable(rSource, rRoll);
  rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);

  Comm.deliverChatMessage(rMessage); 
  if rRoll.sType == "reroll" and rRoll.nRerollCount then
  ActionsManager2.performReroll(rSource, rRoll);
  end
  if rRoll.sType == "spiritopposed" then
  ActionsManager2.performOppossedRoll(rSource, rRoll)
  end
end


function onResolve(rSource, rTarget, rRoll)
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  Comm.deliverChatMessage(rMessage);
  
  local nSuccesses = ActionsManager.total(rRoll);
  notifyApplyInit(rSource, nSuccesses);
end
