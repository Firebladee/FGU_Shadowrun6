-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onListRearranged(bListChanged)
	if bListChanged then
		local f = getFilter(self.window);
		if f == "" then
			local alt = true;
			for i,wnd in ipairs(getWindows()) do
				if alt then
					wnd.setFrame("rowshade",0,0,0,0);
				else
					wnd.setFrame(nil)
				end

				alt = not alt;
			end
		else
			for i,wnd in ipairs(getWindows()) do
				wnd.setFrame(nil)
			end
		end
	end
end

function onFilter(w)
	local f = getFilter(w);
	if f == "" then
		w.windowlist.window.showFullHeaders(true);
		return true;
	end

	w.windowlist.window.showFullHeaders(false);
	w.windowlist.setVisible(true);

	if string.find(string.lower(w.name.getValue()), f, 0, true) then
		return true;
	end

	return false;
end

function getFilter(w)
	local vTop = w;
	while vTop.windowlist or vTop.parentcontrol do
		if vTop.windowlist then
			vTop = vTop.windowlist.window;
		else
			vTop = vTop.parentcontrol.window;
		end
	end
	if not vTop.filter then
		return "";
	end

	return string.lower(vTop.filter.getValue());
end

