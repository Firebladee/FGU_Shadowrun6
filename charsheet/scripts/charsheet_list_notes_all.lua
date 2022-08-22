local bActiveLock = false
function changeLocationName(a,b)
	if not bActiveLock then
		local c = string.gsub(b, "notetabtext", "");
		c = tonumber(c);

		for k, v in ipairs(getWindows()) do
			local d = v.getDatabaseNode().getChild("note.filteritem").getValue();
			if d == c then
				local e = v.getDatabaseNode().getChild("note.location").setValue(a)
			end
		end

		bActiveLock = false;
	end
end

function onSortCompare(w1, w2, fieldname)
	local returnValue = false;

	local date1 = w1.notename.getValue();
	local date2 = w2.notename.getValue();
	local loc1 = w1.notefilteritem.getValue();
	local loc2 = w2.notefilteritem.getValue();
	if loc1 == loc2 then
		returnValue = date1 > date2;
	else
		returnValue = loc1 > loc2;
	end
	return returnValue;
end	
