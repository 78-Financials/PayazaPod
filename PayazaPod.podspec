
Pod::Spec.new do |s|
  s.name             = 'PayazaPod'
  s.version          = '0.2.3'
  s.summary          = 'PayazSdk is the best iOS payment Sdk for ios devices'

  s.description      = 'PayAza ios Sdk aids in processing payment through the following channels: Cards,  Bank and Virtual Transfer'

  s.homepage         = 'https://github.com/78-Financials/PayazaPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xy-joe' => 'josephookoedo@gmail.com' }
  s.source           = { :git => 'https://github.com/78-Financials/PayazaPod.git', :tag => s.version.to_s }


  s.ios.deployment_target = '13.0'
  s.platform     = :ios, "13.0"

  s.source_files = 'PayazaPod/Classes/**/*'
  
   s.resource_bundles = {
     'PayazaPod' => ['PayazaPod/Assets/*.png']
   }
  s.resources = 'PayazaPod/Assets/**/*.{png,jpeg,jpg,gif,storyboard,xib,xcassets}'
  s.dependency  "Socket.IO-Client-Swift", "~> 16.1.0"
  s.dependency  "DropDown"
  s.swift_versions = "5.0"
end
