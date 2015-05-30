
# define a .nimble specific DSL
# for example

proc `=>`(a, b: string): (string, string) = (a, b)

proc `+=`[T](s: var seq[T], element: T) = s.add(element)

var deps = newSeq[string]()
var bins = newSeq[(string, string)]()

var nimargs = newSeq[string]()


# include the .nimble
include build

import typetraits
import strutils
import os

# check mandatory fields, or rather identifiers.
# could be wrapped in a macro...

when not declared(name):
  {.error: "Nimble parse error: .nimble has no `name` specified".}
when name is not string:
  {.error: "Nimble parse error: type of `name` is not string".}

when not declared(author):
  {.error: "Nimble parse error: .nimble has no `author` specified".}
when author is not string:
  {.error: "Nimble parse error: type of `author` is not string".}

when not declared(version):
  {.error: "Nimble parse error: .nimble has no `version` specified".}
when version is not string:
  {.error: "Nimble parse error: type of `version` is not string".}

when not declared(description):
  {.error: "Nimble parse error: .nimble has no `description` specified".}
when description is not string:
  {.error: "Nimble parse error: type of `description` is not string".}

when not declared(license):
  {.error: "Nimble parse error: .nimble has no `license` specified".}
when license is not string:
  {.error: "Nimble parse error: type of `license` is not string".}



# dependency handling

### old attempt
# when declared(deps):
#   when deps is not seq[string]:
#     {.error: "Nimble parse error: type of `deps` must be seq[string] but is " & deps.type.name.}

for dep in deps:
  echo " * ensuring: ", dep
  # TODO: actual dependency check (+ install) + path construction


# some helper procs
proc reverse[T](s: seq[T]): seq[T] =
  result = newSeq[T](s.len)
  for i,x in s:
    result[^(i+1)] = x
    
proc makeRelative(d1, d2: string): string =
  ## expresses d2 relative to d1
  var path = newSeq[string]()
  for par in d1.parentDir.parentDirs:
    path += ParDir
  return path.joinPath / d2
  


# we are currently in .nimbletmp, so we have to
# go up one level before building
let buildDir = getCurrentDir().parentDir 
setCurrentDir(buildDir)

# now build
for src, bin in bins.items:
  echo " * compiling " & src & " => " & bin
  var cmd = @["nim c"]
  for nimarg in nimargs:
    cmd += nimarg

  # this is needed since -o is relative to src
  let binRelToSrc = makeRelative(src, bin)
  cmd += "-o:" & binRelToSrc

  cmd += src
  let finalCmd = cmd.join(" ")
  echo finalCmd


  # make sure output directory exists
  createDir(bin.parentDir)

  # compile
  let ret = execShellCmd(finalCmd)


