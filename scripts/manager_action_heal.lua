-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerTargetingHandler("heal", onTargeting);
	
	ActionsManager.registerModHandler("heal", modHeal);
	
	ActionsManager.registerResultHandler("heal", onHeal);
end

function onTargeting(rSource, rRolls)
	return TargetingManager.getFullTargets(rSource), true;
end

function getRoll(rCreature, rAction)
	local rRoll = {};

	-- Build the basic roll
	rRoll.aDice = rAction.dice;
	rRoll.nValue = rAction.modifier;
	
	-- Build the description
	rRoll.sDesc = "[HEAL";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;
	if rAction.stat ~= "" then
		local sAttributeEffect = DataCommon.attribute_ltos[rAction.stat];
		if sAttributeEffect then
			rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. sAttributeEffect;
			if rAction.statmax and rAction.statmax > 0 then
				rRoll.sDesc = rRoll.sDesc .. ":" .. rAction.statmax;
			end
			rRoll.sDesc = rRoll.sDesc .. "]";
		end
	end
	if rAction.subtype == "temp" then
		rRoll.sDesc = rRoll.sDesc .. " [TEMP]";
	end

	return rRoll;
end

function modHeal(rSource, rTarget, rRoll)
	if rTarget and rTarget.nOrder then
		return;
	end
	
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	if rSource then
		local bEffects = false;

		-- DETERMINE STAT IF ANY
		local sActionStat = nil;
		local nActionStatMax = 0;
		local sModStat, sModMax = string.match(rRoll.sDesc, "%[MOD:(%w+):?(%d*)%]");
		if sModStat then
			sActionStat = DataCommon.attribute_stol[sModStat];
			nActionStatMax = tonumber(sModMax) or 0;
		end
		
		-- DETERMINE EFFECTS
		local nEffectCount;
		aAddDice, nAddMod, nEffectCount = EffectsManager.getEffectsBonus(rSource.nodeCT, {"HEAL"});
		if (nEffectCount > 0) then
			bEffects = true;
		end
		
		-- GET STAT MODIFIERS
		local nBonusStat, nBonusEffects = ActorManager.getattributeEffectsBonus(rSource, sActionStat);
		if nBonusEffects > 0 then
			bEffects = true;
			if (nActionStatMax > 0) and (nBonusStat > nActionStatMax) then
				nBonusStat = nActionStatMax;
			end
			nAddMod = nAddMod + nBonusStat;
		end
		
		-- IF EFFECTS HAPPENED, THEN ADD NOTE
		if bEffects then
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
			if sMod ~= "" then
				sEffects = "[EFFECTS " .. sMod .. "]";
			else
				sEffects = "[EFFECTS]";
			end
			table.insert(aAddDesc, sEffects);
		end
	end
	
	if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
	end
	for k, v in ipairs(aAddDice) do
		table.insert(rRoll.aDice, v);
	end
	rRoll.nValue = rRoll.nValue + nAddMod;
end

function onHeal(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	Comm.deliverChatMessage(rMessage);
	
	-- Apply heal to the PC or combattracker referenced
	if rTarget then
		if rTarget.nodeCT or (rTarget.sType == "pc" and rTarget.nodeCreature) then
			local nTotal = ActionsManager.total(rRoll);

			local msgOOB = {};
			msgOOB.type = ActionDamage.OOB_MSGTYPE_APPLYDMG;
			
			msgOOB.nTotal = nTotal;
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
