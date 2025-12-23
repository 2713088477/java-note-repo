# day9开发知识点

## 1.从配置文件中注入属性

想要直接注入为成员变量，这个类必须被Bean容器管理

1.注入单个属性

@Value属性

```java
@Component
@Data
public class MyService {

    @Value("${app.name}") // 假设配置文件中有 app.name=myapp
    private String appName;

    @Value("${server.port:8080}") // :8080 是默认值，如果server.port未配置则使用8080
    private int port;

}
```

2.注入多个属性

@ConfigurationProperties(prefix = "sky.wechat") 在prefix里面指定配置的前缀

```java
@Component
@ConfigurationProperties(prefix = "sky.wechat")
@Data
public class WeChatProperties {

    private String appid; //小程序的appid
    private String secret; //小程序的秘钥
    private String mchid; //商户号
    private String mchSerialNo; //商户API证书的证书序列号
    private String privateKeyFilePath; //商户私钥文件
    private String apiV3Key; //证书解密的密钥
    private String weChatPayCertFilePath; //平台证书
    private String notifyUrl; //支付成功的回调地址
    private String refundNotifyUrl; //退款成功的回调地址

}

```

