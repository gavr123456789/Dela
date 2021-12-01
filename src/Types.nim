import gintro/[gtk4, gobject, adw]
import std/sets
import json


type Row* = ref object of ExpanderRow
  isPlaying*: bool
  time*: int
  label*: Label
  textView*: TextView
  done*: bool
  playPauseBtn*: Button

type Group* = ref object of PreferencesGroup
  rows*: HashSet[Row]
    
    
type Page* = ref object of PreferencesPage
  groups*: HashSet[Group]

var archivePage*: Page

proc saveRowToJson*(row: Row): JsonNode =
  var startIter = TextIter()
  var endIter = TextIter()
  row.textView.buffer.getBounds(startIter, endIter)
  let text = row.textView.buffer.getText(startIter, endIter, false)
  let jsonNode = %* { "name": row.title, "time": row.time, "note": text, "done": row.done }

  return jsonNode


proc saveGroupToJson*(group: Group): JsonNode =
  var jsonRows: seq[JsonNode]
  var jsonObject: JsonNode = newJObject()
  for row in group.rows:
    jsonRows.add row.saveRowToJson
  
  jsonObject.add(group.title, % jsonRows)

  return jsonObject


proc savePageToJson*(page: Page): JsonNode =
  var jsonGroups: seq[JsonNode]
  var jsonObject: JsonNode = newJObject()

  for group in page.groups:
    jsonGroups.add group.saveGroupToJson
  
  jsonObject.add(page.title, % jsonGroups)

  return jsonObject
