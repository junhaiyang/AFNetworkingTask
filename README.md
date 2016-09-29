# AFNetworkingTask
AFNetworking  OC & Swift  Sample 


####基本需求
* 简化网络处理和返回JSON 结果处理
* 根据用户提前制定的json映射规则，直接解析出对应的对象返回
* 支持图片格式： JPEG、PNG、GIF、WEBP、BMP
* 支持Swift & OC 编译 


####使用方法

###### 引用 Podfile 

		source 'https://github.com/CocoaPods/Specs.git'
		source 'https://github.com/junhaiyang/Specs.git'

		pod 'AFNetworkingTask', '~> 2.0'      #OC 非动态库 使用
		
		pod 'AFNetworkingTaskSwift', '~> 2.0' #Swift 动态库 使用
 

	
###### 引用 头文件
		#import "AFNetworkTask.h"   #OC 非动态库 使用
		
		
		import AFNetworkingTaskSwift    #Swift 动态库 使用
		
			 
###### 具体实例化对象与 json 的解析映射规则
* json 映射 使用的 MJExtension 框架，具体规则 参考 [MJExtension](https://github.com/CoderMJLee/MJExtension)
		
###### 基本代码编写
######2.0之后版本
* [处理方式(内置JSON映射解析支持) OC](./README-NEW-OC.md) 
* [处理方式(内置JSON映射解析支持) Swift](./README-NEW-SWIFT.md) 

######1.2.4之前版本
* [单个协议独立文件方式(无JSON映射解析支持，需自行处理)](./README-INNER.md)
* [协议不用独立文件方式(内置JSON映射解析支持)](./README-SIG.md)
 
 