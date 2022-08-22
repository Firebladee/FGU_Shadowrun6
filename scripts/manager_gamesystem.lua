-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Ruleset action types
actions = {
  ["attribute"] = {},
  ["dice"] = {},
  ["combat"] = { sTargeting = "all" },
  ["spell"] = { sTargeting = "all" },
  ["skill"] = { sTargeting = "all" },
  ["resist"] = {},
  ["matrix"] = {},
  ["spiritopposed"] = {},
  ["spiritisopposed"] = {},
  ["specialattribute"] = { },
  ["init"] = {},
  ["table"] = { },
  ["reroll"] = { sTargeting = "all" }
  

};

targetactions = {
	"combat",
  "spell",
	"damage",
	"reroll",
	"skill"
};


currencies = { "¥" };
currencyDefault = "¥";

function getCharSelectDetailHost(nodeChar)
  local sValue = "";
  local nLevel = DB.getValue(nodeChar, "level", 0);
  if nLevel > 0 then
    sValue = "Level " .. nLevel;
  end
  return sValue;
end

function requestCharSelectDetailClient()
  return "name,#level";
end

function receiveCharSelectDetailClient(vDetails)
  return vDetails[1], "Level " .. vDetails[2];
end

function getCharSelectDetailLocal(nodeLocal)
  local vDetails = {};
  table.insert(vDetails, DB.getValue(nodeLocal, "name", ""));
  table.insert(vDetails, DB.getValue(nodeLocal, "level", 0));
  return receiveCharSelectDetailClient(vDetails);
end

function getDistanceUnitsPerGrid()
  return 1;
end

