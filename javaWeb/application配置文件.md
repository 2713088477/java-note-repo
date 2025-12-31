# application配置文件

## 1.数据源配置

yml/yaml格式的数据源配置:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/db03
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: 1234
```

配置mybatis大小写转换和输出日志

```yaml
mybatis:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

## 2.事物管理配置

开启事物管理日志

```yaml
#spring事务管理日志
logging: 
  level: 
    org.springframework.jdbc.support.JdbcTransactionManager: debug
```

