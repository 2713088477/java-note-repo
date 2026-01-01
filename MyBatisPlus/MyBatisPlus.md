# MyBatisPlus知识点

## 1.MyBatisPlus的使用步骤

1.引入MybatisPlus的起步依赖

MyBatisPlus的官方提供了starter,其中集成了Mybatis和MybatisPlus的所有功能，并且实现了自动装配的效果。

因此我们可以用MybatisPlus的starter代替Mybatis的starter

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.3.1</version>
</dependency>
```

2.定义Mapper

自定义的mapper继承MybatisPlus提供的BaseMapper接口

```java
public interface UserMapper extends BaseMapp<User>{
    
}
```

体现了Mybatis-plus的一个特性:对mybatis无侵入，mybatis改mp很容易

## 2.常见注解

MybatisPlus通过扫描实体类，并基于反射获取实体类信息作为数据库表信息

```java
public interface UserMapper extends BaseMapp<User>{//继承的时候绑定了实体类
    
}
```

约定：

1. 类名驼峰转下划线作为表名
2. 名为id的字段作为主键
3. 变量名驼峰转下划线作为表的字段名

MybatisPlus比较常用的几个注解:

1. @TableName:用来指定表名
2. @TableId:用来指定表中的主键字段信息
3. @TableField:用来指定表中的普通字段信息

示例:

```java
@TableName("tb_user")
public class User {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    
    @TableField("username")
    private String name;
    
    @TableField("is_marryed")
    private Boolean isMarried;
    
    @TableField("`order`")
    private Integer order;
    
    @TableField(exist = false)
    private String address;
}
```

IdType枚举:

1. AUTO:数据库自增长
2. INPUT:通过set方法自行输入
3. ASSIGN_ID:分配ID,接口identifierGenerator的方法nextId来生成id,默认实现类为DefaultIdentifierGenerator雪花算法

使用@TableFieId的常见场景:

1. 成员变量名和数据库字段名不一致
2. 成员变量以is开头，且是布尔值
3. 成员变量名与数据库关键字冲突
4. 成员变量名不是数据库字段

## 3.MybatisPlus常见配置

```yaml
mybatis-plus:
  type-aliases-package: com.itheima.mp.domain.po  # 别名扫描包
  mapper-locations: classpath*: mapper/**/*Mapper.xml  # Mapper.xml文件地址，默认值
  configuration:
    map-underscore-to-camel-case: true  # 是否开启下划线和驼峰的映射
    cache-enabled: false  # 是否开启二级缓存
  global-config:
    db-config:
      id-type: assign_id  # id为雪花算法生成
      update-strategy: not_null  # 更新策略：只更新非空字段
```

## 4.条件构造器

MybatisPlus支持各种复杂的where条件，可以满足日常开发的所有需求

![件构造](assets\条件构造器.png)

```java
@Test
public void testQueryWrapper(){
    QueryWrapper<User> wrapper = new QueryWrapper<User>()
        .select("id", "username", "info","balance")
        .like("username", "o")
        .ge("balance",1000);
    List<User> users = userMapper.selectList(wrapper);
    users.forEach(System.out::println);
}

@Test
public void testUpdateWrapper1(){
    //1.更新的数据
    User user = new User();
    user.setBalance(10000);
    //2.更新的条件
    UpdateWrapper<User> wrapper = new UpdateWrapper<User>().eq("username", "祁同伟");
    userMapper.update(user, wrapper);

}
@Test
public void testUpdateWrapper2(){
    //1.更新的数据

    //2.更新的条件
    List<Long> ids = List.of(2L, 4L);
    UpdateWrapper<User> wrapper = new UpdateWrapper<User>()
        .setSql("balance = balance -200")
        .in("id", ids);
    userMapper.update(null, wrapper);
}

@Test
public void testLambdaQueryWrapper(){
    LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<User>()
        .select(User::getId,User::getUsername, User::getInfo,User::getBalance)
        .like(User::getUsername, "o")
        .ge(User::getBalance,1000);
    List<User> users = userMapper.selectList(wrapper);
    users.forEach(System.out::println);
}
```

条件构造器的用法:

1. QueryWrapper和LambdaQueryWrapper通常用来构建sql中的where条件部分
2. UpdateWrapper和LambdaUpdateWrapper通常只有在set语句比较特殊才使用
3. 尽量使用LambdaQueryWrapper和LambdaUpdateWrapper，避免硬编码

