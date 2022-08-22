--
-- Please see the readme.txt file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();

	-- Build our own delete item menu and Add Modifier
	toggleDetail();
  toggleActive();
end


function toggleActive()
  local active = spellisactive.getState();

  -- Show the power details
  skillcheck.setVisible(active);
end

function toggleDetail()
	local status = activatespelldetail.getValue();

	-- Show the power details
	spelldescription.setVisible(status);
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

