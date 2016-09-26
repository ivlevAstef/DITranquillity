//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class RTypeContainer {
  internal func append(_ key: Any, value: RType) {
    if nil == values[hash(key)] {
      values[hash(key)] = []
    }

    values[hash(key)]?.append(value)
  }

  internal subscript(key: Any) -> [RType]? { return values[hash(key)] }

  internal func data() -> [String: [RType]] {
    return values
  }

  internal func copyFinal() -> RTypeContainerFinal {
		//Hard copy method, for save unique RType
		
		var reverseValues: [RType : [String]] = [:]
    for valueData in self.values {
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

  private var values: [String: [RType]] = [:]
}
