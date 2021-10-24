import gintro/[gtk4, gobject, gio, pango, adw, glib]
import std/with
import Utils

const PLAYICON = "media-playback-start-symbolic"
const PAUSEICON = "media-playback-pause-symbolic"

type 
  Row* = ref object of ExpanderRow
    isPlaying: bool
    time: int
    label: Label

  AddRowData* = tuple
    group: PreferencesGroup
    entry: Entry


proc updateGUI*(row: Row): bool =
  row.time.inc()
  echo "updateGUIFromTime, sec: ", row.time
  echo "updateGUIFromTime, isPlaying: ", row.isPlaying

  if row.isPlaying:
    row.label.text = $row.time
    echo row.label.text
    return SOURCE_CONTINUE
  else:
    return SOURCE_REMOVE


proc playPauseClicked(btn: Button, row: Row) = 
  row.isPlaying = not row.isPlaying

  if row.isPlaying:
    btn.iconName = PAUSEICON
    discard timeoutAdd(1000, updateGUI, row)

  else:
    btn.iconName = PLAYICON


  echo "isPlaying = ", row.isPlaying
  

proc playBtnWithTime(playBtn: Button, time: Label): Box = 
  result = newBox(Orientation.horizontal, 10)
  result.append playBtn
  result.append time
  # result.addCssClass "linked"


proc createTaskRow*(title: string): Row = 
  let 
    row = newExpanderRow(Row)
    playPauseBtn = newOutlineBtnWithIcon(PLAYICON)
  row.label = newLabel("0")
  let  
    box = playBtnWithTime(playPauseBtn, row.label)
    # stopBtn = newButton("Stop")
    # deleteTaskBtn = newButton("Delete")
    # doneTaskBtn = newButton("Done")
    # mainBox = newBox(Orientation.horizontal, 0)  

  
  row.addPrefix box
  playPauseBtn.connect("clicked", playPauseClicked, row)

  row.title = title
  result = row



proc addGroupBtnClicked(btn: Button, data: AddRowData) = 
  let taskRow = createTaskRow(data.entry.text)
  data.group.add taskRow

proc createRowThatAddNewTasks*(group: PreferencesGroup): PreferencesRow = 
  let 
    row = newPreferencesRow()
    entryTaskName = newEntry()
    addRowBtn = newButton("Add Task")
    box = createBoxWithEntryAndBtn(entryTaskName, addRowBtn)

  addRowBtn.connect("clicked", addGroupBtnClicked, (group, entryTaskName))

  row.child = box
  
  result = row