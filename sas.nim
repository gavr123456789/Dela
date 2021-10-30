import gintro/[gtk4, gdk4, gobject, glib, gio, pango, adw]
import std/with

proc windowOnClose(self: PreferencesWindow, mainWindow: adw.ApplicationWindow): bool =
  echo "windowOnClose"
  mainWindow.close()
  return gdk4.EVENT_PROPAGATE # window will not close with gdk4.EVENT_STOP

proc activate(app: gtk4.Application) =
  adw.init()
  let mainWindow = adw.newApplicationWindow(app)

  let
    window = adw.newPreferencesWindow()

  # window.connect("close_request", windowOnClose, mainWindow)
  with window:
    # add createPage(window)
    title = "Main"
    defaultSize = (100, 400)
    show

proc main() =
  let app = newApplication("org.gtk.example")
  app.connect("activate", activate)
  discard run(app)

main()