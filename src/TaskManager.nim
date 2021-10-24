import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Page
import AddNewPageRevealer


proc addNewPage(btn: Button, tabView: TabView) = 
  let page = tabView.append newLabel($tabView.nPages)
  page.title = $tabView.nPages

proc activate(app: gtk4.Application) =
  adw.init()

  let
    window = adw.newApplicationWindow(app)
    header = adw.newHeaderBar()
    addNewPageBtn = newButtonFromIconName("list-add-symbolic")

    mainBox = newBox(Orientation.vertical, 0)

    tabBar = newTabBar()

    tabView = newTabView()
    taskPage1 = createPage2()
    taskPage2 = createPage2()



  # add addPageBtn to header
  # header.packStart addNewPageBtn
  createRevealerWithEntry(header, tabView)

  let page1 = tabView.append taskPage1
  page1.title = "Main"
  let page2 = tabView.append taskPage2
  page2.title = "page 2"


  tabBar.view = tabView
  # tabBar.endActionWidget = addNewPageBtn
  # let data: Data = (tabView, newLabel("page Num " & $tabView.nPages)) 

  addNewPageBtn.connect("clicked", addNewPage, tabView)

  with mainBox: 
    append header
    append tabBar
    append tabView

  with window:
    child = mainBox
    title = ""
    defaultSize = (100, 300)
    show

proc main() =
  let app = newApplication("org.gtk.example")
  app.connect("activate", activate)
  discard run(app)

main()
