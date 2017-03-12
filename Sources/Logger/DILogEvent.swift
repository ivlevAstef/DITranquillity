//
//  DILogEvent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_LOGGER

public enum DILogEvent {
  case registration
  case createSingle(BeginEndBrace)
  
  case resolving(BeginEndBrace)
  case found(typeInfo: DITypeInfo)
  case resolve(ResolveStyle)
  case cached
  case injection(BeginEndBrace)
  
  case error(DIError)
  
  public enum BeginEndBrace: Equatable {
    case begin
    case end
  }
  
  public enum ResolveStyle: Equatable {
    case cache
    case new
    case use
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
         (.error(_), .error(_)):
      return true
    default:
      return false
    }
  }
}

#endif
