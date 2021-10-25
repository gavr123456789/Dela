import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Group
import Utils

type 
  Task* = object
    name: string
    timeStarted: int
    fullTime: int


proc createPage2*(): PreferencesPage = 
  let
      page = newPreferencesPage()
      group = newPreferencesGroup()
      rowAddGroup = newPreferencesRow()
      entryGroupName = newEntry()
      addNewGroupBtn = newFlatBtnWithIcon("list-add-symbolic")
      box2 = createBoxWithEntryAndBtn(entryGroupName, addNewGroupBtn)

  addNewGroupBtn.connect("clicked", addGroupBtnClicked, (page, entryGroupName))
    
  box2.homogeneous = true
  rowAddGroup.child = box2

  page.add group

  with page:
    name = "2"
    iconName = "emblem-flag-purple-symbolic"
    title = "main"

  with group:
    add rowAddGroup
    
  result = page
