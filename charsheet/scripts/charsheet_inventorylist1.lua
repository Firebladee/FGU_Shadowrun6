-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onSortCompare(w1, w2)
	if w1.location.getValue() == "" then
		return true;
	elseif w2.location.getValue() == "" then
		return false;
	end

	return w1.location.getValue() > w2.location.getValue();
end


