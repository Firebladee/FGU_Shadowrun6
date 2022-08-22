-- This file is provided under the Open Game License version 1.0a
-- For more information on OGL and related issues, see 
--   http://www.wizards.com/d20
--
-- For information on the Fantasy Grounds d20 Ruleset licensing and
-- the OGL license text, see the d20 ruleset license in the program
-- options.
--
-- All producers of work derived from this definition are adviced to
-- familiarize themselves with the above licenses, and to take special
-- care in providing the definition of Product Identity (as specified
-- by the OGL) in their products.
--
-- Copyright 2007 SmiteWorks Ltd.
function onInit()
  super.onInit();
  checkValueValid();
  checkBurstTypeVisibility();
end

function checkValueValid()
  local sAvailableModes = window.availablemodes.getValue();
  if sAvailableModes == "" then
    return;
  end
  local sVal = self.getStringValue();
  local nVal = 0;
  if sVal ~= "" then
    nVal = tonumber(sVal);
  end
  local sLabel = "None";
  local count = 0;
  local bValid = 0;
  while count < 5 do
    if nVal == 1 then
      sLabel = "SS";
    elseif nVal == 2 then
      sLabel = "SA";
    elseif nVal == 3 then
      sLabel = "SB";
    elseif nVal == 4 then
      sLabel = "LB";
    elseif nVal == 5 then
      sLabel = "FA";
    end
    if string.match(sAvailableModes, sLabel) == nil then
      nVal = (nVal % 5) + 1;
      sVal = tostring(nVal);
    else
      bValid = 1;
    end
    count = count + 1;
    sLabel = "None";
  end
  if bValid == 0 then
    sVal = "0";
  end
  window.getDatabaseNode().createChild("firemode_str","string").setValue(sVal);
  checked = 0;
  matchData(sVal);
  updateDisplay();
end

function onValueChanged()
  checkValueValid();
  checkBurstTypeVisibility();
end

function checkBurstTypeVisibility()
  nVal = self.getStringValue();
  window.getDatabaseNode().createChild("firemode","number").setValue(tonumber(nVal));
  if nVal == "1" or nVal == "2" or nVal == "" then
    window.bursttype.setVisible(false);
  else
    window.bursttype.setVisible(true);
  end
end
