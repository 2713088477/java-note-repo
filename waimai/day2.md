# Day2知识点

## 1.对象属性拷贝

当我们想要实现对象与对象之间相同属性的拷贝时，

可以用Spring框架提供的**BeanUtils.copyProperties(源对象，目标对象)**

注意:源对象和目标对象属性名必须一样

```
BeanUtils.copyProperties(employeeDTO,employee);
```

## 2.Interceptor拦截器小细节

```java
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    //判断当前拦截到的是Controller的方法还是其他资源
    if (!(handler instanceof HandlerMethod)) {
        //当前拦截到的不是动态方法，直接放行
        return true;
    }

    //1、从请求头中获取令牌
    String token = request.getHeader(jwtProperties.getAdminTokenName());

    //2、校验令牌
    try {
        log.info("jwt校验:{}", token);
        Claims claims = JwtUtil.parseJWT(jwtProperties.getAdminSecretKey(), token);
        Long empId = Long.valueOf(claims.get(JwtClaimsConstant.EMP_ID).toString());
        log.info("当前员工id：", empId);
        //3、通过，放行
        return true;
    } catch (Exception ex) {
        //4、不通过，响应401状态码
        response.setStatus(401);
        return false;
    }
}
```

## 3.ThreadLocal

ThreadLocal是Thread的一个局部变量，为Thread线程提供一个存储空间

特点:ThreadLocal为每个线程提供单独一份存储空间，具有线程隔离的效果，只有在线程内部才能访问到对应的值

提供的方法：

```java
public void set(T value)  //设置当前线程的线程局部变量的值
public T get()            //返回当前线程所对应的线程局部变量的值
public void remove()      //移除当前线程的线程局部变量
```

注意:客户端发送的每次请求，后端的Tomcat服务器都会分配一个单独的线程来处理请求

比如在修改数据的时候往往要记录修改人，可以在登录的时候将登录的id存储在ThreadLocal，然后修改的时候直接get

## 4.返回日期类型的处理

```java
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    //@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
```

在这两个数据封装时，加了@JsonFormat之后和不加的对比如下:

![ateCompar](.\assets\dateCompare.png)

由此可见这个注解还是很必须的

还有一种方法就不用在每个属性上面加这个注解了

方式二:在WebConfiguration中扩展Spring MVC的消息转换器，统一对日期类型进行格式化处理

```java
/**
 * 配置类，注册web层相关组件
 */
@Configuration
@Slf4j
public class WebMvcConfiguration extends WebMvcConfigurationSupport {
    /**
     * 扩展Spring MVC框架的消息转换器
     * @param converters
     */
    @Override
    protected void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        log.info("扩展消息转换器...");
        //创建一个消息转换器对象
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        //设置对象转换器，底层使用Jackson将Java对象转为json
        converter.setObjectMapper(new JacksonObjectMapper());
        //将上面的消息转换器对象追加到mvc框架的转换器集合中
        converters.add(0,converter);
    }
}
```

```java
/**
 * 对象映射器:基于jackson将Java对象转为json，或者将json转为Java对象
 * 将JSON解析为Java对象的过程称为 [从JSON反序列化Java对象]
 * 从Java对象生成JSON的过程称为 [序列化Java对象到JSON]
 */
public class JacksonObjectMapper extends ObjectMapper {

    public static final String DEFAULT_DATE_FORMAT = "yyyy-MM-dd";
    //public static final String DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public static final String DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm";
    public static final String DEFAULT_TIME_FORMAT = "HH:mm:ss";

    public JacksonObjectMapper() {
        super();
        //收到未知属性时不报异常
        this.configure(FAIL_ON_UNKNOWN_PROPERTIES, false);

        //反序列化时，属性不存在的兼容处理
        this.getDeserializationConfig().withoutFeatures(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);

        SimpleModule simpleModule = new SimpleModule()
                .addDeserializer(LocalDateTime.class, new LocalDateTimeDeserializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_TIME_FORMAT)))
                .addDeserializer(LocalDate.class, new LocalDateDeserializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_FORMAT)))
                .addDeserializer(LocalTime.class, new LocalTimeDeserializer(DateTimeFormatter.ofPattern(DEFAULT_TIME_FORMAT)))
                .addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_TIME_FORMAT)))
                .addSerializer(LocalDate.class, new LocalDateSerializer(DateTimeFormatter.ofPattern(DEFAULT_DATE_FORMAT)))
                .addSerializer(LocalTime.class, new LocalTimeSerializer(DateTimeFormatter.ofPattern(DEFAULT_TIME_FORMAT)));

        //注册功能模块 例如，可以添加自定义序列化器和反序列化器
        this.registerModule(simpleModule);
    }
}
```

## 5.开发小技巧

在开发中经常会对数据库就行修改的业务，此时我们在写mapper层的时候，只需要基于动态sql写一个全面的update语句，以后在service层需要修改的时候，都可以调用这个mapper，大大提高复用性。

```xml
<update id="update">
    update employee
    <set>
    <if test="name != null and name.trim()!=''">name = #{name}</if>
    <if test="username != null and username.trim()!=''">,username = #{username}</if>
    <if test="password != null and password.trim()!=''">,password = #{password}</if>
    <if test="phone != null and phone.trim()!=''">,phone = #{phone}</if>
    <if test="sex != null and sex.trim()!=''">,sex = #{sex}</if>
    <if test="idNumber != null and idNumber.trim()!=''">,id_number = #{idNumber}</if>
    <if test="status != null">,status = #{status}</if>
    <if test="updateTime != null">,update_time = #{updateTime}</if>
    <if test="updateUser != null">,update_user = #{updateUser}</if>
    </set>
    where id = #{id}
</update>
```

