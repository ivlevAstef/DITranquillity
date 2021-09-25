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

registrationInitFunction() { #argcount file
local numbers=($(seq 0 $1))
local numbersWithoutZero=($(seq 1 $1))
local n=$((1+$1))

local PType=$(join ',' ${numbers[@]/#/P})
local PSType=$(join ',' $(replaceToArg numbersWithoutZero[@] "P;I.self"))
local cArgs=$(join ',' ${numbersWithoutZero[@]/#/$})
local quote='```'
local zeroComponent='$0'

if [ "$n" != 1 ]; then
  echo "  /// Declaring a new component with initial.
  /// Using:
  /// $quote
  /// container.register(YourClass.init) { arg($zeroComponent) }
  /// $quote
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component." >> $2

  echo "  @discardableResult
  public func register<Impl,$PType,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping (($PType)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make$n([M0.self,$PSType], by: {c((modificator($zeroComponent),$cArgs))}))
  }
  " >> $2
fi

}

registationInitFile() { #file
echo "//
//  DIContainer.RegModify.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 25.09.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIContainer {
" > $1

for argcount in `seq 0 $argmax`; do
    registrationInitFunction $argcount $1
done
echo "}" >> $1
}

registationInitFile "DIContainer.RegModify.swift"
