import gintro/[gtk4, gobject, gio, pango, adw, glib, gdk4]
import std/with
import Page
import AddNewPageRevealer
import Utils 
import Save
import Load

proc windowOnClose(self: adw.ApplicationWindow, tabView: TabView): bool = 
 save(tabView)
 return gdk4.EVENT_PROPAGATE


proc activate(app: gtk4.Application) =
  adw.init()
  let loadedPages = readSaveFromFS().getPages()
  let
    window = adw.newApplicationWindow(app)
    header = adw.newHeaderBar()
    saveToJsonPageBtn = newFlatBtnWithIcon("document-save-symbolic")
    mainBox = newBox(Orientation.vertical, 0)
    tabBar = newTabBar()
    tabView = newTabView()

  for loadedPage in loadedPages:
    let loadedGroups = loadedPage.getGroupsFromPage()
    let taskPage = createPage(loadedPage.pageName, loadedGroups)
    with taskPage: 
      vexpand = true
      hexpand = true
    let page = tabView.append taskPage
    page.title = loadedPage.pageName.cstring

  # add to buttons to header
  addRevealerWithEntryToHeaderBar(header, tabView)
  header.packStart saveToJsonPageBtn
  saveToJsonPageBtn.connect("clicked", saveBtnPressed, tabView)
  tabBar.view = tabView
  # addNewPageBtn.connect("clicked", addNewPage, tabView)
  window.connect("close_request", windowOnClose, tabView)

  with mainBox: 
    append header
    append tabBar
    append tabView

  with window:
    content = mainBox
    title = ""
    defaultSize = (100, 300)
    show

proc main() =
  let app = newApplication("org.gtk.example")
  app.connect("activate", activate)
  discard run(app)

main()
