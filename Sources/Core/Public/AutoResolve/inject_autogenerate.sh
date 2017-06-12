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
local PStyles=$(join ',' $(replaceToArg numbers[@] "_s;I:RS=d")); PStyles=${PStyles//_s/_ s}
local Styles=$(join ',' $(replaceToArg numbers[@] "s;I"))

echo "  @discardableResult
  public func injection<$PType>($PStyles,_ m: @escaping (Impl,$PType) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, $Styles]))
    return self
  }
" >> $2
}

registationInjectFile() { #file
echo "//
//  DIRegistrationBuilder.Injection.Methods.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private let d=DIResolveStyle.neutral
public extension DIRegistrationBuilder {
" > $1

for argcount in `seq 0 $argmax`; do
registrationInjectFunction $argcount $1
done
echo "}" >> $1
}

registationInjectFile "DIRegistrationBuilder.Injection.Methods.swift"
