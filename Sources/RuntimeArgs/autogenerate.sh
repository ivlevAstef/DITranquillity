#!/bin/bash

argmax=4

join() { local d=$1; shift; printf "$1"; shift; printf "%s" "${@/#/$d}"; }

replaceToArg() {
  declare -a arr=("${!1}")
  for i in "${!arr[@]}"; do
    index=${arr[$i]}
    arr[$i]=${2//;I/$index}
  done
  echo "${arr[@]}"
}

######################################

registrationFunction() { #argcount file
  local numbers=($(seq 0 $1))

  local ParamType=$(join ',' ${numbers[@]/#/P})

  local numbers=($(seq 0 $(($1 + 1))))
  local Params=$(join ',' $(replaceToArg numbers[@] "\$;I"));

  echo "  @discardableResult
  public func initialWithArg<$ParamType>(_ closure: @escaping (DIContainer,$ParamType) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($Params) as Any })
    return self
  }
  " >> $2
}

registationFile() { #file
  echo "//
//  DIRegistrationBuilder.Params.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {" > $1

  for argcount in `seq 0 $argmax`; do
    registrationFunction $argcount $1
  done
  echo "}" >> $1
}

######################################

resolveFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"));
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  echo "  public func resolve<T,$ArgType>($prefix$ArgumentsType) throws -> T {
    typealias Method = (DIContainer,$ArgType) throws -> Any
    return try resolver.resolve(self, type: T.self){ try (\$0 as Method)(self,$ArgParam) }
  }
  " >> $3
}

resolveNameFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  prefix=${prefix//&/}
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"))
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  local name="name"
  echo "  public func resolve<T,$ArgType>($prefix$name: String, $ArgumentsType) throws -> T {
    typealias Method = (DIContainer,$ArgType) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try (\$0 as Method)(self,$ArgParam) }
  }
  " >> $3
}

resolveTagFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  prefix=${prefix//&/}
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"))
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  local tag="tag"
  echo "  public func resolve<T,Tag,$ArgType>($prefix$tag: Tag, $ArgumentsType) throws -> T {
    typealias Method = (DIContainer,$ArgType) throws -> Any
    return try resolver.resolve(self, tag: tag, type: T.self){ try (\$0 as Method)(self,$ArgParam) }
  }
  " >> $3
}


resolveFile() { #file
  echo "//
//  DIContainer.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {" > $1

  for argcount in `seq 0 $argmax`; do
    resolveFunctions $argcount "" $1
    resolveNameFunctions $argcount "&" $1
    resolveTagFunctions $argcount "&" $1
  done
  echo "}" >> $1
} 

typeResolveFile() { #file
  echo "//
//  DIContainer.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {" > $1

  for argcount in `seq 0 $argmax`; do
    resolveFunctions $argcount "_: T.Type,§" $1
    resolveNameFunctions $argcount "_: T.Type,§" $1
    resolveTagFunctions $argcount "_: T.Type,§" $1
  done
  echo "}" >> $1
} 


registationFile "DIRegistrationBuilder.Params.swift"
resolveFile "DIContainer.Arg.swift"
typeResolveFile "DIContainer.TypeArg.swift"
