//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainer {
  func append(key: DIType, value: RType) {
    values.append(key: DITypeKey(key), value: value)
  }

  func contains(key: DIType, value: RType) -> Bool {
    return values.contains(key: DITypeKey(key), value: value)
  }

  subscript(key: DIType) -> [RType] { return values[DITypeKey(key)] }

  func data() -> [DITypeKey: [RType]] {
    return values.dictionary
  }

  func copyFinal() -> RTypeContainerFinal {
    // Hard copy method, for save unique RType

    var reverseValues: [RType : [DITypeKey]] = [:]
    for valueData in self.values.dictionary {
      for value in valueData.1 {
        if nil == reverseValues[value] {
          reverseValues[value] = []
        }
        reverseValues[value]!.append(valueData.0)
      }
    }

    var data: [DITypeKey: [RTypeFinal]] = [:]
    for value in reverseValues {
      let final = value.0.copyFinal()
      for type in value.1 {
        if nil == data[type] {
          data[type] = []
        }
        data[type]!.append(final)
      }
    }

    return RTypeContainerFinal(values: data)
  }

  private var values = DIMultimap<DITypeKey, RType>()
}

class DITypeKey: Hashable {
  let value: DIType
  let name: String
  
  init(_ value: DIType) {
    self.value = value
    self.name = String(describing: value)
  }
  
  var hashValue: Int {  return name.hashValue }
  
  static func ==(lhs: DITypeKey, rhs: DITypeKey) -> Bool {
    return lhs.name == rhs.name
  }
}
