import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Row
import Utils
import Types
import print
proc addGroup*(page: Page, title: string);
import std/sets

type 
  AddGroupData* = tuple
    page: Page
    entry: Entry
  RemoveGroupData* = tuple
    page: Page
    group: Group


proc addGroupBtnClicked*(btn: Button, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)

proc addGroupEntryActivated*(entry: Entry, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)

proc deleteGroupBtnClicked*(btn: Button, data: RemoveGroupData) = 

  data.page.groups.excl data.group
  print "after group deleted: ", data.page.groups
  data.page.remove data.group

proc addTaskEntryActivated(entry: Entry, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)

  data.group.rows.incl taskRow
  print "after add task: ", data.group.rows

  data.group.add taskRow


proc createRowThatAddNewTasks*(group: Group, page: Page): PreferencesRow = 
  let 
    row = newActionRow()
    # entryTaskName = newEntry()
    # addRowBtn = newFlatBtnWithIcon("list-add-symbolic")
    deleteGroupBtn = newFlatBtnWithIcon("close-symbolic")
    # box = createBoxWithEntryAndBtns(entryTaskName, addRowBtn, deleteGroupBtn)

  # box.homogeneous = true
  let (btn, entry, box2) = createRevealerWithEntry("list-add-symbolic")
  assert(btn != nil)
  assert(entry != nil)
  assert(box2 != nil)
  box2.append deleteGroupBtn
  deleteGroupBtn.connect("clicked", deleteGroupBtnClicked, (page, group))
  # btn.connect("clicked", addTaskBtnClicked, (group, entry))
  entry.connect("activate", addTaskEntryActivated, (group, entry))


  row.child = box2
  result = row

proc addGroup*(page: Page, title: string) = 
  let 
    group = newPreferencesGroup(Types.Group)
  group.title = title
  echo "try to add group with title: ", group.title, " and description: ", group.description
  group.add createRowThatAddNewTasks(group, page)

  page.groups.incl group
  print "after add group ", page.groups

  page.add group



import std/json
proc saveGroupToJson*(group: Group): JsonNode =
  # let jsonNode = %* { "name": group.label.text }
  var jsonRows: seq[JsonNode]
  for row in group.rows:
    jsonRows.add row.saveRowToJson
  
  return % jsonRows
