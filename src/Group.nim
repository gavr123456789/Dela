import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import std/sets
import print
import Row
import Utils
import Types
import Load
import json

proc addGroupToPage*(page: Page, title: string, loadedTasks: seq[TaskSave] = @[]);

type 
  AddGroupData* = tuple
    page: Page
    entry: Entry

  RemoveGroupData* = tuple
    page: Page
    group: Group
  ArchiveGroupData* = tuple
    page: Page
    group: Group



proc addGroupBtnClicked*(btn: Button, data: AddGroupData) = 
  addGroupToPage(data.page, data.entry.text)

proc addGroupEntryActivated*(entry: Entry, data: AddGroupData) = 
  addGroupToPage(data.page, data.entry.text)

proc deleteGroup*(page: Page, group: Group) = 
  page.groups.excl group
  print "after group deleted: ", page.groups
  page.remove group
proc deleteGroupBtnClicked*(btn: Button, data: RemoveGroupData) = 
  deleteGroup(data.page, data.group)



proc addTaskEntryActivated(entry: Entry, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)

  data.group.rows.incl taskRow
  data.group.add taskRow
  # print "after add task: ", data.group.rows

proc moveGroupToArchiveBtnClicked*(btn: Button, data: ArchiveGroupData) = 
  let serialized = data.group.saveGroupToJson() 
  let groupSave = GroupSave(groupName: data.group.title, groupContent: serialized[data.group.title])
  let tasks = groupSave.getTasksFromGroup()

  archivePage.groups.incl data.group
  archivePage.addGroupToPage(data.group.title, tasks)
  deleteGroup(data.page, data.group)
  


proc createRowThatAddNewTasks(group: Group, page: Page): PreferencesRow = 
  let 
    row = newActionRow()
    deleteGroupBtn = newFlatBtnWithIcon("close-symbolic")
    addToArchiveGroupBtn = newFlatBtnWithIcon("mail-archive-symbolic")

  let (btn, entry, box) = createRevealerWithEntry("list-add-symbolic")
  assert(btn != nil)
  assert(entry != nil)
  assert(box != nil)

  with box:
    append deleteGroupBtn
    append addToArchiveGroupBtn
    
  deleteGroupBtn.connect("clicked", deleteGroupBtnClicked, (page, group))
  addToArchiveGroupBtn.connect("clicked", moveGroupToArchiveBtnClicked, (page, group))
  entry.connect("activate", addTaskEntryActivated, (group, entry))
  row.child = box
  result = row

proc addGroupToPage*(page: Page, title: string, loadedTasks: seq[TaskSave] = @[]) = 
  let 
    group = newPreferencesGroup(Types.Group)
  group.title = title
  echo "try to add group with title: ", group.title, " and description: ", group.description
  group.add createRowThatAddNewTasks(group, page)

  page.groups.incl group

  for loadedTask in loadedTasks: 
    let taskRow = createTaskRow(loadedTask.name, group, loadedTask)
    group.rows.incl taskRow
    group.add taskRow

  page.add group
