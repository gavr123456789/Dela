import gintro/[gtk4, gobject, gio, pango, adw]
import Row

type Group* = ref object of PreferencesGroup
  rows: seq[Row]
    
    
type Page* = ref object of PreferencesPage