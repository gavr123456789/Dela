import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Group
import Utils
import Types
import std/sets
import std/json


type 
  Task* = object
    name: string
    timeStarted: int
    fullTime: int

proc createPage*(pageName: string = "main"): Page = 
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
    title = pageName
    add group
  
    
  result = page

proc saveGroupToJson*(page: Page): JsonNode =
  # let jsonNode = %* { "name": group.label.text }
  var jsonGroups: seq[JsonNode]
  var jsonObject: JsonNode = newJObject()

  for group in page.groups:
    jsonGroups.add group.saveGroupToJson
  
  jsonObject.add(page.title, % jsonGroups)

  return jsonObject


