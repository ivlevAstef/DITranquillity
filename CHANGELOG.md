# v3.8.2
* Support Lazy with tags, many and other combinations. for example: `let services: [Lazy<ServiceProtocol>] = many(by(tag: FooService.self, on: *container))`

# v3.8.1
* Support Many<Lazy<Type>>. For example: `let objects: [Lazy<Service>] = many(*container)`

# v3.8.0
* remove bundle from DIFramework - now support found dependencies for static libralies

# v3.7.4
* fix carthage compilation

# v3.7.3
* Fix "swift build" command compillation error

# v3.7.2
* Support order for many

# v3.7.1
* Fully support optional register. `c.register { optionalValue }` now can correct resolve.
* Improve logs for optional register if optional is nil.

# v3.7.0
* Fix `register1` - now only `register`
* Sorry. Stop support swift 3.x

# v3.6.4
* Fix IBDesignable crash

# v3.6.3
* Support Swift 5

# v3.6.0
* Remove scan
* Support custom/user scopes.
* Improve description for Component

# v3.5.2
* more improve speed

# v3.5.1
* Support arguments for providers
* Add empty Lazy/Provider initialization with fatalError

# v3.5.0
* Support container Hierarchy

# v3.4.3
* Fix swift 4.2 support

# v3.4.2
* Support Carthage

# v3.4.1
* Support Swift 4.2

# v3.4.0
* New feature `Arguments for initialization`: https://github.com/ivlevAstef/DITranquillity/issues/123
- Add extension to container. for example `container.extension(for: Home.self)`
- Support arguments into extensions `container.extension(for: Home.self).setArgs("arg1", arg2, ...)`
- Add modificator `arg` - `container.register{ YourClass(p1: $0, p2: arg($1)) }`

# v3.3.7
* Support static library for cocoapods. Needs cocoapods version 1.5.0 up

# v3.3.6
* Support static library for cocoapods. Needs cocoapods version 1.4.0 up 

# v3.3.5
* Up code coverage to 90%
* Fix postInit - now method call after executed cycle injection
* Fix hard cycle potensial bug.

# v3.3.4
* fix crash when using Lazy/Provider with Optional types.

# v3.3.3 - v3.3.2
* fix swizzling bug.

# v3.3.1
* New feature: inject into subviews, cells, items. Thanks 'Nekitosss'

# v3.3.0
* Support delayed injection. Now have Lazy and Provider injection.

# v3.2.2
* support swift4.1 Thanks 'Nekitosss'

# v3.2.1
* rename lifetimes: single, perRun(weak/strong), perContainer(weak/strong), objectGraph, prototype.
* small improve internal code

# v3.2.0
* support injection by keyPath for swift4
* small improve logging - add new log level `.verbose`

# v3.1.3
* Support multiply using tag and many

# v3.1.2
* Add new lifetime `perContainer`

# v3.1.1
* Improved speed by optimizing logging

# v3.1.0
* Support change bundle for DIFramework. Needed for static library

# v3.0.6
* feature: You can now pass the bundle from which to retrieve the object
* bugfix: When created ViewController, library didn't consider storyboard bundle

# v3.0.5
* swift4 support

# v3.0.4
* bugfix: Improve validate graph cycle, and logs.

# v3.0.3
* bugfix: Support recursive inject into ViewControllers.
* bugfix: Fix component bundle source.
* bugfix: Fix valid method, for hard dependency graph.
* Rename `valid` to `validate(checkGraphCycles:)`

# v3.0.2
* Changed hierarchy/default logic. Now component inside framework a upper priority than 'default'
* Small improve code documentantion
* Added generated documentation for the code

# v3.0.1
* Now thread safe supported for `append(framework:)`, `append(part:)`, `import()`
* Now `append(framework:)` also call `import()`

# v3.0.0
* Added migration documentation.
* Added code documentation.
* Accelerated library work 30 times. Now twice as fast swinject.
* Reduced library size by 40%, but number of parameters is increased.
* Supported StoryboardReference. Even with many containers.
* Removed very old manual syntax. Now the library knows entire dependency graph.
* Improved graph validation. Removed exceptions.
* Changed concept - container builder removed. Now only container.
* The library itself understands what you need - nor any `try?` and `.optional`
* Changed lifetimes on: `single`, `lazySingle`, `weakSingle`, `objectGraph`, `prototype`
* A single syntax for creating a hierarchy. Now it is `Framework` and `Part`
* Logging as part of the library.
* Single cocoapods spec without subspecs.
* fixed API. No more global syntax changes.
* But:
* Removed runtime args - there will be a new more powerful concept.


# v2.3.0
* Fix bug (issue98) into methods initial(useStoryboard:identifier:) and initial(nib:).


# v2.2.0
* Fix modularity bug - reorganization internal work with modularity and access levels
* Supported settings for set default behavior
* Improve injection into ViewControllers. Now app crash if found injections for VC but can’t injection into VC

# v2.1.5, v2.1.6
* Fix modularity access level for complex dependencies

# v2.1.4
* Move logger into default subspec and change realization
* Fix 'as' short style operation - add @discardableResult
* Improve intersectionNames error - now this error contains only incorrect types
* Fix scan components for Modular - now scan component is an public component

# v2.1.2, v2.1.3
* Add tags

# v2.1.0, v2.1.1
* Add logs
* Removed supported errors
* Simplified error names
* Improved separate project for `module`
* Separation `injection` method on: `injection(.manual)`, `injection(.optional)`, `injection`, `postInit`

# v2.0.0
* Add documentation for migration
* A full update documentation
* Remove Lazy
* Remove DynamicAssembly. Now there are late binding
* Rename DIModule -> DIComponent and DIAssembly -> DIModule
* Support area of vision for the components using modules
* Add weak single
* Add error description
* Greatly improve old syntax
* Separate library on modules: `Core`, `Description`, `Component`, `Module`, `Storyboard`, `Scan`, `RuntimeArgs`
* Support auto inject properties for Obj-C types
* Much more


# v1.3.1
* Support Lazy `DILazy`
* Add documentation for lazy
* Improved typing - now `DIType` it's `Any.Type` for a place `Any`

# v1.3.0
* Update documentation
* Update README
* Remove lifetime: .perRequest
* Change arrangement works with ViewControllers
* Fix critical bug (issue-69): App Crash if call DIStoryboard get ViewController methods after short period of time
* Write Test by issue-69

# v1.2.0
* Update documentation
* Added base types: DIType, DIMethodSignature, DIComponent
* Improved DIError - changed names, and added additional parameters
* Change lifetime syntax - now it's method `lifetime(enum)`
* Fix scan bug: not supported recursive check superclass.
* Improved internal code style

# v1.1.1
* Change scan syntax: replace ScannedModule and ScannedAssembly to Scanned + Module and Scanned + Assembly
* Update documentation page scan

# v1.1.0
* Added Scan (ScannedModule, ScannedAssembly, ScanModule, ScanAssembly)
* Update documentation - added scan page

# v1.0.0
* Supported macOS
* Added tvOS

# v0.9.9
* Added short registration syntax for types
* Added short registration syntax for UIViewController
* Renamed resolve functions with parameter 'Name:' to 'name:'
* Added tests

# v0.9.8
* Supported Carthage
* Added Travis
* Supported SwiftPM
