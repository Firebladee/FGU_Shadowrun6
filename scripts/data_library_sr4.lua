--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

-- RECORD TYPE FORMAT
--    ["recordtype"] = { 
--      bHidden = <bool>,
--      bID = <bool>,
--      bNoCategories = <bool>,
--      bAllowClientEdit = <bool>,
--      aDataMap = <table of strings>, 
--      aDisplayIcon = <table of 2 strings>, 
--      fToggleIndex = <function>
--      sListDisplayClass = <string>,
--      sRecordDisplayClass = <string>,
--      fRecordDisplayClass = <function>,
--      aGMListButtons = <table of templates>,
--    },
--
-- FIELDS ADDED FROM STRING DATA
--    sDisplayText = Interface.getString(library_recordtype_label_ .. sRecordType)
--    sEmptyNameText = Interface.getString(library_recordtype_empty_ .. sRecordType)
--
--    *FIELDS ADDED FROM STRING DATA (only when bID set)*
--    sEmptyUnidentifiedNameText = Interface.getString(library_recordtype_empty_nonid_ .. sRecordType)
--
-- RECORD TYPE LEGEND
--    bHidden = Optional. Boolean indicating whether record should be displayed in library, and when show aLl records in sidebar selected.
--    bID = Optional. Boolean indicating whether record is identifiable or not (currently only items and images)
--    bNoCateories = Optional. Disable display and usage of category information.
--    bAllowClientEdit = Optional. Allow clients to add/delete records in the list that they own.
--    aDataMap = Required. Table of strings. defining the valid data paths for records of this type
--    aDisplayIcon = Required. Table of strings. Provides icon resource names for sidebar/library buttons for this record type (normal and pressed icon resources)
--    fToggleIndex = Optional. Function. This function will be called when the sidebar/library button is pressed for this record type. If not defined, a default master list window will be toggled.
--    sListDisplayClass = Optional. String. Class to use when displaying this record in a list. If not defined, a default class will be used.
--    sRecordDisplayClass = Required (or fRecordDisplayClass defined). String. Class to use when displaying this record in detail.
--    fRecordDisplayClass = Required (or sRecordDisplayClass defined). Function. Function called when requesting to display this record in detail.
--    aGMListButtons = Optional. Table of templates. A list of control templates created and added to the master list window for this record type.
--
--    sDisplayText = Required. String Resource. Text displayed in library and tooltips to identify record type textually.
--    sEmptyNameText = Optional. String Resource. Text displayed in name field of record list and detail classes, when name is empty.
--    sEmptyUnidentifiedNameText = Optional. String Resource. Text displayed in nonid_name field of record list and detail classes, when nonid_name is empty. Only used if bID flag set.
--

function isItemRecordDisplayClass(sClass)
  if sClass == "item" then
    return true;
  end
  return ItemManager2.isItemClass(sClass);
end

aRecords = {
  -- CoreRPG override
  ["item"] = { 
    bExport = true,
    bID = true,
    sIDOption = "MIID",
    aDataMap = { "item", "reference.items" }, 
    aDisplayIcon = { "button_items", "button_items_down" }, 
    sListDisplayClass = "masterindexitem_id",
    fIsRecordDisplayClass = isItemRecordDisplayClass,
    }
};

function onInit()
  if LibraryData then
    for kRecordType,vRecordType in pairs(aRecords) do
      LibraryData.setRecordTypeInfo(kRecordType, vRecordType);
    end
  end
  
end

