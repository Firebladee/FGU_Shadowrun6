  function onInit()
    local aLabel = {};

    table.insert(aLabel, ability.getValue());
    sDirect = direct.getValue();
    sRange = range.getValue();
--    sTypeLabel = "[" .. sDirect;
--    if (sRange ~= "LOS") then
--      sTypeLabel = sTypeLabel .. "; " .. sDirect;
--    end
--    sTypeLabel = sTypeLabel .. "]";
    sTypeLabel = "[" .. category.getValue() .. "]";
    type_label.setValue(sTypeLabel);

    local nDrain = drain.getValue();
    if nDrain < 0 then
      dv.setValue("(F/2)"..nDrain);
    else
      dv.setValue("(F/2)+"..nDrain);
    end

  end
