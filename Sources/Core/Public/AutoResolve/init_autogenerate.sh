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
  public func register<Impl,$PType>(file: String = #file, line: Int = #line, _ c: @escaping ($PType) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(false, by: c))
  }
" >> $2

}

registationInitFile() { #file
echo "//
//  DIContainerBuilder.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DIContainerBuilder {
" > $1

for argcount in `seq 0 $argmax`; do
    registrationInitFunction $argcount $1
done
echo "}" >> $1
}

registationInitFile "DIContainerBuilder.Reg.swift"
