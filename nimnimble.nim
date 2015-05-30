let persons = [("bob", 20), ("alice", 19)]

for name, age in persons:
  echo name, age

import os
import nimblepkg/packageinfo

let args = commandLineParams()

if args.len != 1 or args[0] != "build":
  quit "Error: nimnimble currently only support 'build'"


let nimbleFile = findNimbleFile(getCurrentDir())
if nimbleFile == "":
  quit "Error: could not find .nimble file"


let tmpDir = getCurrentDir() / ".nimbletmp"
createDir(tmpDir)

let appDir = getAppDir()

copyFile(appDir / "buildtemplate.nim", tmpDir / "buildtemplate.nim")
copyFile(nimbleFile, tmpDir / "build.nim")

# go to the tmp directory ".nimbletmp"
setCurrentDir(tmpDir)

# compile the buildtemplate + .nimble to ".nimbletmp/build" (includes the .nimble)
let retParse = execShellCmd("nim c --verbosity:0 --hints:off -o:./build buildtemplate.nim")
if retParse != 0:
  quit "Error: could not parse the .nimble file"

# run & validate the resulting binary
let retValid = execShellCmd("build")
if retValid != 0:
  quit "Error: could not validate the .nimble file"
