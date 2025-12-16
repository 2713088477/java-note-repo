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


## 2.HttpClient入门案列

利用java代码发送一个get和post请求

```java
@SpringBootTest
public class HttpClientTest {

    @Test
    public void testGet() throws Exception {
        //创建HttpClient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        //创建请求对象
        HttpGet httpGet = new HttpGet("http://localhost:8080/user/shop/status");
        //发送请求,接受响应结果
        CloseableHttpResponse response = httpClient.execute(httpGet);
        //获取服务端返回的状态码
        int statusCode = response.getStatusLine().getStatusCode();
        System.out.println("服务端返回的状态码为:"+statusCode);
        HttpEntity entity = response.getEntity();
        String body = EntityUtils.toString(entity);
        System.out.println("服务端返回的数据为:"+body);
        //关闭资源
        response.close();
        httpClient.close();
    }

    @Test
    public void testPost() throws Exception {
        //创建HttpClient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        //创建请求对象
        HttpPost httpPost = new HttpPost("http://localhost:8080/admin/employee/login");
        //设置body参数和请求头信息
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("username","admin");
        jsonObject.put("password","123456");
        StringEntity entity = new StringEntity(jsonObject.toString());
        entity.setContentEncoding("utf-8");
        entity.setContentType("application/json");
        httpPost.setEntity(entity);
        //发送请求，接受响应结果
        CloseableHttpResponse response = httpClient.execute(httpPost);
        int statusCode = response.getStatusLine().getStatusCode();
        System.out.println("服务端返回的状态码为:"+statusCode);
        HttpEntity entityResponse = response.getEntity();
        String body = EntityUtils.toString(entityResponse);
        System.out.println("服务端返回的数据为:"+body);
        //关闭资源
        response.close();
        httpClient.close();

    }
}
```

