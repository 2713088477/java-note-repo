## 1.什么是自动配置?
将类交给IOC容器管理，需要用的时候直接@Autowired注入

## 2.如何实现自动配置
### 方法一:Component + ComponentScan
Component声明在需要交给IOC容器管理的类上

ComponentScan默认是在启动类中声明了的，默认是启动类所在包及其子包

评价:太过繁琐

### 方法二:@Import直接导入class字节码对象(普通类,配置类,ImportSelector的实现类)
```java
@Configuration
public class HeaderConfig {

    @Bean
    public HeaderParser headerParser(){
        return new HeaderParser();
    }

    @Bean
    public HeaderGenerator headerGenerator(){
        return new HeaderGenerator();
    }
}
```

```java
public class MyImportSelector implements ImportSelector {
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{"com.example.HeaderConfig"}; //声明全类名
    }
}
```

```java
//自动配置方式二:import
@Import(TokenParser.class)

@Import(HeaderConfig.class)

@Import(MyImportSelector.class)
@EnableHeaderConfig //这个注解封装了@Import,便于开发者使用
```

## 3.源码跟踪
@SpringBootApplication启动类的跟踪

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited

@SpringBootConfiguration //启动类也是配置类
@EnableAutoConfiguration //这个注解里面包含了@Import注解
@ComponentScan(excludeFilters = { @Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
                                  @Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
public @interface SpringBootApplication{...}
```

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import(AutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration{...}
```

因为@EnableAutoConfiguration里面封装了@Import这个注解，加载了一个ImportSelector的实现类的字节码对象,所以我们需要关注的是这个类是怎么返回需要自动配置的对象的?

```java
public class AutoConfigurationImportSelector implements DeferredImportSelector, BeanClassLoaderAware,
ResourceLoaderAware, BeanFactoryAware, EnvironmentAware, Ordered {
    ...
	@Override
	public String[] selectImports(AnnotationMetadata annotationMetadata) {
		if (!isEnabled(annotationMetadata)) {
			return NO_IMPORTS;
		}
		AutoConfigurationEntry autoConfigurationEntry = getAutoConfigurationEntry(annotationMetadata);
		return StringUtils.toStringArray(autoConfigurationEntry.getConfigurations());
	}
    ...

    
}
```

```java
protected AutoConfigurationEntry getAutoConfigurationEntry(AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)) {
        return EMPTY_ENTRY;
    }
    AnnotationAttributes attributes = getAttributes(annotationMetadata);
    //重点在getCandidateConfigurations这个方法上
    List<String> configurations = getCandidateConfigurations(annotationMetadata, attributes);
    configurations = removeDuplicates(configurations);
    //exlusions是排除哪些
    Set<String> exclusions = getExclusions(annotationMetadata, attributes);
    checkExcludedClasses(configurations, exclusions);
    configurations.removeAll(exclusions);
    configurations = getConfigurationClassFilter().filter(configurations);
    fireAutoConfigurationImportEvents(configurations, exclusions);
    return new AutoConfigurationEntry(configurations, exclusions);
}
```

```java
protected List<String> getCandidateConfigurations(AnnotationMetadata metadata, AnnotationAttributes attributes) {
    List<String> configurations = ImportCandidates.load(AutoConfiguration.class, getBeanClassLoader())
    .getCandidates();
    Assert.notEmpty(configurations,
                    "No auto configuration classes found in "
                    + "META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports. If you "
                    + "are using a custom packaging, make sure that file is correct.");
    return configurations;
}
```

找到这个文件"META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports"

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/62364943/1762262281239-0f8ee480-40bf-4406-8571-beec696bc086.png)

再接下来可以看这个自动配置类，会发现里面基本上都是@Configuration+@Bean

## 4.@Conditional父注解及其派生注解
作用；按照一定条件进行判断，条件成立之后才会注册对应的bean对象到Spring IOC容器中

位置:

1.类上：针对这个类中所有方法声明的bean

2.方法上：针对当前这个方法声明的bean

常见派生注解:

```java
//1.判断环境中是否有对应的字节码文件，有的话才注册
@ConditionalOnClass(name ="io.jsonwebtoken.Jwts")

//2.判断环境中是否有对应的bean,没有才注册
@ConditionalOnMissingBean

//3.判断配置文件中是否有对应的属性,有才注册
@ConditionalOnProperty(name = "myname",havingValue = "yiyishenghui")
```

## 5.自己定义自动配置类的核心步骤
1.定义自动配置类 @Configuration + @Bean + @Conditional

2.将自动配置类配置在 

"META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports"文件中

## 6.自定义starter
我们自己定义starter,利用依赖传递和自动配置知识，可以直接在项目中直接注入Bean，以下是步骤:

1.创建一个starter模块，在这个模块的pom.xml文件中引入我们需要自动配置的模块

2.再创建一个AutoConfiguration模块，在这个模块中定义好需要注册为Bean的类，然后再注册一个AutoConfiguration类导入

```java
@EnableConfigurationProperties(AliyunOSSProperties.class)
@Configuration
public class AliyunOSSAutoConfiguration {

    @Bean
    @ConditionalOnMissingBean
    public AliyunOSSOperator aliyunOSSOperator(AliyunOSSProperties aliyunOSSProperties ) {
        return new AliyunOSSOperator(aliyunOSSProperties);
    }
}
```

```java
@ConfigurationProperties(prefix = "aliyun.oss")
public class AliyunOSSProperties{
    ...
}
```

细节知识:在上面这个代码块中，参数也是需要显示自动注册为Bean的,因为这个参数中声明了需要使用配置文件中的信息，所以需要在AutoConfiguration中加上@EnableConfigurationProperties(AliyunOSSProperties.class)注册为 Bean 

3.在resources文件中引入全类名，需要和SpringBoot自动注册的文件同名

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/62364943/1762324651240-51878189-bd34-4aa6-99cc-fec9851d8abb.png)

