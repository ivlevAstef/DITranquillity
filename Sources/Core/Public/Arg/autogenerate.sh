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
  local numbers=($(seq 0 $1))
  numbers[0]=""

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsType=${ArgumentsType//±/ }
  local Arguments=$(join ', ' ${numbers[@]/#/arg})
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I"));

  echo "  @discardableResult
  public func initializer<$ArgType>(method: @escaping (_ scope: DIScope, _ $ArgumentsType) -> ImplObj) -> Self {
    rType.setInitializer { (s, $Arguments) -> Any in return method(s, $ArgParam) }
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

  for argcount in `seq 0 $argmax`; do
    registrationFunction $argcount $1
  done
  echo "}" >> $1
}

registrationShortFunction() { #argcount file
local numbers=($(seq 0 $1))
numbers[0]=""

local ArgType=$(join ', ' ${numbers[@]/#/Arg})
local ArgumentsType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsType=${ArgumentsType//±/ }

echo "  @discardableResult
  public func register<T, $ArgType>(file: String = #file, line: Int = #line, initializer: @escaping (_ scope: DIScope, _ $ArgumentsType) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line)).initializer(method: initializer)
  }
" >> $2
}


registationShortFile() { #file
echo "//
//  DIContainerBuilder.ShortSyntax.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {" > $1

for argcount in `seq 0 $argmax`; do
registrationShortFunction $argcount $1
done
echo "}" >> $1
}

resolveFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))
  numbers[0]=""

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsType=${ArgumentsType//±/ }
  local ArgumentsMethodType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsMethodType=${ArgumentsMethodType//±/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I"));

  echo "  public func resolve<T, $ArgType>($prefix$ArgumentsType) throws -> T {
    typealias Method = (_ scope: DIScope, _ $ArgumentsMethodType) -> Any
		return try impl.resolve(self, type: T.self) { (initializer: Method) in return initializer(self, $ArgParam) }
  }
  " >> $3
}

resolveManyFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))
  numbers[0]=""

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsType=${ArgumentsType//±/ }
  local ArgumentsMethodType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsMethodType=${ArgumentsMethodType//±/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I"));

  echo "  public func resolveMany<T, $ArgType>($prefix$ArgumentsType) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ $ArgumentsMethodType) -> Any
    return try impl.resolveMany(self, type: T.self) { (initializer: Method) in return initializer(self, $ArgParam) }
  }
  " >> $3
}

resolveNameFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  prefix=${prefix//&/}
  local numbers=($(seq 0 $1))
  numbers[0]=""

  local ArgType=$(join ', ' ${numbers[@]/#/Arg})
  local ArgumentsType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsType=${ArgumentsType//±/ }
  local ArgumentsMethodType=$(join ', _ ' $(replaceToArg numbers[@] "arg;I:±Arg;I")); ArgumentsMethodType=${ArgumentsMethodType//±/ }
  local ArgParam=$(join ', ' $(replaceToArg numbers[@] "arg;I"));

  local name="name"
  echo "  public func resolve<T, $ArgType>($prefix$name: String, $ArgumentsType) throws -> T {
    typealias Method = (_ scope: DIScope, _ $ArgumentsMethodType) -> Any
    return try impl.resolve(self, name: name, type: T.self) { (initializer: Method) -> Any in return initializer(self, $ArgParam) }
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

  for argcount in `seq 0 $argmax`; do
    resolveFunctions $argcount "" $1
    resolveManyFunctions $argcount "" $1
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

  for argcount in `seq 0 $argmax`; do
    resolveFunctions $argcount "_: T.Type,§" $1
    resolveManyFunctions $argcount "_: T.Type,§" $1
    resolveNameFunctions $argcount "_: T.Type,§" $1
  done
  echo "}" >> $1
} 


registationFile "DIRegistrationBuilder.Arg.swift"
registationShortFile "DIContainerBuilder.ShortSyntax.Arg.swift"

resolveFile "DIScope.Arg.swift"
typeResolveFile "DIScope.TypeArg.swift"
