//
//  DIGraph.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

public struct DIComponentVertex {
  public let componentInfo: DIComponentInfo
  public let lifeTime: DILifeTime
  public let isDefault: Bool
  public let canInitialize: Bool

  public let framework: DIFramework.Type?
  public let part: DIPart.Type?
}

public struct DIArgumentVertex {
  public let type: DIAType
}

public enum DIVertex {
  case component(DIComponentVertex)
  case argument(DIArgumentVertex)
}

public struct DIEdge {
  public let cycle: Bool
  public let optional: Bool
  public let many: Bool
  public let delayed: Bool
  public let tags: [DITag]
  public let name: String?
}

public struct DIGraph {
  public let vertices: [DIVertex]
  public let matrix: [[DIEdge?]]

  public init(vertices: [DIVertex], matrix: [[DIEdge?]]) {
    self.vertices = vertices
    self.matrix = matrix
  }
}
