import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Utils
type 
  Row* = ref object of ExpanderRow

  AddRowData* = tuple
    group: PreferencesGroup
    entry: Entry

proc createTaskRow*(title: string): Row = 
  let 
    row = newExpanderRow(Row)
  row.title = title
  result = row



proc addGroupBtnClicked(btn: Button, data: AddRowData) = 
  let qwe = createTaskRow(data.entry.text)
  data.group.add qwe

proc createRowThatAddNewTasks*(group: PreferencesGroup): PreferencesRow = 
  let 
    row = newPreferencesRow()
    entryTaskName = newEntry()
    addRowBtn = newButton("Add Task")
    box = createBoxWithEntryAndBtn(entryTaskName, addRowBtn)

  addRowBtn.connect("clicked", addGroupBtnClicked, (group, entryTaskName))

  row.child = box
  
  result = row