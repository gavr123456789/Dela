import json
import Types
import Page
import print
import gintro/[gtk4]
# import os

proc save*(btn: Button, page: Page): void = 
  let jsonPage = page.saveGroupToJson()
  echo "-------------------"
  echo jsonPage.pretty()
  writeFile("state.json", jsonPage.pretty())
