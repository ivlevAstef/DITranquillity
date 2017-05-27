//
//  DILogEvent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public enum DILogEvent {
  case registration
  case createSingle(BeginEndBrace)
  
  case resolving(BeginEndBrace)
  case found(typeInfo: DITypeInfo)
  case resolve(ResolveStyle)
  case cached
  case injection(BeginEndBrace)
  
  case warning(Warning)
  case error(DIError)
  
  public enum BeginEndBrace {
    case begin
    case end
  }
  
  public enum ResolveStyle {
    case cache
    case new
    case use
  }
  
  public enum Warning {
    case implNotFound(for: DITypeInfo)
  }
}

extension DILogEvent: Equatable {
  public static func ==(lhs: DILogEvent, rhs: DILogEvent) -> Bool {
    switch (lhs, rhs) {
    case (.registration, .registration),
         (.createSingle(_), .createSingle(_)),
         (.resolving(_), .resolving(_)),
         (.found(_), .found(_)),
         (.resolve(_), .resolve(_)),
         (.cached, .cached),
         (.injection(_),.injection(_)),
         (.warning(_),.warning(_)),
         (.error(_), .error(_)):
      return true
    default:
      return false
    }
  }
}
