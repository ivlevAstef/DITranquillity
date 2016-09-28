Pod::Spec.new do |s|

  s.name         = 'DITranquillity'
  s.version      = '0.9.6'
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

  s.source_files = core_files, assembly_files, storyboard_files, header_file

  s.frameworks = 'UIKit'
  
end
