import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Group
import Utils
import Types

type 
  Task* = object
    name: string
    timeStarted: int
    fullTime: int



proc createPage2*(): Page = 
  let
      page = newPreferencesPage(Types.Page)
      group = newPreferencesGroup()
      rowAddGroup = newActionRow()
      entryGroupName = newEntry()
      addNewGroupBtn = newFlatBtnWithIcon("list-add-symbolic")
      box = createBoxWithEntryAndBtn(entryGroupName, addNewGroupBtn)

  addNewGroupBtn.connect("clicked", addGroupBtnClicked, (page, entryGroupName))
  entryGroupName.connect("activate", addGroupEntryActivated, (page, entryGroupName))

  box.homogeneous = true

  with rowAddGroup:
    child = box
    # activatableWidget = addNewGroupBtn

  with group:
    add rowAddGroup

  with page:
    name = "1"
    iconName = "emblem-flag-purple-symbolic"
    title = "main"
    add group
  
    
  result = page
