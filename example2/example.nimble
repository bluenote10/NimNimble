
let
  name        = "ExampleProject"
  author      = "Some Author"
  version     = "0.1.0"
  description = "should maybe not required?"
  license     = "MIT"

deps += "Nim >= 0.11.2"
deps += "somelib#f837fe2"

proc createTimestamp(): string = "someTimestamp"

proc osSpecificDir(): string = 
  when defined(windows): 
    "windows"
  elif defined(macosx): 
    "macosx"
  else: 
    "linux"

proc createBinPath(appname: string): string =
  "bin" / osSpecificDir() / appname & "_" & version & "_" & createTimestamp()

bins += ("src/main.nim" => createBinPath("myapp") )

nimargs += "--hints:off"
nimargs += "--opt:speed"

