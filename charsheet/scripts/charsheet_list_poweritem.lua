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
	local status = activatepowerdetail.getValue();

	-- Show the power details
	powerdescription.setVisible(status);
end

function addMagicModifier()
	for k,v in pairs (getWindows()) do
		
	end
end
					
