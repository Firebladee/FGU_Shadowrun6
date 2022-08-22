-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

IMAGE_GRID_MEASURE_UNITS = 1;

-- Attributes (database names)
attributes = {
	"Body",
	"Agility",
	"Reaction",
	"Strength",
	"Charisma",
	"Logic",
	"Intuition",
	"Willpower"
};

attribute_ltos = {
	["body"] = "BOD",
	["agility"] = "AGI",
	["strength"] = "STR",
	["reaction"] = "REA",
	["charisma"] = "CHA",
	["logic"] = "LOG",
	["intuition"] = "INT",
	["willpower"] = "WIL"
};

attribute_stol = {
	["BOD"] = "body",
	["AGI"] = "agility",
	["STR"] = "strength",
	["REA"] = "reaction",
	["CHA"] = "charisma",
	["LOG"] = "logic",
	["INT"] = "intuition",
	["WIL"] = "willpower"
};

-- Ruleset action types
actions = {
	"dice",
	"attribute",
	"specialattribute",
	"resist",
	"skill",
	"combat",
	"magic",
	"matrix",
	"pilot",
	"drain",
	"spirit",
	"agent",
	"init",
	"reroll", -- TRIGGERED ROLLS
	"spiritopposed",
	"spiritisopposed"
};

damagepenalty = {
	"Ballistic Armor";
	"Impact Armor";	
};

armorpenalty = {
	"Agility",
	"Reaction"
};

sustainingpenalty = {
	"resist Drain",
};


edge = {
	"attribute",
	"skill",
	"combat",
	"magic",
	"matrix",
	"pilot",
	"resist",
	"drain",
	"spirit",
	"agent",
};

modstack = {
	"attribute",
	"skill",
	"combat",
	"magic",
	"matrix",
	"pilot",
	"resist",
	"drain",
	"spirit",
	"agent",
};


targetactions = {
	"attack",
};

moddropactions = {
	"attack",
};

-- Effect components which can be targeted
targetableeffectcomps = {
	"CONC",
	"TCONC",
	"COVER",
	"SCOVER",
	"AC",
	"SAVE",
	"ATK",
	"DMG",
	"IMMUNE",
	"VULN",
	"RESIST"
};

connectors = {
	"and",
	"or"
};

-- Range types supported in power descriptions
rangetypes = {
	"melee",
	"ranged",
	"area"
};

-- Damage types supported
energytypes = {
	"acid",  		-- ENERGY DAMAGE TYPES
	"cold",
	"electricity",
	"fire",
	"sonic",
	"force",  		-- OTHER SPELL DAMAGE TYPES
	"positive",
	"negative"
};

immunetypes = {
	"acid",  		-- ENERGY DAMAGE TYPES
	"cold",
	"electricity",
	"fire",
	"sonic",
	"poison",		-- OTHER IMMUNITY TYPES
	"sleep",
	"paralysis",
	"petrification",
	"charm",
	"sleep",
	"fear",
	"disease"
};

dmgtypes = {
	"acid",  		-- ENERGY DAMAGE TYPES
	"cold",
	"electricity",
	"fire",
	"sonic",
	"force",  		-- OTHER SPELL DAMAGE TYPES
	"positive",
	"negative",
	"adamantine", 	-- WEAPON PROPERTY DAMAGE TYPES
	"bludgeoning",
	"cold iron",
	"epic",
	"magic",
	"piercing",
	"silver",
	"slashing",
	"chaotic",		-- ALIGNMENT DAMAGE TYPES
	"evil",
	"good",
	"lawful",
	"nonlethal",	-- MISC DAMAGE TYPE
	"spell"
};

-- Bonus types supported in power descriptions
bonustypes = {
	"alchemical",
	"armor",
	"circumstance",
	"competence",
	"deflection",
	"enhancement",
	"insight",
	"luck",
	"morale",
	"natural",
	"profane",
	"racial",
	"resistance",
	"sacred",
	"shield",
	"size"
};

-- Spell effects supported in spell descriptions
spelleffects = {
	"blinded",
	"confused",
	"cowering",
	"dazed",
	"dazzled",
	"deafened",
	"entangled",
	"exhausted",
	"fascinated",
	"frightened",
	"helpless",
	"invisible",
	"panicked",
	"paralyzed",
	"shaken",
	"sickened",
	"slowed",
	"stunned",
	"unconscious"
};

-- NPC damage properties
weapondmgtypes = {
	["axe"] = "slashing",
	["battleaxe"] = "slashing",
	["bolas"] = "bludgeoning,nonlethal",
	["chain"] = "piercing",
	["club"] = "bludgeoning",
	["crossbow"] = "piercing",
	["dagger"] = "piercing",
	["dart"] = "piercing",
	["falchion"] = "slashing",
	["flail"] = "bludgeoning",
	["glaive"] = "slashing",
	["greataxe"] = "slashing",
	["greatclub"] = "bludgeoning",
	["greatsword"] = "slashing",
	["guisarme"] = "slashing",
	["halberd"] = "piercing,slashing",
	["hammer"] = "bludgeoning",
	["handaxe"] = "slashing",
	["javelin"] = "piercing",
	["kama"] = "slashing",
	["kukri"] = "slashing",
	["lance"] = "piercing",
	["longbow"] = "piercing",
	["longspear"] = "piercing",
	["longsword"] = "slashing",
	["mace"] = "bludgeoning",
	["morningstar"] = "bludgeoning,piercing",
	["nunchaku"] = "bludgeoning",
	["pick"] = "piercing",
	["quarterstaff"] = "bludgeoning",
	["ranseur"] = "piercing",
	["rapier"] = "piercing",
	["sai"] = "bludgeoning",
	["sap"] = "bludgeoning,nonlethal",
	["scimitar"] = "slashing",
	["scythe"] = "piercing,slashing",
	["shortbow"] = "piercing",
	["shortspear"] = "piercing",
	["shuriken"] = "piercing",
	["siangham"] = "piercing",
	["sickle"] = "slashing",
	["sling"] = "bludgeoning",
	["spear"] = "piercing",
	["sword"] = "slashing",
	["trident"] = "piercing",
	["urgrosh"] = "piercing,slashing",
	["waraxe"] = "slashing",
	["warhammer"] = "bludgeoning",
	["whip"] = "slashing"
}

naturaldmgtypes = {
	["arm"] = "bludgeoning",
	["bite"] = "piercing,slashing,bludgeoning",
	["butt"] = "bludgeoning",
	["claw"] =  "piercing,slashing",
	["foreclaw"] =  "piercing,slashing",
	["gore"] = "piercing",
	["hoof"] = "piercing",
	["hoove"] = "piercing",
	["horn"] = "piercing",
	["pincer"] = "bludgeoning",
	["quill"] = "piercing",
	["ram"] = "bludgeoning",
	["rock"] = "bludgeoning",
	["slam"] = "bludgeoning",
	["snake"] = "piercing,slashing,bludgeoning",
	["spike"] = "piercing",
	["stamp"] = "bludgeoning",
	["sting"] = "piercing",
	["swarm"] = "piercing,slashing,bludgeoning",
	["tail"] = "bludgeoning",
	["talon"] =  "piercing,slashing",
	["tendril"] = "bludgeoning",
	["tentacle"] = "bludgeoning",
	["wing"] = "bludgeoning",
}

function tag(sName)
  local sTag = string.lower(sName);
  sTag = string.gsub(sTag, "[^%w]", "");
  return sTag;
end

function outtag(name, type, val)
  if val then
    return "<"..name.." type=\""..type.."\">" .. val .. "</"..name..">\n";
  end
  return "";
end


function dumpSkillData()
  local xmlData = "<activeskills>"

  Debug.console("dumpSkillData: ");

  for i,v in pairs(skilldata) do
    if v.stat ~= "logic" and v.stat ~= "intuition" then
--    Debug.console("dumpSpellData: ",i,v);
      local xmlData2 = "<" .. tag(i) .. ">";
      xmlData2 = xmlData2 .. outtag("name", "string", i);
      xmlData2 = xmlData2 .. outtag("category", "string",  v.category);
      xmlData2 = xmlData2 .. outtag("ability", "string",  v.stat);
      local nDefault = 0;
      if v.default == "Yes" then
        nDefault = 1;
      end
      xmlData2 = xmlData2 .. outtag("default", "number",  nDefault);
      xmlData2 = xmlData2 .. outtag("skillgroup", "string",  v.skill_group);
      local sSpecializations = "";
      for j,w in ipairs(v.specializations) do
        if sSpecializations == "" then
          sSpecializations = w;
        else
          sSpecializations = sSpecializations .. ", " .. w;
        end
      end
      xmlData2 = xmlData2 .. outtag("specializations", "string",  sSpecializations);
  
      xmlData2 = xmlData2 .. outtag("text", "formattedtext", "<p>\n</p>");
  
      xmlData2 = xmlData2 .. "</" .. tag(i) .. ">";
--    Debug.console(xmlData2);
      xmlData = xmlData .. xmlData2;
    end
  end
  xmlData = xmlData .. "</activeskills>";
  Debug.console(xmlData);
end

function dumpSkillList()
  local xmlData = "<activeskills><name type=\"string\">Active Skills</name><index>"

  Debug.console("dumpSkillData: ");

  for i,v in pairs(skilldata) do
    if v.stat ~= "logic" and v.stat ~= "intuition" then
--    Debug.console("dumpSpellData: ",i,v);
      local xmlData2 = "<" .. tag(i) .. ">";
      xmlData2 = xmlData2 .. "<listlink type=\"windowreference\"><class>referenceactiveskill</class><recordname>reference.activeskills."..tag(i).."@SR4 Basic Rules</recordname></listlink>"
      xmlData2 = xmlData2 .. outtag("name", "string", i);
  
      xmlData2 = xmlData2 .. "</" .. tag(i) .. ">";
--    Debug.console(xmlData2);
      xmlData = xmlData .. xmlData2;
    end
  end
  xmlData = xmlData .. "</index></activeskills>";
  Debug.console(xmlData);
end


function dumpSpellData(spellgroup)
  local xmlData = "<spells>"

  Debug.console("dumpSpellData: ",spelldata);

  for i,v in pairs(spelldata) do
    if v.spellgroup == spellgroup then
--    Debug.console("dumpSpellData: ",i,v);
      local xmlData2 = "<" .. tag(i) .. ">";
      xmlData2 = xmlData2 .. outtag("name", "string", i);
      xmlData2 = xmlData2 .. outtag("spellgroup", "string", v.spellgroup);
      xmlData2 = xmlData2 .. outtag("category", "string",  v.category);
      if string.find (v.category, "Indirect") then
        xmlData2 = xmlData2 .. outtag("direct", "string",  "Indirect");
      else
        xmlData2 = xmlData2 .. outtag("direct", "string",  "Direct");
      end
      xmlData2 = xmlData2 .. outtag("type", "string",  v.type);
      xmlData2 = xmlData2 .. outtag("range", "string",  v.range);
      xmlData2 = xmlData2 .. outtag("damagetype", "string",  v.damage);
      xmlData2 = xmlData2 .. outtag("duration", "string",  v.duration);
      local sDrain = string.sub(v.dv, 6);
      local nDrain = tonumber(sDrain);
      xmlData2 = xmlData2 .. outtag("drain", "number", nDrain);
      xmlData2 = xmlData2 .. outtag("text", "formattedtext", "<p>\n</p>");
  
      xmlData2 = xmlData2 .. "</" .. tag(i) .. ">";
--    Debug.console(xmlData2);
      xmlData = xmlData .. xmlData2;
    end
  end
  xmlData = xmlData .. "</spells>";
  Debug.console(xmlData);
end

function dumpSpellList(spellgroup)
  local xmlData = "<spells><name type=\"string\">Spells</name><index>"


  Debug.console("dumpSpellList: ",spelldata);

  for i,v in pairs(spelldata) do
    if v.spellgroup == spellgroup then
--    Debug.console("dumpSpellData: ",i,v);
      local xmlData2 = "<" .. tag(i) .. ">";
      xmlData2 = xmlData2 .. "<listlink type=\"windowreference\"><class>referencespell</class><recordname>reference.spells."..tag(i).."@SR4 Basic Rules</recordname></listlink>"
      xmlData2 = xmlData2 .. outtag("name", "string", i);
      xmlData2 = xmlData2 .. outtag("spellgroup", "string", v.spellgroup);
      xmlData2 = xmlData2 .. outtag("category", "string",  v.category);
      if string.find (v.category, "Indirect") then
        xmlData2 = xmlData2 .. outtag("direct", "string",  "Indirect");
      else
        xmlData2 = xmlData2 .. outtag("direct", "string",  "Direct");
      end
      xmlData2 = xmlData2 .. outtag("type", "string",  v.type);
      xmlData2 = xmlData2 .. outtag("range", "string",  v.range);
      xmlData2 = xmlData2 .. outtag("damagetype", "string",  v.damage);
      xmlData2 = xmlData2 .. outtag("duration", "string",  v.duration);
      xmlData2 = xmlData2 .. outtag("drain", "string", v.dv);
  
      xmlData2 = xmlData2 .. "</" .. tag(i) .. ">";
--    Debug.console(xmlData2);
      xmlData = xmlData .. xmlData2;
    end
  end
  xmlData = xmlData .. "</spells>";
  Debug.console(xmlData);
end
--Spell Data
spelldata = {
  ["Acid Stream"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Toxic Wave"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental, Area",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+5"
    },
  ["Punch"] = {
    spellgroup = "Combat",
    category = "Indirect, Touch",
    type = "P",
    range = "T",
    damage = "S",
    duration = "I",
    dv = "(F/2)-2"
    },
  ["Clout"] = {
    spellgroup = "Combat",
    category = "Indirect",
    type = "P",
    range = "LOS",
    damage = "S",
    duration = "I",
    dv = "(F/2)"
    },
  ["Blast"] = {
    spellgroup = "Combat",
    category = "Indirect, Area",
    type = "P",
    range = "LOS (A)",
    damage = "S",
    duration = "I",
    dv = "(F/2)+2"
    },
  ["Death Touch"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "M",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-2"
    },
  ["Manabolt"] = {
    spellgroup = "Combat",
    category = "Direct",
    type = "M",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)"
    },
  ["Manaball"] = {
    spellgroup = "Combat",
    category = "Direct, Area",
    type = "M",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+2"
    },
  ["Flamethrower"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Fireball"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental, Area",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+5"
    },
  ["Lightning Bolt"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Ball Lightning"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental, Area",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+5"
    },
  ["Shatter"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "P",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-1"
    },
  ["Powerbolt"] = {
    spellgroup = "Combat",
    category = "Direct",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+1"
    },
  ["Powerball"] = {
    spellgroup = "Combat",
    category = "Direct, Area",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Knockout"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "M",
    range = "T",
    damage = "S",
    duration = "I",
    dv = "(F/2)-3"
    },
  ["Stunbolt"] = {
    spellgroup = "Combat",
    category = "Direct",
    type = "M",
    range = "LOS",
    damage = "S",
    duration = "I",
    dv = "(F/2)-1"
    },
  ["Stunball"] = {
    spellgroup = "Combat",
    category = "Direct, Area",
    type = "M",
    range = "LOS (A)",
    damage = "S",
    duration = "I",
    dv = "(F/2)+1"
    },
  ["Corrode"] = {
    spellgroup = "Combat",
    category = "Indirect, Touch, Elemental",
    type = "P",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)"
    },
  ["Melt"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+2"
    },
  ["Sludge"] = {
    spellgroup = "Combat",
    category = "Indirect, Area, Elemental",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+4"
    },
  ["Firewater"] = {
    spellgroup = "Combat",
    category = "Indirect, Elemental",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)+5"
    },
  ["Napalm"] = {
    spellgroup = "Combat",
    category = "Indirect, Area, Elemental",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+7"
    },
  ["One Less"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "M",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-3"
    },
  ["Slay"] = {
    spellgroup = "Combat",
    category = "Direct",
    type = "M",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-1"
    },
  ["Slaughter"] = {
    spellgroup = "Combat",
    category = "Direct, Area",
    type = "M",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+1"
    },
  ["Ram"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "P",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-2"
    },
  ["Wreck"] = {
    spellgroup = "Combat",
    category = "Direct",
    type = "P",
    range = "LOS",
    damage = "P",
    duration = "I",
    dv = "(F/2)"
    },
  ["Demolish"] = {
    spellgroup = "Combat",
    category = "Direct, Area",
    type = "P",
    range = "LOS (A)",
    damage = "P",
    duration = "I",
    dv = "(F/2)+2"
    },
  ["Shattershield"] = {
    spellgroup = "Combat",
    category = "Direct, Touch",
    type = "P",
    range = "T",
    damage = "P",
    duration = "I",
    dv = "(F/2)-3"
    },
  ["Analyze Device"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Analyze Truth"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Clairaudience"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Clairvoyance"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Combat Sense"] = {
    spellgroup = "Detection",
    category = "Active, Psychic",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Detect Enemies"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Detect Enemies, Extended"] = {
    spellgroup = "Detection",
    category = "Active, Extended Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Detect Individual"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Detect Life"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Detect Life, Extended"] = {
    spellgroup = "Detection",
    category = "Active, Extended Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Detect [Life Form]"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Detect [Life Form], Extended"] = {
    spellgroup = "Detection",
    category = "Active, Extended Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Detect Magic"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Detect Magic, Extended"] = {
    spellgroup = "Detection",
    category = "Active, Extended Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Detect [Object]"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Mindlink"] = {
    spellgroup = "Detection",
    category = "Active, Psychic",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Mind Probe"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Analyze Magic"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },  
  ["Astral Clairvoyance"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Borrow Sense"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Animal Sense"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },  
  ["Eyes of the Pack"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Catalog"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Diagnose"] = {
    spellgroup = "Detection",
    category = "Active, Area",
    type = "M",
    range = "T",
    duration = "I",
    dv = "(F/2)"
    },
  ["Enhance Aim"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Hawkeye"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Mana Window"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Astral Window"] = {
    spellgroup = "Detection",
    category = "Active, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mindnet"] = {
    spellgroup = "Detection",
    category = "Active, Psychic, Area",
    type = "M",
    range = "T (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Mindnet Extended"] = {
    spellgroup = "Detection",
    category = "Active, Psychic, Extended Area",
    type = "M",
    range = "T (A)",
    duration = "S",
    dv = "(F/2)+5"
    },
  ["Night Vision"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["[Sense] Cryptesthesia"] = {
    spellgroup = "Detection",
    category = "Passive, Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Spatial Sense"] = {
    spellgroup = "Detection",
    category = "Passive, Area",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Spatial Sense, Extended"] = {
    spellgroup = "Detection",
    category = "Passive, Extended Area",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+4"
    },
  ["Thermographic Vision"] = {
    spellgroup = "Detection",
    category = "Passive, Extended Area",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
   ["Thought Recognition"] = {
    spellgroup = "Detection",
    category = "Active, Psychic/Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Area Thought Recognition"] = {
    spellgroup = "Detection",
    category = "Passive, Extended Area",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },   
  ["Translate"] = {
    spellgroup = "Detection",
    category = "Active, Psychic/Directional",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Antidote"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(Toxin DV) – 2"
    },
  ["Cure Disease"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(Disease DV) – 2"
    },
  ["Decrease [Attribute]"] = {
    spellgroup = "Health",
    category = "Negative",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Detox"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "P",
    dv = "(Toxin DV) – 4"
    },
  ["Heal"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "P",
    dv = "(Disease DV) – 2"
    },
  ["Hibernate]"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-3"
    },
  ["Increase [Attribute]"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Increase Reflexes"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Oxygenate"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Prophylaxis"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Resist Pain"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "P",
    dv = "(Damage Value) – 4"
    },
  ["Stabilize"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "P",
    dv = "(Overflow damage) – 2"
    },
  ["Alleviate Addiction"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-4"
    },
  ["Alleviate Allergy"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-4"
    },
  ["Awaken"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-4"
    },
  ["Crank"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-4"
    },
  ["Decrease Reflexes"] = {
    spellgroup = "Health",
    category = "Negative",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Enabler"] = {
    spellgroup = "Health",
    category = "Negative",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Fast"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-5"
    },
  ["Healthy Glow"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)-5"
    },
  ["Intoxication"] = {
    spellgroup = "Health",
    category = "Negative",
    type = "M",
    range = "T",
    duration = "P",
    dv = "(F/2)"
    },
  ["Nutrition"] = {
    spellgroup = "Health",
    category = "",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)"
    },
  ["Stim"] = {
    spellgroup = "Health",
    category = "",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-5"
    },
  ["Confusion"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mass Confusion"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Chaos"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Chaotic World"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Entertainment"] = {
    spellgroup = "Illusion",
    category = "Obvious, Multi-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Trid Entertainment"] = {
    spellgroup = "Illusion",
    category = "Obvious, Multi-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Invisibility"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Improved Invisibility"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Mask"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)"
    },
  ["Physical Mask"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Phantasm"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Trid Phantasm"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Hush"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Silence"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Stealth"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Agony"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Mass Agony"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)"
    },
  ["Bugs"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Swarm"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Camouflage"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Physical Camouflage"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Chaff"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Flak"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Double Image"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi -Sense",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-3"
    },
  ["Physical Double Image"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Dream"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Foreboding"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Hot Potato"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Orgasm"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Orgy"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)"
    },
  ["[Sense] Removal"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Mass [Sense] Removal"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Stink"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Stench"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)"
    },
  ["Sound Barrier"] = {
    spellgroup = "Illusion",
    category = "Realistic, Single-Sense, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Vehicle Mask"] = {
    spellgroup = "Illusion",
    category = "Realistic, Multi-Sense",
    type = "M",
    range = "T",
    duration = "S",
    dv = "(F/2)-2"
    },
  ["Armor"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Control Actions"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mob Control"] = {
    spellgroup = "Manipulation",
    category = "Mental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Control Emotions"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mob Mood"] = {
    spellgroup = "Manipulation",
    category = "Mental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Control Thoughts"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Mob Mind"] = {
    spellgroup = "Manipulation",
    category = "Mental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+4"
    },
  ["Fling"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "I",
    dv = "(F/2)+1"
    },
  ["Ice Sheet"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Ignite"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "P",
    dv = "(F/2)"
    },
  ["Influence"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "P",
    dv = "(F/2)+1"
    },
  ["Levitate"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Light"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Magic Fingers"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Mana Barrier"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Petrify"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Physical Barrier"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Poltergeist"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Shadow"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Shapechange"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["[Critter] Form"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Turn to Goo"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Alter Memory"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Alter Temperature"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Animate"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mass Animate"] = {
    spellgroup = "Manipulation",
    category = "Physical, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Astral Armor"] = {
    spellgroup = "Manipulation",
    category = "Mana",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Bind"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Net"] = {
    spellgroup = "Manipulation",
    category = "Physical, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Mana Bind"] = {
    spellgroup = "Manipulation",
    category = "Mana",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mana Net"] = {
    spellgroup = "Manipulation",
    category = "Mana, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Calm Animal"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Calm Pack"] = {
    category = "Mental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Catfall"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Clean [Element]"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "P",
    dv = "(F/2)+2"
    },
  ["Compel Truth"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Control Animal"] = {
    spellgroup = "Manipulation",
    category = "Mental",
    type = "M",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Control Pack"] = {
    spellgroup = "Manipulation",
    category = "Mental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Deflection"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["[Element] Aura"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["[Element] Wall"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+5"
    },
  ["Fashion"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)"
    },
  ["Fix"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)+1"
    },
  ["Gecko Crawl"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "T",
    duration = "S",
    dv = "(F/2)-1"
    },
  ["Glue"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Glue Strip"] = {
    spellgroup = "Manipulation",
    category = "Physical, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Interference"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Lock"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)"
    },
  ["Mana Static"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "P",
    dv = "(F/2)+4"
    },
  ["Makeover"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)"
    },
  ["Mist"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Offensive Mana Barrier"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Preserve"] = {
    spellgroup = "Manipulation",
    category = "Physical, Area",
    type = "P",
    range = "T",
    duration = "P",
    dv = "(F/2)"
    },
  ["Pulse"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "I",
    dv = "(F/2)+3"
    },
  ["Reinforce"] = {
    spellgroup = "Manipulation",
    category = "Physical",
    type = "P",
    range = "LOS",
    duration = "S",
    dv = "(F/2)+1"
    },
  ["Shape [Material]"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "P",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+3"
    },
  ["Spirit Barrier"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)"
    },
  ["Spirit Zapper"] = {
    spellgroup = "Manipulation",
    category = "Environmental, Area",
    type = "M",
    range = "LOS (A)",
    duration = "S",
    dv = "(F/2)+2"
    },
  ["Sterilize"] = {
    spellgroup = "Manipulation",
    category = "Physical, Area",
    type = "P",
    range = "LOS (A)",
    duration = "I",
    dv = "(F/2)+2"
    }
}

--Weapon Types
weapondata = {
  ["Blades"] = {
    type = "Melee",
    skill = "Blades",
    min = 0,
    short = 1,
    medium = 0,
    long = 0,
    extreme = 0
    },
  ["Clubs"] = {
    type = "Melee",
    skill = "Clubs",
    min = 0,
    short = 1,
    medium = 0,
    long = 0,
    extreme = 0
    },
  ["Exotic Melee Weapons"] = {
    type = "Melee",
    skill = "Clubs",
    min = 0,
    short = 1,
    medium = 0,
    long = 0,
    extreme = 0
    },
  ["Unarmed Combat"] = {
    type = "Melee",
    skill = "Unarmed Combat",
    min = 0,
    short = 1,
    medium = 0,
    long = 0,
    extreme = 0
    },
  ["Tasers"] = {
    type = "Firearm",
    skill = "Pistols",
    min = 0,
    short = 5,
    medium = 10,
    long = 15,
    extreme = 20
    },
  ["Hold-out Pistols"] = {
    type = "Firearm",
    skill = "Pistols",
    min = 0,
    short = 5,
    medium = 15,
    long = 30,
    extreme = 50
    },
  ["Light Pistols"] = {
    type = "Firearm",
    skill = "Pistols",
    min = 0,
    short = 5,
    medium = 15,
    long = 30,
    extreme = 50
    },
  ["Heavy Pistols"] = {
    type = "Firearm",
    skill = "Pistols",
    min = 0,
    short = 5,
    medium = 20,
    long = 40,
    extreme = 60
    },
  ["Machine Pistols"] = {
    type = "Firearm",
    skill = "Automatics",
    min = 0,
    short = 5,
    medium = 15,
    long = 30,
    extreme = 50
    },
  ["Submachine Guns"] = {
    type = "Firearm",
    skill = "Automatics",
    min = 0,
    short = 10,
    medium = 40,
    long = 80,
    extreme = 150
    },
  ["Assault Rifles"] = {
    type = "Firearm",
    skill = "Automatics",
    min = 0,
    short = 50,
    medium = 150,
    long = 350,
    extreme = 550
    },
  ["Shotguns"] = {
    type = "Firearm",
    skill = "Longarms",
    min = 0,
    short = 10,
    medium = 25,
    long = 40,
    extreme = 60
    },
  ["Shotguns"] = {
    type = "Firearm",
    skill = "Longarms",
    min = 0,
    short = 10,
    medium = 40,
    long = 80,
    extreme = 150
    },
  ["Sporting Rifles"] = {
    type = "Firearm",
    skill = "Longarms",
    min = 0,
    short = 100,
    medium = 250,
    long = 500,
    extreme = 750
    },
  ["Sniper Rifles"] = {
    type = "Firearm",
    skill = "Longarms",
    min = 0,
    short = 150,
    medium = 350,
    long = 800,
    extreme = 1500
    },
  ["Light Machine Guns"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 0,
    short = 75,
    medium = 200,
    long = 400,
    extreme = 800
    },
  ["Medium Machine Guns"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 0,
    short = 80,
    medium = 250,
    long = 750,
    extreme = 1200
    },
  ["Heavy Machine Guns"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 0,
    short = 80,
    medium = 250,
    long = 750,
    extreme = 1200
    },
  ["Assault Cannons"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 0,
    short = 100,
    medium = 300,
    long = 750,
    extreme = 1500
    },
  ["Grenade Launchers"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 5,
    short = 50,
    medium = 100,
    long = 150,
    extreme = 500
    },
  ["Missile Launchers"] = {
    type = "Firearm",
    skill = "Heavy Weapons",
    min = 20,
    short = 70,
    medium = 150,
    long = 450,
    extreme = 1500
    },
  ["Bows"] = {
    type = "Missile",
    skill = "Archery",
    min = 0,
    short = "STR",
    medium = "STRx10",
    long = "STRx30",
    extreme = "STRx60"
    },
  ["Light Crossbows"] = {
    type = "Missile",
    skill = "Archery",
    min = 0,
    short = 6,
    medium = 24,
    long = 60,
    extreme = 120
    },
  ["Medium Crossbows"] = {
    type = "Missile",
    skill = "Archery",
    min = 0,
    short = 9,
    medium = 36,
    long = 90,
    extreme = 150
    },
  ["Heavy Crossbows"] = {
    type = "Missile",
    skill = "Archery",
    min = 0,
    short = 15,
    medium = 45,
    long = 120,
    extreme = 180
    },
  ["Thrown Knives"] = {
    type = "Thrown",
    skill = "Throwing Weapons",
    min = 0,
    short = "STR",
    medium = "STRx2",
    long = "STRx3",
    extreme = "STRx5"
    },
  ["Shurikens"] = {
    type = "Thrown",
    skill = "Throwing Weapons",
    min = 0,
    short = "STR",
    medium = "STRx2",
    long = "STRx5",
    extreme = "STRx7"
    },
  ["Standard Grenades"] = {
    type = "Thrown",
    skill = "Throwing Weapons",
    min = 0,
    short = "STR",
    medium = "STRx2",
    long = "STRx4",
    extreme = "STRx6"
    },
  ["Aerodynamic Grenades"] = {
    type = "Thrown",
    skill = "Throwing Weapons",
    min = 0,
    short = "STRx2",
    medium = "STRx4",
    long = "STRx8",
    extreme = "STRx15"
    }
}


-- Skill properties
skilldata = {
--Combat Active Skills
	["Archery"] = {
	    desc = "Archery governs the use of muscle-powered projectile weapons.",
			stat = "agility",
			default = "yes",
			skill_group = "",
			specializations = {
			 "Bows",
			 "Crossbows",
			 "Slingsots"
			}
		},
	["Automatics"] = {
	    desc = "The Automatics skill governs the use of personal firearms larger than a pistol, capable of autofire, but typically with a shorter barrel than a longarm.",
      stat = "agility",
      default = "Yes",
      skill_group = "Firearms",
      specializations = {
        "Assault Rifles",
        "Carbines",
        "Machine Pistols",
        "Submachine Guns"
      }
		},
	["Blades"] = {
	    desc = "The Blades skill governs the use of hand-held melee weapons that have a sharpened edge or point. This skill allows a character to use various knives, swords, and axes effectively. This skill is used for cyber-blades implanted in the hands or forearms, but not other areas of the body. See Exotic Melee Weapons, below.",
      stat = "agility",
      default = "Yes",
      skill_group = "Close Combat",
      specializations = {
        "Axes",
        "Cyber-Implant Blades",
        "Knives",
        "Swords",
        "Parrying"
      }
	  },
  ["Clubs"] = {
      desc = "Clubs governs the use of hand-held melee weapons that have no edge or blade. This skill allows a character to use any blunt, weighted item as a weapon, from a baseball bat to a tire iron to a chair leg.",
      stat = "agility",
      default = "Yes",
      skill_group = "Close Combat",
      specializations = {
        "Batons",
        "Hammers",
        "Saps",
        "Staves (two-handed clubs)",
        "Parrying"
      }
    },
	["Dodge"] = {
      desc = "Dodge governs your ability to move out of the way of a perceived attack or other incoming threat.",
      stat = "reaction",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Melee Combat",
        "Ranged Combat"
      }
		},
	["Exotic Melee Weapon"] = {
      desc = "The Exotic Melee Weapon skill must be taken separately for each different weapon you wish to be able to use. Some examples: sais, pole arms, chainsaws, cyber-implant weapons in unusual locations (i.e., elbow spurs, foot blades).",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
      }
		},
  ["Exotic Ranged Weapon"] = {
      desc = "Like Exotic Melee Weapon, Exotic Ranged Weapon skill must be taken separately for each different weapon you wish to be able to use. Some examples: lasers, gyrojet pistols, flamethrowers, cyber-implant guns.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
      }
    },
  ["Heavy Weapons"] = {
      desc = "The Heavy Weapons skill allows the user to handle ranged projectile and launch weapons larger than an assault rifle, including large weapons when they are mounted on tripods, pintles, gyromounts, or in fixed emplacements (but not in or on vehicles).",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Assault Cannon",
        "Grenade Launchers",
        "Guided Missiles",
        "Machine Guns",
        "Rocket Launchers"
      }
    },
  ["Longarms"] = {
      desc = "This skill governs the use of all personal firearms with extended barrels, especially those designed to be used braced against the shoulder.",
      stat = "agility",
      default = "Yes",
      skill_group = "Firearms",
      specializations = {
        "Shotguns",
        "Sniper Rifles",
        "Sporting Rifles"
      }
    },
  ["Pistols"] = {
      desc = "The Pistols skill governs the use of all types of hand-held firearms, including hold-outs, light and heavy pistols, and tasers.",
      stat = "agility",
      default = "Yes",
      skill_group = "Firearms",
      specializations = {
        "Hold-Outs",
        "Revolvers",
        "Semi-Automatics",
        "Tasers"
      }
    },
  ["Throwing Weapons"] = {
      desc = "The Throwing Weapons skill governs the use of any item thrown by the user.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Lobbed (grenade-style)",
        "Overhand (baseball-style)",
        "Shuriken",
        "Throwing Knives"
      }
    },
  ["Unarmed Combat"] = {
      desc = "Unarmed Combat skill (also known as hand-to-hand combat) governs the use of combat techniques based solely on the use of the individual’s own body parts. In addition to Boxing, this skill covers such combat styles as Oriental martial arts and Brazilian Capoeira. It also covers the use of certain cyber-implants, such as shock hands.",
      stat = "agility",
      default = "Yes",
      skill_group = "Close Combat",
      specializations = {
        "Cyber-Implants",
        "Martial Arts",
        "Subdual Combat",
        "Parrying"
      }
    },
-- Magical Active Skills
  ["Arcana"] = {
      desc = "Arcana governs the practical applications of a tradition’s magical theory and the tapping of arcane potency dormant in various materials. Characters use the Arcana skill to develop new spell and magical foci formulae from scratch (rather than learning someone else’s tricks) and to produce all types of spirit formulae. Note that Arcana is available to mundanes as well as Awakened. Though they can’t put their formulations into practice, non-magical characters can design formulae just as well as magicians. See Enchanting, p. 178.",
      stat = "logic",
      default = "No",
      skill_group = "",
      specializations = {
        "Spell Design (by spell category)",
        "Focus Design (by focus type)",
        "Ally Spirit Formula",
        "Free Spirit Formula"
      }
    },
  ["Assensing"] = {
      desc = "Assensing is the skill of learning information from auras, astral forms, and astral signatures (Astral Perception, p. 191). Only characters capable of astral perception (they have the Magician quality or the Adept or Mystic Adept quality and the Astral Perception adept power) may take or use this skill.",
      stat = "intuition",
      default = "No",
      skill_group = "",
      specializations = {
        "Aura Reading",
        "Astral Signatures",
        "Psychometry by aura type (Metahumans, Spirits, Foci, Wards, etc.)",
      }
    },
  ["Astral Combat"] = {
      desc = "The Astral Combat skill is used to fight while in astral space, where normal combat methods are next to useless (Astral Combat, p. 193). Only characters capable of astral perception (they have the Magician quality or the Adept or Mystic Adept quality and the Astral Perception adept power) may take or use this skill.",
      stat = "willpower",
      default = "No",
      skill_group = "",
      specializations = {
        "By specific foci types or opponents (Weapon Foci, Magicians, Spirits, Wards, etc.)",
      }
    },
  ["Banishing"] = {
      desc = "Magicians use the Banishing skill to disrupt spirits, removing them from the physical and astral planes. See Banishing, p. 188.",
      stat = "magic",
      default = "No",
      skill_group = "Conjuring",
      specializations = {
        "By spirit type (Spirits of Air, Spirits of Fire, etc.)",
      }
    },
  ["Binding"] = {
      desc = "The Binding skill is used to ask/demand long-term services from a spirit the magician has already summoned. See Binding, p. 188.",
      stat = "magic",
      default = "No",
      skill_group = "Conjuring",
      specializations = {
        "By spirit type (Spirits of Air, Spirits of Earth, etc.)",
      }
    },
  ["Counterspelling"] = {
      desc = "Magicians use the Counterspelling skill to remove existing sustained spells from people or objects, or defend against spells cast at them or others. See Counterspelling, p. 185.",
      stat = "magic",
      default = "No",
      skill_group = "Sorcery",
      specializations = {
        "By spell type (Combat Spells, Detection Spells, etc.)",
      }
    },
  ["Enchanting"] = {
      desc = "Enchanting comprises the techniques needed to harness the latent magical potency in natural materials and the artificing of magical foci used to assist magic performance. It also includes the creation and preparation of spirit vessels and the evaluation of magical goods. See Enchanting, p. 190.",
      stat = "magic",
      default = "No",
      skill_group = "",
      specializations = {
        "Artificing",
        "Alchemy",
        "Vessel Preparation"
      }
    },
  ["Ritual Spellcasting"] = {
      desc = "The Ritual Spellcasting skill is used to cast spells in a ritual fashion (Ritual Spellcasting, p. 184). In those cases, Ritual Spellcasting is used instead of Spellcasting to determine the results.",
      stat = "magic",
      default = "No",
      skill_group = "Sorcery",
      specializations = {
        "By spell type (Combat Spells, Detection Spells, etc.)"
      }
    },
  ["Spellcasting"] = {
      desc = "The Spellcasting skill governs the control of magical energy in the form of spells. See Spellcasting, p. 182.",
      stat = "magic",
      default = "No",
      skill_group = "Sorcery",
      specializations = {
        "By spell type (Combat Spells, Detection Spells, etc.)"
      }
    },
  ["Summoning"] = {
      desc = "This skill is used to summon spirits and determines how many services they owe you. See Summoning, p. 188.",
      stat = "magic",
      default = "No",
      skill_group = "Conjuring",
      specializations = {
        "By spirit type (Spirits of Fire, Spirits of Water, etc.)"
      }
    },
-- Physical Active Skills
  ["Climbing"] = {
      desc = "Climbing is used to ascend vertical obstacles or walls, whether using tools or unassisted. See Using Climbing, p. 132.",
      stat = "strength",
      default = "Yes",
      skill_group = "Athletics",
      specializations = {
        "Assisted",
        "Freehand",
        "Rappelling",
        "by condition (rock climbing, ice climbing, building scaling, etc.)"
      }
    },
  ["Disguise"] = {
      desc = "When a character wants to take on a false appearance of some kind, she uses the Disguise skill. This is true whether she wants to look like someone else or blend into the background. See Using Disguise, p. 133.",
      stat = "intuition",
      default = "Yes",
      skill_group = "Stealth",
      specializations = {
        "Camouflage",
        "Cosmetic",
        "Theatrical",
        "Trideo"
      }
    },
  ["Diving"] = {
      desc = "This skill covers all forms of underwater diving, including underwater swimming techniques and the use of SCUBA and other underwater gear.",
      stat = "body",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Liquid Breathing Apparatus",
        "Mixed Gas",
        "Oxygen Extraction",
        "SCUBA",
        "by condition (Arctic, Cave, Commercial, Military, etc.)"
      }
    },
  ["Escape Artist"] = {
      desc = "Escape Artist comes into play whenever a character tries to slip out of bonds or shackles without using brute force. See Using Escape Artist, p. 133.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "By restraint (Ropes, Cuffs, Zip Ties, etc.)"
      }
    },
  ["Gymnastics"] = {
      desc = "Gymnastics involves acrobatics feats and balance as well as jumping, vaulting, and tumbling. See Using Jumping, p. 134.",
      stat = "agility",
      default = "Yes",
      skill_group = "Athletics",
      specializations = {
        "Balance",
        "Breakfall",
        "Dance",
        "Jumping",
        "Parkour",
        "Tumbling"
      }
    },
  ["Infiltration"] = {
      desc = "Infiltration is the skill used when a character wants to sneak around undetected by either other characters or security sensors.",
      stat = "agility",
      default = "Yes",
      skill_group = "Stealth",
      specializations = {
        "Urban",
        "Vehicle",
        "Wilderness",
        "by detection method (Motion Sensors, Pressure Pads, Thermal Imagers, etc.)"
      }
    },
  ["Navigation"] = {
      desc = "This skill governs a character’s ability to determine directions, read maps, plot a course, and stick to it without getting lost. See Using Navigation, p. 135.",
      stat = "intuition",
      default = "Yes",
      skill_group = "Outdoors",
      specializations = {
        "Desert",
        "Forest",
        "Jungle",
        "Mountain",
        "Polar",
        "Polar",
        "other appropriate terrain"
      }
    },
  ["Palming"] = {
      desc = "Those who have hands quicker than the eye can see use the Palming skill, which is as much about misdirection as it is dexterous motion. This skill is used to conceal small objects about the character or remove them from others without being noticed.",
      stat = "agility",
      default = "Yes",
      skill_group = "Stealth",
      specializations = {
        "Legerdemain",
        "Pickpocket",
        "Shoplifting"
      }
    },
  ["Parachuting"] = {
      desc = "The Parachuting skill is used when a character exits an aircraft or other high area with a parachute and wishes to stop her quick descent.",
      stat = "body",
      default = "Yes",
      skill_group = "",
      specializations = {
        "BASE Jumping",
        "HALO",
        "Low Altitude",
        "Recreational (standard skydiving)",
        "Static Line"
      }
    },
  ["Perception"] = {
      desc = "Perception is used to determine what a character notices about her surroundings that is abnormal or strange. See Using Perception, p. 135.",
      stat = "intuition",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Hearing",
        "Scent",
        "Taste",
        "Touch",
        "Visual"
      }
    },
  ["Running"] = {
      desc = "The Running skill is used to increase the distance a character can run, as well as determine how well she can pace herself and conserve energy while running. See Using Running, p. 136.",
      stat = "strength",
      default = "Yes",
      skill_group = "Athletics",
      specializations = {
        "Long Distance",
        "Sprinting",
        "Urban",
        "Wilderness"
      }
    },
  ["Shadowing"] = {
      desc = "Shadowing involves following someone else discreetly without being noticed or ensuring that you are not being followed the same way. See Using Stealth Skills, p. 136.",
      stat = "intuition",
      default = "Yes",
      skill_group = "Stealth",
      specializations = {
        "Stakeouts",
        "Tail Evasion",
        "Tailing"
      }
    },
  ["Survival"] = {
      desc = "This skill governs a character’s proficiency in surviving outdoors for an extended period of time. It determines her ability with various camping and survival gear, as well as how well she can scrounge for food and water, create makeshift shelters, and adapt to harsh natural conditions. See Using Survival, p. 137.",
      stat = "willpower",
      default = "Yes",
      skill_group = "Outdoors",
      specializations = {
        "Desert",
        "Forest",
        "Jungle",
        "Mountain",
        "Polar",
        "Urban",
        "other appropriate terrain"
      }
    },
  ["Swimming"] = {
      desc = "The Swimming skill is used to increase the distance a character can swim, and also helps determine how much experience she has had with water. See Using Swimming, p. 137.",
      stat = "strength",
      default = "Yes",
      skill_group = "Athletics",
      specializations = {
        "Long Distance",
        "Sprinting"
      }
    },
  ["Tracking"] = {
      desc = "This skill is a character’s ability to track metahumans or critters in the wild. It includes her ability to detect signs of passage, follow a trail, and locate game paths. See Using Tracking, p. 138.",
      stat = "intuition",
      default = "Yes",
      skill_group = "Outdoors",
      specializations = {
        "Desert",
        "Forest",
        "Jungle",
        "Mountain",
        "Polar",
        "Urban",
        "other appropriate terrain"
      }
    },
--Resonance Active Skills
  ["Compiling"] = {
      desc = "This skill is used to create sprites and determines how many tasks they owe you. See Sprites, p. 240.",
      stat = "resonance",
      default = "No",
      skill_group = "Tasking",
      specializations = {
        "By sprite type (Data, Machine, etc.)"
      }
    },
  ["Decompiling"] = {
      desc = "This skill is used to decompile sprites. See Sprites, p. 240.",
      stat = "resonance",
      default = "No",
      skill_group = "Tasking",
      specializations = {
        "By sprite type (Data, Machine, etc.)"
      }
    },
  ["Registering"] = {
      desc = "This skill is used to register sprites for long-term service. See Sprites, p. 240.",
      stat = "resonance",
      default = "No",
      skill_group = "Tasking",
      specializations = {
        "By sprite type (Data, Machine, etc.)"
      }
    },
--Social Active Skills
  ["Con"] = {
      desc = "Characters using the Con skill are misrepresenting the truth in some way and trying to get someone else to believe them. This may be flat out lying, evasion, or double talk, but the intended result is to have the target believe something that is false. Con Tests are opposed by the target’s Con (or Negotiation) + Intuition. See Using Charisma-Linked Skills, p. 130.",
      stat = "charisma",
      default = "Yes",
      skill_group = "Influence",
      specializations = {
        "Fast Talk",
        "Impersonation",
        "Seduction"
      }
    },
  ["Etiquette"] = {
      desc = "The Etiquette Skill allows a character to function within a specific subculture without appearing out of place. It allows the character to fit in, put suspicious or agitated people at ease, and defuse tense social situations. It also allows the player to negate a social gaffe she made that the character wouldn’t have. See Using Etiquette, p. 133.",
      stat = "charisma",
      default = "Yes",
      skill_group = "Influence",
      specializations = {
        "By culture or subculture (High Society, Street Gang, Mafia, Catholic Church, Corporate, Media, Goblin Rock, etc.)"
      }
    },
  ["Instruction"] = {
      desc = "The Instruction Skill allows a character to teach something efficiently to another character. See Using Instruction, p. 134.",
      stat = "charisma",
      default = "Yes",
      skill_group = "",
      specializations = {
        "By Active or Knowledge skill category (Combat, Language, Magical, Academic Knowledge, Street Knowledge, etc.)"
      }
    },
  ["Intimidation"] = {
      desc = "This skill allows a character to make people do what they normally might not, simply out of fear inspired by the character’s in-your-face appearance or behavior. Intimidation Tests are opposed by the target’s Intimidation + Willpower. See Using Charisma-Linked Skills (p. 130) for Intimidation Test modifiers.",
      stat = "charisma",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Interrogation",
        "Mental",
        "Physical",
        "Torture"
      }
    },
  ["Leadership"] = {
      desc = "The Leadership Skill governs a character’s ability to get others to do her bidding through the exercise of example and authority. It includes an aspect of problem-solving, but is not intended to substitute for clear thinking and good planning on the part of the players. Leadership Tests are opposed by the target’s Leadership + Charisma. See Using Charisma-Linked Skills, p. 130 for Test modifiers.",
      stat = "charisma",
      default = "Yes",
      skill_group = "Influence",
      specializations = {
        "Gut Check",
        "Morale",
        "Persuasion",
        "Strategy",
        "Tactics"
      }
    },
  ["Negotiation"] = {
      desc = "The Negotiation Skill governs the psychology and bargaining tactics used when the character deals with another and seeks to come out ahead, either through careful and deliberate bartering or through fast talk. It is opposed by the target’s Negotiation + Charisma. Negotiation can also be used to determine if a character has noticed if someone is lying to them. See Using Charisma-Linked Skills (p. 130) for Test modifiers.",
      stat = "charisma",
      default = "Yes",
      skill_group = "Influence",
      specializations = {
        "Bargaining",
        "Diplomacy",
        "Sense Motive"
      }
    },
--Technical Active Skills
  ["Aeronautics Mechanic"] = {
      desc = "Characters with this skill can repair and maintain aircraft. The proper tools and time are still necessary. See Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "No",
      skill_group = "Mechanic",
      specializations = {
        "Aerospace",
        "Fixed Wing",
        "LTA (blimp)",
        "Rotary Wing",
        "Tilt Wing",
        "Vector Thrust"
      }
    },
  ["Armorer"] = {
      desc = "This skill is used to create or repair any weapon or piece of armor for which the character has designs. Armorer also assumes that the character has access to the tools and/or equipment commonly used in that area of expertise. The character still needs time, tools, and materials to build something from scratch. Even a character with a superb level of skill can do little without the proper equipment. If the character is trying to build something new, she also needs theoretical knowledge to design the item, unless someone else provides a detailed blueprint for its construction. For Threshold determination and success results, see Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Armor",
        "Artillery",
        "Explosives",
        "Firearms",
        "Heavy Weapons",
        "Weapon Accessories"
      }
    },
  ["Artisan"] = {
      desc = "The Artisan skill represents a number of different creative skills, including singing, painting, and the like. Characters who are well-developed artistically use this skill.",
      stat = "intuition",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Carpentry",
        "Guitars",
        "Painting",
        "Sculpture",
        "other crafts"
      }
    },
  ["Automotive Mechanic"] = {
      desc = "The Automotive Mechanic skill is used to repair and maintain ground craft of all kinds. The proper tools and time are still necessary. See Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "No",
      skill_group = "Mechanic",
      specializations = {
        "Anthroform",
        "Hover",
        "Tracked",
        "Wheeled"
      }
    },
  ["Chemistry"] = {
      desc = "The Chemistry Technical Active Skill governs the use of and understanding of the properties of matter. It includes proper laboratory procedure and the ability to read chemical formulae.",
      stat = "logic",
      default = "No",
      skill_group = "",
      specializations = {
        "Compounds",
        "Drugs",
        "Toxins"
      }
    },
  ["Computer"] = {
      desc = "The Computer skill governs the use and understanding of computers and electronic devices, which in the 2070s is just about everything powered by electricity. It does not include knowledge of exploiting or subverting such systems, which is covered by the Hacking (software) or Hardware skills.",
      stat = "logic",
      default = "Yes",
      skill_group = "Electronics",
      specializations = {
        "By program (Analyze, Edit, etc.)",
        "by device type (commlink, surveillance, media, etc.)"
      }
    },
  ["Cybercombat"] = {
      desc = "Cybercombat skill is used to attack other icons in the Matrix, utilizing attack programs and system tricks. See Cybercombat, p. 236.",
      stat = "logic",
      default = "Yes",
      skill_group = "Cracking",
      specializations = {
        "By specific opponents (Persona icons, Agents, IC, Living Persona icons, Sprites, etc.)"
      }
    },
  ["Cybertechnology"] = {
      desc = "Cybertechnology is the ability to create and care for cybernetics and bioware, possessed primarily by inventors, medical professionals, and cyberdocs. This skill also includes knowledge about the current state of the field of cybertechnology and the ability to repair damaged cyberware. A proper facility and the right materials are needed to manufacture cyberware—see Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "No",
      skill_group = "Biotech",
      specializations = {
        "Bioware",
        "Bodyware",
        "Cyberlimbs",
        "Headware",
        "Nanoware"
      }
    },
  ["Data Search"] = {
      desc = "This is the character’s research ability, her ability to use search engines, databases and other tools to track down information online or in computer storage. Data Search includes the character’s ability to refine search parameters as well as her knowledge of lesser known archives and resources. See Using Data Search, p. 227.",
      stat = "logic",
      default = "Yes",
      skill_group = "Electronics",
      specializations = {
        "By source (Data Havens, Public Archives, News Indexes, Financial Records, etc.)",
        "by data type (Corporate, Celebrity Gossip, Street Rumors, Trid Footage, etc.)"
      }
    },
  ["Demolitions"] = {
      desc = "The Demolitions Skill governs the preparation, measuring, and setting of chemical explosives. See Explosives, p. 325.",
      stat = "logic",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Commercial Explosives",
        "Defusing",
        "Improvised Explosives",
        "Plastic Explosives"
      }
    },
  ["Electronic Warfare"] = {
      desc = "Electronic Warfare is used to disrupt communications in a variety of ways, such as jamming, signal degradation, or complete overtaking of control of a target’s communication systems. It is also used for encoding and decoding communications. Appropriate equipment is necessary to make use of this skill.",
      stat = "logic",
      default = "No",
      skill_group = "Cracking",
      specializations = {
        "Communications",
        "Encryption",
        "Jamming",
        "Sensor Operations"
      }
    },
  ["First Aid"] = {
      desc = "The First Aid skill governs basic medicine in a hands-on sense, as a paramedic rather than a physician. This skill provides little knowledge of cybernetics and how they function, and cannot be used to repair them.",
      stat = "logic",
      default = "Yes",
      skill_group = "Biotech",
      specializations = {
        "By type of treatment (Chemical Burns, Combat Wounds, Sports Injuries, Electric Shock, etc.)"
      }
    },
  ["Forgery"] = {
      desc = "Those who wish to make a copy of a document or other item use Forgery. Most duplicated items are in the form of art or official paper documents. See Using Forgery, p. 134.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Counterfeiting",
        "Credstick Forgery",
        "False ID",
        "Image Doctoring",
        "Paper Forgery"
      }
    },
  ["Hacking"] = {
      desc = "Hacking skill is used to exploit and subvert the programming of computers and electronics, specifically Matrix systems and interactions. For specific uses of the Hacking skill, see Hacking, p. 227.",
      stat = "logic",
      default = "Yes",
      skill_group = "Cracking",
      specializations = {
        "By program (Exploit, Sniffer, etc.)",
        "by device type (commlink, surveillance, media, etc.)"
      }
    },
  ["Hardware"] = {
      desc = "This skill governs the creation, repair, and technical manipulation of computers and electronic devices. To create something, a plan, the proper materials, and time are still needed. See Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "Yes",
      skill_group = "Electronics",
      specializations = {
        "By specific device (Commlinks, Maglocks, Sensors, etc.)"
      }
    },
  ["Industrial Mechanic"] = {
      desc = "The Industrial Mechanic skill is used to repair and maintain mechanical devices used in various industries and teaches a baseline of mechanics ability. The proper tools and time are still necessary. See Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "No",
      skill_group = "Mechanic",
      specializations = {
        "Electrical Power Systems",
        "Hydraulics",
        "Robotics",
        "Structural",
        "Welding"
      }
    },
  ["Locksmith"] = {
      desc = "Locksmith is the art of manipulating, opening, and repairing mechanical locks. See Using Locksmith, p. 135.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "By lock type (Combination, Cylinder, Pin Tumbler, Safe, etc.)"
      }
    },
  ["Medicine"] = {
      desc = "Medicine is the skill used for more detailed attempts at helping a character medically, beyond what mere First Aid can do. It includes the proper treatment of disease and illness as well as wounds. Medicine interacts with cybernetics only when they are being implanted into a body or removed from one. For more information, see Healing, p. 252.",
      stat = "logic",
      default = "No",
      skill_group = "Biotech",
      specializations = {
        "Cosmetic Surgery",
        "Extended Care",
        "Implant Surgery",
        "Magical Health",
        "Organ Culture",
        "Trauma Surgery"
      }
    },
  ["Nautical Mechanic"] = {
      desc = "The Nautical Mechanic skill is used to repair and maintain watercraft of all kinds. The proper tools and time are still necessary. See Using Technical Skills to Build or Repair, p. 138.",
      stat = "logic",
      default = "No",
      skill_group = "Mechanic",
      specializations = {
        "Motorboat",
        "Sailboat",
        "Ship",
        "Submarine"
      }
    },
  ["Software"] = {
      desc = "The Software skill comes into play when a character is writing utilities for use in the Matrix. See Using Software, p. 228.",
      stat = "logic",
      default = "No",
      skill_group = "Electronics",
      specializations = {
        "Defensive Utilities",
        "Offensive Utilities",
        "Masking Utilities",
        "Operational Utilities",
        "Special Utilities (specify)"
      }
    },
--Vehicle Active Skills
  ["Gunnery"] = {
      desc = "The Gunnery skill governs the use of all vehicle-mounted weapons, whether in mounts, pintles or turrets. This skill includes manual and sensor-enhanced gunnery.",
      stat = "agility",
      default = "Yes",
      skill_group = "",
      specializations = {
        "Artillery",
        "Ballistic",
        "Energy",
        "Guided Missile",
        "Rocket"
      }
    },
  ["Pilot Aerospace"] = {
      desc = "This skill is used to control rocket-boosted parabolic aircraft, suborbital aircraft, and anything that is piloted outside the atmosphere. This includes remote control.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
        "Deep Space",
        "Launch Craft",
        "Remote Operation",
        "Semiballistic",
        "Suborbital"
      }
    },
  ["Pilot Aircraft"] = {
      desc = "Pilot Aircraft governs the use of all aircraft piloted within the atmosphere, including those remotely controlled.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
        "Fixed-Wing",
        "Lighter-Than-Air",
        "Remote Operation",
        "Rotary Wing",
        "Tilt Wing",
        "Vectored Thrust"
      }
    },
  ["Pilot Anthroform"] = {
      desc = "This skill is used to operate any vehicle that walks on legs. It is also used if such operation is remotely controlled.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
        "Remote Operation",
        "Biped",
        "Quadruped"
      }
    },
  ["Pilot Exotic Vehicle"] = {
      desc = "This skill is used for exotic vehicles such as undersea sleds, personal lifters, jet packs, hot-air balloons, etc. Each time this skill is taken, a specific exotic vehicle must be chosen to which it applies. This skill is then used whenever piloting that vehicle, whether remotely or in person.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
      },
      sublabeling = true
    },
  ["Pilot Ground Craft"] = {
      desc = "Characters use Pilot Ground Craft to control ground vehicles without legs, whether remotely or in person.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
        "Bike",
        "Hovercraft",
        "Remote Operation",
        "Tracked",
        "Wheeled"
      }
    },
  ["Pilot Watercraft"] = {
      desc = "Pilot Watercraft is used to control water vehicles both remotely and personally.",
      stat = "reaction",
      default = "No",
      skill_group = "",
      specializations = {
        "Motorboat",
        "Remote Operation",
        "Sail",
        "Ship",
        "Submarine"
      }
    },
  ["Street Knowledge"] = {
       sublabeling = true,
       stat = "intuition",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    },
  ["Interest"] = {
       sublabeling = true,
       stat = "intuition",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    },
  ["Acedemic Knowledge"] = {
       sublabeling = true,
       stat = "logic",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    },
  ["Professional Knowledge"] = {
       sublabeling = true,
       stat = "logic",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    },
  ["Knowledge"] = {
       sublabeling = true,
       stat = "logic",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    },
  ["Language"] = {
       sublabeling = true,
       stat = "logic",
       defaul = "No",
       skill_group = "",
       specializations = {
       "Any"
       }
    }
}
