 
Pod::Spec.new do |s|
 

  s.name         = "AFNetworkingTask"
  s.version      = "1.0"
  s.summary      = "AFNetworking Sample Task....."
 

  s.homepage     = "https://github.com/junhaiyang/AFNetworkingTask"
 
  s.license      = "MIT"
 
  s.author             = { "yangjunhai" => "junhaiyang@gmail.com" } 
  s.ios.deployment_target = "7.0" 

  s.ios.framework = 'UIKit'
 
  s.source = { :git => 'https://github.com/junhaiyang/AFNetworkingTask.git' , :tag => '1.0'} 
 
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m,mm}'  

  s.dependency 'AFNetworking', '<=2.6.1'
  s.dependency 'AFNetworkActivityLogger', '<=2.0.4'
  s.dependency 'AFgzipRequestSerializer', '<=0.0.2'
  s.dependency 'Godzippa', '<=1.1.0'
 
   
 
end
