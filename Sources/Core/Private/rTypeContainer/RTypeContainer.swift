//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainer {
  func append(key: Any, value: RType) {
    values.append(key: AnyKey(key), value: value)
  }

  func contains(key: Any, value: RType) -> Bool {
    return values.contains(key: AnyKey(key), value: value)
  }

  subscript(key: Any) -> [RType] { return values[AnyKey(key)] }

  func data() -> [AnyKey: [RType]] {
    return values.dictionary
  }

  func copyFinal() -> RTypeContainerFinal {
    // Hard copy method, for save unique RType

    var reverseValues: [RType : [AnyKey]] = [:]
    for valueData in self.values.dictionary {
      for value in valueData.1 {
        if nil == reverseValues[value] {
          reverseValues[value] = []
        }
        reverseValues[value]!.append(valueData.0)
      }
    }

    var data: [AnyKey: [RTypeFinal]] = [:]
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

  private var values = DIMultimap<AnyKey, RType>()
}

class AnyKey: Hashable {
  let value: Any
  let name: String
  
  init(_ value: Any) {
    self.value = value
    self.name = String(describing: value)
  }
  
  var hashValue: Int {  return name.hashValue }
  
  static func ==(lhs: AnyKey, rhs: AnyKey) -> Bool {
    return lhs.name == rhs.name
  }
}