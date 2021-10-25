import gintro/[gtk4, gobject, gio, pango, adw, glib]
import std/with
import Utils

const PLAYICON = "media-playback-start-symbolic"
const PAUSEICON = "media-playback-pause-symbolic"

type 
  Row* = ref object of ExpanderRow
    isPlaying*: bool
    time*: int
    label*: Label

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
    hexpand = true
    transitionType = RevealerTransitionType.swingRight

  
  revealBtnSetTaskName.connect("clicked", openRevealer, (newTabNameReveal, tabNameEntry)) # tabNameEntry
  # revealBtnSetTaskName.addCssClass "flat"
  # tabNameEntry.hexpand = true
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

# proc addTagToTask(entry: Entry, taskEntry: Entry) = 
#   discard

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

  # tabNameEntry.connect("activate", addTagToTask, )

  with doneDeleteEditBox:
    append doneTaskBtn
    append deleteTaskFooterBtn
    append editNameBtn
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
  row.title = title
  result = row



proc addGroupBtnClicked(btn: Button, data: AddRowData) = 
  let taskRow = createTaskRow(data.entry.text, data.group)
  data.group.add taskRow

proc createRowThatAddNewTasks*(group: PreferencesGroup): PreferencesRow = 
  let 
    row = newPreferencesRow()
    entryTaskName = newEntry()
    addRowBtn = newFlatBtnWithIcon("list-add-symbolic")
    box = createBoxWithEntryAndBtn(entryTaskName, addRowBtn)

  addRowBtn.connect("clicked", addGroupBtnClicked, (group, entryTaskName))
  box.homogeneous = true

  row.child = box
  
  result = row