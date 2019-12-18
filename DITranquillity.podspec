Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '3.9.3'
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

  s.dependency 'SwiftLazy'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |s_core|
    core_h = 'Sources/DITranquillity.h'
    core_src = 'Sources/Core/**/*.swift'
  
    s_core.source_files = core_h, core_src
  end

  s.subspec 'UIKit' do |s_uikit|
    uikit_swizzling = 'Sources/UIKit/Swizzling/*.{h,m,swift}'

    uikit_storyboard = 'Sources/UIKit/Storyboard/*.{h,m,swift}'
    uikit_storyboard_OSX = 'Sources/UIKit/Storyboard/OSX/*.{h,m,swift}'
    uikit_storyboard_iOStvOS = 'Sources/UIKit/Storyboard/iOS-tvOS/*.{h,m,swift}'

    uikit_injectintosubviews = 'Sources/UIKit/InjectIntoSubviews/*.{h,m,swift}'
    uikit_injectintosubviews_iOStvOS = 'Sources/UIKit/InjectIntoSubviews/iOS-tvOS/*.{h,m,swift}'

    s_uikit.dependency 'DITranquillity/Core'
    s_uikit.source_files = uikit_swizzling, uikit_storyboard, uikit_injectintosubviews
    s_uikit.ios.source_files = uikit_storyboard_iOStvOS, uikit_injectintosubviews_iOStvOS
    s_uikit.tvos.source_files = uikit_storyboard_iOStvOS, uikit_injectintosubviews_iOStvOS
    s_uikit.osx.source_files = uikit_storyboard_OSX
  end

  s.default_subspec = 'Core', 'UIKit'

end
