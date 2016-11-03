Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '1.2.0'
  s.summary      = 'DITranquillity - Dependency injection for iOS/macOS/tvOS (Swift) '

  s.description  = <<-DESC
  					DITranquillity - Prototype Dependency injection for iOS/macOS/tvOS (Swift). 
            DESC

  s.homepage     = 'https://github.com/ivlevAstef/DITranquillity'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.documentation_url = 'https://github.com/ivlevAstef/DITranquillity'

  s.author       = { 'Alexander.Ivlev' => 'ivlev.stef@gmail.com' }
  s.source       = { :git => 'https://github.com/ivlevAstef/DITranquillity.git', :tag => "v#{s.version}" }

  s.requires_arc = true
  
  header_file = 'Sources/DITranquillity.h'
  core_files = 'Sources/Core/**/*.swift'
  ios_tvos_storyboard_files = 'Sources/Storyboard/iOS-tvOS/*.{h,m,swift}'
  osx_storyboard_files = 'Sources/Storyboard/OSX/*.{h,m,swift}'
  assembly_files = 'Sources/Assembly/*.swift'
  scan_files = 'Sources/Scan/*.swift'

  s.ios.source_files = core_files, assembly_files, scan_files, ios_tvos_storyboard_files, header_file
  s.tvos.source_files = core_files, assembly_files, scan_files, ios_tvos_storyboard_files, header_file
  s.osx.source_files = core_files, assembly_files, scan_files, osx_storyboard_files, header_file

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

end