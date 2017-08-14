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

registrationInitFunction() { #argcount file
local numbers=($(seq 0 $1))

local PType=$(join ',' ${numbers[@]/#/P})

echo "  @discardableResult
  public func initial<$PType>(_ c: @escaping ($PType) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }
" >> $2
}

registationInitFile() { #file
echo "//
//  DI.ComponentBuilder.Init.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DI.ComponentBuilder {

  private func set(initial signature: MethodSignature) -> Self {
    component.set(initial: signature)
    return self
  }
" > $1

for argcount in `seq 0 $argmax`; do
    registrationInitFunction $argcount $1
done
echo "}" >> $1
}

registationInitFile "DI.ComponentBuilder.Init.swift"
