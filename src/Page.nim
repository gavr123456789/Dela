import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Group
import Utils

# proc createPage*(prefWindow: PreferencesWindow): PreferencesPage;

type 

  Task* = object
    name: string
    timeStarted: int
    fullTime: int
  Sas = tuple
    prefWin: PreferencesWindow
    entry: Entry

# proc addPageBtnClicked(btn: Button, data: Sas) = 
#   let qwe = createPage(data.prefWin)
#   qwe.title = data.entry.text
#   data.prefWin.add qwe



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

# proc createSelectPageName(): Clamp = 
#   result = newClamp()
#   result.maximumSize = 600




# proc createNewStuckPage(): Stack =
#   let
#     stack = newStack()
#     clamp = newClamp()
#     taskPage = createPage2()
#     tabNameEntry = newEntry()
  
#   clamp.maximumSize = 600
#   clamp.child = tabNameEntry

#   let stackPage1 = stack.addNamed(clamp, "1")
#   let stackPage2 = stack.addNamed(taskPage, "2")
#   result = stack