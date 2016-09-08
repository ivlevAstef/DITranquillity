Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '0.9.4'
  s.summary      = 'DITranquillity - Dependency injection for iOS (Swift) '

  s.description  = <<-DESC
  					DITranquillity - Prototype Dependency injection for iOS (Swift). 
            DESC

  s.homepage     = 'https://github.com/ivlevAstef/DITranquillity'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.documentation_url = 'https://github.com/ivlevAstef/DITranquillity'

  s.author       = { 'Alexander.Ivlev' => 'ivlev.stef@gmail.com' }
  s.source       = { :git => 'https://github.com/ivlevAstef/DITranquillity.git', :tag => "v#{s.version}" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  
  header_file = 'Swift/DITranquillity/DITranquillity/DITranquillity.h'
  core_files = 'Swift/DITranquillity/DITranquillity/Sources/{Public,Private}/**/*.swift'
  storyboard_files = 'Swift/DITranquillity/DITranquillity/Sources/Storyboard/*.{h,m,swift}'
  assembly_files = 'Swift/DITranquillity/DITranquillity/Sources/Assembly/*.swift'

  s.subspec 'Core' do |core|
    core.source_files = core_files, header_file
  end

  s.subspec 'Assembly' do |assembly|
    assembly.dependency 'DITranquillity/Core'

    assembly.source_files = assembly_files, core_files, header_file
  end

  s.subspec 'Storyboard' do |storyboard|
    storyboard.xcconfig = { 'OTHER_CFLAGS' => '$(inherited) -D__DITRANQUILLITY_STORYBOARD__' }
    storyboard.dependency 'DITranquillity/Core'

    storyboard.frameworks = 'UIKit'

    storyboard.source_files = storyboard_files, core_files, header_file
  end

  s.default_subspec = 'Assembly'

end
