Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '2.0.0'
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

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.subspec 'Core' do |cores|
    cores.source_files = 'Sources/DITranquillity.h', 'Sources/Core/**/*.swift'
  end

  s.subspec 'Description' do |dess|
    dess.source_files = 'Sources/Descriptions/**/*.swift'
    dess.dependency 'DITranquillity/Core'
  end

  s.subspec 'Component' do |coms|
    coms.source_files = 'Sources/Component/*.swift'
    coms.dependency 'DITranquillity/Core'
  end

  s.subspec 'Module' do |mods|
    mods.source_files = 'Sources/Module/*.swift'
    mods.dependency 'DITranquillity/Component'
  end

  s.subspec 'Storyboard' do |storys|
    storys.ios.source_files = 'Sources/Storyboard/iOS-tvOS/*.{h,m,swift}'
    storys.tvos.source_files = 'Sources/Storyboard/iOS-tvOS/*.{h,m,swift}'
    storys.osx.source_files = 'Sources/Storyboard/OSX/*.{h,m,swift}'
    storys.dependency 'DITranquillity/Core'
  end

  s.subspec 'Scan' do |scans|
    scans.source_files = 'Sources/Scan/*.swift'
    scans.dependency 'DITranquillity/Component'
    scans.dependency 'DITranquillity/Module'
  end

  s.subspec 'RuntimeArgs' do |args|
    args.source_files = 'Sources/RuntimeArgs/*.swift'
    args.dependency 'DITranquillity/Core'
  end

  s.subspec 'Full' do |alls|
    alls.dependency 'DITranquillity/Core'
    alls.dependency 'DITranquillity/Description'
    alls.dependency 'DITranquillity/Component'
    alls.dependency 'DITranquillity/Module'
    alls.dependency 'DITranquillity/Storyboard'
    alls.dependency 'DITranquillity/Scan'
    alls.dependency 'DITranquillity/RuntimeArgs'
  end

  s.default_subspecs = 'Core', 'Description', 'Component', 'Module', 'Storyboard'

end
