//
//  ComponentAlternativeType.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Alternative type. It' types setup in component used function `as(...`
public enum ComponentAlternativeType {
  case type(DIAType)
  case tag(DITag, type: DIAType)
  case name(String, type: DIAType)
}
