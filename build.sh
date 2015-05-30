#!/bin/bash

file=nimnimble.nim

fileAbs=`readlink -m $file`
traceback=false

nim c --parallelBuild:1 --threads:on $file

compiler_exit=$?

if [ "$compiler_exit" -eq 0 ] ; then
  # test with an example .nimble
  cd example2
  ../nimnimble build
fi

if [ "$traceback" = true ] ; then
  echo -e "\nRunning ./koch temp c $fileAbs"
  cd ~/bin/nim-repo
  ./koch temp c `readlink -m $fileAbs`
fi


