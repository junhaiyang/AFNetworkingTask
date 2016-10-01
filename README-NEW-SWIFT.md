# AFNetworkingTask(2.0) for SWIFT
 
####基本请求
 
 
		import AFNetworkingTaskSwift 
 		//声明构造
 		
    	let  container:AFNetworkContainer = AFNetworkContainer();
    	
    	//返回数据解析构造器，可自定义实现 
        container.addDefaultStructure(UserData.classForCoder());
    	
 		//声明对象
        let  task1:AFNetworkTask = AFNetworkTask(container:container);
    	
    	// originalObj 为原始数据对象
    	// data 为解析出来的返回对象
    	task1.get("http://xxxxxxxx") { (msg:AFNetworkMsg, originalObj:Any? , data:AFNetworkResponseData? ) in
  			 let userData:UserData = data as! UserData; 
         	 print("finish .........");
             
        }; 
    	 
         
    	
* 默认请求是JSON格式解析，所以上面的方法会无任何返回结果
  
###### 自定义返回对象
* 实例化说明
    
    	//解析结构声明
    	let  container:AFNetworkContainer = AFNetworkContainer();
   		container.responseType =  .normal ;     //响应协议类型， 无任何格式的字符串流方式
   		container.responseType =  .JSON ;     //响应协议类型， JSON格式符串流方式
   		 
    	container.requestType = .normal;      //请求协议类型，标准提交
    	container.requestType = .JSON;        //请求协议类型，发JSON格式提交
   		
   		//处理结果是否在非主线程中回调，默认是主线程
   		container.completionCustomQueue = true; 
   		 
			
    	
###### 回调说明

* (msg:AFNetworkMsg, originalObj:Any? , data:AFNetworkResponseData? )
* msg：包含服务器的错误码和http 错误码 和 本地处理错误码，以及 response headers 数据
* originalObj：返回的原始数据，根据 container.responseType 不同回事不同的格式类型
	* AFNetworkProtocolType.normal：字符串
	* AFNetworkProtocolType.JSON：字典 

* data：解析出来的实例化对象，可能为空，前提是得自行去配置 AFNetworkDataAdapter 继承实现


###### 适配器(Adapter)说明

* 有三种适配器 AFNetworkSerializerAdapter，AFNetworkSessionAdapter，AFNetworkDataAdapter
* AFNetworkSerializerAdapter
	* 只能有一个实现，用于生成，请求和响应序列化处理
* AFNetworkSessionAdapter
	* 可以有多个实现，分别会在创建成功 request  和 响应response 后调用，会按照顺序依次执行
* AFNetworkDataAdapter
	* 可以有多个实现，会在 AFNetworkTaskAdapter 后调用，会按照顺序依次执行，并会将处理结果依次传递给下一个adapter，最终使用最后一个的处理结果
		
		
			//自定义数据解析器
        	let  dataAdapter:AFNetworkDataCovertModelAdapter = AFNetworkDataCovertModelAdapter(); 
    		//解析返回json中的result数据，构造成 UserData 对象返回
       		dataAdapter.addStructure(UserData.classForCoder());
    
        	container.addDataAdapter(dataAdapter);
    		 

	 
			
			 
###### 具体实例化对象与 json 的解析映射规则
* json 映射 使用的 MJExtension 框架，具体规则 参考 [MJExtension](https://github.com/CoderMJLee/MJExtension)
	
###### 请求时添加新的header问题
* 自定义 AFNetworkTaskAdapter   

			class MyAFNetworkSessionAdapter: AFNetworkSessionAdapter {
    
    			open override func request(_ request: NSMutableURLRequest){
           			//TODO add header 
        			request.addValue("", forHTTPHeaderField: ""); 
    			}
    
   				open override func response(_ response: HTTPURLResponse, msg: AFNetworkMsg?){
    
    			} 
    			
			}

			let sessionAdapter:MyAFNetworkSessionAdapter = MyAFNetworkSessionAdapter();
			
			container.addSessionAdapter(sessionAdapter);
 	
		
###### 直接对象请求模式

		
		//自己继承实现该协议就行，对象只能继承自 AFNetworkRequestData
		class  MyData:AFNetworkRequestData {
		
		}

		@end
		
		let myData:MyData =  MyData(); 
 
    	let  container:AFNetworkContainer = AFNetworkContainer(); 
        container.addDefaultStructure(UserData.classForCoder());
    	
 		//声明对象
        let  task1:AFNetworkTask = AFNetworkTask(container:container);
    	
    	// originalObj 为原始数据对象
    	// data 为解析出来的返回对象
    	task1.post("http://xxxxxx", data: myData) { (msg:AFNetworkMsg, originalObj:Any? , data:AFNetworkResponseData? ) in
  			 let userData:UserData = data as! UserData; 
         	 print("finish .........");
             
        };   
  