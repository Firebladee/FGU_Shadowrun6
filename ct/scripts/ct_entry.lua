-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

activeon = false;
defensiveon = false;

function onInit()
  onTypeChanged();

  -- Register the deletion menu item for the host
	registerMenuItem(Interface.getString("list_menu_deleteitem"), "delete", 6);
	registerMenuItem(Interface.getString("list_menu_deleteconfirm"), "delete", 6, 7);

	-- Set the displays to what should be shown
  setTargetingVisible();
  setActiveVisible(false);
  setDefensiveVisible(false);
	setSpacingVisible();
	setEffectsVisible();

	-- Acquire token reference, if any
	linkToken();
	
	-- Update the displays
	onLinkChanged();
	onFactionChanged();
end

function updateDisplay()
	local sFaction = friendfoe.getStringValue();

	if DB.getValue(getDatabaseNode(), "active", 0) == 1 then
		name.setFont("sheetlabel");
		nonid_name.setFont("sheetlabel");
		
		active_spacer_top.setVisible(true);
		active_spacer_bottom.setVisible(true);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend_active");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral_active");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe_active");
		else
			setFrame("ctentrybox_active");
		end
	else
		name.setFont("sheettext");
		nonid_name.setFont("sheettext");
		
		active_spacer_top.setVisible(false);
		active_spacer_bottom.setVisible(false);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe");
		else
			setFrame("ctentrybox");
		end
	end
end

function linkToken()
	local imageinstance = token.populateFromImageNode(tokenrefnode.getValue(), tokenrefid.getValue());
	if imageinstance then
		TokenManager.linkToken(getDatabaseNode(), imageinstance);
	end
end

function onMenuSelection(selection, subselection)
	if selection == 6 and subselection == 7 then
		delete();
	end
end

function delete()
	local node = getDatabaseNode();
	if not node then
		close();
		return;
	end
	
	-- Remember node name
	local sNode = node.getNodeName();
	
	-- Clear any effects and wounds first, so that rolls aren't triggered when initiative advanced
	effects.reset(false);
	
	-- Move to the next actor, if this CT entry is active
	if DB.getValue(node, "active", 0) == 1 then
		CombatManager.nextActor();
	end

	-- Delete the database node and close the window
	local cList = windowlist;
	node.delete();

	-- Update list information (global subsection toggles)
	cList.onVisibilityToggle();
	cList.onEntrySectionToggle();
end

function onTypeChanged()
	-- If a PC, then set up the links to the char sheet
	local sType = type.getValue();
	if sType == "pc" then
		linkPCFields();
	end

end
function onLinkChanged()
	-- If a PC, then set up the links to the char sheet
	local sClass, sRecord = link.getValue();
	if sClass == "charsheet" then
		linkPCFields();
		name.setLine(false);
	end
	onIDChanged();
end

function onIDChanged()
	local nodeRecord = getDatabaseNode();
	local sClass = DB.getValue(nodeRecord, "link", "", "");
	if sClass == "npc" then
    linkNPCFields();
    name.setLine(false);
		local bID = LibraryData.getIDState("npc", nodeRecord, true);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
		isidentified.setVisible(true);
	else
		name.setVisible(true);
		nonid_name.setVisible(false);
		isidentified.setVisible(false);
	end
end

function onFactionChanged()
	-- Update the entry frame
	updateDisplay();

	-- If not a friend, then show visibility toggle
	if friendfoe.getStringValue() == "friend" then
		tokenvis.setVisible(false);
	else
		tokenvis.setVisible(true);
	end
end

function onVisibilityChanged()
	TokenManager.updateVisibility(getDatabaseNode());
	windowlist.onVisibilityToggle();
end


function setSpacerState()
	if effects_label.isVisible() then
		if targets_label.isVisible() then
			spacer2.setAnchoredHeight(2);
		else
			spacer2.setAnchoredHeight(6);
		end
	else
		spacer2.setAnchoredHeight(0);
	end
end

function linkPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);
		ctphysicaldamage.setLink(nodeChar.createChild("damage.physical.current", "number"), true);
		ctstundamage.setLink(nodeChar.createChild("damage.stun.current", "number"), true);
		ctphysicaldamagemax.setLink(nodeChar.createChild("damage.physical.max", "number"), true);
		ctstundamagemax.setLink(nodeChar.createChild("damage.stun.max", "number"), true);
		ctinitypelink.setLink(nodeChar.createChild("initype", "string"), true);

		edgescore.setLink(nodeChar.createChild("base.attribute.edge.score", "number"), true);
		edgemod.setLink(nodeChar.createChild("base.attribute.edge.mod", "number"), true);
		edgecheck.setLink(nodeChar.createChild("base.attribute.edge.check", "number"), true);
 		damagepenalty.setLink(nodeChar.createChild("damage.all.modifier", "number"), true);
		sustainedpenalty.setLink(nodeChar.createChild("base.special.spellsustainedpenalty", "number"), true);
		armorpenalty.setLink(nodeChar.createChild("base.special.penalty", "number"), true);

		ctbaseini.setLink(nodeChar.createChild("base.attribute.ini.check", "number"), true);
		ctbaseastini.setLink(nodeChar.createChild("base.attribute.astini.check", "number"), true);
		ctbasematini.setLink(nodeChar.createChild("base.attribute.matini.check", "number"), true);
		ctbasehotmatini.setLink(nodeChar.createChild("base.attribute.hotmatini.check", "number"), true);
		ctbaseinimod.setLink(nodeChar.createChild("base.attribute.ini.mod", "number"), true);
		ctbaseastinimod.setLink(nodeChar.createChild("base.attribute.astini.mod", "number"), true);
		ctbasematinimod.setLink(nodeChar.createChild("base.attribute.matini.mod", "number"), true);
		ctbasehotmatinimod.setLink(nodeChar.createChild("base.attribute.hotmatini.mod", "number"), true);

		ctbaseinipass.setLink(nodeChar.createChild("base.attribute.inipass.score", "number"), true);

		ctbaseastinipass.setLink(nodeChar.createChild("base.attribute.astinipass.score", "number"), true);
		ctbasematinipass.setLink(nodeChar.createChild("base.attribute.matinipass.score", "number"), true);
		ctbasehotmatinipass.setLink(nodeChar.createChild("base.attribute.hotmatinipass.score", "number"), true);

    ctattackdamage.setLink(nodeChar.createChild("attack.damage.current", "number"), true);
    ctattackdamagetype.setLink(nodeChar.createChild("attack.damage.type", "string"), true);
    ctattackresistmod.setLink(nodeChar.createChild("attack.resistmod", "number"), true);
    ctattacktype.setLink(nodeChar.createChild("attack.type", "string"), true);
    ctattackarmormod.setLink(nodeChar.createChild("attack.armormod", "number"), true);
    ctattackarmortype.setLink(nodeChar.createChild("attack.armortype", "string"), true);
    ctattacksuccesses.setLink(nodeChar.createChild("attack.hits", "number"), true);

    ctdefensedamage.setLink(nodeChar.createChild("defense.damage.current", "number"), true);
    ctdefensedamagetype.setLink(nodeChar.createChild("defense.damage.type", "string"), true);
    ctdefenseresistmod.setLink(nodeChar.createChild("defense.resistmod", "number"), true);
    ctdefensetype.setLink(nodeChar.createChild("defense.type", "string"), true);
    ctdefensearmormod.setLink(nodeChar.createChild("defense.armormod", "number"), true);
    ctdefensearmortype.setLink(nodeChar.createChild("defense.armortype", "string"), true);
    ctdefensesuccesses.setLink(nodeChar.createChild("defense.hits", "number"), true);
  end
end  
function linkNPCFields(src)
  local src = link.getTargetDatabaseNode();
  if src then
    name.setLink(NodeManager.createChild(src, "name", "string"), true);
    ctphysicaldamage.setLink(NodeManager.createChild(src, "damage.physical.current", "number"), true);
    ctstundamage.setLink(NodeManager.createChild(src, "damage.stun.current", "number"), true);
    ctphysicaldamagemax.setLink(NodeManager.createChild(src, "damage.physical.max", "number"), true);
    ctstundamagemax.setLink(NodeManager.createChild(src, "damage.stun.max", "number"), true);
    ctinitypelink.setLink(NodeManager.createChild(src, "initype", "string"), true);

    edgescore.setLink(NodeManager.createChild(src, "base.attribute.edge.score", "number"), true);
    edgemod.setLink(NodeManager.createChild(src, "base.attribute.edge.mod", "number"), true);
    edgecheck.setLink(NodeManager.createChild(src, "base.attribute.edge.check", "number"), true);
    damagepenalty.setLink(NodeManager.createChild(src, "damage.all.modifier", "number"), true);
--    sustainedpenalty.setLink(NodeManager.createChild(src, "base.special.spellsustainedpenalty", "number"), true);
    armorpenalty.setLink(NodeManager.createChild(src, "base.special.penalty", "number"), true);

    ctbaseini.setLink(NodeManager.createChild(src, "base.attribute.ini.check", "number"), true);
--    ctbaseastini.setLink(NodeManager.createChild(src, "base.attribute.astini.check", "number"), true);
--    ctbasematini.setLink(NodeManager.createChild(src, "base.attribute.matini.check", "number"), true);
--    ctbasehotmatini.setLink(NodeManager.createChild(src, "base.attribute.hotmatini.check", "number"), true);
    ctbaseinimod.setLink(NodeManager.createChild(src, "base.attribute.ini.mod", "number"), true);
--    ctbaseastinimod.setLink(NodeManager.createChild(src, "base.attribute.astini.mod", "number"), true);
--    ctbasematinimod.setLink(NodeManager.createChild(src, "base.attribute.matini.mod", "number"), true);
--    ctbasehotmatinimod.setLink(NodeManager.createChild(src, "base.attribute.hotmatini.mod", "number"), true);

    ctbaseinipass.setLink(NodeManager.createChild(src, "base.attribute.inipass.score", "number"), true);

    ctattackdamage.setLink(NodeManager.createChild(src, "attack.damage.current", "number"), true);
    ctattackdamagetype.setLink(NodeManager.createChild(src, "attack.damage.type", "string"), true);
    ctattackresistmod.setLink(NodeManager.createChild(src, "attack.resistmod", "number"), true);
    ctattacktype.setLink(NodeManager.createChild(src, "attack.type", "string"), true);
    ctattackarmormod.setLink(NodeManager.createChild(src, "attack.armormod", "number"), true);
    ctattackarmortype.setLink(NodeManager.createChild(src, "attack.armortype", "string"), true);
    ctattacksuccesses.setLink(NodeManager.createChild(src, "attack.hits", "number"), true);

    ctdefensedamage.setLink(NodeManager.createChild(src, "defense.damage.current", "number"), true);
    ctdefensedamagetype.setLink(NodeManager.createChild(src, "defense.damage.type", "string"), true);
    ctdefenseresistmod.setLink(NodeManager.createChild(src, "defense.resistmod", "number"), true);
    ctdefensetype.setLink(NodeManager.createChild(src, "defense.type", "string"), true);
    ctdefensearmormod.setLink(NodeManager.createChild(src, "defense.armormod", "number"), true);
    ctdefensearmortype.setLink(NodeManager.createChild(src, "defense.armortype", "string"), true);
    ctdefensesuccesses.setLink(NodeManager.createChild(src, "defense.hits", "number"), true);
  
--    ctbaseastinipass.setLink(NodeManager.createChild(src, "base.attribute.astinipass.score", "number"), true);
--    ctbasematinipass.setLink(NodeManager.createChild(src, "base.attribute.matinipass.score", "number"), true);
--    ctbasehotmatinipass.setLink(NodeManager.createChild(src, "base.attribute.hotmatinipass.score", "number"), true);

  end
end

--
-- SECTION VISIBILITY FUNCTIONS
--

function setTargetingVisible()
	local v = false;
	if activatetargeting.getValue() == 1 then
		v = true;
	end

	targetingicon.setVisible(v);
	
	sub_targeting.setVisible(v);
	
	frame_targeting.setVisible(v);

	target_summary.onTargetsChanged();
end

function setActiveVisible(v)
	if activateactive.getValue()==1 then
		v = true;
	else
    v = false;
	end

	activeon = v;
	activeicon.setVisible(v);

	initbase.setVisible(v);
	initlabel.setVisible(v);
	label_initbase.setVisible(v);
	initroll.setVisible(v);
	label_initroll.setVisible(v);
	initmod.setVisible(v);
	label_initmod.setVisible(v);
	passbase.setVisible(v);
	passlabel.setVisible(v);
	label_passbase.setVisible(v);
	passbonus.setVisible(v);
	label_passbonus.setVisible(v);
	ctinitrolled.setVisible(v);
	label_ctinitrolled.setVisible(v);

  attacklabel.setVisible(v);
	ctattackdamage.setVisible(v);
	label_ctattackdamage.setVisible(v);
	ctattackdamagetype.setVisible(v);
	label_ctattackdamagetype.setVisible(v);
  ctattackresistmod.setVisible(v);
  label_ctattackresistmod.setVisible(v);
  ctattacktype.setVisible(v);
  label_ctattacktype.setVisible(v);
  ctattackarmormod.setVisible(v);
  label_ctattackarmormod.setVisible(v);
  ctattackarmortype.setVisible(v);
  label_ctattackarmortype.setVisible(v);
  ctattacksuccesses.setVisible(v);
  label_ctattacksuccesses.setVisible(v);

	frame_active.setVisible(v);
end

function setDefensiveVisible(v)
	if activatedefensive.getValue()==1 then
		v = true;
  else
    v = false;
	end

	defensiveon = v;
	defensiveicon.setVisible(v);

	edgescore.setVisible(v);
	edgescorelabel.setVisible(v);
	label_edgescore.setVisible(v);
	edgemod.setVisible(v);
	label_edgemod.setVisible(v);
	edgecheck.setVisible(v);
	label_edgecheck.setVisible(v);
	damagepenalty.setVisible(v);
	damagepenaltylabel.setVisible(v);
	label_damagepenalty.setVisible(v);
	sustainedpenalty.setVisible(v);
	label_sustainedpenalty.setVisible(v);
	armorpenalty.setVisible(v);
	label_armorpenalty.setVisible(v);

  defenselabel.setVisible(v);
  ctdefensedamage.setVisible(v);
  label_ctdefensedamage.setVisible(v);
  ctdefensedamagetype.setVisible(v);
  label_ctdefensedamagetype.setVisible(v);
  ctdefenseresistmod.setVisible(v);
  label_ctdefenseresistmod.setVisible(v);
  ctdefensetype.setVisible(v);
  label_ctdefensetype.setVisible(v);
  ctdefensearmormod.setVisible(v);
  label_ctdefensearmormod.setVisible(v);
  ctdefensearmortype.setVisible(v);
  label_ctdefensearmortype.setVisible(v);
  ctdefensesuccesses.setVisible(v);
  label_ctdefensesuccesses.setVisible(v);


	frame_defensive.setVisible(v);
end

function setSpacingVisible()
	local v = false;
	if activatespacing.getValue() == 1 then
		v = true;
	end

	spacingicon.setVisible(v);
	
	space.setVisible(v);
	spacelabel.setVisible(v);
	reach.setVisible(v);
	reachlabel.setVisible(v);
	
	frame_spacing.setVisible(v);
end

function setEffectsVisible()
	local v = false;
	if activateeffects.getValue() == 1 then
		v = true;
	end
	
	effecticon.setVisible(v);
	
	effects.setVisible(v);
	effects_iadd.setVisible(v);
	for _,w in pairs(effects.getWindows()) do
		w.idelete.setValue(0);
	end

	frame_effects.setVisible(v);

	effect_summary.onEffectsChanged();
end
