import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Row

type 
  AddGroupData* = tuple
    page: PreferencesPage
    entry: Entry


proc addGroup*(page: PreferencesPage, title: string) = 
  let 
    group = newPreferencesGroup()


  group.title = title
  # group.description = title
  echo "try to add group with title: ", group.title, " and description: ", group.description
  group.add createRowThatAddNewTasks(group)
  page.add group

proc addGroupBtnClicked*(btn: Button, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)

proc addGroupEntryActivated*(entry: Entry, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)
