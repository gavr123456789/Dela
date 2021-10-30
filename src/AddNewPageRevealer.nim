import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Page
import Utils

type 
  Data = tuple
    revealer: Revealer
    tabView: TabView
  

proc createTab(entry: Entry, sas: Data) = 
  echo entry.text.len
  if entry.text.len == 0:
    sas.revealer.revealChild = false
    return

  let page1 = sas.tabView.append createPage(entry.text)
  page1.title = entry.text
    
  sas.revealer.revealChild = false
  entry.text = ""


proc openFileEntry(self: Button, revealerAndEntry: RevealerAndEntry) =
  revealerAndEntry.revealer.revealChild = not revealerAndEntry.revealer.revealChild
  if revealerAndEntry.revealer.revealChild:
    discard revealerAndEntry.entry.grabFocus()

proc addRevealerWithEntryToHeaderBar*(header: adw.HeaderBar, tabView: TabView) =
  let
    headerButtonsBox = newBox(Orientation.horizontal, 3)
    revealBtnSetTabName = newFlatBtnWithIcon("document-new-symbolic")
    newTabNameReveal = newRevealer()
    tabNameEntry = newEntry()

  with headerButtonsBox: 
    append revealBtnSetTabName
    append newTabNameReveal

  with newTabNameReveal:
    child = tabNameEntry
    hexpand = true
    transitionType = RevealerTransitionType.swingRight

  with header: 
    packStart headerButtonsBox
  
  
  revealBtnSetTabName.connect("clicked", openFileEntry, (newTabNameReveal, tabNameEntry)) # tabNameEntry

  tabNameEntry.hexpand = true
  tabNameEntry.connect("activate", createTab, (newTabNameReveal, tabView))