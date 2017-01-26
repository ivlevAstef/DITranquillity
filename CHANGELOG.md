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

