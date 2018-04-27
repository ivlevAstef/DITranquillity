Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '3.3.0'
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

  s.dependency = 'SwiftLazy'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  core_headers = 'Sources/DITranquillity.h'
  core_sources = 'Sources/**/*.swift'

  s.ios.public_header_files = core_headers, 'Sources/Storyboard/iOS-tvOS/*.h'
  s.tvos.public_header_files = core_headers, 'Sources/Storyboard/iOS-tvOS/*.h'
  s.osx.public_header_files = core_headers, 'Sources/Storyboard/OSX/*.h'

  s.ios.source_files = core_headers, core_sources, 'Sources/Storyboard/iOS-tvOS/*.{h,m}'
  s.tvos.source_files = core_headers, core_sources, 'Sources/Storyboard/iOS-tvOS/*.{h,m}'
  s.osx.source_files = core_headers, core_sources, 'Sources/Storyboard/OSX/*.{h,m}'

end
