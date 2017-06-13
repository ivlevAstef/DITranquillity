//
//  MethodSignature.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

class MethodSignature: Hashable {
  struct Parameter: Hashable {
    let type: Any.Type
    let style: DIResolveStyle
    
    var hashValue: Int {
      return "\(type)\(style)".hashValue
    }
    
    static func ==(lhs: Parameter, rhs: Parameter) -> Bool {
      return lhs.type == rhs.type && lhs.style == rhs.style
    }
    
    var optional: Bool { return isOptional(self.type) }
  }
  
  let parameters: [Parameter]
  let unique: String
  
  convenience init(styles: [DIResolveStyle], types: [Any.Type]) {
    self.init(styles, types)
  }
  
  init(_ styles: [DIResolveStyle], _ types: [Any.Type]) {
    assert(styles.count == types.count || 0 == styles.count)
    var parameters: [Parameter] = []
    for i in 0..<types.count {
      let style = i < styles.count ? styles[i] : DIResolveStyle.default
      parameters.append(Parameter(type: types[i], style: style))
    }
    self.parameters = parameters
    
    self.unique = parameters
      .filter{ $0.style == .arg }
      .map{ TypeKey($0.type).unique }
      .joined()
  }
  
  var hashValue: Int { return unique.hashValue }
  static func ==(lhs: MethodSignature, rhs: MethodSignature) -> Bool {
    return lhs.unique == rhs.unique
  }
}
