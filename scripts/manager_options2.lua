--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
  registerPublicNodes();
  registerOptions();
end

function registerOptions()
  OptionsManager.registerOption2("ADRT", true, "option_header_sr4", "option_label_ADRT", "option_entry_cycler", 
      { labels = "option_val_on|option_val_off", values = "on|off", baselabel = "option_val_off", baseval = "off", default = "on" });
end

function registerPublicNodes()
    if Session.IsHost then
        DB.createNode("options").setPublic(true);
        DB.createNode("partysheet").setPublic(true);
        DB.createNode("calendar").setPublic(true);
        DB.createNode("combattracker").setPublic(true);
        DB.createNode("modifiers").setPublic(true);
        DB.createNode("effects").setPublic(true);
    end
end
