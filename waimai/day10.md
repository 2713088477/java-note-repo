# Day10知识点

## 1.Spring Task介绍

Spring Task是Spring框架提供的任务调度工具，可以按照约定的时间自动执行某个代码逻辑。

定位:定时任务框架

作用:定时自动执行某段Java代码



cron表达式其实就是一个字符串，通过cron表达式可以定义任务触发的时间

构成规则:分为6或7个域，由空格分隔开，每个域代表一个含义

每个域的含义分别为:秒、分钟、小时、日、月、周、年(可选)

| 秒   | 分钟 | 小时 | 日   | 月   | 周   | 年   |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 0    | 0    | 9    | 12   | 10   | ?    | 2022 |

2022年10月12日上午9点整，对应的cron表达式为:0 0 9 12 10 ? 2022

在线生成工具:https://cron.qqe2.com/

## 2.Spring Task使用步骤

1.导入maven坐标spring-context(一般会由starter直接传递下来)

2.启动类添加注解@EnableScheduling开启任务调度

3.自定义定时任务类

```java
@Component
@Slf4j
public class MyTask {

    /**
     * 5秒执行一次
     */
    @Scheduled(cron = "0/5 * * * * ?")
    //方法返回值需要指定为void
    public void executeTask() {
        log.info("定时任务开始执行"+new Date());
    }
}

```

苍穹外卖处理超时的未支付订单:

```java
@Component
@Slf4j
public class OrderTask {

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 每分钟执行一次
     * 检测订单是否超时
     */
    @Scheduled(cron = "0 * * * * ? ")
    public void checkOrderTimeOut(){
        log.info("开始处理超时订单:{}", LocalDateTime.now());
        List<Orders> outTimeOrders = orderMapper.getByStatusAndOrderTimeLT(Orders.PENDING_PAYMENT, LocalDateTime.now().plusMinutes(-15));
        if(outTimeOrders != null && outTimeOrders.size() > 0){
            for (Orders outTimeOrder : outTimeOrders) {
                outTimeOrder.setStatus(Orders.CANCELLED);
                outTimeOrder.setCancelReason("支付超时,自动取消");
                outTimeOrder.setCancelTime(LocalDateTime.now());
                orderMapper.update(outTimeOrder);
            }
        }
    }

}

```

## 3.WebSocket

WebSocket是基于TCP的一种新的网络协议。它实现了浏览器与服务器全双工通信——浏览器和服务器只需要完成一次握手，两者直接就可以创建持久性的连接，并进行双向数据传输。

![tt](assets\http.png)

![ebSocke](assets\WebSocket.png)

两者的主要区别:

1.http是短连接,WebSocket是长连接

2.http通信是单向的，基于请求响应模式

webSocket支持双向通信

相同点:底层都是TCP连接

## 4.WebSocket使用步骤

1.有一个WebSocket客户端

2.导入WebSocket的maven坐标

3.导入WebSocket服务端组件WebSocketServer,用于和客户端通信

```java
/**
 * WebSocket服务
 */
@Component
@ServerEndpoint("/ws/{sid}")
public class WebSocketServer {

    //存放会话对象
    private static Map<String, Session> sessionMap = new HashMap();

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("sid") String sid) {
        System.out.println("客户端：" + sid + "建立连接");
        sessionMap.put(sid, session);
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息
     */
    @OnMessage
    public void onMessage(String message, @PathParam("sid") String sid) {
        System.out.println("收到来自客户端：" + sid + "的信息:" + message);
    }

    /**
     * 连接关闭调用的方法
     *
     * @param sid
     */
    @OnClose
    public void onClose(@PathParam("sid") String sid) {
        System.out.println("连接断开:" + sid);
        sessionMap.remove(sid);
    }

    /**
     * 群发
     *
     * @param message
     */
    public void sendToAllClient(String message) {
        Collection<Session> sessions = sessionMap.values();
        for (Session session : sessions) {
            try {
                //服务器向客户端发送消息
                session.getBasicRemote().sendText(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
```

4.导入配置类WebSocketConfiguration,注册WebSocket的服务端组件

```java
/**
 * WebSocket配置类，用于注册WebSocket的Bean
 */
@Configuration
public class WebSocketConfiguration {

    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }

}

```

5.导入定时任务类WebSocketTask,定时向客户端推送数据

```java
@Component
public class WebSocketTask {
    @Autowired
    private WebSocketServer webSocketServer;

    /**
     * 通过WebSocket每隔5秒向客户端发送消息
     */
    @Scheduled(cron = "0/5 * * * * ?")
    public void sendMessageToClient() {
        webSocketServer.sendToAllClient("这是来自服务端的消息：" + DateTimeFormatter.ofPattern("HH:mm:ss").format(LocalDateTime.now()));
    }
}

```

