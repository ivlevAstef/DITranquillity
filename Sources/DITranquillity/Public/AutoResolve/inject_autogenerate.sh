#!/bin/bash

argmax=7

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
local n=$((2+$1))

local PType=$(join ',' ${numbers[@]/#/P})
local PSType=$(join ',' $(replaceToArg numbers[@] "P;I.self"))
local params=$(join ', ' ${numbers[@]/#/p})
local quote='```'

echo "
  /// Function for appending an injection method
  ///
  /// Using:
  /// $quote
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, $params in yourClass.yourMethod($params) }
  /// $quote
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<$PType>(_ m: @escaping (Impl,$PType) -> ()) -> Self {
    return append(injection: MM.make$n([UseObject.self,$PSType], by: m))
  }" >> $2
}

registationInjectFile() { #file
echo "//
//  DIComponentBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIComponentBuilder {

  private func append(injection signature: MethodSignature) -> Self {
    component.append(injection: signature, cycle: false)
    return self
  }
" > $1

for argcount in `seq 1 $argmax`; do
registrationInjectFunction $argcount $1
done
echo "}" >> $1
}

registationInjectFile "DIComponentBuilder.Injection.swift"
