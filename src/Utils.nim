import gintro/[gtk4, gobject, gio, adw]
import std/with, hashes

proc hash*(b: Widget): Hash = 
  # create hash from widget pointer
  result =  cast[Hash](cast[uint](b) shr 3)
  echo result


proc newOutlineBtn*(text: string = ""): Button = 
  result = newButton(text)
  result.valign = Align.center
  result.addCssClass("outline")


proc newFlatBtnWithIcon*(iconName: string = ""): Button = 
  result = newButtonFromIconName(iconName)
  result.valign = Align.center
  result.addCssClass("flat")

proc newOutlineBtnWithIcon*(iconName: string = ""): Button = 
  result = newButtonFromIconName(iconName)
  result.valign = Align.center
  result.addCssClass("outline")

proc createLinkedBox*(widgets: seq[Widget]): Box = 
  result = newBox(Orientation.horizontal)
  result.addCssClass("linked")
  for index in widgets:
    result.append index


func setWidgetToEnd*(widget: Widget) = 
  with widget: 
    halign = Align.end
    valign = Align.center
    # marginStart = 10
    marginEnd = 10

func setWidgetToStart*(widget: Widget) = 
  with widget: 
    halign = Align.center
    valign = Align.center
    marginStart = 10
    # marginEnd = 10

proc createBoxWithEntryAndBtn*(entry: Entry, addBtn: Button): Box = 
  let box = newBox(Orientation.horizontal, 5)
  with box: 
    append entry
    append addBtn
  
  entry.setWidgetToStart()
  addBtn.setWidgetToEnd()

  result = box

# proc createBoxWithEntryAndBtns*(entry: Entry, addBtn, delGroupBtn: Button): Box = 
#   let box = newBox(Orientation.horizontal, 5)
#   with box: 
#     append addBtn
#     append entry
#     append delGroupBtn
  
#   entry.hexpand = true
#   entry.setWidgetToStart()
#   addBtn.setWidgetToStart()
#   delGroupBtn.setWidgetToEnd()

#   result = box
  

type 
  RevealerWithButtonAndEntry* = tuple
    button: Button
    entry: Entry
    box: Box
  RevealerAndEntry* = tuple
    revealer: Revealer
    entry: Entry
  
proc openFileEntry(self: Button, revealerAndEntry: RevealerAndEntry) =
  revealerAndEntry.revealer.revealChild = not revealerAndEntry.revealer.revealChild
  if revealerAndEntry.revealer.revealChild:
    discard revealerAndEntry.entry.grabFocus()


proc createRevealerWithEntry*(iconName: string): RevealerWithButtonAndEntry =
  let
    headerButtonsBox = newBox(Orientation.horizontal, 3)
    revealBtnSetTabName = newFlatBtnWithIcon(iconName)
    newTabNameReveal = newRevealer()
    tabNameEntry = newEntry()

  with headerButtonsBox: 
    append revealBtnSetTabName
    append newTabNameReveal

  with newTabNameReveal:
    child = tabNameEntry
    hexpand = true
    transitionType = RevealerTransitionType.swingRight
  
  
  revealBtnSetTabName.connect("clicked", openFileEntry, (newTabNameReveal, tabNameEntry)) # tabNameEntry

  tabNameEntry.hexpand = true

  result = (revealBtnSetTabName, tabNameEntry, headerButtonsBox)
