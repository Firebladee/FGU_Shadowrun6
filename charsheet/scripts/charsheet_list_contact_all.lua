local bActiveLock = false
function changeLocationName(a,b)
	if not bActiveLock then
		local c = string.gsub(b, "contacttabtext", "");
		c = tonumber(c);

		for k, v in ipairs(getWindows()) do
			local d = v.getDatabaseNode().getChild("contact.filteritem").getValue();
			if d == c then
				local e = v.getDatabaseNode().getChild("contact.location").setValue(a)
			end
		end

		bActiveLock = false;
	end
end