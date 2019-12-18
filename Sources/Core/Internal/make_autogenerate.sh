#!/bin/bash

argmax=15

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
local n=$((1+$1))

local PType=$(join ',' ${numbers[@]/#/P})
local MArg=$(join ',' $(replaceToArg numbers[@] "m(\$0[;I])"))

echo "  static func make$n<$PType,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ($PType)->R) -> MethodSignature {
    return MS(types, names){f($MArg)}
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
private func m<T>(_ obj: Any?) ->T { return gmake(by: obj) }
private typealias MS = MethodSignature
struct MethodMaker {

  static func makeVoid<P0,R>(by f: @escaping (P0)->R) -> MethodSignature {
    assert(P0.self is Void.Type, "makeVoid called not for Void type creation")
    return MS([]){_ in f(() as! P0)}
  }
" > $1

for argcount in `seq 0 $argmax`; do
    makeFunction $argcount $1
done
echo "}" >> $1
}

makeFile "MethodMaker.swift"
