//
//  DILogStyle.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_LOGGER

public enum DILogStyle {
  case registration
  case createSingle(BeginEndBrace)
  
  case resolving(BeginEndBrace)
  case found(typeInfo: DITypeInfo)
  case resolve(ResolveStyle)
  case cached
  case injection(BeginEndBrace)
  
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
}

extension DILogStyle: Equatable {
  public static func ==(lhs: DILogStyle, rhs: DILogStyle) -> Bool {
    switch (lhs, rhs) {
    case (.createSingle(let brace1), .createSingle(let brace2)):
      return brace1 == brace2
    case (.resolving(let brace1), .resolving(let brace2)):
      return brace1 == brace2
    case (.found(let typeInfo1), .found(let typeInfo2)):
      return typeInfo1 == typeInfo2
    case (.resolve(let brace1), .resolve(let brace2)):
      return brace1 == brace2
    case (.injection(let brace1),.injection(let brace2)):
      return brace1 == brace2
    case (.registration, .registration),
         (.cached, .cached):
      return true
    case (.error(_), .error(_)):
      return true
    default:
      return false
    }
  }
}

extension DILogStyle.BeginEndBrace: Equatable {
  public static func==(lhs: DILogStyle.BeginEndBrace, rhs: DILogStyle.BeginEndBrace) -> Bool {
    switch (lhs, rhs) {
    case (.begin, .begin),
         (.end, .end):
      return true
    default:
      return false
    }
  }
}

extension DILogStyle.ResolveStyle: Equatable {
  public static func==(lhs: DILogStyle.ResolveStyle, rhs: DILogStyle.ResolveStyle) -> Bool {
    switch (lhs, rhs) {
    case (.cache, .cache),
         (.new, .new),
         (.use, .use):
      return true
    default:
      return false
    }
  }
}

#endif
