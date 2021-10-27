import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Row
import Utils

proc addGroup*(page: PreferencesPage, title: string);

type 
  AddGroupData* = tuple
    page: PreferencesPage
    entry: Entry
  RemoveGroupData* = tuple
    page: PreferencesPage
    group: PreferencesGroup



proc addGroupBtnClicked*(btn: Button, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)

proc addGroupEntryActivated*(entry: Entry, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)

proc deleteGroupBtnClicked*(btn: Button, data: RemoveGroupData) = 
  data.page.remove data.group

proc addTaskBtnClicked(btn: Button, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow

proc addTaskEntryActivated(entry: Entry, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow


proc createRowThatAddNewTasks*(group: PreferencesGroup, page: PreferencesPage): PreferencesRow = 
  let 
    row = newActionRow()
    entryTaskName = newEntry()
    addRowBtn = newFlatBtnWithIcon("list-add-symbolic")
    deleteGroupBtn = newFlatBtnWithIcon("close-symbolic")
    # addRowBtn2 = newFlatBtnWithIcon("list-add-symbolic")
    box = createBoxWithEntryAndBtns(entryTaskName, addRowBtn, deleteGroupBtn)

  # row.activatableWidget = addRowBtn2
  # row.connect("activated", addTaskActionRowActivated,  (group, entryTaskName))
  deleteGroupBtn.connect("clicked", deleteGroupBtnClicked, (page, group))
  addRowBtn.connect("clicked", addTaskBtnClicked, (group, entryTaskName))
  entryTaskName.connect("activate", addTaskEntryActivated, (group, entryTaskName))
  # addRowBtn2.connect("clicked", sas)
  box.homogeneous = true

  row.child = box
  
  result = row

proc addGroup*(page: PreferencesPage, title: string) = 
  let 
    group = newPreferencesGroup()


  group.title = title
  # group.description = title
  echo "try to add group with title: ", group.title, " and description: ", group.description
  group.add createRowThatAddNewTasks(group, page)
  page.add group
