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

registrationFunction() { #argcount file
  local numbers=($(seq 1 $1))

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', ' $(replaceToArg numbers[@] "arg;I:_Arg;I")); ArgumentsType=${ArgumentsType//_/ }
  local Arguments=$(join ', ' ${numbers[@]/#/arg})
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I:_arg;I")); ArgParam=${ArgParam//_/ }

  echo "  public func initializer<$ArgType>(method: (scope: DIScope, $ArgumentsType) -> ImplObj) -> Self {
    rType.setInitializer { (s, $Arguments) -> Any in return method(scope: s, $ArgParam) }
    return self
  }
  " >> $2
}

registationFile() { #file
  echo "//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {" > $1

  for argcount in `seq 1 $argmax`; do
    registrationFunction $argcount $1
  done
  echo "}" >> $1
}

resolveFunctions() { #argcount prefix file
  local prefix=${2//±/ }
  local numbers=($(seq 1 $1))

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', ' $(replaceToArg numbers[@] "arg;I:_Arg;I")); ArgumentsType=${ArgumentsType//_/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I:_arg;I")); ArgParam=${ArgParam//_/ }

  echo "  public func resolve<T, $ArgType>($prefix$ArgumentsType) throws -> T {
    typealias Method = (scope: DIScope, $ArgumentsType) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, $ArgParam) }
  }
  " >> $3
}

resolveManyFunctions() { #argcount prefix file
  local prefix=${2//±/ }
  local numbers=($(seq 1 $1))

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', ' $(replaceToArg numbers[@] "arg;I:_Arg;I")); ArgumentsType=${ArgumentsType//_/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I:_arg;I")); ArgParam=${ArgParam//_/ }

  echo "  public func resolveMany<T, $ArgType>($prefix$ArgumentsType) throws -> [T] {
    typealias Method = (scope: DIScope, $ArgumentsType) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, $ArgParam) }
  }
  " >> $3
}

resolveNameFunctions() { #argcount prefix file
  local prefix=${2//±/ }
  prefix=${prefix//&/}
  local numbers=($(seq 1 $1))

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', ' $(replaceToArg numbers[@] "arg;I:_Arg;I")); ArgumentsType=${ArgumentsType//_/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I:_arg;I")); ArgParam=${ArgParam//_/ }

  local name="name"
  echo "  public func resolve<T, $ArgType>($prefix$name: String, $ArgumentsType) throws -> T {
    typealias Method = (scope: DIScope, $ArgumentsType) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, $ArgParam) }
  }
  " >> $3
}

resolveFile() { #file
  echo "//
//  DIScope.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIScope {" > $1

  for argcount in `seq 1 $argmax`; do
    resolveFunctions $argcount "arg1±" $1
    resolveManyFunctions $argcount "arg1±" $1
    resolveNameFunctions $argcount "&" $1
  done
  echo "}" >> $1
} 

typeResolveFile() { #file
  echo "//
//  DIScope.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIScope {" > $1

  for argcount in `seq 1 $argmax`; do
    resolveFunctions $argcount "_: T.Type,±" $1
    resolveManyFunctions $argcount "_: T.Type,±" $1
    resolveNameFunctions $argcount "_: T.Type,±" $1
  done
  echo "}" >> $1
} 


registationFile "DIRegistrationBuilder.Arg.swift"

resolveFile "DIScope.Arg.swift"
typeResolveFile "DIScope.TypeArg.swift"