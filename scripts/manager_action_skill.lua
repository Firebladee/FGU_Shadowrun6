-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("skill", modRoll);
  ActionsManager.registerModHandler("combat", modRoll);
  ActionsManager.registerModHandler("matrix", modRoll);
  ActionsManager.registerModHandler("spell", modRoll);
  ActionsManager.registerModHandler("spiritopposed", modRoll);
  ActionsManager.registerModHandler("spiritisopposed", modRoll);
	
  ActionsManager.registerResultHandler("skill", onSkill);
  ActionsManager.registerResultHandler("combat", onSkill);
  ActionsManager.registerResultHandler("matrix", onSkill);
	ActionsManager.registerResultHandler("spell", onSkill);
  ActionsManager.registerResultHandler("spiritopposed", onSkill);
  ActionsManager.registerResultHandler("spiritisopposed", onSkill);
  ActionsManager.registerResultHandler("reroll", onReroll);
end

function isSkillRangedAttack(sLabel)
  if sLabel == "Archery" or
    sLabel == "Automatics" or
    sLabel == "Exotic Ranged Weapon" or
    sLabel == "Heavy Weapons" or
    sLabel == "Longarms" or
    sLabel == "Pistols" or
    sLabel == "Throwing Weapons" then
    return true;
  else
    return false;
  end
end

function isSkillMeleeAttack(sLabel)
  if sLabel == "Blades" or
    sLabel == "Clubs" or
    sLabel == "Exotic Melee Weapon" or
    sLabel == "Unarmed Combat" then
    return true;
  else
    return false;
  end
end

function isSkillBallisticAttack(sLabel)
  if sLabel == "Archery" or
    sLabel == "Automatics" or
    sLabel == "Exotic Ranged Weapon" or
    sLabel == "Heavy Weapons" or
    sLabel == "Longarms" or
    sLabel == "Pistols" then
    return true;
  else
    return false;
  end
end

function isSkillImpactAttack(sLabel)
  if sLabel == "Blades" or
    sLabel == "Clubs" or
    sLabel == "Exotic Melee Weapon" or
    sLabel == "Unarmed Combat" or
    sLabel == "Throwing Weapons" then
    return true;
  else
    return false;
  end
end

function isSkillAttack(sLabel)
  if sLabel == "Archery" or
    sLabel == "Automatics" or
    sLabel == "Blades" or
    sLabel == "Clubs" or
    sLabel == "Exotic Melee Weapon" or
    sLabel == "Exotic Ranged Weapon" or
    sLabel == "Heavy Weapons" or
    sLabel == "Longarms" or
    sLabel == "Pistols" or
    sLabel == "Throwing Weapons" or
    sLabel == "Unarmed Combat" then
    return true;
  else
    return false;
  end
end

function getNpcWeaponData(rActor, rRoll, nValue, rWeaponData)
  local nDamage = 0;
  local nWeaponBonus = 0;
  if rWeaponData then
    local sWeaponName = rWeaponData.sName;
    local nWeaponBonus = 0;
    local sBurstType = ""; 
    rRoll.sDesc = rRoll.sDesc.."\rUsing " .. sWeaponName .. " (Bonus: ".. nWeaponBonus .. ")\r";
    nValue = nValue + nWeaponBonus;
    -- Show what firemode is being used       
    if rWeaponData.type == "Firearm" then
      if rWeaponData.sFireMode == "SS" or
        rWeaponData.sFireMode == "SA" then
        rRoll.sDesc = rRoll.sDesc .. "Firing 1 round (single)\r";
      elseif rWeaponData.sFireMode == "SB" then
        -- NPCs only use wide burts for now...
        ActorManager2.setAttackResistMod(rActor, -2);       
        sBurstType = ", wide";
        rRoll.sDesc = rRoll.sDesc .. "Firing 3 rounds (short"..sBurstType .. " burst)\r";
      elseif rWeaponData.sFireMode == "SNB" then
        nDamage = nDamage + 2;
        sBurstType = ", narrow";
        rRoll.sDesc = rRoll.sDesc .. "Firing 3 rounds (short"..sBurstType .. " burst)\r";
      elseif rWeaponData.sFireMode == "LB" then
        -- NPCs only use wide burst for now...
        ActorManager2.setAttackResistMod(rActor, -5);       
        sBurstType = ", wide";
        rRoll.sDesc = rRoll.sDesc .. "Firing 6 rounds (long"..sBurstType .. " burst)\r";
      elseif rWeaponData.sFireMode == "LNB" then
        nDamage = nDamage + 5;
        sBurstType = ", narrow";
        rRoll.sDesc = rRoll.sDesc .. "Firing 6 rounds (long"..sBurstType .. " burst)\r";
      elseif rWeaponData.sFireMode == "FA" then
        -- NPCs only use wide burst for now...
        ActorManager2.setAttackResistMod(rActor, -9);       
        sBurstType = ", wide";
        rRoll.sDesc = rRoll.sDesc .. "Firing 10 rounds (full"..sBurstType .. " burst)\r";
      elseif rWeaponData.sFireMode == "NFA" then
        nDamage = nDamage + 2;
        sBurstType = ", narrow";
        rRoll.sDesc = rRoll.sDesc .. "Firing 10 rounds (full"..sBurstType .. " burst)\r";
      end
    end
    -- Show reach if this is a melee weapon
    if rWeaponData.type == "Melee" then
      rRoll.sDesc = rRoll.sDesc .. "Reach: " .. rWeaponData.sReach .. "\r";
    end
  end
  ActorManager2.setAttackDamage(rActor, nDamage);
  return rRoll.sDesc, nValue, nDamage;
end

function getWeaponData(rActor, rRoll, nValue)
  local nDamage = 0;
	local nWeaponBonus = 0;
	if rActor.nodeCreature.getChild("node.activeweapon") and rActor.nodeCreature.getChild("node.activeweapon").getValue() ~="none" then
		local nodeActiveWeapon = rActor.nodeCreature.getChild("node.activeweapon").getValue();
    if not nodeActiveWeapon  or not DB.findNode(nodeActiveWeapon) then
        rRoll.sDesc = rRoll.sDesc .. "No weapon selected\r";
    else
  		local sWeaponName = DB.findNode(nodeActiveWeapon).getChild("weaponname").getValue();
  		local nWeaponBonus = DB.findNode(nodeActiveWeapon).getChild("weapon.skillbonus").getValue();
  		local sBurstType = ""; 
  		rRoll.sDesc = rRoll.sDesc.."\rUsing " .. sWeaponName .. " (Bonus: ".. nWeaponBonus .. ")\r";
  		nValue = nValue + nWeaponBonus;
  		-- Show what firemode is being used				
  		if DB.findNode(nodeActiveWeapon).getChild("weapontype").getValue() == "Firearm" then
  			if DB.findNode(nodeActiveWeapon).getChild("firemode").getValue() == 1 or
  			   DB.findNode(nodeActiveWeapon).getChild("firemode").getValue() == 2 then
  				rRoll.sDesc = rRoll.sDesc .. "Firing " .. DB.findNode(nodeActiveWeapon).getChild("weapon.singleshot").getValue() .. " round (single)\r";
  			elseif DB.findNode(nodeActiveWeapon).getChild("firemode").getValue() == 3 then
  				if DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '1' then
  				   nDamage = nDamage + 2;
  				   sBurstType = ", narrow";
  				elseif DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '2' then
  				   ActorManager2.setAttackResistMod(rActor, -2);       
  				   sBurstType = ", wide";
  				end
  				rRoll.sDesc = rRoll.sDesc .. "Firing " .. DB.findNode(nodeActiveWeapon).getChild("weapon.shortburst").getValue() .. " rounds (short"..sBurstType .. " burst)\r";
  			elseif DB.findNode(nodeActiveWeapon).getChild("firemode").getValue() == 4 then
          if DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '1' then
             nDamage = nDamage + 5;
             sBurstType = ", narrow";
          elseif DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '2' then
             ActorManager2.setAttackResistMod(rActor, -5);       
             sBurstType = ", wide";
          end
  				rRoll.sDesc = rRoll.sDesc .. "Firing " .. DB.findNode(nodeActiveWeapon).getChild("weapon.longburst").getValue() .. " rounds (long"..sBurstType .. " burst)\r";
  			elseif DB.findNode(nodeActiveWeapon).getChild("firemode").getValue() == 5 then
          if DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '1' then
             nDamage = nDamage + 9;
             sBurstType = ", narrow";
          elseif DB.findNode(nodeActiveWeapon).getChild("bursttype").getValue() == '2' then
             ActorManager2.setAttackResistMod(rActor, -9);       
             sBurstType = ", wide";
          end
  				rRoll.sDesc = rRoll.sDesc .. "Firing " .. DB.findNode(nodeActiveWeapon).getChild("weapon.fullauto").getValue() .. " rounds (full"..sBurstType .. " burst)\r";
  			end
  		end
  		-- Show reach if this is a melee weapon
  		if DB.findNode(nodeActiveWeapon).getChild("weapontype").getValue() == "Melee" then
  			rRoll.sDesc = rRoll.sDesc .. "Reach: " .. DB.findNode(nodeActiveWeapon).getChild("weapon.reach").getValue() .. "\r";
  		end
  	end
  end
	ActorManager2.setAttackDamage(rActor, nDamage);       
	return rRoll.sDesc, nValue, nDamage;
end

function getFinalWeaponText(rActor, rRoll, nValue, nDamage)

	local sDamageType = " ";
	local nDV = nDamage;
	local nAP = 0;

	if rActor.nodeCreature.getChild("node.activeweapon").getValue() ~="none" then
		local nodeActiveWeapon = rActor.nodeCreature.getChild("node.activeweapon").getValue();
		if DB.findNode(nodeActiveWeapon).getChild("weapondamagetype") then
		sDamageType = DB.findNode(nodeActiveWeapon).getChild("weapondamagetype").getValue();
			if DB.findNode(nodeActiveWeapon).getChild("activeammo") and DB.findNode(nodeActiveWeapon).getChild("activeammo").getValue() ~= "" then
				local sActiveAmmo = DB.findNode(nodeActiveWeapon).getChild("activeammo").getValue();
				local nFireMode = DB.findNode(nodeActiveWeapon).getChild("firemode").getValue();
				local nAmmoUsed = 0
				local nAmmoCount = 0;
				if sActiveAmmo then
          local sActiveAmmoNode = DB.findNode(sActiveAmmo);
  				if sActiveAmmoNode then
  				  nAmmoCount = sActiveAmmoNode.getChild("ammunition.count").getValue();
  				end
  			end
					if nFireMode == 1 or nFireMode == 2 then
						nAmmoUsed = DB.findNode(nodeActiveWeapon).getChild("weapon.singleshot").getValue();
					elseif nFireMode == 3 then
						nAmmoUsed = DB.findNode(nodeActiveWeapon).getChild("weapon.shortburst").getValue();
					elseif nFireMode == 4 then
						nAmmoUsed = DB.findNode(nodeActiveWeapon).getChild("weapon.longburst").getValue();
					elseif nFireMode == 5 then
						nAmmoUsed = DB.findNode(nodeActiveWeapon).getChild("weapon.fullauto").getValue();
					end
					local nAmmoLeft = nAmmoCount - nAmmoUsed
					if nAmmoLeft == 0 then
						rRoll.sDesc = rRoll.sDesc .. "[WARNING! No more Ammo]";
					elseif nAmmoLeft < 0 and nAmmoUsed > (-nAmmoLeft) then 
						rRoll.sDesc = rRoll.sDesc .. "[WARNING! No more Ammo] (short " .. -nAmmoLeft .. " Rounds)";
						nAmmoLeft = 0
					elseif nAmmoLeft < 0 and nAmmoUsed <= (-nAmmoLeft) then
						rRoll.sDesc = "[Click.... uhm Click? I thought this weapon comes automatically with ammo]"
						nAmmoLeft = 0
						return rRoll.sDesc, false;
					end
					DB.findNode(sActiveAmmo).getChild("ammunition.count").setValue(nAmmoLeft);
				if DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue() and DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue() ~= "" then
					sDamageType = DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue();
				end
        local sAmmoArmorUsed = DB.findNode(sActiveAmmo).getChild("ammoarmorused").getValue();
        ActorManager2.setAttackArmorType(rActor, sAmmoArmorUsed);
        rRoll.sAttackArmorType = sAmmoArmorUsed;
			end
		elseif DB.findNode(nodeActiveWeapon).getChild("activeammo") then
			local sActiveAmmo = DB.findNode(nodeActiveWeapon).getChild("activeammo").getValue();
				if DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue() and DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue() ~= " " then
					sDamageType = DB.findNode(sActiveAmmo).getChild("ammodamagetype").getValue();
				end
		end

		-- REMOVED and moved into damage value below (Base DV: number P, S etc
		-- Adds damage type to combat text
		-- if sDamageType ~= "" then
		-- 	rRoll.sDesc = rRoll.sDesc .. sDamageType.." Damage ";
		-- else
		-- 	rRoll.sDesc = rRoll.sDesc
		-- end
		
		-- Adjust damage value based on ammo? ** Barrow
		if DB.findNode(nodeActiveWeapon).getChild("weapon.damage") then
			nDV = nDV + DB.findNode(nodeActiveWeapon).getChild("weapon.damage").getValue();
			if DB.findNode(nodeActiveWeapon).getChild("activeammo") then
				local sActiveAmmo = DB.findNode(nodeActiveWeapon).getChild("activeammo").getValue();
				nDV = nDV + DB.findNode(sActiveAmmo).getChild("ammunition.dv").getValue();
			end
		end
		
		-- Add Base Damage Value
		-- Add type of damage after damage value
		if nDV and nDV > 0 then
		  ActorManager2.setAttackDamage(rActor, nDV);
			rRoll.sDesc = rRoll.sDesc .. "Base DV: ".. nDV;
			if sDamageType ~= "" then
					rRoll.sDesc = rRoll.sDesc .. " " .. sDamageType;
					ActorManager2.setAttackDamageType(rActor, sDamageType);				
			end
			-- next line after damage value is in
			rRoll.sDesc = rRoll.sDesc .. "\r";
		end
		
		-- Adjust Armor penetration based on ammo being used
		if DB.findNode(nodeActiveWeapon).getChild("weapon.armorpenetration") then
			nAP = DB.findNode(nodeActiveWeapon).getChild("weapon.armorpenetration").getValue();
			if DB.findNode(nodeActiveWeapon).getChild("activeammo") then
				local sActiveAmmo = DB.findNode(nodeActiveWeapon).getChild("activeammo").getValue();
				nAP = nAP + DB.findNode(sActiveAmmo).getChild("ammunition.ap").getValue();
			end
		end
		
		-- Add Armor penetration if it exists
		if nAP and nAP ~= 0 then
        ActorManager2.setAttackArmorMod(rActor, nAP);       
			rRoll.sDesc = rRoll.sDesc .. "Base AP: ".. nAP .. "\r"
		end
	end
	return rRoll.sDesc, true;
end

function getDamageType(sDV)
  local sDamageType = "Unknown";
  local nS, nE, sD, sT, sE = string.find(sDV, "(%d*)([PS])(.*)");
  if sT == "S" then
    sDamageType = "Stun";
  elseif sT == "P" then
    sDamageType = "Physical";
  end
  local nD = tonumber(sD);
  if nD == nil then
    nD = 0
  end
  return nD, sDamageType;
end

function getFinalNpcWeaponText(rActor, rRoll, nValue, rWeaponData, nDamage)
  local sDamageType = " ";
  local nDV = 0;
  local nBaseDamage = 0;
  local nAP = 0;

  if rWeaponData then

    nDV, sDamageType = getDamageType(rWeaponData.dv);
    nDV = nDV + nDamage;

    -- Add type of damage after damage value
    if nDV and nDV > 0 then
      ActorManager2.setAttackDamage(rActor, nDV);
      rRoll.sDesc = rRoll.sDesc .. "Base DV: ".. nDV;
      if sDamageType ~= "" then
          rRoll.sDesc = rRoll.sDesc .. " " .. sDamageType;
          ActorManager2.setAttackDamageType(rActor, sDamageType);       
      end
      -- next line after damage value is in
      rRoll.sDesc = rRoll.sDesc .. "\r";
    end
    
    -- Adjust Armor penetration based on ammo being used
      nAP = rWeaponData.ap;
    
    -- Add Armor penetration if it exists
    if nAP and nAP ~= 0 then
      ActorManager2.setAttackArmorMod(rActor, nAP);       
      rRoll.sDesc = rRoll.sDesc .. "Base AP: ".. nAP .. "\r"
    end
  end
  return rRoll.sDesc, true;
end

function getProgramData(rActor, rRoll, nValue)
  local nComlinkResponse = 0;
  local nComlinkSystem = 0;
  local nodeComlink = "none";
  local bProgramActive = false
  local bNotValid = false;
			
  if rActor.nodeCreature.getChild("node.activeprogram") and rActor.nodeCreature.getChild("node.activeprogram").getValue() ~="none" then
	  if rActor.nodeCreature.getChild("node.activecomlink") then
		  if rActor.nodeCreature.getChild("node.activecomlink").getValue() == "none" then
			  rRoll.sDesc = rRoll.sDesc .. " [NO Active Comlink] "
				bNotValid = true;
			else
			  nodeComlink = rActor.nodeCreature.getChild("node.activecomlink").getValue();
			  nComlinkResponse = DB.findNode(nodeComlink).getChild("comlinkresponse").getValue();
			  nComlinkSystem = DB.findNode(nodeComlink).getChild("comlinksystem").getValue();
			  if nComlinkResponse < nComlinkSystem then
			    nComlinkSystem = nComlinkResponse
				  rRoll.sDesc = rRoll.sDesc .. " [ATTENTION - Systemrating smaller then base Response]";
				  bNotValid = true;
			  end
		  end
	  end

	  local nodeActiveProgram = rActor.nodeCreature.getChild("node.activeprogram").getValue();
	  local sProgramName = DB.findNode(nodeActiveProgram).getChild("programname").getValue();
	  local nProgramRating = DB.findNode(nodeActiveProgram).getChild("programrating").getValue();
	  if nProgramRating > nComlinkSystem then
	    nProgramRating = nComlinkSystem
		  rRoll.sDesc = rRoll.sDesc .. "[ATTENTION - ProgramRating higher then Systemrating]";
		  bNotValid = true;
	  end
	    if nodeComlink ~= "none" then
	      local a = {}
		    a = DB.findNode(nodeComlink).getChild("comlinkmodifier").getChildren();
		    for k, v in pairs(a) do
		      if nodeActiveProgram == v.getChild("comlinkmodifiernode").getValue() and v.getChild("comlinkmodifierinusebox").getValue() == 1 then
			      bProgramActive = true;
			    end
		    end
		    if bProgramActive == true then
		      rRoll.sDesc = rRoll.sDesc .. " using " .. sProgramName .. " with Rating of (" .. nProgramRating .. ")";
			    nValue = nValue + nProgramRating
		    else 
		      rRoll.sDesc = rRoll.sDesc .. " using " .. sProgramName .. " [ATTENTION - Program not active on Comlink] with Rating of (" .. nProgramRating .. ")";
			    nValue = nValue + nProgramRating
          bNotValid = true;
		    end
	    end
    end
  return rRoll.sDesc, nValue, bNotValid;
end

function getNpcSpellData(rActor, rRoll, nValue, rSpellData)
  local sSpellName = rSpellData.sName;
  local nSpellForce = rSpellData.nMagic;
  local sDrainValue = rSpellData.dv;
  local sDrainMod = string.gsub(sDrainValue, "%(F/2%)", "");
  sDrainMod = string.gsub(sDrainMod, "+", "");
  local sSpellDrainType = "S";
  if sDrainMod == "" then
    sDrainMod = "0";
  end

  local nSpellStandardDrain = tonumber(sDrainMod);
    
  local nSpellDrain = math.floor((nSpellForce /2) + nSpellStandardDrain);
  if nSpellDrain < 1 then
    nSpellDrain = 1
  end
  local nStandardSpellForce = nSpellForce;
  local nPhysicalDrain = nSpellForce - nStandardSpellForce;
  if nPhysicalDrain <=0 then
    rRoll.sDesc = rRoll.sDesc.."\rCasting " .. sSpellName .. " (Force: ".. nSpellForce .. ")\r[DRAIN: " .. nSpellDrain .. "]\r";
  elseif nPhysicalDrain > 0 and nStandardSpellForce >=  nPhysicalDrain then
    rRoll.sDesc = rRoll.sDesc.."\rCasting " .. sSpellName .. " (Force (exeeds Magic Attribute: ".. nSpellForce .. ")\r PHYSICAL [DRAIN: " .. nSpellDrain .. "]\r";
    sSpellDrainType = "P";
  elseif nPhysicalDrain > 0 and nStandardSpellForce <  nPhysicalDrain then
    rRoll.sDesc = "OVERCAST"
    sSpellDrainType = "P";
  end

  ActorManager2.setSpellDrain(rActor, nSpellDrain, sSpellDrainType);
        
  nValue = nValue;
  local rExtraSpellData = DataCommon.spelldata[sSpellName];
  if rExtraSpellData.spellgroup == "Combat" then
    ActorManager2.setAttackDamage(rActor, nSpellForce);
    ActorManager2.setAttackDamageType(rActor, rExtraSpellData.damage);
  end
  return rRoll.sDesc, nValue, sSpellName;
end

function getSpellData(rActor, rRoll, nValue)
  local sSpellName = "";
	if rActor.nodeCreature.getChild("node.activespell") and rActor.nodeCreature.getChild("node.activespell").getValue() ~="none" then
		local nodeActiveSpell = rActor.nodeCreature.getChild("node.activespell").getValue();
		if DB.findNode(nodeActiveSpell) then
			sSpellName = DB.findNode(nodeActiveSpell).getChild("spellname").getValue();
			local nSpellForce = DB.findNode(nodeActiveSpell).getChild("spellforce").getValue();
			local nSpellStandardDrain = DB.findNode(nodeActiveSpell).getChild("spelldrain").getValue();
			local nSpellDrain = math.floor((nSpellForce /2) + nSpellStandardDrain);
			local sSpellDrainType = "S";
			if nSpellDrain < 1 then
				nSpellDrain = 1
			end
			local nStandardSpellForce = DB.findNode(nodeActiveSpell).getChild("spellstandardforce").getValue();
			local nPhysicalDrain = nSpellForce - nStandardSpellForce;
			if nPhysicalDrain <=0 then
				rRoll.sDesc = rRoll.sDesc.."\rCasting " .. sSpellName .. " (Force: ".. nSpellForce .. ")\r[DRAIN: " .. nSpellDrain .. "]\r";
			elseif nPhysicalDrain > 0 and nStandardSpellForce >=  nPhysicalDrain then
				rRoll.sDesc = rRoll.sDesc.."\rCasting " .. sSpellName .. " (Force (exeeds Magic Attribute: ".. nSpellForce .. ")\r PHYSICAL [DRAIN: " .. nSpellDrain .. "]\r";
        sSpellDrainType = "P";
			elseif nPhysicalDrain > 0 and nStandardSpellForce <  nPhysicalDrain then
				rRoll.sDesc = "OVERCAST"
        sSpellDrainType = "P";
			end

      local rExtraSpellData = DataCommon.spelldata[sSpellName];
      if rExtraSpellData.spellgroup == "Combat" then
        ActorManager2.setAttackDamage(rActor, nSpellForce);
        ActorManager2.setAttackDamageType(rActor, rExtraSpellData.damage);
      end
			
			ActorManager2.setSpellDrain(rActor, nSpellDrain, sSpellDrainType);
			
			nValue = nValue;
		end
	end
	return rRoll.sDesc, nValue, sSpellName;
end

function getSpiritOpposedRoll(rActor, rRoll)
  rActor = ActorManager2.getActor(nil, rActor.sCreatureNode);
  local sActiveSpirit = rActor.nodeCreature.getChild("node.activespirit").getValue();
  local nSpiritForce = DB.findNode(sActiveSpirit).getChild("spirit.force").getValue();
  rRoll.aDice = {}
  if DB.findNode(sActiveSpirit).getChild("spiritsummoning").getValue() == 1 then
	  nSpiritForce = nSpiritForce
		rRoll.sDesc = DB.findNode(sActiveSpirit).getChild("spiritname").getValue() .. " opposes summoning with [FORCE: (" .. nSpiritForce ..")]"
	elseif DB.findNode(sActiveSpirit).getChild("spiritbinding").getValue() == 1 and DB.findNode(sActiveSpirit).getChild("spiritinvocation").getValue() == 0 then
		nSpiritForce = nSpiritForce * 2
		rRoll.sDesc = DB.findNode(sActiveSpirit).getChild("spiritname").getValue() .. " opposes binding with [FORCE: (" .. nSpiritForce ..")]"
	elseif DB.findNode(sActiveSpirit).getChild("spiritbinding").getValue() == 1 and DB.findNode(sActiveSpirit).getChild("spiritinvocation").getValue() == 1 then
		nSpiritForce = nSpiritForce * 2
		rRoll.sDesc = DB.findNode(sActiveSpirit).getChild("spiritname").getValue() .. " opposes binding combined with invocation with [FORCE: (" .. nSpiritForce ..")]"
	end
	for i=1, nSpiritForce do
	  table.insert (rRoll.aDice, "d6");
	end

	rRoll.sType = "spiritisopposed"
	rRoll.bEdge = false
	rRoll.nEdgeValue = 0
		
	return rRoll
end

function getSpiritData(rActor, rRoll, nValue)
	if rActor.nodeCreature.getChild("node.activespirit") and rActor.nodeCreature.getChild("node.activespirit").getValue() ~="none" then
		local sActiveSpirit = rActor.nodeCreature.getChild("node.activespirit").getValue();
		local nSpiritForce = DB.findNode(sActiveSpirit).getChild("spirit.force").getValue();
		if DB.findNode(sActiveSpirit).getChild("spiritsummoning").getValue() == 1 then
			rRoll.sDesc = rRoll.sDesc .. " " .. DB.findNode(sActiveSpirit).getChild("spiritname").getValue().. " with " ;
		end
	end			
	nValue = nValue;
	return rRoll.sDesc, nValue;
end

function setSpiritSummoned(rActor, nServices)
  if rActor.nodeCreature.getChild("node.activespirit") and rActor.nodeCreature.getChild("node.activespirit").getValue() ~="none" then
    local sActiveSpirit = rActor.nodeCreature.getChild("node.activespirit").getValue();
    DB.findNode(sActiveSpirit).getChild("spirit.services").setValue(nServices);
    DB.findNode(sActiveSpirit).getChild("spiritrelation").setValue(1);
  end
end

function setSpiritBound(rActor, nAdditionalServices)
  if rActor.nodeCreature.getChild("node.activespirit") and rActor.nodeCreature.getChild("node.activespirit").getValue() ~="none" then
    local sActiveSpirit = rActor.nodeCreature.getChild("node.activespirit").getValue();
    local nServices = DB.findNode(sActiveSpirit).getChild("spirit.services").getValue() + nAdditionalServices;
    DB.findNode(sActiveSpirit).getChild("spirit.services").setValue(nServices);
    DB.findNode(sActiveSpirit).getChild("spiritrelation").setValue(2);
  end
end

function performRoll(draginfo, rActor, sStatName, sStatMod, rDetail)
  if sStatMod == nil then
    sStatMod = "0";
  end
  ActorManager2.clearAttackData(rActor);

	local rRoll = {};
	rRoll.sType = "skill";
	local nValue = 0;
	local aDice =  {};
	rRoll.sDesc = rActor.nodeCreature.getChild("name").getValue() .. " -> "
	rRoll.sDesc = rRoll.sDesc .. "[SKILL-Check]"

	--pre Skill Roll Descriptions
	if rActor.sType == "pc" or rActor.sType == "charsheet" then
		if rActor.sWindowClass == "charsheet_3_1_weapons" then
			rRoll.sDesc = "[COMBAT] Check"
			rRoll.sType = "combat";
      rRoll.sSubType = sStatName;
		elseif rActor.sWindowClass == "charsheet_4_1_spells" then
			rRoll.sDesc = "[MAGIC] Check"
			rRoll.sType = "spell";
      rRoll.sSubType = sStatName;
		elseif rActor.sWindowClass == "charsheet_4_2_spirits" then
			if rActor.nodeCreature.getChild("node.activespirit") and rActor.nodeCreature.getChild("node.activespirit").getValue() ~="none" then
			rRoll.sDesc = "[SPIRIT] Check"
			else
			rRoll.sDesc = "[MAGIC] Check"
			end
		elseif rActor.sWindowClass == "charsheet_5_1_programs" then
			rRoll.sDesc = "[MATRIX] Check"
			rRoll.sType = "matrix"
      rRoll.sSubType = sStatName;
		elseif rActor.sWindowClass == "charsheet_6_1_pilot" then
			rRoll.sDesc = "[PILOT] Check"
		end
	elseif rActor.sType == "npc" then
	  if sStatName == "Spellcasting" then
      rRoll.sDesc = "[MAGIC] Check";
      rRoll.sType = "spell";
      rRoll.sSubType = sStatName;  
    elseif isSkillAttack(sStatName) then
      rRoll.sDesc = "[COMBAT] Check"
      rRoll.sType = "combat";
      rRoll.sSubType = sStatName;  
	  end
	end

  if isSkillRangedAttack(sStatName) then
    rRoll.sAttackType = "Ranged";
    ActorManager2.setAttackType(rActor, "R");  
  elseif isSkillMeleeAttack(sStatName) then
    rRoll.sAttackType = "Melee";
    ActorManager2.setAttackType(rActor, "M");
  else
    rRoll.sAttackType = "";
    ActorManager2.setAttackType(rActor, "-");      
  end

  if isSkillBallisticAttack(sStatName) then
    rRoll.sAttackArmorType = "B";
    ActorManager2.setAttackArmorType(rActor, "B");  
  elseif isSkillImpactAttack(sStatName) then
    rRoll.sAttackArmorType = "I";
    ActorManager2.setAttackArmorType(rActor, "I");
  else
    rRoll.sAttackArmorType = "-";
    ActorManager2.setAttackArmorType(rActor, "-");      
  end      

	if rRoll.sType == "matrix" and rActor.nodeCreature.getChild("node.activeprogram").getValue() ~="none" then
    rRoll.sDesc , nValue = ActorManager2.getPureSkillScore(rActor, sStatName, rRoll.sDesc);
	else
    rRoll.sDesc , nValue = ActorManager2.getSkillScore(rActor, sStatName, sStatMod, rRoll.sDesc);
--	rRoll.sDesc , nValue = ActorManager2.getSkillScore(rActor.nodeCreature, sStatName, sStatMod, rRoll.sDesc);
	end
  local bCanFire = true;
  local nDamage = 0;
	-- get Additional Bonuses and Texts
	if rActor.sType == "pc" or rActor.sType == "charsheet" then
		if rActor.sWindowClass == "charsheet_3_1_weapons" then
			rRoll.sDesc, nValue, nDamage = getWeaponData(rActor, rRoll,nValue);
      rRoll.sDesc ,nValue, bCanFire = ActorManager2.getRangePenalty(rActor, nValue, rRoll.sDesc, sStatName);
		elseif rActor.sWindowClass == "charsheet_4_1_spells" then
			rRoll.sDesc, nValue, rRoll.sSpellName = getSpellData(rActor, rRoll,nValue);
		elseif rActor.sWindowClass == "charsheet_4_2_spirits" then
			rRoll.sDesc, nValue = getSpiritData(rActor, rRoll,nValue);
		elseif rActor.sWindowClass == "charsheet_5_1_programs" then
		  local bNotValid = false;
			rRoll.sDesc, nValue, bNotValid = getProgramData(rActor, rRoll,nValue);
			if bNotValid then
        rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rActor, nil, rRoll);
--        rMessage.secret = false;
--        rMessage.dicesecret = false;
        Comm.deliverChatMessage(rMessage); 
			  return;
			end
		elseif rActor.sWindowClass == "charsheet_6_1_pilot" then
		end
  elseif rActor.sType == "npc" then
    Debug.console("performRoll: rDetail: ", rDetail);
	  if sStatName == "Spellcasting" and rDetail then
      rRoll.sDesc, nValue, rRoll.sSpellName = getNpcSpellData(rActor, rRoll,nValue, rDetail);
      rRoll.sDesc  = ActorManager2.getRangePenalty(rActor, 0, rRoll.sDesc, sStatName);
    elseif isSkillAttack(sStatName) then
      rRoll.sDesc, nValue, nDamage = getNpcWeaponData(rActor, rRoll,nValue, rDetail);
      rRoll.sDesc , nValue = ActorManager2.getRangePenalty(rActor, nValue, rRoll.sDesc, sStatName, rDetail);
    end
	end
	-- finalize Roll (additional Texting)
	if rActor.sType == "pc" or rActor.sType == "charsheet" then
		if rActor.sWindowClass == "charsheet_3_1_weapons" then
			rRoll.sDesc, bCanFire = getFinalWeaponText(rActor, rRoll, nValue, nDamage);
		elseif rActor.sWindowClass == "charsheet_4_1_spells" then
		elseif rActor.sWindowClass == "charsheet_3_1_weapons" then
		elseif rActor.sWindowClass == "charsheet_3_1_weapons" then
		end
	elseif rActor.sType == "npc" then
    if sStatName == "Spellcasting" then
    elseif isSkillAttack(sStatName) then
      rRoll.sDesc, bCanFire = getFinalNpcWeaponText(rActor, rRoll, nValue, rDetail, nDamage);
    end
	end
	-- need to look into the order here.
	rRoll.sDesc , nValue = ActorManager2.getPenalty(rActor, nValue, rRoll.sDesc, sStatName);
	rRoll.sDesc , nValue = ActorManager2.getSustainingPenalty(rActor, nValue, rRoll.sDesc, sStatName);
	rRoll.sDesc , nValue = ActorManager2.getArmorPenalty(rActor, nValue, rRoll.sDesc, sStatName);
	rRoll.sDesc, nValue = ActorManager2.getModifiers(rRoll.sDesc, nValue)
	rRoll.sDesc, rRoll.bEdge , rRoll.nEdgeVal = ActorManager2.getEdge(rActor, rRoll.sDesc);
	nValue = nValue + rRoll.nEdgeVal
	if not bCanFire then
    rMessage, rSource, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);
--    rMessage.secret = false;
--    rMessage.dicesecret = false;
    Comm.deliverChatMessage(rMessage); 
    return;    
	end
	
	-- SETUP
	for i = 1, nValue do
		table.insert (aDice, "d6");
	end
	rRoll.aDice = aDice;
	rRoll.nValue = 0;
	 rRoll.nMod = 0;

	ActionsManager2.performSingleRollAction(draginfo, rActor, "skill", rRoll);
end

function onReroll(rSource, rTarget, rRoll)
  if rRoll.sOriginalType == "resist" then
    Resist.onResist(rSource, rTarget, rRoll);
  else
    onSkill(rSource, rTarget, rRoll);
  end
end

function onSkill(rSource, rTarget, rRoll)
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
  local rSource2
  rMessage, rSource2, rRoll = ActionsManager2.createActionMessage(rSource, rTarget, rRoll);

  if rRoll.sType == "spiritisopposed" or rRoll.sOriginalType == "spiritisopposed" then
    local isInvoced = string.match(rRoll.sDesc, "%invocation")
    if isInvoced then
      nDrain = rRoll.nSuccessesCalling * 3;
    else 
      nDrain = rRoll.nSuccessesCalling * 2;
    end
    local rTempSource = ActorManager2.getActor(nil, rSource.sCreatureNode);
    local isSummoning = string.match(rRoll.sDesc, "summoning");
    local isBinding = string.match(rRoll.sDesc, "binding");
    if isBinding then
      local nAdditionalServices = tonumber(rRoll.nSuccessesPC) - rRoll.nSuccessesCalling;
      if nAdditionalServices > 0 then
        rMessage.text = rMessage.text .. " successfully bound with " .. nAdditionalServices - 1  .. " additional services ";        
        setSpiritBound(rTempSource, nAdditionalServices-1);
      else
        rMessage.text = rMessage.text .. " not successfully bound";        
      end
    elseif isSummoning then
      local nServices = tonumber(rRoll.nSuccessesPC) - rRoll.nSuccessesCalling;
      if nServices > 0 then
        rMessage.text = rMessage.text .. " successfully summoned with " .. rRoll.nSuccessesPC - rRoll.nSuccessesCalling  .. " services ";
        setSpiritSummoned(rTempSource, nServices);
      else
        rMessage.text = rMessage.text .. " not successfully summoned";
      end
    end
    if nDrain > 0 then
      rMessage.text = rMessage.text .. " draining your Mental Power for " .. nDrain .. " Stun Damage."
    else
      rMessage.text = rMessage.text .. " causing no Drain Damage."
    end
    ActorManager2.setSpellDrain(rSource, nDrain, "S");
  end
--  rMessage.secret = false;
--  rMessage.dicesecret = false;
  
  Comm.deliverChatMessage(rMessage); 
  
  if rRoll.sType == "reroll" and rRoll.nRerollCount and rRoll.nRerollCount > 0 then
    ActionsManager2.performReroll(rSource, rRoll);
    return;
  end
  
  if rRoll.sType == "spiritopposed" or rRoll.sOriginalType == "spiritopposed" then
    ActionsManager2.performOpposedRoll(rSource, rRoll);
    return;
  end
  
  if rRoll.sType == "spiritisopposed" or rRoll.sOriginalType == "spiritisopposed" then
    if nDrain > 0 then
      local rTempSource = ActorManager2.getActor(nil, rSource.sCreatureNode);
      Resist.performRoll(nil, rTempSource, "Drain Resist", rTempSource, rRoll.sSubType);
    end
  end

  local src = DB.findNode(rSource.sCreatureNode);
  
  if rRoll.sType == "combat" or rRoll.sOriginalType == "combat" then
    ActorManager2.setAttackHits(rSource, nSuccesses);
    if nSuccesses == 0 then
      -- Missed
      return;
    elseif rTarget then
--        local rTempTarget = ActorManager2.getActor(nil, rTarget.sCreatureNode);
        rRoll.nAttackHits = nSuccesses;
--        local rTempSource = ActorManager2.getActor(nil, rSource.sCreatureNode);
        
        if OptionsManager.isOption("ADRT", "on") then
          Resist.deliverResist(rTarget, rRoll.sAttackType .. " Resist", rSource, rRoll.sSubType);
        end
      return;
    else
    end
  end
  if rRoll.sType == "spell" or rRoll.sOriginalType == "spell" then
    if nSuccesses > 0 and rTarget then
      -- check if Combat spell
      local rExtraSpellData = DataCommon.spelldata[rRoll.sSpellName];
      if rExtraSpellData and rExtraSpellData.spellgroup == "Combat" then
        local sSpellCategory = rExtraSpellData.category;
        local isIndirect = string.match(sSpellCategory, "Indirect");

        local resistType = "";
        if isIndirect then
          resistType = "Ranged Resist";
          ActorManager2.setAttackArmorType(rSource, "I");
          rRoll.sAttackArmorType = "I";
        elseif rExtraSpellData.type == "P" then
          resistType = "Physical Spell Resist";
        else 
          resistType = "Mana Spell Resist";
        end
        ActorManager2.setAttackHits(rSource, nSuccesses);
        if OptionsManager.isOption("ADRT", "on") then
          Resist.deliverResist(rTarget, resistType, rSource, rRoll.sSubType);
        else
          return;
        end
      end      
    end
    -- must resist drain
    local rTempSource = ActorManager2.getActor(nil, rSource.sCreatureNode);
    if OptionsManager.isOption("ADRT", "on") then
      Resist.performRoll(nil, rTempSource, "Drain Resist", rTempSource, rRoll.sSubType);
    end
  end
end
