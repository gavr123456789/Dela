# Package

version       = "0.2.0"
author        = "gavr"
description   = "A simple task manager with timer"
license       = "MIT"
srcDir        = "src"
bin           = @["Dela"]


# Dependencies

requires "nim >= 1.4.8"
requires "gintro"
requires "print"

task installBinary:
  description = "Install binary file to /bin folder"

  var binaryPath = "Dela"
  var installPath = "/bin"

  doAssert isFile(binaryPath), "Binary file not found."

  proc installBinaryFile(): bool =
    let destPath = installPath / binaryPath
    try:
      copyFile(binaryPath, destPath)
      echo "Binary file installed successfully to ", destPath
      result = true
    except:
      echo "Failed to install binary file."
      result = false

  runTask installBinaryFile