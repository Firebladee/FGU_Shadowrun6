-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("specialattribute", modRoll);
  ActionsManager.registerResultHandler("specialattribute", onSpecialAttribute);
end

function performRoll(draginfo, rActor, sAttributeStat)
	local rRoll = {};
	local nValue = 0;
	local aDice =  {};
	rRoll.sDesc = rActor.nodeCreature.getChild("name").getValue() .. " -> "
	rRoll.sDesc , nValue = ActorManager2.getSpecialAttributeScore(rActor, sAttributeStat, rRoll.sDesc);
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
	rRoll.sType = "specialattribute"
	
	ActionsManager2.performSingleRollAction(draginfo, rActor, "attribute", rRoll);
end

function onSpecialAttribute(rSource, rTarget, rRoll)
  -- Apply target specific modifiers before roll
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