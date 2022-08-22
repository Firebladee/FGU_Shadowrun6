-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Adds the username to the list of holders for the given node
function addWatcher (sNode, sUser, bOwner)
	if not bOwner then 
		bOwner = false
	end
	DB.addHolder(sNode, sUser, bOwner);
end

-- Removes all users from the list of holders for the given node
function removeAllWatchers(sNode)
	DB.removeAllHolders(sNode, false);
end

-- Sets the given value into the fieldname child of sourcenode.  
-- If the fieldname child node does not exist, then it is created.
function set(nodeSource, sField, sFieldType, varInitial)
	return DB.setValue(nodeSource, sField, sFieldType, varInitial);
end

-- Gets the given value of the fieldname child of sourcenode.  
-- If the fieldname child node does not exist, then the defaultval is returned instead.
function get(nodeSource, sField, varDefault)
	return DB.getValue(nodeSource, sField, varDefault);
end

--
-- SAFE NODE CREATION
--

function createChild(nodeSource, sField, sFieldType)
	if not nodeSource then
		return nil;
	end
	
	if not nodeSource.isReadOnly() then
		if sField then
			if sFieldType then
				return nodeSource.createChild(sField, sFieldType);
			else
				return nodeSource.createChild(sField);
			end
		else
			return nodeSource.createChild();
		end
	end

	if not sField then
		return nil;
	end

	return nodeSource.getChild(sField);
end

function createWindow(winList)
	if not winList then
		return nil;
	end
	
	local nodeWindowList = winList.getDatabaseNode();
	if nodeWindowList then
		if nodeWindowList.isReadOnly() then
			return nil;
		end
	end
	
	return winList.createWindow();
end
