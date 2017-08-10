//
//  MethodSignature.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

final class MethodSignature {
  final class Parameter {
    let type: Any.Type
    let style: DIResolveStyle
    var links: [Component] = []
    
    init(type: Any.Type, style: DIResolveStyle) {
      self.type = type
      self.style = style
    }
    
    var optional: Bool { return isOptional(self.type) }
  }
  
  let parameters: [Parameter]
  
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
  }
  
}
