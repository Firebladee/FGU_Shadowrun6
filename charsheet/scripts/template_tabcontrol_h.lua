-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

local topWidget = nil;
local tabIndex = 1;
local tabWidgets = {};
local count = 0;

function getIndex()
	return tabIndex;
end

function activateTab(index)
	-- Hide active tab, fade text labels
	tabWidgets[tabIndex].setFont("sheetlabelsmall")
	window[tab[tabIndex].subwindow[1]].setVisible(false);
	if tab[tabIndex].scroller then
		window[tab[tabIndex].scroller[1]].setVisible(false);
	end

	-- Set new index
	tabIndex = tonumber(index);

	-- Move helper graphic into position
	topWidget.setPosition("topleft", 67*(count - tabIndex)+39, 13 );
	topWidget.setVisible(true);
	
	-- Activate text label and subwindow
	tabWidgets[tabIndex].setFont("sheetlabel");
	window[tab[tabIndex].subwindow[1]].setVisible(true);
	if tab[tabIndex].scroller then
		window[tab[tabIndex].scroller[1]].setVisible(true);
	end
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	local i = math.ceil((x-8)/67);
	
	i = (count+1) - i;
	-- Make sure index is in range and activate selected
	if i > 0 and i < #tab+1 then
		activateTab(i);
	end
	
	return true;
end


function onDoubleClick(x, y)
	-- Emulate click
	onClickRelease(1, x, y);
end

function onInit()
	-- Create a helper graphic widget to indicate that the selected tab is on top
	topWidget = addBitmapWidget("tabtop_h");
	topWidget.setVisible(false);
	for n, v in ipairs(tab) do
		count = count + 1;
	end

	-- Deactivate all labels	
	for n, v in ipairs(tab) do
		local tabname = "";
		local a = "";
		if v.target then
			tabname = v.target[1]
			if window.getDatabaseNode().getChild(tabname) then
				a = window.getDatabaseNode().getChild(tabname).getValue();
			end
		end

		if a == "" then
			a = v.text[1];
		end
		tabWidgets[n] = addTextWidget();
		tabWidgets[n].setText(a);
		tabWidgets[n].setPosition("topleft", 67*((count)-n)+43, 11);
		tabWidgets[n].setMaxWidth(52);
		tabWidgets[n].setFont("sheetlabelsmall")
	end

	if activate then
		activateTab(activate[1]);
	else
		activateTab(1);
	end
end

function getTarget(cTab)
	if tab[cTab].target then
		local returnValue = tab[cTab].target[1];
		return(returnValue);
	else
		return(false);
	end
end

function getTabtext(cTab)
	local returnValue = tab[cTab].text[1];
	return(returnValue);
end

function renameTabText(index, newtext)
	local cTab = tonumber(index);
	local ttf = getTarget(cTab);
	local dText = tab[cTab].text[1];
	if newtext == "" then
		newtext = dText;
	end
	if ttf ~= false then
		tabWidgets[cTab].setText(newtext);
		window.getDatabaseNode().getChild(ttf).setValue(newtext);
	end
	return true;
end