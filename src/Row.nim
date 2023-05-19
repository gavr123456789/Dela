import gintro/[gtk4, gobject, gio, pango, adw, glib]
import std/with
import print
import std/sets
import Utils
import Types
import Load
import IconNames


type
  AddRowData* = tuple
    group: Group
    entry: Entry
  RemoveRowData = tuple
    group: Group
    row: Row

type 
  RevealerAndEntry = tuple
    revealer: Revealer
    entry: Entry
  Data = tuple
    revealer: Revealer
    row: Row


proc renameTask(entry: Entry, data: Data) = 
  echo entry.text.len
  if entry.text.len == 0:
    data.revealer.revealChild = false
    return

  data.row.title = entry.text.cstring
  data.revealer.revealChild = false
  entry.text = ""


proc openRevealer(self: Button, revealerAndEntry: RevealerAndEntry) =
  revealerAndEntry.revealer.revealChild = not revealerAndEntry.revealer.revealChild
  if revealerAndEntry.revealer.revealChild:
    discard revealerAndEntry.entry.grabFocus()

proc createRevealerWithEntry*(row: Row): Box =
  let
    mainBox = newBox(Orientation.horizontal, 3)
    revealBtnrenameTask = newFlatBtnWithIcon(EDITNAMEICON)
    newTabNameReveal = newRevealer()
    tabNameEntry = newEntry()

  with mainBox:
    append revealBtnrenameTask
    append newTabNameReveal

  with newTabNameReveal:
    child = tabNameEntry
    transitionType = RevealerTransitionType.swingRight

  
  revealBtnrenameTask.connect("clicked", openRevealer, (newTabNameReveal, tabNameEntry)) # tabNameEntry
  tabNameEntry.connect("activate", renameTask, (newTabNameReveal, row))

  result = mainBox

### ROW
proc updateGUI*(row: Row): bool =
  row.time.inc()
  # echo "updateGUIFromTime, sec: ", row.time
  # echo "updateGUIFromTime, isPlaying: ", row.isPlaying

  if row.isPlaying:
    row.label.text = $row.time
    echo row.label.text
    return SOURCE_CONTINUE
  else:
    row.time -= 1
    return SOURCE_REMOVE


proc playPauseClicked(btn: Button, row: Row) = 
  row.isPlaying = not row.isPlaying

  if row.isPlaying:
    btn.iconName = PAUSEICON
    discard timeoutAdd(1000, updateGUI, row)

  else:
    btn.iconName = PLAYICON
  
  echo "isPlaying = ", row.isPlaying
  

proc removeRowClicked(btn: Button, data: RemoveRowData) = 
  data.group.rows.excl data.row
  print "after remove task: ", data.group.rows
  data.group.remove data.row

proc playBtnWithTime(playBtn: Button, time: Label): Box = 
  result = newBox(Orientation.horizontal, 10)
  result.append playBtn
  result.append time

proc doneTask(row: Row) = 
  if row.isPlaying: return
  row.done = not row.done

  if row.done:
    row.opacity = 0.6
    row.playPauseBtn.iconName = DOUBLECLICICON
    row.playPauseBtn.sensitive = false
  
  else:
    row.opacity = 1
    row.playPauseBtn.iconName = PLAYICON
    row.playPauseBtn.sensitive = true

proc doneTaskClicked(btn: Button, row: Row) = 
  row.doneTask()


proc createTaskRow*(title: string, group: Group, taskSave: TaskSave = TaskSave()): Row = 
  let 
    row = newExpanderRow(Types.Row)
    playPauseBtn = newOutlineBtnWithIcon(PLAYICON)
    textView = newTextView()

  row.label = newLabel("0")
  let  
    playBtnWithTimeBox = playBtnWithTime(playPauseBtn, row.label)

    footerBox = newBox(Orientation.vertical, 0)
    deleteTaskFooterBtn =  newFlatBtnWithIcon(DELETETASKICON)
    doneTaskBtn = newFlatBtnWithIcon(DONETASKICON) # TODO при нажатии превращается в undone и делает opacity 06
    doneDeleteEditBox = newBox(Orientation.horizontal, 0)
    editNameBtn = createRevealerWithEntry(row)

  textView.wrapMode = gtk4.WrapMode.word
  row.playPauseBtn = playPauseBtn
  row.textView = textView

  with doneDeleteEditBox:
    append doneTaskBtn
    append editNameBtn
    append deleteTaskFooterBtn
  
  doneDeleteEditBox.addCssClass "linked"
  # deleteTaskFooterBtn.addCssClass "suggested-action"

  with footerBox: 
    append doneDeleteEditBox
    append textView
    
  row.addPrefix playBtnWithTimeBox
  row.addRow footerBox
  playPauseBtn.connect("clicked", playPauseClicked, row)
  deleteTaskFooterBtn.connect("clicked", removeRowClicked, (group, row))
  doneTaskBtn.connect("clicked", doneTaskClicked, row)

  if taskSave.name != "":
    row.time = taskSave.time
    row.label.text = $taskSave.time

    if taskSave.done:
      row.doneTask()
    row.done = taskSave.done
    

    row.textView.buffer.setText taskSave.note, taskSave.note.len
    row.title = taskSave.name


  row.title = title
  result = row


