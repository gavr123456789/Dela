import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Group
import Utils

proc createPage*(prefWindow: PreferencesWindow): PreferencesPage;

type 

  Task* = object
    name: string
    timeStarted: int
    fullTime: int
  Sas = tuple
    prefWin: PreferencesWindow
    entry: Entry

proc addPageBtnClicked(btn: Button, data: Sas) = 
  let qwe = createPage(data.prefWin)
  qwe.title = data.entry.text
  data.prefWin.add qwe

proc createPage*(prefWindow: PreferencesWindow): PreferencesPage =
  adw.init()
  let
    page = newPreferencesPage()
    group = newPreferencesGroup()
    rowAddPage = newPreferencesRow()
    rowAddGroup = newPreferencesRow()

    entryPageName = newEntry()
    entryGroupName = newEntry()

    addNewPageBtn = newButton("Add Page")
    addNewGroupBtn = newButton("Add Group")
    
    box1 = createBoxWithEntryAndBtn(entryPageName, addNewPageBtn)
    box2 = createBoxWithEntryAndBtn(entryGroupName, addNewGroupBtn)

  addNewPageBtn.connect("clicked", addPageBtnClicked, (prefWindow, entryPageName))
  addNewGroupBtn.connect("clicked", addGroupBtnClicked, (page, entryGroupName))
  
  box1.homogeneous = true
  box2.homogeneous = true

  rowAddPage.child = box1
  rowAddGroup.child = box2

  page.add group

  with page:
    name = "2"
    iconName = "emblem-flag-purple-symbolic"
    title = "main"

  with group:
    add rowAddPage
    add rowAddGroup
    
  result = page

