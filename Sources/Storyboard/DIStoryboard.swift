//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS)
  import UIKit
#elseif os(OSX)
  import Cocoa
#endif

#if os(iOS) || os(tvOS) || os(OSX)

/// The class provides the features to inject dependencies of view/window controllers in a storyboard.
/// Needs to specify a container to inject dependencies in view/window controllers.
public final class DIStoryboard: _DIStoryboardBase {
  private override init() { super.init() }
  
  /// Creates new instance of `DIStoryboard`.
  /// When initializing itself, it finds a container and other information about the storyboard.
  ///
  /// - Parameters:
  ///   - name: The name of the storyboard resource file without the filename extension.
  ///   - storyboardBundleOrNil: The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
  /// - Returns: The new instane of `DIStoryboard`.
  @objc public class func create(name: String, bundle storyboardBundleOrNil: Bundle?) -> DIStoryboard {
    let scm = StoryboardContainerMap.instance
    if let container = scm.findContainer(by: name, bundle: storyboardBundleOrNil) {
      if let component = scm.findComponent(by: name, bundle: storyboardBundleOrNil) {
        return container.resolver.resolve(type: DIStoryboard.self, component: component)
      }
      
      return create(name: name, bundle: storyboardBundleOrNil, container: container)
    }
    
    return DIStoryboard._create(name, bundle: storyboardBundleOrNil)
  }
  
  /// Creates new instance of `DIStoryboard`, with the specified container.
  ///
  /// - Parameters:
  ///   - name: The name of the storyboard resource file without the filename extension.
  ///   - storyboardBundleOrNil: The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
  ///   - container: The container with registrations of the view/window controllers in the storyboard ant their dependencies.
  /// - Returns: The new instane of `DIStoryboard`.
  public class func create(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIContainer) -> DIStoryboard {
    let storyboard = DIStoryboard._create(name, bundle: storyboardBundleOrNil)
    storyboard.resolver = StoryboardResolver(container: container, bundle: storyboardBundleOrNil)
    return storyboard
  }

  #if os(iOS) || os(tvOS)
  
  /// Instantiates the view controller with the specified identifier.
  /// The view controller and its child controllers have their dependencies injected as specified in the container passed to the initializer of the self.
  ///
  /// - Parameter identifier: The identifier set in the storyboard file.
  /// - Returns: The instantiated view controller with its dependencies injected.
  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
    let vc = super.instantiateViewController(withIdentifier: identifier)
    resolver?.inject(into: vc)
    return vc
  }
  
  #elseif os(OSX)
  
  /// Instantiates the view/window controler with the specified identifier.
  /// The view/window controller and tis child controllers hase their dependencies injected as specified in the container passed to the initializer of the self.
  ///
  /// - Parameter identifier: The identifier set in the storyboard file.
  /// - Returns: The instantiated view/window controller with its dependencies injected.
  public override func instantiateController(withIdentifier identifier: NSStoryboard.SceneIdentifier) -> Any {
    let vc = super.instantiateController(withIdentifier: identifier)
    resolver?.inject(into: vc)
    return vc
  }
  
  #endif

  private var resolver: StoryboardResolver? = nil
}
 
// MARK: - Storyboard maker
extension DIContainer {
  #if os(iOS) || os(tvOS)
  
  /// Registers a new storyboard.
  /// The storyboard can be created both from the code or use storyboard reference from otherwise a storyboard.
  ///
  /// - Parameters:
  ///   - name: The name of the storyboard resource file without the filename extension.
  ///   - storyboardBundleOrNil: The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
  /// - Returns: component builder, to configure the component
  @discardableResult
  public func registerStoryboard(name: String, bundle storyboardBundleOrNil: Bundle? = nil, file: String = #file, line: Int = #line) -> DIComponentBuilder<UIStoryboard> {
    let bundle = storyboardBundleOrNil ?? self.frameworkStack.last?.bundle
    let builder = register(file: file, line: line) {
      DIStoryboard.create(name: name, bundle: bundle, container: $0) as UIStoryboard
    }
    builder.as(UIStoryboard.self, name: name)
    
    StoryboardContainerMap.instance.append(name: name, bundle: storyboardBundleOrNil, component: builder.component, in: self)
    return builder
  }
  
  #elseif os(OSX)
  
  /// Registers a new storyboard.
  /// The storyboard can be created both from the code or use storyboard reference from otherwise a storyboard.
  ///
  /// - Parameters:
  ///   - name: The name of the storyboard resource file without the filename extension.
  ///   - storyboardBundleOrNil: The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
  /// - Returns: component builder, to configure the component
  @discardableResult
  public func registerStoryboard(name: String, bundle storyboardBundleOrNil: Bundle? = nil, file: String = #file, line: Int = #line) -> DIComponentBuilder<NSStoryboard> {
    let bundle = storyboardBundleOrNil ?? self.frameworkStack.last?.bundle
    let builder = register(file: file, line: line) {
      DIStoryboard.create(name: name, bundle: bundle, container: $0) as NSStoryboard
    }
    builder.as(NSStoryboard.self, name: name)
  
    StoryboardContainerMap.instance.append(name: name, bundle: storyboardBundleOrNil, component: builder.component, in: self)
    return builder
  }
  
  #endif
}
  
#endif
