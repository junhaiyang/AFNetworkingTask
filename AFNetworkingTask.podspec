 
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

  s.source_files = 'AFNetworkingTask/Classes/*.{h,m,mm}'  


  s.subspec 'AFTextResponseSerializer' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFTextResponseSerializer/*.{h,m,mm}' 
          
  end

  s.subspec 'AFGIFResponseSerializer' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFGIFResponseSerializer/*.{h,m,mm}' 
          
  end
    
  s.subspec 'UIKit' do |ks|
     
     ks.subspec 'UIImageView+AFNetworkTask' do |ds|
       
      ds.source_files = 'AFNetworkingTask/Classes/UIKit/UIImageView+AFNetworkTask.{h,m,mm}' 
         
    end
         
  end 

  s.dependency 'AFNetworking', '<=2.6.1'
  s.dependency 'AFNetworkActivityLogger', '<=2.0.4'
  s.dependency 'AFgzipRequestSerializer', '<=0.0.2'
  s.dependency 'Godzippa', '<=1.1.0'
  s.dependency 'YLGIFImage' 
  s.dependency 'TMCache'
   
 
end
