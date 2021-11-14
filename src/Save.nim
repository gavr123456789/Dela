import json
import Types
import Page
import gintro/[gtk4, adw]
import os

const SAVE_DIR_NAME = ".config" / "Dela"


proc getAllPages(tabView: TabView): seq[TabPage] = 
  let n = tabView.getNPages()
  for i in 0..<n:
    result.add tabView.getNthPage(i)

proc save*(btn: Button, tabView: TabView): void = 
  let allPages = tabView.getAllPages()
  var jsonPages: seq[JsonNode]
  for tabPage in allPages:
    let page = tabPage.child.Page
    jsonPages.add page.saveGroupToJson()

  # let jsonPage = page.saveGroupToJson()
  echo "-------------------"
  # echo jsonPage.pretty()
  let savePath = getHomeDir() / SAVE_DIR_NAME
  discard existsOrCreateDir(savePath)
  writeFile(savePath / "state.json", pretty(% jsonPages))
