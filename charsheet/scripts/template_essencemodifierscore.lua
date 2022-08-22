function onInit()
	if gmonly and not Session.IsHost then
		setReadOnly(true);
	end
end

function onWheel(n)
	if not OptionsManager.isMouseWheelEditEnabled() then
		return false;
	end
	
	if isReadOnly() then
		return false;
	end

	-- Mouse Wheel Editing Notches (tenth used with shift, hundredth used with alt button --
	if Input.isControlPressed() then
		local newessence;
		if Input.isShiftPressed() then
			newessence = self.getValue() + (0.1 * n);
		elseif Input.isAltPressed() then
			newessence = self.getValue() + (0.01 * n);
		else 
			newessence = self.getValue() + n;
		end
		self.setValue((math.floor((newessence+0.00049)*1000))/1000);
	return true;
	end
end