# Day6知识点

## 1.HttpClient

HttpClient是Apache Jakarta Common 下的子项目，可以用来提供高效的、最新的、功能丰富的支持HTTP协议的客户端编程工具包，并且它支持HTTP协议最新的版本和建议。

Maven坐标:

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>    
    <artifactId>httpclient</artifactId>   
    <version>4.5.13</version>
</dependency>
```

核心API:

1. HttpClient
2. HttpClients
3. CloseableHttpClient
4. HttpGet
5. HttpPost

发送请求步骤:

1. 创建HttpClient对象
2. 创建Http请求对象
3. 调用HttpClient的execute方法发送请求

