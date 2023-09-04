Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '4.5.2'
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
  s.swift_version = '5.1'

  s.dependency 'SwiftLazy', '>= 1.2.0'

  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = '4.0'

  # subspecs is very long validation - 'pod lib lint' check all combination....
  core_h = 'Sources/DITranquillity.h'
  core_src = 'Sources/Core/**/*.swift'

  graphapi_src = 'Sources/GraphAPI/*.swift'

  ui_swizzling = 'Sources/UI/Swizzling/*.{h,m,swift}'

  ui_storyboard = 'Sources/UI/Storyboard/*.{h,m,swift}'
  ui_storyboard_OSX = 'Sources/UI/Storyboard/OSX/*.{h,m,swift}'
  ui_storyboard_iOStvOS = 'Sources/UI/Storyboard/iOS-tvOS/*.{h,m,swift}'

  ui_injectintosubviews = 'Sources/UI/InjectIntoSubviews/*.{h,m,swift}'
  ui_injectintosubviews_iOStvOS = 'Sources/UI/InjectIntoSubviews/iOS-tvOS/*.{h,m,swift}'

  s.ios.source_files = core_h, core_src, graphapi_src, ui_swizzling, ui_storyboard, ui_injectintosubviews, ui_storyboard_iOStvOS, ui_injectintosubviews_iOStvOS
  s.tvos.source_files = core_h, core_src, graphapi_src, ui_swizzling, ui_storyboard, ui_injectintosubviews, ui_storyboard_iOStvOS, ui_injectintosubviews_iOStvOS
  s.osx.source_files = core_h, core_src, graphapi_src, ui_swizzling, ui_storyboard, ui_injectintosubviews, ui_storyboard_OSX
  s.watchos.source_files = core_h, core_src, graphapi_src, ui_swizzling

end
