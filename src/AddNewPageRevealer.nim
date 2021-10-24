import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Page

type 
  RevealerAndEntry = tuple
    revealer: Revealer
    entry: Entry
  Data = tuple
    revealer: Revealer
    tabView: TabView
  

proc createTab(entry: Entry, sas: Data) = 
  echo entry.text.len
  if entry.text.len == 0:
    sas.revealer.revealChild = false
    return

  let page1 = sas.tabView.append createPage2()
  page1.title = entry.text
    
  sas.revealer.revealChild = false
  entry.text = ""


proc openFileEntry(self: Button, revealerAndEntry: RevealerAndEntry) =
  revealerAndEntry.revealer.revealChild = not revealerAndEntry.revealer.revealChild
  if revealerAndEntry.revealer.revealChild:
    discard revealerAndEntry.entry.grabFocus()

# proc createFile(self: Button, folderNameEntry: gtk4.Entry) =


proc createRevealerWithEntry*(header: adw.HeaderBar, tabView: TabView) =
  let
    headerButtonsBox = newBox(Orientation.horizontal, 3)
    revealBtnSetTabName = newButtonFromIconName("document-new-symbolic")
    newTabNameReveal = newRevealer()
    tabNameEntry = newEntry()

  with headerButtonsBox: 
    append revealBtnSetTabName
    append newTabNameReveal

  with newTabNameReveal:
    child = tabNameEntry
    hexpand = true
    transitionType = RevealerTransitionType.slideLeft

  with header: 
    packStart headerButtonsBox
  
  
  revealBtnSetTabName.connect("clicked", openFileEntry, (newTabNameReveal, tabNameEntry)) # tabNameEntry

  tabNameEntry.hexpand = true
  tabNameEntry.connect("activate", createTab, (newTabNameReveal, tabView))
  

  # result.child = centerBox