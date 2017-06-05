Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '2.3.1'
  s.summary      = 'DITranquillity - Dependency injection for iOS/macOS/tvOS (Swift) '

  s.description  = <<-DESC
  					DITranquillity - The small library for dependency injection in applications written on pure Swift for iOS/OSX/tvOS. Despite its size, it solves a large enough range of tasks, including Storyboard support. Its main advantage - modularity of support, detailed errors description and lots of opportunities.
            DESC

  s.homepage     = 'https://github.com/ivlevAstef/DITranquillity'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.documentation_url = 'https://github.com/ivlevAstef/DITranquillity'

  s.author       = { 'Alexander.Ivlev' => 'ivlev.stef@gmail.com' }
  s.source       = { :git => 'https://github.com/ivlevAstef/DITranquillity.git', :tag => "v#{s.version}" }

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |cores|
    cores.public_header_files = 'Sources/DITranquillity.h'
    cores.source_files = 'Sources/Core/**/*.swift', 'Sources/Logger/*.swift', 'Sources/DITranquillity.h'
  end

  s.subspec 'Description' do |dess|
    dess.source_files = 'Sources/Descriptions/**/*.swift'
    dess.dependency 'DITranquillity/Core'
  end

  s.subspec 'Component' do |coms|
    coms.source_files = 'Sources/Component/*.swift'
    coms.dependency 'DITranquillity/Core'
    coms.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D ENABLE_DI_COMPONENT' }
  end

  s.subspec 'Module' do |mods|
    mods.source_files = 'Sources/Module/*.swift'
    mods.dependency 'DITranquillity/Component'
    mods.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D ENABLE_DI_MODULE' }
  end

  s.subspec 'Storyboard' do |storys|
    storys.ios.public_header_files = 'Sources/Storyboard/iOS-tvOS/*.h'
    storys.tvos.public_header_files = 'Sources/Storyboard/iOS-tvOS/*.h'
    storys.osx.public_header_files = 'Sources/Storyboard/OSX/*.h'
    storys.ios.source_files = 'Sources/Storyboard/iOS-tvOS/*.{h,m,swift}'
    storys.tvos.source_files = 'Sources/Storyboard/iOS-tvOS/*.{h,m,swift}'
    storys.osx.source_files = 'Sources/Storyboard/OSX/*.{h,m,swift}'
    storys.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ENABLE_DI_STORYBOARD' }
    storys.dependency 'DITranquillity/Core'
  end

  s.subspec 'Logger' do |logs|
    logs.dependency 'DITranquillity/Core'
    logs.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D ENABLE_DI_LOGGER' }
  end

  s.subspec 'Scan' do |scans|
    scans.source_files = 'Sources/Scan/*.swift'
  end

  s.subspec 'RuntimeArgs' do |args|
    args.source_files = 'Sources/RuntimeArgs/*.swift'
    args.dependency 'DITranquillity/Core'
  end

  s.subspec 'Modular' do |modls|
    modls.dependency 'DITranquillity/Core'
    modls.dependency 'DITranquillity/Logger'
    modls.dependency 'DITranquillity/Description'
    modls.dependency 'DITranquillity/Component'
    modls.dependency 'DITranquillity/Module'
    modls.dependency 'DITranquillity/Storyboard'
    modls.dependency 'DITranquillity/Scan'
  end

  s.subspec 'Full' do |alls|
    alls.dependency 'DITranquillity/Core'
    alls.dependency 'DITranquillity/Description'
    alls.dependency 'DITranquillity/Component'
    alls.dependency 'DITranquillity/Module'
    alls.dependency 'DITranquillity/Storyboard'
    alls.dependency 'DITranquillity/Logger'
    alls.dependency 'DITranquillity/Scan'
    alls.dependency 'DITranquillity/RuntimeArgs'
  end

  s.default_subspecs = 'Core', 'Logger', 'Description', 'Component', 'Storyboard'

end
