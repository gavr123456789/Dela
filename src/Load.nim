import json

type PageSave = object
  pageName: string
  pageContent: JsonNode

type GroupSave = object
  groupName: string
  groupContent: JsonNode

type TaskSave = object
  name*: string  
  time*: int
  note*: string  
  done*: bool  

proc readSaveFromFS(): JsonNode = "state.json".readFile.parseJson

func getPages(x: JsonNode): seq[PageSave] = 
  assert x.kind == JArray
  for a in x.elems:
    assert a.kind == JObject
    for pageName, pageContent in a:
      result.add PageSave(pageName: pageName, pageContent: pageContent)
  
  #   echo "array"
  #   for i in x.elems:
  #     assert i.kind == JObject
  #     result.add i
      # for pageName, pageContent in i:
      #   assert pageContent.kind == JArray
      #   for group in pageContent.elems:
      #     echo group
          # for pairs

func getGroupsFromPage(page: PageSave): seq[GroupSave] =
  assert page.pageContent.kind == JArray
  for group in page.pageContent.items: 
    assert group.kind == JObject
    for groupName, groupContent in group:   
      # debugEcho groupName
      # debugEcho groupContent
      result.add GroupSave(groupName: groupName, groupContent: groupContent)

    
func getTasksFromGroup(group: GroupSave): seq[TaskSave] = 
  assert group.groupContent.kind == JArray
  for task in group.groupContent.items: 
    assert task.kind == JObject
    result.add TaskSave(
      name: task["name"].getStr,
      time: task["time"].getInt,
      note: task["note"].getStr,
      done: task["done"].getBool
    )
  
readSaveFromFS().getPages()[0].getGroupsFromPage()[0].getTasksFromGroup.echo
