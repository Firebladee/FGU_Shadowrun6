-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  ActionsManager.registerResultHandler("dice", onDice);
end


function onDice(rSource, rTarget, rRoll)
  if (rRoll.nRerollCount) then
    rRoll.nRerollCount = tonumber(rRoll.nRerollCount);
  end
  if (rRoll.nRerollSuccesses) then
    rRoll.nRerollSuccesses = tonumber(rRoll.nRerollSuccesses);
  end
  -- Apply target specific modifiers before roll
  if rTarget and rTarget.nOrder then
    ActionsManager.applyModifiers(rSource, rTarget, rRoll);
  end

  local rMessage, rSource, rRoll = ActionsManager2.createRollTable(rSource, rRoll);
  local nSuccesses = rRoll.nSuccesses;
  local nDrain = 0;
  rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);

 
--  rMessage.secret = false;
--  rMessage.dicesecret = false;
  
  Comm.deliverChatMessage(rMessage); 
  
  if rRoll.sType == "reroll" and rRoll.nRerollCount and rRoll.nRerollCount > 0 then
    ActionsManager2.performReroll(rSource, rRoll);
    return;
  end

end
