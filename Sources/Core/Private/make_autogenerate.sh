#!/bin/bash

argmax=9

join() { local d=$1; shift; printf "$1"; shift; printf "%s" "${@/#/$d}"; }

replaceToArg() {
  declare -a arr=("${!1}")
  for i in "${!arr[@]}"; do
    index=${arr[$i]}
    arr[$i]=${2//;I/$index}
  done
  echo "${arr[@]}"
}

##################################

makeFunction() { #argcount file
local numbers=($(seq 0 $1))

local PType=$(join ',' ${numbers[@]/#/P})
local MArg=$(join ',' $(replaceToArg numbers[@] "m(\$0[;I])"))
local PSType=$(join ',' $(replaceToArg numbers[@] "P;I.self"))


echo "  static func make<$PType,R>(by f: @escaping ($PType)->R) -> MethodSignature {
    return MS([$PSType], {f($MArg)})
  }
" >> $2
}

makeFile() { #file
echo "//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

// for short write MethodMaker
private func m<T>(_ obj: Any?) ->T { return make(by: obj) }
private typealias MS = MethodSignature
struct MethodMaker {

  static func make<R>(by f: @escaping ()->R) -> MethodSignature {
    return MS([], {_ in f()})
  }
" > $1

for argcount in `seq 0 $argmax`; do
    makeFunction $argcount $1
done
echo "}" >> $1
}

makeFile "MethodMaker.swift"
