-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onSortCompare(w1, w2)
	if w1.label.getValue() == "" then
		return true;
	elseif w2.label.getValue() == "" then
		return false;
	end

	return w1.label.getValue() > w2.label.getValue();
end


