#!/bin/bash

argmax=16

join() { local d=$1; shift; printf "$1"; shift; printf "%s" "${@/#/$d}"; }

replaceToArg() {
  declare -a arr=("${!1}")
  for i in "${!arr[@]}"; do
    index=${arr[$i]}
    arr[$i]=${2//;I/$index}
  done
  echo "${arr[@]}"
}

dependencyFunction() { #argcount file
  local numbers1=($(seq 1 $1))
  local count=$(($1 - 1))
  local numbers0=($(seq 0 $count))

  local ArgType=$(join ', ' $(replaceToArg numbers1[@] "T;I:±DIAssembly")); ArgType=${ArgType//±/ }
  local ArgumentsType=$(join ', _ ' $(replaceToArg numbers1[@] "t;I:±T;I.Type")); ArgumentsType=${ArgumentsType//±/ }
  local Arguments=$(join ', ' ${numbers0[@]/#/t})

  echo "  public final func addDependencies<T0: DIAssembly, $ArgType>(t0: T0.Type, _ $ArgumentsType) {
    addDependencies($Arguments)
    addDependency(t$1)
  }
  " >> $2
}

dependencyFile() { #file
  echo "//
//  DIAssembly.Setters.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIAssembly {
  public final func addModules(modules: DIModule...) {
    for module in modules {
      addModule(module)
    }
  }

  public final func addDependencies<T0: DIAssembly>(t0: T0.Type) {
    addDependency(t0)
  }
  " > $1

  for argcount in `seq 1 $argmax`; do
    dependencyFunction $argcount $1
  done
  echo "}" >> $1
}

dependencyFile "DIAssembly.Setters.swift"
