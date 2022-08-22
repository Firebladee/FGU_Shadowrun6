-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYDMG = "applydmg";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYDMG, handleApplyDamage);

	ActionsManager.registerTargetingHandler("damage", onTargeting);
	ActionsManager.registerTargetingHandler("spdamage", onSpellTargeting);
	
	ActionsManager.registerModHandler("damage", modDamage);
	ActionsManager.registerModHandler("spdamage", modDamage);
	
	ActionsManager.registerResultHandler("damage", onDamage);
	ActionsManager.registerResultHandler("spdamage", onDamage);
	ActionsManager.registerResultHandler("stabilization", onStabilization);
end

function handleApplyDamage(msgOOB)
	-- GET THE TARGET ACTOR
	local rTarget = ActorManager.getActor("ct", msgOOB.sTargetCTNode);
	if not rTarget then
		rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetCreatureNode);
	end
	
	-- GET THE SOURCE ACTOR
	local rSource = ActorManager.getActor("ct", msgOOB.sSourceCTNode);
	
	-- Apply the damage
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	RulesManager.applyDamage(rSource, rTarget, msgOOB.sDamage, nTotal);
end

function onTargeting(rSource, rRolls)
	return TargetingManager.getFullTargets(rSource), false;
end

function onSpellTargeting(rSource, rRolls)
	return TargetingManager.getFullTargets(rSource), true;
end

function performStabilizationRoll(rActor)
	local rRoll = { sType = "stabilization", sDesc = "[STABILIZATION]", aDice = { "d100", "d10" }, nValue = 0 };

	ActionsManager.roll(rActor, nil, rRoll);
end

function getRoll(rActor, rAction)
	local rRoll = {};
	
	-- Build basic roll
	rRoll.aDice = {};
	rRoll.nValue = 0;
	
	-- Build the description label
	rRoll.sDesc = "[DAMAGE";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	if rAction.range then
		rRoll.sDesc = rRoll.sDesc .. " (" .. rAction.range ..")";
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;
	
	-- Add base.attribute modifiers and multiples
	if rAction.stat ~= "" then
		if (rAction.range == "M" and rAction.statmult ~= 1) or (rAction.range == "R" and rAction.statmult ~= 0) then
			rRoll.sDesc = rRoll.sDesc .. " [MULT:" .. rAction.statmult .. "]";
		end
	end
	if (rAction.stat ~= "strength" and rAction.statmult ~= 0) or (rAction.statmax and rAction.statmax > 0) then
		local sAttributeEffect = DataCommon.attribute_ltos[rAction.stat];
		if sAttributeEffect then
			rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. sAttributeEffect;
			if rAction.statmax and rAction.statmax > 0 then
				rRoll.sDesc = rRoll.sDesc .. ":" .. rAction.statmax;
			end
			rRoll.sDesc = rRoll.sDesc .. "]";
		end
	end
	if rAction.stat2 ~= "" then
		local sAttributeEffect = DataCommon.attribute_ltos[rAction.stat2];
		if sAttributeEffect then
			rRoll.sDesc = rRoll.sDesc .. " [MOD2:" .. sAttributeEffect .. "]";
		end
	end
	
	-- Iterate through damage clauses to get dice, modifiers and damage types
	local aDamageTypes = {};
	for k, v in pairs(rAction.clauses) do
		local nClauseDice = 0;
		local nClauseMod = 0;
		local nClauseMult = v.mult or 2;
		
		for kDie, vDie in ipairs(v.dice) do
			table.insert(rRoll.aDice, vDie);
			nClauseDice = nClauseDice + 1;
		end
			
		nClauseMod = v.modifier;
		rRoll.nValue = rRoll.nValue + v.modifier;
		
		if (nClauseDice > 0) or (nClauseMod ~= 0) then
			table.insert(aDamageTypes, { sType = v.dmgtype, nDice = nClauseDice, nValue = nClauseMod, nMult = nClauseMult } );
		end
	end
	if #aDamageTypes > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. encodeDamageTypes(aDamageTypes);
	end
	
	return rRoll;
end

function performRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(rActor, rAction);
	
	ActionsManager.performSingleRollAction(draginfo, rActor, "damage", rRoll, true);
end

function modDamage(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	if rTarget and rTarget.nOrder then
		if rSource and rSource.nodeCT then
			local sAttackType = string.match(rRoll.sDesc, "%[DAMAGE.*%((%w+)%)%]");
			local aAttackFilter = {};
			if sAttackType == "R" then
				table.insert(aAttackFilter, "ranged");
			elseif sAttackType == "M" then
				table.insert(aAttackFilter, "melee");
			end
			
			local nAddEffect;
			aAddDice, nAddMod, nAddEffect = EffectsManager.getEffectsBonus(rSource.nodeCT, "DMG", false, aAttackFilter, rTarget, true);
			if nAddEffect > 0 then
				nAddMod = StringManager.evalDice(aAddDice, nAddMod);
			
				rRoll.nValue = rRoll.nValue + nAddMod;
				if nAddMod > 0 then
					rRoll.sDesc = rRoll.sDesc .. " [SPECIFIC +" .. nAddMod .. "]";
				else
					rRoll.sDesc = rRoll.sDesc .. " [SPECIFIC " .. nAddMod .. "]";
				end
			end
		end
		
		return;
	end
	
	local aDamageTypes = decodeDamageTypes(false, rRoll.sDesc, rRoll.aDice, rRoll.nValue);
	rRoll.sDesc = string.gsub(rRoll.sDesc, " %[TYPE: ([^]]+)%]", "");
	
	-- IS CRITICAL?
	local bCritical = ModifierStack.getModifierKey("DMG_CRIT") or Input.isShiftPressed();
	if bCritical then
		local aAddDamageTypes = {};
		table.insert(aAddDesc, "[CRITICAL]");

		local nDiceIndex = 0;
		for k,v in pairs(aDamageTypes) do
			local nMult = v.nMult or 2;
			if nMult > 1 then
				for i = 2, nMult do
					for j = 1, v.nDice do
						local nIndex = nDiceIndex + j;
						if nIndex <= #(rRoll.aDice) then
							table.insert(aAddDice, rRoll.aDice[nIndex]);
						end
					end
					nAddMod = nAddMod + v.nValue;
				end
				nDiceIndex = nDiceIndex + v.nDice;
				
				table.insert(aAddDamageTypes, { sType = v.sType, nDice = v.nDice * (nMult - 1), nValue = v.nValue * (nMult - 1), nMult = v.nMult });
			end
		end
		
		for k, v in ipairs(aAddDamageTypes) do
			table.insert(aDamageTypes, v);
		end
	end
	
	-- IS HALF?
	local bHalf = ModifierStack.getModifierKey("DMG_HALF");
	if bHalf then
		table.insert(aAddDesc, "[HALF]");
	end
	
	if rSource then
		local bEffects = false;

		local sAttackType = string.match(rRoll.sDesc, "%[DAMAGE.*%((%w+)%)%]");

		-- GET STATS AND MULTIPLES
		local nMult = 1;
		if sAttackType == "R" then
			nMult = 0;
		end
		local sModMult = string.match(rRoll.sDesc, "%[MULT:([%d.]+)%]");
		if sModMult then
			nMult = tonumber(sModMult) or nMult;
			if nMult < 0 then
				nMult = 1;
			end
		end
		local sActionStat = nil;
		local nActionStatMax = 0;
		local sModStat, sModMax = string.match(rRoll.sDesc, "%[MOD:(%w+):?(%d*)%]");
		if sModStat then
			sActionStat = DataCommon.attribute_stol[sModStat];
			nActionStatMax = tonumber(sModMax) or 0;
		end
		if not sActionStat then
			sActionStat = "strength";
		end
		local sActionStat2 = nil;
		local sModStat2 = string.match(rRoll.sDesc, "%[MOD2:%w+%]");
		if sModStat2 then
			sActionStat2 = DataCommon.attribute_stol[sModStat2];
		end

		local aAttackFilter = {};
		if sAttackType == "R" then
			table.insert(aAttackFilter, "ranged");
		elseif sAttackType == "M" then
			table.insert(aAttackFilter, "melee");
		end
		
		-- NOTE: Effect damage dice are not multiplied on critical, though numerical modifiers are multiplied
		-- http://rpg.stackexchange.com/questions/4465/is-smite-evil-damage-multiplied-by-a-critical-hit
		-- NOTE: Using damage type of the first damage clause for the bonuses
		local aEffectDice = {};
		local nEffectMod = 0;

		-- GET STAT MODIFIERS
		local nBonusStat, nBonusEffects;
		if nMult > 0 then
			local nActionStatMod = ActorManager.getAttributeBonus(rSource, sActionStat);
			
			nBonusStat, nBonusEffects = ActorManager.getattributeEffectsBonus(rSource, sActionStat);

			if nBonusEffects > 0 then
				bEffects = true;
			end
			if nBonusStat > 0 and nActionStatMax > 0 then
				nBonusStat = math.min(nBonusStat, nActionStatMax);
			end
			
			-- WORKAROUND: If max limited, then assume bows which allow no penalty
			if nBonusStat >= 0 then
				if nActionStatMod >= 0 then
					nEffectMod = nEffectMod + math.floor(nBonusStat * nMult);
				else
					if nActionStatMax > 0 then
						nBonusStat = math.max(nBonusStat + nActionStatMod, 0);
						nEffectMod = nEffectMod + math.floor(nBonusStat * nMult);
					else
						if nBonusStat + nActionStatMod > 0 then
							nEffectMod = nEffectMod + (-nActionStatMod);
							nEffectMod = nEffectMod + math.floor((nBonusStat + nActionStatMod) * nMult);
						else
							nEffectMod = nEffectMod + nBonusStat;
						end
					end
				end
			elseif nBonusStat < 0 then
				if nActionStatMod <= 0 then
					if nActionStatMax == 0 then
						nEffectMod = nEffectMod + nBonusStat;
					end
				else
					if nActionStatMod + nBonusStat < 0 then
						nEffectMod = nEffectMod - math.floor(nActionStatMod * nMult);
						if nActionStatMax == 0 then
							nEffectMod = nEffectMod + (nActionStatMod + nBonusStat);
						end
					else
						nEffectMod = nEffectMod + math.floor(nBonusStat * nMult);
					end
				end
			end
		end
		nBonusStat, nBonusEffects = ActorManager.getattributeEffectsBonus(rSource, sActionStat2);
		if nBonusEffects > 0 then
			bEffects = true;
			nEffectMod = nEffectMod + nBonusStat;
		end

		-- GET CONDITION MODIFIERS
		if EffectsManager.hasEffectCondition(rSource, "Sickened") then
			nEffectMod = nEffectMod - 2;
			bEffects = true;
		end

		-- APPLY CRITICAL MULTIPLIER TO EFFECTS SO FAR
		if bCritical then
			local nEffectCritMult = 2;
			if #aDamageTypes > 0 then
				nEffectCritMult = aDamageTypes[1].nMult or 2;
			end
			
			nEffectMod = nEffectMod * nEffectCritMult;
		end
		
		-- GET GENERAL DAMAGE MODIFIERS
		local aEffects, nEffectCount = EffectsManager.getEffectsBonusByType(rSource.nodeCT, {"DMG"}, true, aAttackFilter);
		if nEffectCount > 0 then
			bEffects = true;
			
			local nEffectCritMult = 2;
			local sEffectBaseType = "";
			if #aDamageTypes > 0 then
				nEffectCritMult = aDamageTypes[1].nMult or 2;
				sEffectBaseType = aDamageTypes[1].sType or "";
			end
			
			for k, v in pairs(aEffects) do
				for k2, v2 in ipairs(v.dice) do
					table.insert(aEffectDice, v2);
				end
				
				local nCurrentMod;
				if bCritical then
					nCurrentMod = (v.mod * nEffectCritMult);
				else
					nCurrentMod = v.mod;
				end
				nEffectMod = nEffectMod + nCurrentMod;
				
				local aEffectDmgType = {};
				if sEffectBaseType ~= "" then
					table.insert(aEffectDmgType, sEffectBaseType);
				end
				for kWord, sWord in ipairs(v.remainder) do
					if StringManager.contains(DataCommon.dmgtypes, sWord) then
						table.insert(aEffectDmgType, sWord);
					end
				end
				if #aEffectDmgType > 0 then
					table.insert(aDamageTypes, { sType = table.concat(aEffectDmgType, ","), nDice = #(v.dice), nValue = nCurrentMod, nMult = nEffectCritMult });
				else
					table.insert(aDamageTypes, { sType = "", nDice = #(v.dice), nValue = nCurrentMod, nMult = nEffectCritMult });
				end
			end
		end
		
		-- GET DAMAGE TYPE MODIFIER
		local aEffects = EffectsManager.getEffectsByType(rSource.nodeCT, "DMGTYPE", {});
		local aAddTypes = {};
		for k, v in ipairs(aEffects) do
			for k2, v2 in ipairs(v.remainder) do
				local aSplitTypes = StringManager.split(v2, ",", true);
				for k3, v3 in ipairs(aSplitTypes) do
					table.insert(aAddTypes, v3);
				end
			end
		end
		if #aAddTypes > 0 then
			for k, v in ipairs(aDamageTypes) do
				local aSplitTypes = StringManager.split(v.sType, ",", true);
				for k2, v2 in ipairs(aAddTypes) do
					if not StringManager.contains(aSplitTypes, v2) then
						if v.sType ~= "" then
							v.sType = v.sType .. "," .. v2;
						else
							v.sType = v2;
						end
					end
				end
			end
		end
		
		-- IF EFFECTS HAPPENED, THEN ADD NOTE
		if bEffects then
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aEffectDice, nEffectMod, true);
			if sMod ~= "" then
				sEffects = "[EFFECTS " .. sMod .. "]";
			else
				sEffects = "[EFFECTS]";
			end
			table.insert(aAddDesc, sEffects);
			
			for k, v in ipairs(aEffectDice) do
				table.insert(aAddDice, v);
			end
			nAddMod = nAddMod + nEffectMod;
		end
	end
	
	if #aDamageTypes > 0 then
		table.insert(aAddDesc, encodeDamageTypes(aDamageTypes));
	end
	
	if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
	end
	for k, v in ipairs(aAddDice) do
		table.insert(rRoll.aDice, v);
	end
	rRoll.nValue = rRoll.nValue + nAddMod;
end

function onDamage(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local rAction = {};
	rAction.nTotal = ActionsManager.total(rRoll);
	rAction.aMessages = {};
	
	-- DETERMINE DAMAGE TYPES FOR THIS ROLL
	local aDamageTypes = decodeDamageTypes(true, rRoll.sDesc, rRoll.aDice, rRoll.nValue);
	if #aDamageTypes > 0 then
		-- BUILD THE TYPE SUB-TOTALS
		local nTypeIndex = 1;
		local nTypeCount = 0;
		local nTypeTotal = 0;
		for i, d in ipairs(rRoll.aDice) do
			if nTypeIndex <= #aDamageTypes then
				nTypeCount = nTypeCount + 1;
				nTypeTotal = nTypeTotal + d.result;
				
				if nTypeCount >= aDamageTypes[nTypeIndex].nDice then
					nTypeTotal = nTypeTotal + aDamageTypes[nTypeIndex].nValue;
					aDamageTypes[nTypeIndex].nTotal = nTypeTotal;
					
					nTypeIndex = nTypeIndex + 1;
					nTypeCount = 0;
					nTypeTotal = 0;
				end
			end
		end

		-- HANDLE ANY REMAINING FIXED DAMAGE
		for i = nTypeIndex, #aDamageTypes do
			aDamageTypes[i].nTotal = aDamageTypes[i].nValue;
		end
			
		-- ADD DAMAGE TYPE SUB-TOTALS TO OUTPUT
		rMessage.text = string.gsub(rMessage.text, " %[TYPE: ([^]]+)%]", "");
		rMessage.text = rMessage.text .. " " .. encodeDamageTypes(aDamageTypes);
	end

	-- HANDLE MINIMUM DAMAGE
	if rAction.nTotal <= 0 then
		local nMinDmgAdj = -(rAction.nTotal) + 1;
		rMessage.text = rMessage.text .. " [MIN DMG ADJ +" .. nMinDmgAdj .. "]";
		rMessage.diemodifier = rMessage.diemodifier + nMinDmgAdj;
		rAction.nTotal = rAction.nTotal + nMinDmgAdj;
	end
	
	local bShowMsg = true;
	if rTarget and rTarget.nOrder and rTarget.nOrder ~= 1 then
		if not string.match(rRoll.sDesc, "%[SPECIFIC") then
			bShowMsg = false;
		end
	end
	if bShowMsg then
		Comm.deliverChatMessage(rMessage);
	end

	-- Apply damage to the PC or combattracker referenced
	if rTarget then
		if rTarget.nodeCT or (rTarget.sType == "pc" and rTarget.nodeCreature) then
			local msgOOB = {};
			msgOOB.type = OOB_MSGTYPE_APPLYDMG;
			
			msgOOB.nTotal = rAction.nTotal;
			msgOOB.sDamage = rMessage.text;
			msgOOB.sTargetType = rTarget.sType;
			msgOOB.sTargetCreatureNode = rTarget.sCreatureNode;
			msgOOB.sTargetCTNode = rTarget.sCTNode;
			if rSource then
				msgOOB.sSourceCTNode = rSource.sCTNode;
			end

			Comm.deliverOOBMessage(msgOOB, "");
		end
	end
end

function onStabilization(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local nTotal = ActionsManager.total(rRoll);
	if nTotal <= 10 then
		rMessage.text = rMessage.text .. " [SUCCESS]";
	else
		rMessage.text = rMessage.text .. " [FAILURE]";
	end
	
	Comm.deliverChatMessage(rMessage);

	if nTotal <= 10 then
		EffectsManager.addEffect("", "", rSource.nodeCT, { sName = "Stable", nDuration = 0 }, true);
	else
		RulesManager.applyDamage(nil, rSource, "[DAMAGE] Dying", 1);
	end
end

--
-- UTILITY FUNCTIONS
--

function encodeDamageTypes(aDamageTypes)
	local aOutputType = {};
	
	local nTypeCount = 0;
	local sLastDamageType = nil;
	local nLastDieCount = 0;
	local nLastMod = 0;
	local nLastTotal = nil;
	local nLastMult = 2;
	for k, v in ipairs(aDamageTypes) do
		local nCurrentMult = v.nMult or 2;
		
		local sCurrentDamageType = string.lower(v.sType);
		
		if sLastDamageType and ((sCurrentDamageType ~= sLastDamageType) or (nCurrentMult ~= nLastMult)) then
			local sDmgType;
			if sLastDamageType == "" then
				sDmgType = "[TYPE: untyped";
			else
				sDmgType = "[TYPE: " .. sLastDamageType;
			end
			sDmgType = sDmgType .. " (" .. nLastDieCount .. "D";
			if nLastMod > 0 then
				sDmgType = sDmgType .. "+" .. nLastMod;
			elseif nLastMod < 0 then
				sDmgType = sDmgType .. nLastMod;
			end
			if nLastTotal then
				sDmgType = sDmgType .. "=" .. nLastTotal;
			end
			sDmgType = sDmgType .. ")";
			if nLastMult ~= 2 then
				sDmgType = sDmgType .. "(x" .. nLastMult .. ")";
			end
			sDmgType = sDmgType .. "]";
			
			table.insert(aOutputType, sDmgType);
			
			nTypeCount = nTypeCount + 1;
			nLastDieCount = 0;
			nLastMod = 0;
		end
		
		sLastDamageType = sCurrentDamageType;
		nLastDieCount = nLastDieCount + v.nDice;
		nLastMod = nLastMod + v.nValue;
		nLastMult = nCurrentMult;
		nLastTotal = v.nTotal;
	end
	if sLastDamageType and ((sLastDamageType ~= "") or (nLastMult ~= 2)) then
		local sDmgType;
		if sLastDamageType == "" then
			sDmgType = "[TYPE: untyped";
		else
			sDmgType = "[TYPE: " .. sLastDamageType;
		end
		if nTypeCount > 0 then
			sDmgType = sDmgType .. " (" .. nLastDieCount .. "D";
			if nLastMod > 0 then
				sDmgType = sDmgType .. "+" .. nLastMod;
			elseif nLastMod < 0 then
				sDmgType = sDmgType .. nLastMod;
			end
			if nLastTotal then
				sDmgType = sDmgType .. "=" .. nLastTotal;
			end
			sDmgType = sDmgType .. ")";
		end
		if nLastMult ~= 2 then
			sDmgType = sDmgType .. "(x" .. nLastMult .. ")";
		end
		sDmgType = sDmgType .. "]";
		
		table.insert(aOutputType, sDmgType);
	end
	
	return table.concat(aOutputType, " ");
end

function decodeDamageTypes(bRolled, sDesc, aDice, nValue)
	local aDamageTypes = {};
	
	local nDamageDice = 0;
	local nDamageMod = 0;
	
	for sDamageClause in string.gmatch(sDesc, "%[TYPE: ([^]]+)%]") do
		local sDamageType = string.match(sDamageClause, "^([,%w%s]+)");
		if sDamageType then
			sDamageType = StringManager.trimString(sDamageType);
			
			local nTotal = nil;
			local sDieCount, sSign, sMod = string.match(sDamageClause, "%((%d+)D([%+%-]?)(%d*)");
			local nDieCount = tonumber(sDieCount) or 0;
			local nDieMod = tonumber(sMod) or 0;
			if nDieCount > 0 or nDieMod > 0 then
				if sSign == "-" then
					nDieMod = 0 - nDieMod;
				end
			else
				nDieCount = #aDice - nDamageDice;
				nDieMod = nValue - nDamageMod;
			end

			nDamageDice = nDamageDice + nDieCount;
			nDamageMod = nDamageMod + nDieMod;

			if sDamageType == "untyped" then
				sDamageType = "";
			end
			
			local rDamageType = { sType = sDamageType, nDice = nDieCount, nValue = nDieMod };

			local sMult = string.match(sDamageClause, "%(x(%d+)%)");
			if sMult then
				rDamageType.nMult = tonumber(sMult) or 2;
			end
			local sTotal = string.match(sDamageClause, "%(%d+D[%+%-]?%d*=(%d+)%)");
			if sTotal then
				rDamageType.nTotal = tonumber(sTotal) or 0;
			end
			
			table.insert(aDamageTypes, rDamageType);
		end
	end
	
	if (nDamageDice < #aDice) or (nDamageMod ~= nValue) then
		local rDamageType = { sType = "", nDice = (#aDice - nDamageDice), nValue = (nValue - nDamageMod) };
		if bRolled then
			rDamageType.nTotal = 0;
			if (nDamageDice < #aDice) then
				for i = nDamageDice + 1, #aDice do
					rDamageType.nTotal = rDamageType.nTotal + aDice[i].result;
				end
			end
			rDamageType.nTotal = rDamageType.nTotal + rDamageType.nValue;
		end
		
		table.insert(aDamageTypes, rDamageType);
	end
	
	return aDamageTypes;
end

function getDamageTypesFromString(sDamageTypes)
	local sLower = string.lower(sDamageTypes);
	local aSplit = StringManager.split(sLower, ",", true);
	
	local aDamageTypes = {};
	for k, v in ipairs(aSplit) do
		if StringManager.contains(DataCommon.dmgtypes, v) then
			table.insert(aDamageTypes, v);
		end
	end
	
	return aDamageTypes;
end