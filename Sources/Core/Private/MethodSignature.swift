//
//  MethodSignature.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

final class MethodSignature {
  typealias Call = ([Any?])->Any?
  
  final class Parameter {
    let type: DIAType
    var links: [Component] = []
    
    init(type: DIAType) {
      self.type = type
    }
    
    var optional: Bool { return isOptional(self.type) }
    var taggedType: IsTag.Type? { return self.type as? IsTag.Type }
    var many: Bool { return self.type is IsMany.Type }
  }
  
  let parameters: [Parameter]
  let call: Call
  let specificFirst: Bool
  
  init(_ types: [DIAType], _ specificFirst: Bool, _ call: @escaping Call) {
    let params = types.map{ Parameter(type: $0) }
    self.specificFirst = specificFirst
    self.parameters = specificFirst ? Array(params.dropFirst()) : params
    self.call = call
  }
}
