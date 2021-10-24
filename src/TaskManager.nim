import gintro/[gtk4, gobject, gio, pango, adw]
import std/with
import Page

proc activate(app: gtk4.Application) =
  adw.init()
  discard adw.newApplicationWindow(app)

  let
    window = adw.newPreferencesWindow()

  with window:
    add createPage(window)
    title = "Main"
    defaultSize = (100, 400)
    show

proc main() =
  let app = newApplication("org.gtk.example")
  app.connect("activate", activate)
  discard run(app)

main()
