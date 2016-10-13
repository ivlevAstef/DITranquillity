//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainer {
  func append(key: Any, value: RType) {
    values.append(key: hash(key), value: value)
  }

  func contains(key: Any, value: RType) -> Bool {
    return values.contains(key: hash(key), value: value)
  }

  subscript(key: Any) -> [RType] { return values[hash(key)] }

  func data() -> [String: [RType]] {
    return values.dictionary
  }

  func copyFinal() -> RTypeContainerFinal {
    // Hard copy method, for save unique RType

    var reverseValues: [RType : [String]] = [:]
    for valueData in self.values.dictionary {
      for value in valueData.1 {
        if nil == reverseValues[value] {
          reverseValues[value] = []
        }
        reverseValues[value]!.append(valueData.0)
      }
    }

    var data: [String: [RTypeFinal]] = [:]
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

  private func hash(_ type: Any) -> String {
    return String(describing: type)
  }

  private var values = DIMultyMap<String, RType>()
}
