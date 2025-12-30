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

