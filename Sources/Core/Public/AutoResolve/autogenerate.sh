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

local ParamType=$(join ',' ${numbers[@]/#/P})
local Resolvers=$(join ',' $(replaceToArg numbers[@] "*c"))

echo "  @discardableResult
  public func initial<$ParamType>(_ closure: @escaping ($ParamType) -> Impl) -> Self {
    component.append(initial: { (c: DIContainer) -> Any in closure($Resolvers) })
    return self
  }
" >> $2
}

registationInitFile() { #file
echo "//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {" > $1

for argcount in `seq 0 $argmax`; do
    registrationInitFunction $argcount $1
done
echo "}" >> $1
}

##################################

registrationInjectFunction() { #argcount file
local numbers=($(seq 0 $1))

local ParamType=$(join ',' ${numbers[@]/#/P})
local Resolvers=$(join ',' $(replaceToArg numbers[@] "*c"))

echo "  @discardableResult
  public func injection<$ParamType>(_ method: @escaping (Impl,$ParamType) -> ()) -> Self {
    component.append(injection: { c, o in method(o, $Resolvers) })
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

public extension DIRegistrationBuilder {" > $1

for argcount in `seq 1 $argmax`; do
registrationInjectFunction $argcount $1
done
echo "}" >> $1
}

##################################

containerInitFunction() { #argcount file
local numbers=($(seq 0 $1))

local ParamType=$(join ',' ${numbers[@]/#/P})

echo "  @discardableResult
  public func register<T, $ParamType>(file: String = #file, line: Int = #line, type initial: @escaping ($ParamType) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
" >> $2
}

containerInitFile() { #file
echo "//
//  DIContainerBuilder.Register.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {" > $1

for argcount in `seq 0 $argmax`; do
  containerInitFunction $argcount $1
done

echo "}" >> $1
}

registationInitFile "DIRegistrationBuilder.Arg.swift"
registationInjectFile "DIRegistrationBuilder.Injection.Methods.swift"

containerInitFile "DIContainerBuilder.Register.Arg.swift"
