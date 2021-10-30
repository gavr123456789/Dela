import gintro/[gtk4, gobject, adw]
import std/sets

type 
  Row* = ref object of ExpanderRow
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
