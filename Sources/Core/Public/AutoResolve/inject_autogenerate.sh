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

registrationInjectFunction() { #argcount file
local numbers=($(seq 0 $1))

local PType=$(join ',' ${numbers[@]/#/P})

echo "  @discardableResult
  public func injection<$PType>(_ m: @escaping (Impl,$PType) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }
" >> $2
}

registationInjectFile() { #file
echo "//
//  DI.ComponentBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DI.ComponentBuilder {

  private func append(injection signature: MethodSignature) -> Self {
    component.append(injection: signature)
    return self
  }
" > $1

for argcount in `seq 0 $argmax`; do
registrationInjectFunction $argcount $1
done
echo "}" >> $1
}

registationInjectFile "DI.ComponentBuilder.Injection.swift"
