# Day1知识点

##  1.实体类细分

| 名称   | 说明                                         |
| ------ | -------------------------------------------- |
| POJO   | 普通Java对象，只有属性和对应的getter和setter |
| Entity | 实体，通常和数据库中的表对应                 |
| DTO    | 数据传输对象，通常用于程序中各层之间传递数据 |
| VO     | 数据视图，为前端展示数据提供的对象           |

## 2.MD5对密码加密

MD5的核心特性:

1.输入任意长度，输出固定长度

无论是空字符串、一句话、还是一整部小说,MD5都会将其转换为一个128位的二进制摘要，通常以32位的十六进制字符串表示。

2.单向不可逆

只能从原始数据计算出哈希值，无法还原

3.雪崩效应

哪怕只改动一个字符，输出的MD5的值也会发生巨大变化

4.使用md5加密

```java
//spring框架提供的加密方法
String password = "123456"
password = DigestUtils.md5DigestAsHex(password.getBytes());
```

## 3.Swagger

Swagger是一套用于设计、构建、文档化和使用RESTful API的开源工具集。Swagger帮助开发者更轻松地搭建、测试和维护API。

Knife4j 是为Java MVC框架集成Swagger生成Api文档的增强解决方案。

使用Swagger步骤:

1.引入依赖

```xml
<dependency>
  <groupId>com.github.xiaoymin</groupId>
  <artifactId>knife4j-spring-boot-starter</artifactId>
  <version>3.0.2</version>
</dependency>
```

2.在配置类加入Knife4j（extends WebMvcConfigurationSupport）

```java
/**
 * 通过knife4j生成接口文档
 * @return
 */
@Bean
public Docket docket() {
    log.info("准备生成接口文档...");
    ApiInfo apiInfo = new ApiInfoBuilder()
    .title("苍穹外卖项目接口文档")
    .version("2.0")
    .description("苍穹外卖项目接口文档")
    .build();
    Docket docket = new Docket(DocumentationType.SWAGGER_2)
    .apiInfo(apiInfo)
    .select()
    .apis(RequestHandlerSelectors.basePackage("com.sky.controller"))
    .paths(PathSelectors.any())
    .build();
    return docket;
}
```

3.设置静态资源映射

```java
/**
 * 设置静态资源映射
 * @param registry
 */
protected void addResourceHandlers(ResourceHandlerRegistry registry) {
    log.info("开始进行静态资源映射...");
    registry.addResourceHandler("/doc.html").addResourceLocations("classpath:/META-INF/resources/");
    registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
}
```

4.常用注解

| 注解              | 说明                                                   |
| ----------------- | ------------------------------------------------------ |
| @Api              | 用在类上，例如Controller，表示对类的说明               |
| @ApiModel         | 用在类上，例如entity、DTO、VO                          |
| @ApiModelProperty | 用在属性上，描述属性信息                               |
| @ApiOperation     | 用在方法上，例如Controller的方法，说明方法的用途，作用 |

## 4.构建器模式

效果展示

```java
@ApiOperation("员工登录")
@PostMapping("/login")
public Result<EmployeeLoginVO> login(@RequestBody EmployeeLoginDTO employeeLoginDTO) {
    log.info("员工登录：{}", employeeLoginDTO);

    Employee employee = employeeService.login(employeeLoginDTO);

    //登录成功后，生成jwt令牌
    Map<String, Object> claims = new HashMap<>();
    claims.put(JwtClaimsConstant.EMP_ID, employee.getId());
    String token = JwtUtil.createJWT(
        jwtProperties.getAdminSecretKey(),
        jwtProperties.getAdminTtl(),
        claims);

    EmployeeLoginVO employeeLoginVO = EmployeeLoginVO.builder()  //重点
    .id(employee.getId())
    .userName(employee.getUsername())
    .name(employee.getName())
    .token(token)
    .build();

    return Result.success(employeeLoginVO);
}
```

只需要在类上加一个@Builder就可以完成以上功能

```java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ApiModel(description = "员工登录返回的数据格式")
public class EmployeeLoginVO implements Serializable {

    @ApiModelProperty("主键值")
    private Long id;

    @ApiModelProperty("用户名")
    private String userName;

    @ApiModelProperty("姓名")
    private String name;

    @ApiModelProperty("jwt令牌")
    private String token;

}
```

这个注解的作用大概是这样的(通义AI生成)

基本代码

```java
import lombok.Builder;
import lombok.ToString;

@Builder
@ToString
public class Person {
    private String name;
    private int age;
    private String email;
}
```

底层实现的代码

```java
public class Person {
    private String name;
    private int age;
    private String email;

    private Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    public static PersonBuilder builder() {
        return new PersonBuilder();
    }

    public static class PersonBuilder {
        private String name;
        private int age;
        private String email;

        public PersonBuilder name(String name) { this.name = name; return this; }
        public PersonBuilder age(int age) { this.age = age; return this; }
        public PersonBuilder email(String email) { this.email = email; return this; }

        public Person build() {
            return new Person(name, age, email);
        }
    }
}
```

