-- This file is provided under the Open Game License version 1.0a
-- For more information on OGL and related issues, see 
--   http://www.wizards.com/d20

-- All producers of work derived from this definition are adviced to
-- familiarize themselves with the above license, and to take special
-- care in providing the definition of Product Identity (as specified
-- by the OGL) in their products.

-- Copyright 2008 SmiteWorks Ltd.

local portraitwidget = nil;

function onInit()
  if super and super.onInit then
    super.onInit();
  end
  if window.getDatabaseNode() and window.getDatabaseNode().getName() then
    if getName() == "FullPortraitFrame" then
      -- full-sized portrait
      portraitwidget = window.FullPortraitFrame.addBitmapWidget("portrait_" .. window.getDatabaseNode().getName().. "_charlist");
    end
    if getName() == "SmallPortraitFrame" then
      -- small portrait
      portraitwidget = window.SmallPortraitFrame.addBitmapWidget("portrait_" .. window.getDatabaseNode().getName().. "_token");
    end
  end
  if portraitwidget and portraitwidget.getBitmap() and window.logo then
    window.logo.setVisible(false);
  end  
end

function onDrag(button, x, y, dragdata)
  local base = nil;

  dragdata.setType("playercharacter");
  dragdata.setDatabaseNode(window.getDatabaseNode());
  dragdata.setTokenData("portrait_" .. window.getDatabaseNode().getName().. "_token");
  
  base = dragdata.createBaseData();
  base.setType("token");
  base.setTokenData("portrait_" .. window.getDatabaseNode().getName() .. "_token");

  return dragdata;
end

function onDrop(x, y, draginfo)
  if draginfo.isType("portraitselection") then
    CampaignDataManager.setCharPortrait(window.getDatabaseNode(), draginfo.getStringData());
    return true;
  end
end

function onClickDown(button, x, y)
  return true;
end

function onClickRelease(button, x, y)
  local nodeChar = window.getDatabaseNode();
  if nodeChar then
    local wnd = Interface.openWindow("portraitselection", "");
    if wnd then
      wnd.SetLocalNode(nodeChar);
    end
  end
end
