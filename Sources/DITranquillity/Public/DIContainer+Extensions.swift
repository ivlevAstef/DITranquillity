//
//  DIContainer+Extensions.swift
//  DITranquillity
//
//  Created by Ивлев Александр Евгеньевич on 17/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import Foundation

extension DIContainer
{

  /// Method for creating an object capable of customizing extensions
  ///
  /// - Parameters:
  ///   - type: object type for which extensions are specified. Сan be tagged
  ///   - name: optional. Qualified name by which to retrieve a specific component
  ///   - framework: optinal. Qualified framework to which component belongs
  /// - Returns: object for customizing extensions
  public func extensions(for type: DIAType, name: String? = nil, framework: DIFramework.Type? = nil, file: String = #file, line: Int = #line) -> DIExtensions? {
    let candidates = self.resolver.findComponents(by: ParsedType(type: type), with: name, from: framework?.bundle)
    if let component = candidates.first, 1 == candidates.count {
      return extensionsContainer.get(by: component.info)
    }

    if 0 == candidates.count {
      log(.error, msg: "Until make extensions can't find component by type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line)")
    } else {
      log(.error, msg: "Until make extensions can't choose component by type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line) from: \(candidates)")
    }

    return nil
  }
}
