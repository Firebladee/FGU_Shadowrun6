--
-- Please see the readme.txt file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 3);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
	toggleComlinkModifier();
end

function onMenuSelection(selection)
	if selection == 3 then
		local wnd = list_comlinkmodifier.createWindow();
	end
end


function toggleDetail()
	local status = activatecomlinkdetail.getValue();

	-- Show the power details
	comlinkdescription.setVisible(status);
end

function toggleComlinkModifier()
	local status = activatecomlinkmodifier.getValue();
		list_comlinkmodifier.setVisible(status);

	for k,v in pairs(list_comlinkmodifier.getWindows()) do
		v.updateDisplay();
	end

end


function modifierProgramDrop(vmodifiername, vmodifier, vmodifiernode)
	local newitem = true
	for i,v in pairs(list_comlinkmodifier.getWindows()) do
		local a = v.getDatabaseNode().getChild("comlinkmodifiernode").getValue();
			if a == vmodifiernode then
				v.getDatabaseNode().getChild("comlinkmodifiername").setValue(vmodifiername);
				v.getDatabaseNode().getChild("comlinkmodifiercount").setValue(1);
				v.getDatabaseNode().getChild("comlinkmodifiernode").setValue(vmodifiernode);
				v.getDatabaseNode().getChild("comlinkmodifierinusebox").setValue(1);
				newitem = false
			end
	end
	if newitem == true then
		local wnd = list_comlinkmodifier.createWindow();
		if wnd then
			NodeManager.set(wnd.getDatabaseNode(), "comlinkmodifiername", "string", vmodifiername);
			wnd.getDatabaseNode().getChild("comlinkmodifiercount").setValue(1);
			wnd.getDatabaseNode().getChild("comlinkmodifiernode").setValue(vmodifiernode);
			wnd.getDatabaseNode().getChild("comlinkmodifierinusebox").setValue(1);
			end
	end
end

function modifierAgentDrop(vmodifiername, vmodifier, vmodifiernode)
	local newitem = true
	for i,v in pairs(list_comlinkmodifier.getWindows()) do
		local a = v.getDatabaseNode().getChild("comlinkmodifiernode").getValue();
			if a == vmodifiernode then
				v.getDatabaseNode().getChild("comlinkmodifiername").setValue(vmodifiername);
				v.getDatabaseNode().getChild("comlinkmodifiercount").setValue(vmodifier+1);
				v.getDatabaseNode().getChild("comlinkmodifiernode").setValue(vmodifiernode);
				v.getDatabaseNode().getChild("comlinkmodifierinusebox").setValue(1);
				newitem = false
			end
	end
	if newitem == true then
		local wnd = list_comlinkmodifier.createWindow();
		if wnd then
			NodeManager.set(wnd.getDatabaseNode(), "comlinkmodifiername", "string", vmodifiername);
			wnd.getDatabaseNode().getChild("comlinkmodifiercount").setValue(vmodifier+1);
			wnd.getDatabaseNode().getChild("comlinkmodifiernode").setValue(vmodifiernode);
			wnd.getDatabaseNode().getChild("comlinkmodifierinusebox").setValue(1);
			end
	end
end
function modifierIdDrop(vmodifiername, vmodifier, vmodifiernode)
	getDatabaseNode().getChild("comlinkid").setValue(vmodifiername);
	getDatabaseNode().getChild("comlinkidrating").setValue(vmodifier);
end

function updateColorframe()
	local a = getDatabaseNode().getChild("color").getValue();
	if not a or a == "" then
		getDatabaseNode().getChild("color").setValue("ffffffff");
	end
	local b = getDatabaseNode().getChild("frame").getValue();
	if not b or b == "" then
		getDatabaseNode().getChild("frame").setValue("dailyframe");
	end
end

function updateResponse()
	if not getDatabaseNode().getChild("comlinkisactive") then
		getDatabaseNode().createChild("comlinkisactive", "number")
	end
	if getDatabaseNode().getChild("comlinkisactive").getValue() == 1 then
		if windowlist.window.getDatabaseNode().getChild("base.attribute.comlink.response") then
			local response = comlinkresponse.getValue() + comlinkresponsepenalty.getValue();
			windowlist.window.getDatabaseNode().getChild("base.attribute.comlink.response").setValue(response);
		end
	end
end

function onDrop(x, y, draginfo)
  local sDragType = draginfo.getType();
  if sDragType ~= "shortcut" then
              return false;
            end
Debug.console("Commlink Item onDrop: ", draginfo);
  local sDropClass, sDropNodeName = draginfo.getShortcutData();
  if not StringManager.contains({ "referenceequipment"}, sDropClass) then
    return false;
  end
  local nodeSource = draginfo.getDatabaseNode();
  local sCategory = DB.getValue(nodeSource, "category", "");
  if sCategory ~= "Operating System" then
    return false;
  end

  local sSourceName = DB.getValue(nodeSource, "name", "");
  local nSourceFirewall = DB.getValue(nodeSource, "firewall", 0);
  local nSourceSystem = DB.getValue(nodeSource, "system", 0);

  local sDesc = comlinkdescription.getValue();
  if sDesc == "" then
    sDesc = sSourceName;
  else
    sDesc = sDesc .. "w/ OS " .. sSourceName;
  end
  comlinkdescription.setValue(sDesc);
  comlinkfirewall.setValue(nSourceFirewall);
  comlinksystem.setValue(nSourceSystem);
  comlinkfirewall.setReadOnly(true);
  comlinksystem.setReadOnly(true);

  return true;
end