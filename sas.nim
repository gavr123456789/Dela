import json
type Task = object 
  name: string

let x = JsonNode()
let task = Task(name: "sas")
x.add("tag", % task)

echo x.pretty()