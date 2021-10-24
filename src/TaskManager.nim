import gintro/[gtk4, gobject, gio, pango, adw]
import std/with

proc createPage0(prefWindow: PreferencesWindow): PreferencesPage;

type 
  Row* = ref object of ExpanderRow

  Task* = object
    name: string
    timeStarted: int
    fullTime: int
  Sas = tuple
    prefWin: PreferencesWindow
    entry: Entry
  AddGroupData = tuple
    page: PreferencesPage
    entry: Entry

proc createRow*(): Row = 
  let 
    row = newExpanderRow(Row)
  row.title = "sas"
  result = row

proc createRowThatCatAddNewTasks*(): Row = 
  let 
    row = newExpanderRow(Row)
  row.title = "sas"
  result = row


proc addGroup(page: PreferencesPage, title: string) = 
  let group = newPreferencesGroup()
  group.title = title
  # group.description = title
  echo "try to add group with title: ", group.title, " and description: ", group.description
  group.add createRow()
  page.add group

proc createPage1(): PreferencesPage =
  adw.init()
  let
    page = newPreferencesPage()
    group = newPreferencesGroup()
    listExpanderRow0 = newExpanderRow()

  with page:
    name = "0"
    iconName = "emblem-flag-purple-symbolic"
    title = "sas"
  page.add group

  listExpanderRow0.title = "ExpanderRow"

  with group:
    add listExpanderRow0
    
  result = page

proc addGroupBtnClicked(btn: Button, data: AddGroupData) = 
  addGroup(data.page, data.entry.text)


proc addPageBtnClicked(btn: Button, data: Sas) = 
  let qwe = createPage0(data.prefWin)
  qwe.title = data.entry.text
  data.prefWin.add qwe

proc createPage0(prefWindow: PreferencesWindow): PreferencesPage =
  adw.init()
  let
    page = newPreferencesPage()
    group = newPreferencesGroup()
    rowAddPage = newPreferencesRow()
    rowAddGroup = newPreferencesRow()
    box1 = newBox(Orientation.horizontal, 5)
    box2 = newBox(Orientation.horizontal, 5)

    entryPageName = newEntry()
    entryGroupName = newEntry()

    addNewPageBtn = newButton("Add Page")
    addNewGroupBtn = newButton("Add Group")

  with entryPageName: 
    halign = Align.start
    valign = Align.center
    marginStart = 10
    marginEnd = 10

  with addNewPageBtn: 
    halign = Align.end
    valign = Align.center
    marginStart = 10
    marginEnd = 10

  with entryGroupName: 
    halign = Align.start
    valign = Align.center
    marginStart = 10
    marginEnd = 10

  with addNewGroupBtn: 
    halign = Align.end
    valign = Align.center
    marginStart = 10
    marginEnd = 10

  with box1:
    append entryPageName
    append addNewPageBtn

  with box2:
    append entryGroupName
    append addNewGroupBtn

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


proc activate(app: gtk4.Application) =
  adw.init()
  discard adw.newApplicationWindow(app)

  let
    window = adw.newPreferencesWindow()

  with window:
    # child = mainBox
    add createPage0(window)
    add createPage1()
    title = "Row"
    defaultSize = (100, 100)
    show

proc main() =
  let app = newApplication("org.gtk.example")
  app.connect("activate", activate)
  discard run(app)

main()
