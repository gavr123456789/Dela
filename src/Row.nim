import gintro/[gtk4, gobject, gio, pango, adw, glib]
import std/with
import Utils

const
  PLAYICON = "media-playback-start-symbolic"
  PAUSEICON = "media-playback-pause-symbolic"
  DOUBLECLICICON ="dino-double-tick-symbolic"

type 
  Row* = ref object of ExpanderRow
    isPlaying*: bool
    time*: int
    label*: Label
    done: bool
    playPauseBtn: Button

type
  AddRowData* = tuple
    group: PreferencesGroup
    entry: Entry
  RemoveRowData = tuple
    group: PreferencesGroup
    row: Row
  

### EntryRevealer 

type 
  RevealerAndEntry = tuple
    revealer: Revealer
    entry: Entry
  Data = tuple
    revealer: Revealer
    row: Row
  

proc setTaskName(entry: Entry, data: Data) = 
  echo entry.text.len
  if entry.text.len == 0:
    data.revealer.revealChild = false
    return

  data.row.title = entry.text
    
  data.revealer.revealChild = false
  entry.text = ""


proc openRevealer(self: Button, revealerAndEntry: RevealerAndEntry) =
  revealerAndEntry.revealer.revealChild = not revealerAndEntry.revealer.revealChild
  if revealerAndEntry.revealer.revealChild:
    discard revealerAndEntry.entry.grabFocus()

proc createRevealerWithEntry*(row: Row): Box =
  let
    mainBox = newBox(Orientation.horizontal, 3)
    revealBtnSetTaskName = newFlatBtnWithIcon("document-edit-symbolic")
    newTabNameReveal = newRevealer()
    tabNameEntry = newEntry()

  with mainBox: 
    append revealBtnSetTaskName
    append newTabNameReveal

  with newTabNameReveal:
    child = tabNameEntry
    # hexpand = true
    transitionType = RevealerTransitionType.swingRight

  
  revealBtnSetTaskName.connect("clicked", openRevealer, (newTabNameReveal, tabNameEntry)) # tabNameEntry
  tabNameEntry.connect("activate", setTaskName, (newTabNameReveal, row))

  result = mainBox

### ROW

proc updateGUI*(row: Row): bool =
  row.time.inc()
  echo "updateGUIFromTime, sec: ", row.time
  echo "updateGUIFromTime, isPlaying: ", row.isPlaying

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
  data.group.remove data.row

proc playBtnWithTime(playBtn: Button, time: Label): Box = 
  result = newBox(Orientation.horizontal, 10)
  result.append playBtn
  result.append time
  # result.addCssClass "linked"

# proc addTagToTask(entry: Entry) = 
#   entry.buffer.
#   discard
proc doneTaskClicked(btn: Button, row: Row) = 
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

proc createTaskRow*(title: string, group: PreferencesGroup): Row = 
  let 
    row = newExpanderRow(Row)
    playPauseBtn = newOutlineBtnWithIcon(PLAYICON)
    textView = newTextView()

  row.label = newLabel("0")
  let  
    playBtnWithTimeBox = playBtnWithTime(playPauseBtn, row.label)
    # FOOTER
    footerBox = newBox(Orientation.vertical, 0)  
    deleteTaskFooterBtn =  newFlatBtnWithIcon("close-symbolic")
    doneTaskBtn = newFlatBtnWithIcon("dino-tick-symbolic") # TODO при нажатии превращается в undone и делает opacity 06
    doneDeleteEditBox = newBox(Orientation.horizontal, 0)  
    editNameBtn = createRevealerWithEntry(row)

    # addTagBox = newBox(Orientation.horizontal, 0)
    # tabNameEntry = newEntry()

  # tabNameEntry.connect("activate", addTagToTask)
  row.playPauseBtn = playPauseBtn
  with doneDeleteEditBox:
    append doneTaskBtn
    append editNameBtn
    append deleteTaskFooterBtn
    # append editTaskFooterBtn
  
  doneDeleteEditBox.addCssClass "linked"
  deleteTaskFooterBtn.addCssClass "destructive-action"

  with footerBox: 
    append doneDeleteEditBox
    append textView
    
  row.addPrefix playBtnWithTimeBox
  row.add footerBox
  playPauseBtn.connect("clicked", playPauseClicked, row)
  deleteTaskFooterBtn.connect("clicked", removeRowClicked, (group, row))
  doneTaskBtn.connect("clicked", doneTaskClicked, row)
  row.title = title
  result = row



proc addTaskBtnClicked(btn: Button, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow

proc addTaskActionRowActivated(row: ActionRow, data: AddRowData) = 
  echo "sas"
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow

proc addTaskEntryActivated(entry: Entry, data: AddRowData) = 
  if data.entry.text == "": return
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow

# proc sas(btn: Button) = 
#   echo "qwe"

proc createRowThatAddNewTasks*(group: PreferencesGroup): PreferencesRow = 
  let 
    row = newActionRow()
    entryTaskName = newEntry()
    addRowBtn = newFlatBtnWithIcon("list-add-symbolic")
    addRowBtn2 = newFlatBtnWithIcon("list-add-symbolic")
    box = createBoxWithEntryAndBtn(entryTaskName, addRowBtn)

  row.activatableWidget = addRowBtn2
  row.connect("activated", addTaskActionRowActivated,  (group, entryTaskName))
  addRowBtn.connect("clicked", addTaskBtnClicked, (group, entryTaskName))
  entryTaskName.connect("activate", addTaskEntryActivated, (group, entryTaskName))
  # addRowBtn2.connect("clicked", sas)
  box.homogeneous = true

  row.child = box
  
  result = row