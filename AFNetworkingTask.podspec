 
Pod::Spec.new do |s|
 

  s.name         = "AFNetworkingTask"
  s.version      = "1.2.1"
  s.summary      = "AFNetworking Sample Task....."
 

  s.homepage     = "https://github.com/junhaiyang/AFNetworkingTask"
 
  s.license      = "MIT"
 
  s.author             = { "yangjunhai" => "junhaiyang@gmail.com" } 
  s.ios.deployment_target = "7.0" 

  s.ios.framework = 'UIKit'
 
  s.source = { :git => 'https://github.com/junhaiyang/AFNetworkingTask.git' , :tag => '1.2.1'} 
 
  s.requires_arc = true

  s.source_files = 'AFNetworkingTask/Classes/*.{h,m,mm}'  


  s.subspec 'AFTextResponseSerializer' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFTextResponseSerializer/*.{h,m,mm}' 
          
  end

  s.subspec 'AFGIFResponseSerializer' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFGIFResponseSerializer/*.{h,m,mm}' 
          
  end

  s.subspec 'AFNetworkActivityLogger' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFNetworkActivityLogger/*.{h,m,mm}' 
          
  end
  s.subspec 'AFgzipRequestSerializer' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/AFgzipRequestSerializer/*.{h,m,mm}' 
          
  end
  s.subspec 'NSObjectKeyValueOption' do |ds|
    
    ds.source_files = 'AFNetworkingTask/Classes/NSObjectKeyValueOption/*.{h,m,mm}' 
          
  end 
  
    
  s.subspec 'UIKit' do |ks| 
       
      ks.source_files = 'AFNetworkingTask/Classes/UIKit/*.{h,m,mm}' 
         
         
  end 

  s.dependency 'AFNetworking' , '~> 3.1.0'
  s.dependency 'Godzippa' , '~> 1.1.0'
  s.dependency 'YLGIFImage'  , '~> 0.11'
  s.dependency 'TMCache' , '~> 2.1.0'
  s.dependency 'MJExtension' , '~> 3.0.10' 
   
 
end
