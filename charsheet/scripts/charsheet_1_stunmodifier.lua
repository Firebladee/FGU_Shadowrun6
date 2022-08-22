-- This file is provided under the Open Game License version 1.0a
-- For more information on OGL and related issues, see 
--   http://www.wizards.com/d20
--
-- For information on the Fantasy Grounds d20 Ruleset licensing and
-- the OGL license text, see the d20 ruleset license in the program
-- options.
--
-- All producers of work derived from this definition are adviced to
-- familiarize themselves with the above licenses, and to take special
-- care in providing the definition of Product Identity (as specified
-- by the OGL) in their products.
--
-- Copyright 2007 SmiteWorks Ltd.
function onSourceUpdate()
	dmgUpdate();
end

function dmgUpdate()
	local a = window.stuncurrent.getValue();
	local check = window.stuncheckboxnumber.getValue();
	local mod = window.stunignore.getValue();
	local b = 3 - check;
	
	local c = 0 - math.floor(((a - mod) / b));
	if c > 0 then
	 	c = 0;
	end

	setValue(c);
end
