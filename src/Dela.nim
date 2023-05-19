import gintro/[gtk4, gobject, gio, pango, adw, glib, gdk4]
import std/with
import Page
import AddNewPageRevealer
import Utils 
import Save
import Load
import Types
import IconNames

proc windowOnClose(self: adw.ApplicationWindow, tabView: TabView): bool = 
 save(tabView)
 return gdk4.EVENT_PROPAGATE


proc revealSideBarArchive(toggleButton: ToggleButton, reveal: Revealer) = 
  reveal.revealChild = toggleButton.active

proc activate(app: gtk4.Application) =
  adw.init()
  let
    loadedPages = readSaveFromFS().getPages()
    window = adw.newApplicationWindow(app)
    header = adw.newHeaderBar()
    saveToJsonPageBtn = newFlatBtnWithIcon(SAVETOJSON)
    mainBox = newBox(Orientation.vertical, 0)
    tabBar = newTabBar()
    tabView = newTabView()

    hboxSidebar = newBox(Orientation.horizontal, 0)
    reveal = newRevealer()
    archiveRevealBtn = newToggleButton()

  with archiveRevealBtn:
    addCssClass("flat")
    setIconName(SHOWSIDEBAR)
    connect("toggled", revealSideBarArchive, reveal)
  
  for loadedPage in loadedPages:
    if loadedPage.pageName == "archive":
      let 
        loadedGroups = loadedPage.getGroupsFromPage()
      archivePage = createPage(loadedPage.pageName, loadedGroups)
      reveal.child = archivePage
  if archivePage == nil:
    echo "Создали архивную страницу"
    archivePage = createPage("archive")
    reveal.child = archivePage
  for loadedPage in loadedPages:
    echo "loading page name: ", loadedPage.pageName
    if loadedPage.pageName != "archive":
      let
        loadedGroups = loadedPage.getGroupsFromPage()
        taskPage = createPage(loadedPage.pageName, loadedGroups)
        page = tabView.append taskPage
      taskPage.hexpand = true
      taskPage.vexpand = true
      page.title = loadedPage.pageName.cstring
    else:
      # add to sidebar
      discard

  reveal.child.setSizeRequest(300,-1)
  reveal.transitionType = RevealerTransitionType.slideRight

  with header:
    addRevealerWithEntryToHeaderBar(tabView)
    packStart saveToJsonPageBtn
    packEnd archiveRevealBtn

  saveToJsonPageBtn.connect("clicked", saveBtnPressed, tabView)
  window.connect("close_request", windowOnClose, tabView)

  tabBar.view = tabView
  tabView.hexpand = true
  tabView.vexpand = true

  with hboxSidebar:
    append tabView
    append reveal

  with mainBox: 
    append header
    append tabBar
    append hboxSidebar

  with window:
    content = mainBox
    title = ""
    defaultSize = (100, 300)
    show

proc main() =
  let app = newApplication("com.github.gavr123456789.Dela")
  app.connect("activate", activate)
  discard run(app)

main()
