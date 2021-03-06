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

proc save*(tabView: TabView) =
  let allPages = tabView.getAllPages()
  var jsonPages: seq[JsonNode]
  for tabPage in allPages:
    let page = tabPage.child.Page
    jsonPages.add page.savePageToJson()
    
  jsonPages.add archivePage.savePageToJson()

  echo "-------------------"
  let savePath = getHomeDir() / SAVE_DIR_NAME
  discard existsOrCreateDir(savePath)
  writeFile(savePath / "state.json", pretty(% jsonPages))
  

proc saveBtnPressed*(btn: Button, tabView: TabView) = 
  save(tabView)
