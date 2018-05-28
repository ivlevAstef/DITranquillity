Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '3.3.6'
  s.summary      = 'DITranquillity - Dependency injection for iOS/macOS/tvOS (Swift) '

  s.description  = <<-DESC
  					DITranquillity - The small library for dependency injection in applications written on pure Swift for iOS/OSX/tvOS. Despite its size, it solves a large enough range of tasks, including Storyboard support. Its main advantage - modularity of support, detailed logs and lots of opportunities.
            DESC

  s.homepage     = 'https://github.com/ivlevAstef/DITranquillity'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.documentation_url = 'https://htmlpreview.github.io/?https://github.com/ivlevAstef/DITranquillity/blob/master/Documentation/code/index.html'

  s.author       = { 'Alexander.Ivlev' => 'ivlev.stef@gmail.com' }
  s.source       = { :git => 'https://github.com/ivlevAstef/DITranquillity.git', :tag => "v#{s.version}" }

  s.requires_arc = true
  s.static_framework = true

  s.pod_target_xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_TARGET_SRCROOT)/Sources/DITranquillity-Bridging-Header.h' }

  s.dependency 'SwiftLazy'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  core_h = 'Sources/DITranquillity*.h'
  core_src = 'Sources/Core/**/*.{h,m,swift}'
  hierarchy_src = 'Sources/Hierarchy/*.swift'
  scan_src = 'Sources/Scan/*.swift'
  extensions_src = 'Sources/Extensions/*.swift'

  iis_h = 'Sources/InjectIntoSubviews/*.h'
  iis_src = 'Sources/InjectIntoSubviews/*.{h,m,swift}'
  iis_iOStvOS_src = 'Sources/InjectIntoSubviews/iOS-tvOS/*.{h,m,swift}'

  story_src = 'Sources/Storyboard/*.swift'
  story_iOStvOS_h = 'Sources/Storyboard/iOS-tvOS/*.h'
  story_iOStvOS_src = 'Sources/Storyboard/iOS-tvOS/*.{h,m}'
  story_OSX_h = 'Sources/Storyboard/OSX/*.h'
  story_OSX_src = 'Sources/Storyboard/OSX/*.{h,m}'

  s.ios.public_header_files = core_h, iis_h, story_iOStvOS_h
  s.tvos.public_header_files = core_h, iis_h, story_iOStvOS_h
  s.osx.public_header_files = core_h, story_OSX_h

  s.ios.source_files = core_h, core_src, hierarchy_src, scan_src, extensions_src, iis_src, iis_iOStvOS_src, story_src, story_iOStvOS_src
  s.tvos.source_files = core_h, core_src, hierarchy_src, scan_src, extensions_src, iis_src, iis_iOStvOS_src, story_src, story_iOStvOS_src
  s.osx.source_files = core_h, core_src, hierarchy_src, scan_src, extensions_src, story_src, story_OSX_src

end
