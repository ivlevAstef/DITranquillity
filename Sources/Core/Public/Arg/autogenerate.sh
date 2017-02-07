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

######################################

registrationFunction() { #argcount file
  local numbers=($(seq 0 $1))

  local ParamType=$(join ',' ${numbers[@]/#/P})
  local ParametersType=$(join ',_' $(replaceToArg numbers[@] ":P;I"));

  local numbers=($(seq 0 $(($1 + 1))))
  local Params=$(join ',' $(replaceToArg numbers[@] "\$;I"));

  echo "  @discardableResult
  public func initialWithParams<$ParamType>(_ closure: @escaping (_:DIScope,_$ParametersType) -> ImplObj) -> Self {
    rType.append(initial: { closure($Params) as Any })
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


##################################

registrationInitFunction() { #argcount file
local numbers=($(seq 0 $1))

local ParamType=$(join ',' ${numbers[@]/#/P})
local ParametersType=$(join ',_' $(replaceToArg numbers[@] ":P;I"))
local Resolvers=$(join ',' $(replaceToArg numbers[@] "*!s"))

echo "  @discardableResult
  public func initial<$ParamType>(_ closure: @escaping (_$ParametersType) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIScope) -> Any in closure($Resolvers) })
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
local ParametersType=$(join ',_' $(replaceToArg numbers[@] ":P;I"))
local Resolvers=$(join ',' $(replaceToArg numbers[@] "*!s"))

echo "  @discardableResult
  public func injection<$ParamType>(_ method: @escaping (_:ImplObj, _$ParametersType) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, $Resolvers) })
    return self
  }
" >> $2
}

registationInjectFile() { #file
echo "//
//  DIRegistrationBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {" > $1

for argcount in `seq 0 $argmax`; do
registrationInjectFunction $argcount $1
done
echo "}" >> $1
}

##################################

containerInitFunction() { #argcount file
local numbers=($(seq 0 $1))

local ParamType=$(join ',' ${numbers[@]/#/P})
local ParametersType=$(join ',_:' $(replaceToArg numbers[@] "P;I"));

echo "  @discardableResult
  public func register<T, $ParamType>(file: String = #file, line: Int = #line, type initial: @escaping (_:$ParametersType) -> T) -> DIRegistrationBuilder<T> {
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


######################################

resolveFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"));
  local ArgumentsMethodType=$(join ',_' $(replaceToArg numbers[@] ":A;I"))
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  echo "  public func resolve<T,$ArgType>($prefix$ArgumentsType) throws -> T {
    typealias Method = (_:DIScope,_$ArgumentsMethodType) -> Any
    return try impl.resolve(self, type: T.self) { (\$0 as Method)(self, $ArgParam) }
  }
  " >> $3
}

resolveManyFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"))
  local ArgumentsMethodType=$(join ',_' $(replaceToArg numbers[@] ":A;I"))
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  echo "  public func resolveMany<T,$ArgType>($prefix$arg$ArgumentsType) throws -> [T] {
    typealias Method = (_:DIScope,_$ArgumentsMethodType) -> Any
    return try impl.resolveMany(self, type: T.self) { (\$0 as Method)(self, $ArgParam) }
  }
  " >> $3
}

resolveNameFunctions() { #argcount prefix file
  local prefix=${2//§/ }
  prefix=${prefix//&/}
  local numbers=($(seq 0 $1))

  local ArgType=$(join ',' ${numbers[@]/#/A})
  local ArgumentsType=$(join ',_ ' $(replaceToArg numbers[@] "a;I:A;I"))
  local ArgumentsMethodType=$(join ',_' $(replaceToArg numbers[@] ":A;I"))
  local ArgParam=$(join ',' $(replaceToArg numbers[@] "a;I"))
  ArgumentsType=${ArgumentsType//a0:A0/arg a0:A0}

  local name="name"
  echo "  public func resolve<T,$ArgType>($prefix$name: String, $ArgumentsType) throws -> T {
    typealias Method = (_: DIScope,_$ArgumentsMethodType) -> Any
    return try impl.resolve(self, name: name, type: T.self) { (\$0 as Method)(self, $ArgParam) }
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


registationFile "DIRegistrationBuilder.Params.swift"
registationInitFile "DIRegistrationBuilder.Arg.swift"
registationInjectFile "DIRegistrationBuilder.Injection.swift"

containerInitFile "DIContainerBuilder.Register.Arg.swift"

resolveFile "DIScope.Arg.swift"
typeResolveFile "DIScope.TypeArg.swift"
