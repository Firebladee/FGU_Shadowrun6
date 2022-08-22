-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYATK = "applyatk";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYATK, handleApplyAttack);

--	ActionsManager.registerMultiHandler("fullattack", translateFullAttack);
	
	ActionsManager.registerTargetingHandler("attack", onTargeting);
	ActionsManager.registerTargetingHandler("grapple", onTargeting);
	ActionsManager.registerTargetingHandler("fullattack", onTargeting);
	
	ActionsManager.registerModHandler("attack", modAttack);
	ActionsManager.registerResultHandler("attack", onAttack);
	ActionsManager.registerResultHandler("misschance", onMissChance);
end

function handleApplyAttack(msgOOB)
	-- GET THE SOURCE ACTOR
	local rSource = ActorManager2.getActor("ct", msgOOB.sSourceCTNode);
	
	-- GET THE TARGET ACTOR
	local rTarget = ActorManager2.getActor("ct", msgOOB.sTargetCTNode);
	if not rTarget then
		rTarget = ActorManager2.getActor(msgOOB.sTargetType, msgOOB.sTargetCreatureNode);
	end
	
	-- Apply the damage
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	RulesManager.applyAttack(rSource, rTarget, msgOOB.sDesc, nTotal, msgOOB.sResults);
end

function translateFullAttack(nSlot)
	return "attack";
end

function onTargeting(rSource, rRolls)
	local aTargets = TargetingManager.getFullTargets(rSource);
	
	if #aTargets > 1 then
		for kRoll, vRoll in ipairs(rRolls) do
			if not string.match(vRoll.sDesc, "%[FULL%]") then
				vRoll.sDesc = vRoll.sDesc .. " [MULTI]";
			end
		end
	end
	
	return aTargets, false;
end

function getRoll(rActor, rAction)
	local rRoll = {};
	
	-- Build basic roll
	rRoll.aDice = { "d20" };
	rRoll.nValue = rAction.modifier or 0;
	
	-- Build the description label
	rRoll.sDesc = "[ATTACK";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	if rAction.range then
		rRoll.sDesc = rRoll.sDesc .. " (" .. rAction.range .. ")";
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;
	
	-- Add base.attribute modifiers
	if rAction.stat then
		if (rAction.range == "M" and rAction.stat ~= "strength") or (rAction.range == "R" and rAction.stat ~= "dexterity") then
			local sAttributeEffect = DataCommon.attribute_ltos[rAction.stat];
			if sAttributeEffect then
				rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. sAttributeEffect .. "]";
			end
		end
	end
	
	-- Add other modifiers
	if rAction.crit and rAction.crit < 20 then
		rRoll.sDesc = rRoll.sDesc .. " [CRIT " .. rAction.crit .. "]";
	end
	if rAction.touch then
		rRoll.sDesc = rRoll.sDesc .. " [TOUCH]";
	end
	
	return rRoll;
end

function performRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(rActor, rAction);
	
	ActionsManager.performSingleRollAction(draginfo, rActor, "attack", rRoll);
end

function onAttack(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local rAction = {};
	rAction.nTotal = ActionsManager.total(rRoll);
	rAction.aMessages = {};
	
	-- If we have a target, then calculate the defense we need to exceed
	local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus, nMissChance = ActorManager.getDefenseValue(rSource, rTarget, rRoll.sDesc);
	if nAtkEffectsBonus ~= 0 then
		table.insert(rAction.aMessages, string.format("[EFFECTS %+d]", nAtkEffectsBonus));
	end
	if nDefEffectsBonus ~= 0 then
		table.insert(rAction.aMessages, string.format("[DEF EFFECTS %+d]", nDefEffectsBonus));
	end

	-- Get the crit threshold
	rAction.nCrit = 20;	
	local sAltCritRange = string.match(rRoll.sDesc, "%[CRIT (%d+)%]");
	if sAltCritRange then
		rAction.nCrit = tonumber(sAltCritRange) or 20;
		if (rAction.nCrit <= 1) or (rAction.nCrit > 20) then
			rAction.nCrit = 20;
		end
	end
	
	rAction.nFirstDie = 0;
	if #(rRoll.aDice) > 0 then
		rAction.nFirstDie = rRoll.aDice[1].result or 0;
	end
	rAction.bCritThreat = false;
	if rAction.nFirstDie >= 20 then
		rAction.bSpecial = true;
		if not (rSource and rSource.sType == "pc") and OptionsManager.isOption("REVL", "off") then
			ChatManager.Message("[GM] Original attack = " .. rAction.nFirstDie .. "+" .. rRoll.nValue .. "=" .. rAction.nTotal, false);
			rMessage.diemodifier = 0;
		end
		if (rRoll.sType == "critconfirm") then
			rAction.sResult = "crit";
			table.insert(rAction.aMessages, "[CRITICAL HIT]");
		else
			rAction.sResult = "hit";
			rAction.bCritThreat = true;
			table.insert(rAction.aMessages, "[AUTOMATIC HIT]");
		end
	elseif rAction.nFirstDie == 1 then
		rAction.sResult = "miss";
		if not (rSource and rSource.sType == "pc") and OptionsManager.isOption("REVL", "off") then
			rMessage.diemodifier = 0;
		end
		if (rRoll.sType == "critconfirm") then
			table.insert(rAction.aMessages, "[CRIT NOT CONFIRMED]");
		else
			table.insert(rAction.aMessages, "[AUTOMATIC MISS]");
		end
	elseif nDefenseVal then
		if rAction.nTotal >= nDefenseVal then
			if rRoll.sType == "critconfirm" then
				rAction.sResult = "crit";
				table.insert(rAction.aMessages, "[CRITICAL HIT]");
			else
				rAction.sResult = "hit";
				if rAction.nFirstDie >= rAction.nCrit then
					table.insert(rAction.aMessages, "[CRITICAL THREAT]");
					rAction.bCritThreat = true;
				else
					table.insert(rAction.aMessages, "[HIT]");
				end
			end
		else
			rAction.sResult = "miss";
			if rRoll.sType == "critconfirm" then
				table.insert(rAction.aMessages, "[CRIT NOT CONFIRMED]");
			else
				table.insert(rAction.aMessages, "[MISS]");
			end
		end
	elseif rAction.nFirstDie >= rAction.nCrit then
		table.insert(rAction.aMessages, "[CRITICAL THREAT, CHECK AC]");
		rAction.bCritThreat = true;
	end
	
	if rRoll.sType == "attack" and nMissChance > 0 then
		table.insert(rAction.aMessages, "[MISS CHANCE " .. nMissChance .. "%]");
	end

	Comm.deliverChatMessage(rMessage);

	if rRoll.sType ~= "critconfirm" then
		if rAction.bCritThreat and OptionsManager.isOption("HRCC", "on") then
			local rCritConfirmRoll = { sType = "critconfirm", aDice = {"d20"} };
			
			local nCCMod = EffectsManager.getEffectsBonus(rSource.nodeCT, {"CC"}, true);
			if nCCMod > 0 then
				rCritConfirmRoll.sDesc = rRoll.sDesc .. " [CONFIRM +" .. nCCMod .. "]";
			elseif nCCMod < 0 then
				rCritConfirmRoll.sDesc = rRoll.sDesc .. " [CONFIRM " .. nCCMod .. "]";
			else
				rCritConfirmRoll.sDesc = rRoll.sDesc .. " [CONFIRM]";
			end
			rCritConfirmRoll.nValue = rRoll.nValue + nCCMod;
			
			ActionsManager.roll(rSource, rTarget, rCritConfirmRoll);
		end
		if (nMissChance > 0) and (rAction.sResult ~= "miss") then
			local rMissChanceRoll = { sType = "misschance", sDesc = rRoll.sDesc .. " [MISS CHANCE " .. nMissChance .. "%]", aDice = { "d100", "d10" }, nValue = 0 };
			ActionsManager.roll(rSource, rTarget, rMissChanceRoll);
		end
	end

	if rTarget then
		local msgOOB = {};
		msgOOB.type = OOB_MSGTYPE_APPLYATK;
		
		msgOOB.nTotal = rAction.nTotal;
		msgOOB.sDesc = rMessage.text;
		msgOOB.sResults = table.concat(rAction.aMessages, " ");
		msgOOB.sTargetType = rTarget.sType;
		msgOOB.sTargetCreatureNode = rTarget.sCreatureNode;
		msgOOB.sTargetCTNode = rTarget.sCTNode;
		if rSource then
			msgOOB.sSourceCTNode = rSource.sCTNode;
		end

		Comm.deliverOOBMessage(msgOOB, "");
		
		if rAction.sResult == "miss" and rRoll.sType ~= "critconfirm" and not string.match(rRoll.sDesc, "%[FULL%]") then
			local bRemoveTarget = false;
			if OptionsManager.isOption("RMMT", "on") then
				bRemoveTarget = true;
			elseif OptionsManager.isOption("RMMT", "multi") then
				local sTargetNumber = string.match(rRoll.sDesc, "%[MULTI%]");
				if sTargetNumber then
					bRemoveTarget = true;
				end
			end
			
			if bRemoveTarget then
				local sTargetType = "client";
				if Session.IsHost then
					sTargetType = "host";
				end
			
				TargetingManager.removeTarget(sTargetType, rSource.nodeCT, rTarget.sCTNode);
			end
		end
	end
end

function onGrapple(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	
	if rTarget then
		rMessage.text = rMessage.text .. " [at " .. rTarget.sName .. "]";
	end
	
	if not rSource then
		rMessage.sender = nil;
	end
	Comm.deliverChatMessage(rMessage);
end

function onMissChance(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	local nTotal = ActionsManager.total(rRoll);
	local nMissChance = tonumber(string.match(rMessage.text, "%[MISS CHANCE (%d+)%%%]")) or 0;
	if nTotal <= nMissChance then
		rMessage.text = rMessage.text .. " [MISS]";
	else
		rMessage.text = rMessage.text .. " [HIT]";
	end
	
	Comm.deliverChatMessage(rMessage);
end
