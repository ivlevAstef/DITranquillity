//
//  DIComponentBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Component Builder.
/// To create a used function `register(_:)` in class `ContainerBuilder`.
/// The class allows you to configure all the necessary properties for the component.
/// Don't retain this class objects, because component registration happens on deinit this object.
public final class DIComponentBuilder<Impl> {
  private weak var extensions: DIExtensions?

  init(container: DIContainer, componentInfo: DIComponentInfo) {
    self.extensions = container.extensions
    self.component = Component(componentInfo: componentInfo,
                               in: container.frameworkStack.last, container.partStack.last)
    self.componentContainer = container.componentContainer
    self.resolver = container.resolver
  }
  
  deinit {
    log(.verbose, msgc: {
      var msg = "\(component.priority) "
      msg += "registration: \(component.info)\n"
      msg += "\(DISetting.Log.tab)initial: \(nil != component.initial)\n"
      msg += "\(DISetting.Log.tab)lifetime: \(component.lifeTime)\n"
      msg += "\(DISetting.Log.tab)injections: \(component.injections.count)\n"
      return msg
    })

    extensions?.componentRegistration?(DIComponentVertex(component: component))
    componentContainer.insert(TypeKey(by: unwrapType(Impl.self)), component)
  }
  
  let component: Component
  let componentContainer: ComponentContainer
  let resolver: Resolver
}
