import std/[macros, strutils]

macro dumpParent(t: typedesc) = 
  proc aux(node: NimNode, level: int) = 
    case node.kind:
      of nnkBracketExpr:
        if node[0].eqIdent("typedesc"):
          aux(node[1][1], level)
          
        else:
          assert false, "TODO"
        
      of nnkSym:
        echo "  ".repeat(level), node.repr(), " inherits from"
        let impl = node.getTypeImpl()
        aux(impl, level)
        
      of nnkObjectTy:
        if node[1].kind == nnkOfInherit:
          aux(node[1][0], level + 1)
          
      of nnkRefTy:
        aux(node[0], level)
        
      else:
        echo node.treeRepr()
  
  aux(t.getType(), 0)
  
type
  A = ref object of RootObj
  B = ref object of A
  C = ref object of B
  
dumpParent(C)