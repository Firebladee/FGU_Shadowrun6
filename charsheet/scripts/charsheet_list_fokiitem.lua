-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();

	-- Build our own delete item menu and Add Modifier
	toggleDetail();
end	



function toggleDetail()
	local status = activatefokidetail.getValue();

	-- Show the power details
	fokidescription.setVisible(status);
end


					
