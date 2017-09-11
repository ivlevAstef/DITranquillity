//
//  TypeKey.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

struct TypeKey: Hashable {
  private let type: DIAType
  private let bundle: Bundle
  private let tag: DITag
  private let name: String
  
  private let typeID: ObjectIdentifier
  private let tagID: ObjectIdentifier
  
  init(by type: DIAType) {
    self.init(type: type, tag: Any.self, name: "")
  }
  
  init(by type: DIAType, and tag: DITag) {
    self.init(type: type, tag: tag, name: "")
  }
  
  init(by type: DIAType, and name: String) {
    self.init(type: type, tag: Any.self, name: name)
  }
  
  private init(type: DIAType, tag: DITag, name: String) {
    self.type = type
    self.bundle = getBundle(for: type)
    self.tag = tag
    self.name = name
    
    self.typeID = ObjectIdentifier(type)
    self.tagID = ObjectIdentifier(tag)
  }
  
  var hashValue: Int {
    return typeID.hashValue ^ name.hashValue ^ tagID.hashValue ^ bundle.hashValue
  }
  
  static func ==(lhs: TypeKey, rhs: TypeKey) -> Bool {
    return lhs.type == rhs.type && lhs.name == rhs.name && lhs.tag == rhs.tag && lhs.bundle == rhs.bundle
  }
}

private var defaultBundle = Bundle(for: NSObject.self)

private func getBundle(for type: DIAType) -> Bundle {
  if let clazz = type as? AnyClass {
    return Bundle(for: clazz)
  }
  return defaultBundle
}

