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
    let type: DI.AType
    var links: [Component] = []
    
    init(type: DI.AType) {
      self.type = type
    }
    
    var optional: Bool { return isOptional(self.type) }
    var taggedType: IsTag.Type? { return self.type as? IsTag.Type }
    var many: Bool { return isMany(self.type) }
  }
  
  let parameters: [Parameter]
  let call: Call
  
  init(_ types: [DI.AType], _ call: @escaping Call) {
    self.parameters = types.map{ Parameter(type: $0) }
    self.call = call
  }
}
