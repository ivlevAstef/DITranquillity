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

resolveFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"));
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  echo "  public func resolve<T,$ArgType>($prefix$ArgumentsType) -> T {
    typealias Method = (DIContainer,$ArgType) -> Any
    return resolver.resolve(self, type: T.self){ (\$0 as Method)(self,$ArgParam) }
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
  echo "  public func resolve<T,$ArgType>($prefix$name: String, $ArgumentsType) -> T {
    typealias Method = (DIContainer,$ArgType) -> Any
    return resolver.resolve(self, name: name, type: T.self){ (\$0 as Method)(self,$ArgParam) }
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
  echo "  public func resolve<T,Tag,$ArgType>($prefix$tag: Tag, $ArgumentsType) -> T {
    typealias Method = (DIContainer,$ArgType) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ (\$0 as Method)(self,$ArgParam) }
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

resolveFile "DIContainer.Arg.swift"
