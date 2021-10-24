import gintro/[gtk4, gobject, gio, adw]
import std/with

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

proc createBoxWithEntryAndBtn*(entry: Entry, btn: Button): Box = 
  let box = newBox(Orientation.horizontal, 5)
  with box: 
    append entry
    append btn
  
  entry.setWidgetToStart()
  btn.setWidgetToEnd()
  
  result = box
  


