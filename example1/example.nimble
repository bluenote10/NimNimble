
let
  name        = "ExampleProject"
  #author      = "Some Author"
  version     = "0.1.0"
  description = "should maybe not required?"
  license     = "MIT"

deps += "Nim >= 0.11.2"
deps += "somelib#f837fe2"

bins += ("src/main.nim" => "bin/myapp")
bins += ("src/converter.nim" => "bin/myapp_converter")

nimargs += "--hints:off"
nimargs += "--opt:speed"