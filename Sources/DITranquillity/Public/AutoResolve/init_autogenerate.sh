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
local n=$((1+$1))

local PType=$(join ',' ${numbers[@]/#/P})
local PSType=$(join ',' $(replaceToArg numbers[@] "P;I.self"))
local PComment=$(join ',' $(replaceToArg numbers[@] "p;I:$;I"))
local quote='```'

echo "
  /// Declaring a new component with initial.
  /// Using:
  /// $quote
  /// container.register{ YourClass($PComment) }
  /// $quote
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component." >> $2

if [ "$n" == 1 ]; then
  echo "  #if swift(>=3.2)  /// swift4 bug: https://bugs.swift.org/browse/SR-5112
  @discardableResult
  public func register1<Impl,P0>(file: String = #file, line: Int = #line, _ c: @escaping (P0) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make1([P0.self], by: c))
  }
  #else
  @discardableResult
  public func register<Impl,P0>(file: String = #file, line: Int = #line, _ c: @escaping (P0) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make1([P0.self], by: c))
  }
  #endif
" >> $2
else
  echo "  @discardableResult
  public func register<Impl,$PType>(file: String = #file, line: Int = #line, _ c: @escaping ($PType) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make$n([$PSType], by: c))
  }
" >> $2
fi

}

registationInitFile() { #file
echo "//
//  DIContainer.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIContainer {
" > $1

for argcount in `seq 0 $argmax`; do
    registrationInitFunction $argcount $1
done
echo "}" >> $1
}

registationInitFile "DIContainer.Reg.swift"
