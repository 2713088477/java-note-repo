# RabbitMQ

## 1.RabbitMQ介绍

RabbitMQ是一款典型的异步通信组件。

同步通信就像视频电话，实时对话；

同步调用的优势: 

- 时效性强：等待到结果后才返回。

同步调用的劣势:

 - 扩展性差
- 性能下降
- 级联失败问题(微服务中，一个远程调用失败，下面的流程可能接着失败)



异步通信就像发微信，不用实时回复，根据自己的时间来回复。

异步调用方式其实就是基于消息通知的方式，一般包含三个角色：

- **消息发送者**：投递消息的人，就是原来的调用方。
- **消息代理**：管理、暂存、转发消息，你可以把它理解成微信服务器。
- **消息接收者**：接收和处理消息的人，就是原来的服务提供方。

异步调用的优势:

- **耦合度低，拓展性强**
- **异步调用，无需等待，性能好**
- **故障隔离**：下游服务故障不影响上游业务。
- **缓存消息，流量削峰填谷**

异步调用的缺点:

- **不能立即得到调用结果，时效性差**
- **不确定下游业务执行是否成功**
- **业务安全依赖于 Broker 的可靠性**





基础篇

- 同步和异步
- MQ技术选型
- 数据隔离
- SpringAMQP
- Work模式
- MQ消息转换器
- 发布订阅模式
- 消息堆积问题处理

高级篇

- 发送者重连
- 发送者确认
- MQ持久化
- LazyQueue
- 消费者确认
- 失败重试
- 业务幂等
- 延迟消息



## 2.MQ的技术选型

MQ（MessageQueue），中文是消息队列，字面来看就是存放消息的队列。也就是异步调用中的 Broker。

| 对比维度       | RabbitMQ                | ActiveMQ                          | RocketMQ   | Kafka      |
| :------------- | :---------------------- | :-------------------------------- | :--------- | :--------- |
| **公司/社区**  | Rabbit                  | Apache                            | 阿里       | Apache     |
| **开发语言**   | Erlang                  | Java                              | Java       | Scala&Java |
| **协议支持**   | AMQP, XMPP, SMTP, STOMP | OpenWire, STOMP, REST, XMPP, AMQP | 自定义协议 | 自定义协议 |
| **可用性**     | 高                      | 一般                              | 高         | 高         |
| **单机吞吐量** | 一般                    | 差                                | 高         | 非常高     |
| **消息延迟**   | 微秒级                  | 毫秒级                            | 毫秒级     | 毫秒以内   |
| **消息可靠性** | 高                      | 一般                              | 高         | 一般       |



RabbitMQ的基本介绍:

![](assets\RabbitMQ的基本介绍.png)

## 3.数据隔离

![](assets\利用virtual_host进行数据隔离.png)

通过virtual host可以实现数据隔离，不同的virtual host之间互不影响

## 4.Java客户端快速入门

![](assets\amqp.png)

Spring AMQP:[Spring AMQP](https://spring.io/projects/spring-amqp)





SpringAMQP如何收发消息？
1.引入spring-boot-starter-amqp依赖
2.配置rabbitmq服务端信息
3.利用RabbitTemplate发送消息
4.利用@RabbitListener注解声明要监听的队列，监听消息

```java
//发消息
record User(String name,Integer age){}
@Test
public void sendMessage(){
    User user = new User("张峻豪", 21);
    String queueName = "queue1";
    rabbitTemplate.convertAndSend(queueName,user);
}
```

```java
//收消息
@Slf4j
@Component
public class MqListener {

    record User(String name,Integer age){}

    @RabbitListener(queues = "queue1")
    public void listenSimpleQueue(User user){
        log.info("消费者收到了消息:【{}】",user);
    }
}

```

提示，配置一下mq的消息转换器(使用Jackson来序列化对象)

```java
@Configuration
public class RabbitMQConfig {
    @Bean
    public MessageConverter jsonMessageConverter(){
        return new JacksonJsonMessageConverter();
    }
}

```

## 5.Java客户端work模型

默认情况下，RabbitMQ会将消息依次轮询投递给绑定在队列上的每一个消费者。但这并没有考虑到消费者是否已经处理完消息，可能出现消息堆积。

```java
@Slf4j
@Component
public class MqListener {
    @RabbitListener(queues = "work.queue")
    public void listenWorkQueue1(String msg) throws InterruptedException {
        log.info("消费者1收到了消息:【{}】",msg);
        Thread.sleep(20);
    }
    @RabbitListener(queues = "work.queue")
    public void listenWorkQueue2(String msg) throws InterruptedException {
        log.info("消费者2222收到了消息:【{}】",msg);
        Thread.sleep(200);
    }
}
```

![](assets\默认轮询.png)


因此我们需要修改`application.yml`设置preFetch值为1，确保同一时刻最多投递给消费者1条消息

```
spring:
  application:
    name: consumer

  rabbitmq:
    host: 127.0.0.1
    port: 5672
    username: yiyi
    password: 1234
    virtual-host: test_virtual
    listener:
      simple:
        prefetch: 1
```

![](assets\设置preFetch之后.png)

Work模型的使用：

- 多个消费者绑定到一个队列，可以加快消息处理速度
- 同一条消息只会被一个消费者处理
- 通过设置prefetch来控制消费者预取的消息数量，处理完一条再处理下一条，实现能者多劳