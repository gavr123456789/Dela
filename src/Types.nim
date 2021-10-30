import gintro/[gtk4, gobject, adw]


type 
  Row* = ref object of ExpanderRow
    isPlaying*: bool
    time*: int
    label*: Label
    done*: bool
    playPauseBtn*: Button

type Group* = ref object of PreferencesGroup
  rows: seq[Row]
    
    
type Page* = ref object of PreferencesPage
  groups: seq[Group]
