import json, os

const SAVE_DIR_NAME = ".config" / "Dela"
const SAVE_FILE_NAME = "state.json"
const FULL_PATH = SAVE_DIR_NAME / SAVE_FILE_NAME
const DEFAULT_CONTENT = """
[
  {
    "Main": [
      {
        "TODO": [
          {
            "name": "Todo example",
            "time": 0,
            "note": "",
            "done": false
          }
        ]
      }
    ]
  }
]
"""

type PageSave* = object
  pageName*: string
  pageContent*: JsonNode

type GroupSave* = object
  groupName*: string
  groupContent*: JsonNode

type TaskSave* = object
  name*: string  
  time*: int
  note*: string  
  done*: bool  


proc readSaveFromFS*(): JsonNode = 
  let path = (getHomeDir() / FULL_PATH)
  if not fileExists(path):
    createDir(getHomeDir() / SAVE_DIR_NAME)
    echo "try to write to: ", path
    writeFile(path, DEFAULT_CONTENT)
    
  path.readFile.parseJson

func getPages*(x: JsonNode): seq[PageSave] = 
  assert x.kind == JArray
  for a in x.elems:
    assert a.kind == JObject
    for pageName, pageContent in a:
      result.add PageSave(pageName: pageName, pageContent: pageContent)

func getGroupsFromPage*(page: PageSave): seq[GroupSave] =
  assert page.pageContent.kind == JArray
  for group in page.pageContent.items: 
    assert group.kind == JObject
    for groupName, groupContent in group:   
      # debugEcho groupName
      # debugEcho groupContent
      result.add GroupSave(groupName: groupName, groupContent: groupContent)

    
func getTasksFromGroup*(group: GroupSave): seq[TaskSave] = 
  assert group.groupContent.kind == JArray
  for task in group.groupContent.items: 
    assert task.kind == JObject
    result.add TaskSave(
      name: task["name"].getStr,
      time: task["time"].getInt,
      note: task["note"].getStr,
      done: task["done"].getBool
    )
  
# readSaveFromFS().getPages()[0].getGroupsFromPage()[0].getTasksFromGroup.echo
