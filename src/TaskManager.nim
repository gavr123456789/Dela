import gintro/[gtk4, gobject, gio, pango, adw, glib, gdk4]
import std/with
import Page
import Types
import AddNewPageRevealer
import Utils 
import Save
import Load

proc addNewPage(btn: Button, tabView: TabView) = 
  let page = tabView.append newLabel($tabView.nPages)
  page.title = $tabView.nPages

proc activate(app: gtk4.Application) =
  adw.init()
  let loadedPages = readSaveFromFS().getPages()
  let
    window = adw.newApplicationWindow(app)
    header = adw.newHeaderBar()
    # addNewPageBtn = newButtonFromIconName("list-add-symbolic")
    saveToJsonPageBtn = newFlatBtnWithIcon("document-save-symbolic")

    mainBox = newBox(Orientation.vertical, 0)

    tabBar = newTabBar()

    tabView = newTabView()
    # taskPage1 = createPage()

  for loadedPage in loadedPages:
    let loadedGroups = loadedPage.getGroupsFromPage()
    let taskPage = createPage(loadedPage.pageName, loadedGroups)
    with taskPage: 
      vexpand = true
      hexpand = true
    let page = tabView.append taskPage
    page.title = loadedPage.pageName


  # add to buttons to header
  addRevealerWithEntryToHeaderBar(header, tabView)

  header.packStart saveToJsonPageBtn

  # save to JSON connecting


  


  saveToJsonPageBtn.connect("clicked", save, tabView)



  tabBar.view = tabView
  # addNewPageBtn.connect("clicked", addNewPage, tabView)
  # window.connect("close_request", windowOnClose, page)


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
