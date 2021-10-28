import gintro/[gtk4, gobject, gio, adw]
import std/with


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


proc setWidgetToEnd*(widget: Widget) = 
  with widget: 
    halign = Align.end
    valign = Align.center
    marginStart = 10
    marginEnd = 10

proc setWidgetToStart*(widget: Widget) = 
  with widget: 
    halign = Align.start
    valign = Align.center
    marginStart = 10
    marginEnd = 10

proc createBoxWithEntryAndBtn*(entry: Entry, addBtn: Button): Box = 
  let box = newBox(Orientation.horizontal, 5)
  with box: 
    append entry
    append addBtn
  
  entry.setWidgetToStart()
  addBtn.setWidgetToEnd()

  result = box

proc createBoxWithEntryAndBtns*(entry: Entry, addBtn, delGroupBtn: Button): Box = 
  let box = newBox(Orientation.horizontal, 5)
  with box: 
    append entry
    append addBtn
    append delGroupBtn
  
  entry.setWidgetToStart()
  addBtn.setWidgetToStart()
  delGroupBtn.setWidgetToEnd()

  result = box
  
