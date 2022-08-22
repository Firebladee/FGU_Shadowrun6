-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
-- DAMAGE APPLICATION
--

function decodeAndOrClauses(sText)
	local nIndexOR = 1;
	local nStartOR, nEndOR, nStartAND, nEndAND;
	local nStartOR2, nEndOR2;
	local sPhraseOR;

	local aClausesOR = {};
	local aSkipOR = {};
	while nIndexOR < #sText do
		nStartOR, nEndOR = string.find(sText, "%s+or%s+", nIndexOR);
		nStartOR2, nEndOR2 = string.find(sText, "%s*;%s*", nIndexOR);
		
		if nStartOR or nStartOR2 then
			if nStartOR2 and (not nStartOR or nStartOR > nStartOR2) then
				nStartOR = nStartOR2;
				nEndOR = nEndOR2;
			end
			sPhraseOR = string.sub(sText, nIndexOR, nStartOR - 1);
			nIndexOR = nEndOR + 1;
		else
			sPhraseOR = string.sub(sText, nIndexOR);
			nIndexOR = #sText;
		end

		local aClausesAND = {};
		local aSkipAND = {};
		local nIndexAND = 1;
		while nIndexAND < #sPhraseOR do
			nStartAND, nEndAND = string.find(sPhraseOR, "%s+and%s+", nIndexAND);
			if nStartAND then
				table.insert(aClausesAND, string.sub(sPhraseOR, nIndexAND, nStartAND - 1));
				nIndexAND = nEndAND + 1;
				table.insert(aSkipAND, nEndAND - nStartAND + 1);
			else
				table.insert(aClausesAND, string.sub(sPhraseOR, nIndexAND));
				nIndexAND = #sPhraseOR;
				if nStartOR then
					table.insert(aSkipAND, nEndOR - nStartOR + 1);
				else
					table.insert(aSkipAND, 0);
				end
			end
		end

		table.insert(aClausesOR, aClausesAND);
		table.insert(aSkipOR, aSkipAND);
	end
	
	
	return aClausesOR, aSkipOR;
end

function matchAndOrClauses(aClausesOR, aMatchWords)
	for kClauseOR, aClausesAND in ipairs(aClausesOR) do
		local bMatchAND = true;
		local nMatchAND = 0;

		for kClauseAND, sClause in ipairs(aClausesAND) do
			nMatchAND = nMatchAND + 1;

			if not StringManager.contains(aMatchWords, sClause) then
				bMatchAND = false;
				break;
			end
		end
		
		if bMatchAND and nMatchAND > 0 then
			return true;
		end
	end
		
	return false;
end

function getDamageAdjust(rSource, rTarget, nDamage, rDamageOutput)
	-- SETUP
	local nDamageAdjust = 0;
	local nNonlethal = 0;
	local bVulnerable = false;
	local bResist = false;
	local aWords;
	
	-- GET THE DAMAGE ADJUSTMENT EFFECTS
	local aImmune = EffectsManager.getEffectsBonusByType(rTarget.nodeCT, "IMMUNE", false, {}, rSource);
	local aVuln = EffectsManager.getEffectsBonusByType(rTarget.nodeCT, "VULN", false, {}, rSource);
	local aResist = EffectsManager.getEffectsBonusByType(rTarget.nodeCT, "RESIST", false, {}, rSource);
	local aDR = EffectsManager.getEffectsByType(rTarget.nodeCT, "DR", {}, rSource);
	
	-- IF IMMUNE ALL, THEN JUST HANDLE IT NOW
	if aImmune["all"] then
		nDamageAdjust = 0 - nDamage;
		bResist = true;
		return nDamageAdjust, bVulnerable, bResist;
	end
	
	-- HANDLE REGENERATION
	local aRegen = EffectsManager.getEffectsBonusByType(rTarget.nodeCT, "REGEN", false, {});
	local nRegen = 0;
	for _, _ in pairs(aRegen) do
		nRegen = nRegen + 1;
	end
	if nRegen > 0 then
		local aRemap = {};
		for k, v in pairs(rDamageOutput.aDamageTypes) do
			local bCheckRegen = true;
			
			local aSrcDmgClauseTypes = {};
			local aTemp = StringManager.split(k, ",", true);
			for i = 1, #aTemp do
				if aTemp[i] == "nonlethal" then
					bCheckRegen = false;
					break;
				elseif aTemp[i] ~= "untyped" and aTemp[i] ~= "" then
					table.insert(aSrcDmgClauseTypes, aTemp[i]);
				end
			end

			if bCheckRegen then
				local bMatchAND, nMatchAND, bMatchDMG, aClausesOR;
				local bApplyRegen;
				for kRegen, vRegen in pairs(aRegen) do
					bApplyRegen = true;
					
					local sRegen = table.concat(vRegen.remainder, " ");
					
					aClausesOR = decodeAndOrClauses(sRegen);
					if matchAndOrClauses(aClausesOR, aSrcDmgClauseTypes) then
						bApplyRegen = false;
					end
					
					if bApplyRegen then
						local kNew = table.concat(aSrcDmgClauseTypes, ",");
						if kNew ~= "" then
							kNew = kNew .. ",nonlethal";
						else
							kNew = "nonlethal";
						end
						aRemap[k] = kNew;
					end
				end
			end
		end
		for k, v in pairs(aRemap) do
			rDamageOutput.aDamageTypes[v] = rDamageOutput.aDamageTypes[k];
			rDamageOutput.aDamageTypes[k] = nil;
		end
	end
	
	-- ITERATE THROUGH EACH DAMAGE TYPE ENTRY
	local nVulnApplied = 0;
	for k, v in pairs(rDamageOutput.aDamageTypes) do
		-- GET THE INDIVIDUAL DAMAGE TYPES FOR THIS ENTRY (EXCLUDING UNTYPED DAMAGE TYPE)
		local aSrcDmgClauseTypes = {};
		local bHasEnergyType = false;
		local aTemp = StringManager.split(k, ",", true);
		for i = 1, #aTemp do
			if aTemp[i] ~= "untyped" and aTemp[i] ~= "" then
				table.insert(aSrcDmgClauseTypes, aTemp[i]);
				if not bHasEnergyType and StringManager.contains(DataCommon.energytypes, aTemp[i]) or aTemp[i] == "spell" then
					bHasEnergyType = true;
				end
			end
		end

		-- HANDLE IMMUNITY, VULNERattribute AND RESISTANCE
		local nLocalDamageAdjust = 0;
		if #aSrcDmgClauseTypes > 0 then
			-- CHECK VULN TO DAMAGE TYPES
			for keyDmgType, sDmgType in pairs(aSrcDmgClauseTypes) do
				if not aImmune[sDmgType] and aVuln[sDmgType] and not aVuln[sDmgType].nApplied then
					nLocalDamageAdjust = nLocalDamageAdjust + math.floor(v / 2);
					aVuln[sDmgType].nApplied = v;
					bVulnerable = true;
				end
			end
			
			-- CHECK EACH DAMAGE TYPE
			for keyDmgType, sDmgType in pairs(aSrcDmgClauseTypes) do
				-- IF IMMUNE, THEN DISCOUNT ALL OF THIS DAMAGE
				if aImmune[sDmgType] then
					nLocalDamageAdjust = nLocalDamageAdjust - v;
					bResist = true;
				else
					-- CHECK RESISTANCE
					if aResist[sDmgType] then
						local nApplied = aResist[sDmgType].nApplied or 0;
						if nApplied < aResist[sDmgType].mod then
							local nChange = math.min((aResist[sDmgType].mod - nApplied), v + nLocalDamageAdjust);
							aResist[sDmgType].nApplied = nApplied + nChange;
							nLocalDamageAdjust = nLocalDamageAdjust - nChange;
							bResist = true;
						end
					end
				end
			end
		end
		
		-- HANDLE DR  (FORM: <type> and <type> or <type> and <type>)
		if not bHasEnergyType and (v + nLocalDamageAdjust) > 0 then
			local bMatchAND, nMatchAND, bMatchDMG, aClausesOR;
			
			local bApplyDR;
			for kDR, vDR in pairs(aDR) do
				if kDR == "" or kDR == "-" or kDR == "all" then
					bApplyDR = true;
				else
					bApplyDR = true;
					aClausesOR = decodeAndOrClauses(table.concat(vDR.remainder, " "));
					if matchAndOrClauses(aClausesOR, aSrcDmgClauseTypes) then
						bApplyDR = false;
					end
				end

				if bApplyDR then
					local nApplied = vDR.nApplied or 0;
					if nApplied < vDR.mod then
						local nChange = math.min((vDR.mod - nApplied), v + nLocalDamageAdjust);
						vDR.nApplied = nApplied + nChange;
						nLocalDamageAdjust = nLocalDamageAdjust - nChange;
						bResist = true;
					end
				end
			end
		end
		
		-- CALCULATE NONLETHAL DAMAGE
		local nNonlethalAdjust = 0;
		if (v + nLocalDamageAdjust) > 0 then
			local bNonlethal = false;
			for keyDmgType, sDmgType in pairs(aSrcDmgClauseTypes) do
				if sDmgType == "nonlethal" then
					bNonlethal = true;
					break;
				end
			end
			if bNonlethal then
				nNonlethalAdjust = v + nLocalDamageAdjust;
			end
		end

		-- APPLY DAMAGE ADJUSTMENT FROM THIS DAMAGE CLAUSE TO OVERALL DAMAGE ADJUSTMENT
		nDamageAdjust = nDamageAdjust + nLocalDamageAdjust - nNonlethalAdjust;
		nNonlethal = nNonlethal + nNonlethalAdjust;
	end

	-- HANDLE IMMUNITY TO NONLETHAL
	if EffectsManager.hasEffectCondition(rTarget, "Construct traits") or EffectsManager.hasEffectCondition(rTarget, "Undead traits") then
		if nNonlethal > 0 then
			nNonlethal = 0;
			bResist = true;
		end
	end
	
	-- RESULTS
	return nDamageAdjust, nNonlethal, bVulnerable, bResist;
end

function decodeDamageText(nDamage, sDamageDesc)
	local rDamageOutput = {};
	rDamageOutput.sType = "damage";
	rDamageOutput.sTypeOutput = "Damage";
	rDamageOutput.sVal = "" .. nDamage;
	rDamageOutput.nVal = nDamage;
	
	if string.match(sDamageDesc, "%[HEAL") then
		if string.match(sDamageDesc, "%[TEMP%]") then
			-- SET MESSAGE TYPE
			rDamageOutput.sType = "temphp";
			rDamageOutput.sTypeOutput = "Temporary hit points";
		else
			-- SET MESSAGE TYPE
			rDamageOutput.sType = "heal";
			rDamageOutput.sTypeOutput = "Heal";
		end
	elseif string.match(sDamageDesc, "%[FHEAL") then
		rDamageOutput.sType = "fheal";
		rDamageOutput.sTypeOutput = "Fast healing";
	elseif string.match(sDamageDesc, "%[REGEN") then
		rDamageOutput.sType = "regen";
		rDamageOutput.sTypeOutput = "Regeneration";
	elseif nDamage < 0 then
		rDamageOutput.sType = "heal";
		rDamageOutput.sTypeOutput = "Heal";
		rDamageOutput.sVal = "" .. (0 - nDamage);
		rDamageOutput.nVal = 0 - nDamage;
	else
		-- DETERMINE CRITICAL
		rDamageOutput.bCritical = string.match(sDamageDesc, "%[CRITICAL%]");

		-- DETERMINE RANGE
		rDamageOutput.sRange = string.match(sDamageDesc, "%[DAMAGE %((%w)%)%]") or "";

		-- NOTE: Effect damage dice are not multiplied on critical, though numerical modifiers are multiplied
		-- http://rpg.stackexchange.com/questions/4465/is-smite-evil-damage-multiplied-by-a-critical-hit
		-- NOTE: Using damage type of the first damage clause for the bonuses

		-- DETERMINE DAMAGE ENERGY TYPES
		rDamageOutput.aDamageTypes = {};
		local nDamageRemaining = nDamage;
		for sDamageType in string.gmatch(sDamageDesc, "%[TYPE: ([^%]]+)%]") do
			local sDmgType = StringManager.trimString(string.match(sDamageType, "^([^(%]]+)"));
			local sDice, sTotal = string.match(sDamageType, "%(([%d%+%-D]+)%=(%d+)%)");
			local nDmgTypeTotal = tonumber(sTotal) or nDamageRemaining;

			if rDamageOutput.aDamageTypes[sDmgType] then
				rDamageOutput.aDamageTypes[sDmgType] = rDamageOutput.aDamageTypes[sDmgType] + nDmgTypeTotal;
			else
				rDamageOutput.aDamageTypes[sDmgType] = nDmgTypeTotal;
			end
			if not rDamageOutput.sFirstDamageType then
				rDamageOutput.sFirstDamageType = sDmgType;
				local sMult = string.match(sDamageType, "%(x(%d+)%)");
				rDamageOutput.nFirstDamageMult = tonumber(sMult) or 2;
			end

			nDamageRemaining = nDamageRemaining - nDmgTypeTotal;
			if nDamageRemaining <= 0 then
				break;
			end
		end
		if nDamageRemaining > 0 then
			rDamageOutput.aDamageTypes[""] = nDamageRemaining;
		end
		
		-- DETERMINE DAMAGE TYPES
		rDamageOutput.aDamageFilter = {};
		if rDamageOutput.sRange == "M" then
			table.insert(rDamageOutput.aDamageFilter, "melee");
		elseif rDamageOutput.sRange == "R" then
			table.insert(rDamageOutput.aDamageFilter, "ranged");
		elseif rDamageOutput.sRange == "C" then
			table.insert(rDamageOutput.aDamageFilter, "close");
		elseif rDamageOutput.sRange == "A" then
			table.insert(rDamageOutput.aDamageFilter, "area");
		end
	end
	
	return rDamageOutput;
end

function applyAttack(rSource, rTarget, sDesc, nTotal, sResults)
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};
	
	msgShort.text = "Attack ->";
	msgLong.text = "Attack [" .. nTotal .. "] ->";
	if rTarget then
		msgShort.text = msgShort.text .. " [at " .. rTarget.sName .. "]";
		msgLong.text = msgLong.text .. " [at " .. rTarget.sName .. "]";
	end
	if sResults ~= "" then
		msgLong.text = msgLong.text .. " " .. sResults;
	end
	
	msgShort.icon = "indicator_attack";
	if string.match(sResults, "%[CRITICAL HIT%]") then
		msgLong.icon = "indicator_attack_crit";
	elseif string.match(sResults, "HIT%]") then
		msgLong.icon = "indicator_attack_hit";
	elseif string.match(sResults, "MISS%]") then
		msgLong.icon = "indicator_attack_miss";
	else
		msgLong.icon = "indicator_attack";
	end
		
	local bGMOnly = string.match(sDesc, "^%[GM%]") or string.match(sDesc, "^%[TOWER%]") ;
	RulesManager.messageResult(bGMOnly, rSource, rTarget, msgLong, msgShort);
end

function applyDamage(rSource, rTarget, sDamage, nTotal)
	-- SETUP
	local totalhp = 0;
	local temphp = 0;
	local wounds = 0;
	local nSurgeMax = 0;
	local nSurgeUsed = 0;
	local nHSV = 0;

	local aNotifications = {};
	
	-- GET HEALTH FIELDS
	if rTarget.sType == "pc" and rTarget.nodeCreature then
		totalhp = NodeManager.get(rTarget.nodeCreature, "hp.total", 0);
		temphp = NodeManager.get(rTarget.nodeCreature, "hp.temporary", 0);
		nonlethal = NodeManager.get(rTarget.nodeCreature, "hp.nonlethal", 0);
		wounds = NodeManager.get(rTarget.nodeCreature, "hp.wounds", 0);
	elseif rTarget.nodeCT then
		totalhp = NodeManager.get(rTarget.nodeCT, "hp", 0);
		temphp = NodeManager.get(rTarget.nodeCT, "hptemp", 0);
		nonlethal = NodeManager.get(rTarget.nodeCT, "nonlethal", 0);
		wounds = NodeManager.get(rTarget.nodeCT, "wounds", 0);
	else
		return "";
	end
	
	-- DECODE DAMAGE DESCRIPTION
	local rDamageOutput = decodeDamageText(nTotal, sDamage);
	
	-- HEALING
	if rDamageOutput.sType == "heal" or rDamageOutput.sType == "fheal" then
		-- CHECK COST
		if wounds <= 0 and nonlethal <= 0 then
			table.insert(aNotifications, "[NOT WOUNDED]");
		else
			-- CALCULATE HEAL AMOUNTS
			local nHealAmount = rDamageOutput.nVal;
			
			local nNonlethalHealAmount = math.min(nHealAmount, nonlethal);
			nonlethal = nonlethal - nNonlethalHealAmount;
			if rDamageOutput.sType == "fheal" then
				nHealAmount = nHealAmount - nNonlethalHealAmount;
			end

			local nOriginalWounds = wounds;
			
			local nWoundHealAmount = math.min(nHealAmount, wounds);
			wounds = wounds - nWoundHealAmount;
			
			-- IF WE HEALED FROM NEGATIVE TO ZERO OR HIGHER, THEN REMOVE STABLE EFFECT
			if (nOriginalWounds > totalhp) and (wounds <= totalhp) then
				EffectsManager.removeEffect(rTarget.nodeCT, "Stable");
			end
			
			-- SET THE ACTUAL HEAL AMOUNT FOR DISPLAY
			rDamageOutput.nVal = nNonlethalHealAmount + nWoundHealAmount;
			if nWoundHealAmount > 0 then
				rDamageOutput.sVal = "" .. nWoundHealAmount;
				if nNonlethalHealAmount > 0 then
					rDamageOutput.sVal = rDamageOutput.sVal .. " (+" .. nNonlethalHealAmount .. " NL)";
				end
			elseif nNonlethalHealAmount > 0 then
				rDamageOutput.sVal = "" .. nNonlethalHealAmount .. " NL";
			else
				rDamageOutput.sVal = "0";
			end
		end

	-- REGENERATION
	elseif rDamageOutput.sType == "regen" then
		if nonlethal <= 0 then
			table.insert(aNotifications, "[NO NONLETHAL DAMAGE]");
		else
			local nNonlethalHealAmount = math.min(rDamageOutput.nVal, nonlethal);
			nonlethal = nonlethal - nNonlethalHealAmount;
			
			rDamageOutput.nVal = nNonlethalHealAmount;
			rDamageOutput.sVal = "" .. nNonlethalHealAmount .. " NL";
		end

	-- TEMPORARY HIT POINTS
	elseif rDamageOutput.sType == "temphp" then
		-- APPLY TEMPORARY HIT POINTS
		temphp = math.max(temphp, nTotal);

	-- DAMAGE
	else
		-- APPLY ANY TARGETED DAMAGE EFFECTS
		-- NOTE: DICE ARE RANDOMLY DETERMINED BY COMPUTER, INSTEAD OF ROLLED
		if rSource then
			local aTargetedDamage = EffectsManager.getEffectsBonusByType(rSource.nodeCT, {"DMG"}, true, rDamageOutput.aDamageFilter, rTarget, true);

			local nDamageEffectTotal = 0;
			local nDamageEffectCount = 0;
			for k, v in pairs(aTargetedDamage) do
				local nSubTotal = 0;
				if rDamageOutput.bCritical then
					local nMult = rDamageOutput.nFirstDamageMult or 2;
					nSubTotal = StringManager.evalDice(v.dice, (nMult * v.mod));
				else
					nSubTotal = StringManager.evalDice(v.dice, v.mod);
				end
				
				local sDamageType = rDamageOutput.sFirstDamageType;
				if sDamageType then
					sDamageType = sDamageType .. "," .. k;
				else
					sDamageType = k;
				end

				rDamageOutput.aDamageTypes[sDamageType] = (rDamageOutput.aDamageTypes[sDamageType] or 0) + nSubTotal;
				
				nDamageEffectTotal = nDamageEffectTotal + nSubTotal;
				nDamageEffectCount = nDamageEffectCount + 1;
			end
			nTotal = nTotal + nDamageEffectTotal;

			if nDamageEffectCount > 0 then
				if nDamageEffectTotal ~= 0 then
					table.insert(aNotifications, string.format("[EFFECTS %+d]", nDamageEffectTotal));
				else
					table.insert(aNotifications, "[EFFECTS]");
				end
			end
		end
		
		-- CHECK FOR HALF DAMAGE
		local isHalf = string.match(sDamage, "%[HALF%]");
		if isHalf then
			table.insert(aNotifications, "[HALF]");
			for kType, nType in pairs(rDamageOutput.aDamageTypes) do
				rDamageOutput.aDamageTypes[kType] = math.floor(nType / 2);
			end
			nTotal = math.max(math.floor(nTotal / 2), 1);
		end
		
		-- APPLY ANY DAMAGE TYPE ADJUSTMENT EFFECTS
		local nDamageAdjust, nNonlethal, bVulnerable, bResist = getDamageAdjust(rSource, rTarget, nTotal, rDamageOutput);

		-- ADDITIONAL DAMAGE ADJUSTMENTS NOT RELATED TO DAMAGE TYPE
		local nAdjustedDamage = nTotal + nDamageAdjust;
		if nAdjustedDamage < 0 then
			nAdjustedDamage = 0;
		end
		if bResist then
			if nAdjustedDamage <= 0 then
				table.insert(aNotifications, "[RESISTED]");
			else
				table.insert(aNotifications, "[PARTIALLY RESISTED]");
			end
		end
		if bVulnerable then
			table.insert(aNotifications, "[VULNERABLE]");
		end
		
		-- REDUCE DAMAGE BY TEMPORARY HIT POINTS
		if temphp > 0 and nAdjustedDamage > 0 then
			if nAdjustedDamage > temphp then
				nAdjustedDamage = nAdjustedDamage - temphp;
				temphp = 0;
				table.insert(aNotifications, "[PARTIALLY ABSORBED]");
			else
				temphp = temphp - nAdjustedDamage;
				nAdjustedDamage = 0;
				table.insert(aNotifications, "[ABSORBED]");
			end
		end

		-- Update the damage output variable to reflect adjustments
		rDamageOutput.nVal = nAdjustedDamage;
		if nAdjustedDamage > 0 then
			rDamageOutput.sVal = "" .. nAdjustedDamage;
			if nNonlethal > 0 then
				rDamageOutput.sVal = rDamageOutput.sVal .. " (+" .. nNonlethal .. " NL)";
			end
		elseif nNonlethal > 0 then
			rDamageOutput.sVal = "" .. nNonlethal .. " NL";
		else
			rDamageOutput.sVal = "0";
		end

		-- APPLY REMAINING DAMAGE
		local nOriginalWounds = wounds;
		wounds = wounds + nAdjustedDamage;
		if wounds < 0 then
			wounds = 0;
		end
		local nOriginalNonlethal = nonlethal;
		nonlethal = nonlethal + nNonlethal;
		if nonlethal < 0 then
			nonlethal = 0;
		end

		-- ADD STATUS CHANGE NOTIFICATIONS
		if nTotal > 0 then
			if (nNonlethal > 0) then
				if (nOriginalWounds + nOriginalNonlethal < totalhp) and (wounds + nonlethal == totalhp) then
					table.insert(aNotifications, "[STAGGERED]");
				elseif (nOriginalWounds + nOriginalNonlethal <= totalhp) and (wounds + nonlethal > totalhp) then
					table.insert(aNotifications, "[UNCONSCIOUS]");
				end
			end
			
			local moderate_hp = totalhp / 3;
			local heavy_hp = 2 * moderate_hp;
			if (nOriginalWounds < totalhp + 10) and (wounds >= totalhp + 10) then
				table.insert(aNotifications, "[DEAD]");
			elseif (nOriginalWounds < totalhp) and (wounds > totalhp) then
				table.insert(aNotifications, "[DYING]");
			elseif (nOriginalWounds < totalhp) and (wounds == totalhp) then
				table.insert(aNotifications, "[DISABLED]");
			elseif (nOriginalWounds < heavy_hp) and (wounds >= heavy_hp) then
				table.insert(aNotifications, "[HEAVY DAMAGE]");
			elseif (nOriginalWounds < moderate_hp) and (wounds >= moderate_hp) then
				table.insert(aNotifications, "[MODERATE DAMAGE]");
			end
		end
	end

	-- SET HEALTH FIELDS
	if rTarget.sType == "pc" and rTarget.nodeCreature then
		NodeManager.set(rTarget.nodeCreature, "hp.temporary", "number", temphp);
		NodeManager.set(rTarget.nodeCreature, "hp.wounds", "number", wounds);
		NodeManager.set(rTarget.nodeCreature, "hp.nonlethal", "number", nonlethal);
		NodeManager.set(rTarget.nodeCreature, "hp.surgesused", "number", nSurgeUsed);
	else
		NodeManager.set(rTarget.nodeCT, "hptemp", "number", temphp);
		NodeManager.set(rTarget.nodeCT, "wounds", "number", wounds);
		NodeManager.set(rTarget.nodeCT, "nonlethal", "number", nonlethal);

		if NodeManager.get(rTarget.nodeCT, "type", "") == "pc" then
			NodeManager.set(rTarget.nodeCT, "healsurgesused", "number", nSurgeUsed);
		else
			NodeManager.set(rTarget.nodeCT, "healsurgeremaining", "number", nSurgeMax - nSurgeUsed);
		end
	end

	-- OUTPUT RESULTS
	messageDamage(rSource, rTarget, rDamageOutput.sTypeOutput, sDamage, rDamageOutput.sVal, table.concat(aNotifications, " "));
end

function messageDamage(rSource, rTarget, sDamageType, sDamageDesc, sTotal, sExtraResult)
	if not (rTarget or sExtraResult ~= "") then
		return;
	end
	
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};

	if sDamageType == "Heal" or sDamageType == "Temporary hit points" then
		msgShort.icon = "indicator_heal";
		msgLong.icon = "indicator_heal";
	else
		msgShort.icon = "indicator_damage";
		msgLong.icon = "indicator_damage";
	end

	msgShort.text = sDamageType .. " ->";
	msgLong.text = sDamageType .. " [" .. sTotal .. "] ->";
	if rTarget then
		msgShort.text = msgShort.text .. " [to " .. rTarget.sName .. "]";
		msgLong.text = msgLong.text .. " [to " .. rTarget.sName .. "]";
	end
	
	if sExtraResult and sExtraResult ~= "" then
		msgLong.text = msgLong.text .. " " .. sExtraResult;
	end
	
	local bGMOnly = string.match(sDamageDesc, "^%[GM%]") or string.match(sDamageDesc, "^%[TOWER%]") ;
	messageResult(bGMOnly, rSource, rTarget, msgLong, msgShort);
end

function messageResult(bGMOnly, rSource, rTarget, rMessageLong, rMessageShort)
	if bGMOnly then
		rMessageLong.text = "[GM] " .. rMessageLong.text;
		Comm.deliverChatMessage(rMessageLong, "");
	else
		local bShowResultToPlayer = OptionsManager.isOption("REVL", "on");
		if not bShowResultToPlayer then
			if (not rSource or rSource.sType == "pc") and (not rTarget or rTarget.sType == "pc") then
				bShowResultToPlayer = true;
			end
		end

		if bShowResultToPlayer then
			Comm.deliverChatMessage(rMessageLong);
		else
			rMessageLong.text = "[GM] " .. rMessageLong.text;
			Comm.deliverChatMessage(rMessageLong, "");

			if Session.IsHost then
				local aUsers = User.getActiveUsers();
				if #aUsers > 0 then
					Comm.deliverChatMessage(rMessageShort, aUsers);
				end
			else
				Comm.addChatMessage(rMessageShort);
			end
		end
	end
end