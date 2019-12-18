//
//  TypeKey.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

struct ShortTypeKey: Hashable {
  private let type: DIAType
  private let hash: Int
  
  init(by type: DIAType) {
    self.type = type
    self.hash = ObjectIdentifier(type).hashValue
  }
  
  #if swift(>=5.0)
  func hash(into hasher: inout Hasher) {
    hasher.combine(hash)
  }
  #else
  var hashValue: Int { return hash }
  #endif
  
  static func ==(lhs: ShortTypeKey, rhs: ShortTypeKey) -> Bool {
    return lhs.type == rhs.type
  }
}

struct TypeKey: Hashable {
  let type: DIAType //need for construct ShortTypeKey...
  private let tag: DITag
  private let name: String
  
  private let hash: Int
  
  init(by type: DIAType, tag: DITag = Any.self, name: String = "") {
    self.type = type
    self.tag = tag
    self.name = name
    
    hash = ObjectIdentifier(type).hashValue ^ ObjectIdentifier(tag).hashValue ^ name.hashValue
  }
  
  #if swift(>=5.0)
  func hash(into hasher: inout Hasher) {
    hasher.combine(hash)
  }
  #else
  var hashValue: Int { return hash }
  #endif
  
  static func ==(lhs: TypeKey, rhs: TypeKey) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.tag == rhs.tag
  }
}
