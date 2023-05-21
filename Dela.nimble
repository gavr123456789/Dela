# Package

version       = "0.3.0"
author        = "gavr"
description   = "A simple task manager with timer"
license       = "MIT"
srcDir        = "src"
bin           = @["Dela"]


# Dependencies

requires "nim >= 1.4.8"
requires "gintro#head"
requires "print"


import std/os

# task installBinary, "install exe":
#   # setCommand "i"
#   description = "Install binary file to /bin folder"

#   const 
#     installPath = "/bin/Dela"
#     binaryPath = "Dela"
  
#   # doAssert isFile(binaryPath), "Binary file not found."


#   withDir ".":
#     exec "nimble build"

  
#   try:
#     mvFile "Dela".toExe, "/bin/Dela".toExe
#     # copyFile(binaryPath, installPath)
#     echo "Binary file installed successfully to ", installPath
#   except:
#     echo "Failed to install binary file."
