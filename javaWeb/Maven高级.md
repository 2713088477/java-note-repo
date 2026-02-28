## 1.分模块设计
### 1.概述
将一个大项目拆分成若干个子模块，方便项目的管理维护、扩展、也方便模块间的相互引用，资源共享。

### 2.如何分类?
1.按照功能模块拆分,比如:公共组件、商品模块、搜索模块、购物车模块、订单模块等。

2.按层拆分，比如:公共组件、实体类、控制层、业务层、数据访问层

3.按功能模块+层拆分

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/62364943/1762325035711-14d36d2a-53ba-4cfe-b9a4-f32f73014b57.png)

### 3.注意事项
分模块设计需要先针对模块功能进行设计，再进行编码。不会先将工程开发完毕，然后进行拆分。

## 2.继承与聚合
### 1.继承
#### 概念:
继承描述的是两个工程间的关系，与java中的继承相似(只能单继承，可以多重继承)，子工程可以继承父工程中的配置信息，常见于依赖关系的继承。

#### 作用:
1.可以简化依赖配置。体现在减少重复依赖的引入。

2.统一管理依赖。体现在对子工程依赖版本的管理

#### 实现；
<parent>...</parent>

#### 创建一个父工程的方式；
1.新建一个maven管理的模块只保留pom.xml文件，打包方式设置为pom

<font style="background-color:#CEF5F7;">知识点:三种常见的打包方式；</font>

<font style="background-color:#CEF5F7;">jar:普通模块打包,springboot项目基本都是jar包(内嵌tomcat运行)</font>

<font style="background-color:#CEF5F7;">war:普通web程序打包，需要部署在外部的tomcat服务器中运行</font>

<font style="background-color:#CEF5F7;">pow:父工程或聚合工程，该模块下不写代码，仅进行依赖管理</font>

2.在子工程的pom.xml文件中，配置继承关系

```xml
<parent>
  <groupId>com.hao</groupId>
  <artifactId>tlias-parent</artifactId>
  <version>1.0-SNAPSHOT</version>
  <relativePath>../tlias-parent/pom.xml</relativePath> <!-- 配置父工程的相对路径 -->
</parent>
```

3.在父工程中配置各个工程共有的依赖(子工程会自动继承父工程的依赖)

```plain
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.4.10</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
```

相关细节；

1.在子工程中，配置了继承关系之后，坐标中的groupId是可以省略的，因为会自动继承父工程的

2.relativePath指定父工程的pom文件的相对位置(如果不指定,将从本地仓库/远程仓库中查找)

3.若父子工程都配置了同一个依赖的不同版本，以子工程的为准

#### 版本锁定
版本锁定就是在父工程中配置各个依赖的版本，方便管理和维护

利用<dependencyManagement>+自定义属性 来统一管理依赖版本

```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

    <!-- 自定义属性 -->
    <lombok.version>1.18.40</lombok.version>
    <spring.boot.starter.version>3.4.10</spring.boot.starter.version>
    <aliyun.sdk.oss.version>3.17.4</aliyun.sdk.oss.version>
    <jaxb.api.version>2.3.1</jaxb.api.version>
    <activation.version>1.1.1</activation.version>
    <jaxb.runtime.version>2.3.3</jaxb.runtime.version>
    <jjwt.version>0.9.1</jjwt.version>
</properties>
<dependencyManagement>
        <dependencies>
            <!--阿里云OSS依赖-->
            <dependency>
                <groupId>com.aliyun.oss</groupId>
                <artifactId>aliyun-sdk-oss</artifactId>
                <version>${aliyun.sdk.oss.version}</version>
            </dependency>
            <dependency>
                <groupId>javax.xml.bind</groupId>
                <artifactId>jaxb-api</artifactId>
                <version>${jaxb.api.version}</version>
            </dependency>
            <dependency>
                <groupId>javax.activation</groupId>
                <artifactId>activation</artifactId>
                <version>${activation.version}</version>
            </dependency>
            <!-- no more than 2.3.3-->
            <dependency>
                <groupId>org.glassfish.jaxb</groupId>
                <artifactId>jaxb-runtime</artifactId>
                <version>${jaxb.runtime.version}</version>
            </dependency>
            <!-- JWT -->
            <dependency>
                <groupId>io.jsonwebtoken</groupId>
                <artifactId>jjwt</artifactId>
                <version>${jjwt.version}</version>
            </dependency>

        </dependencies>
</dependencyManagement>
```

<font style="color:#E4495B;background-color:#FBE4E7;">面试题:<dependencyManagement>与<dependencies>的区别是什么？</font>

<font style="color:#E4495B;background-color:#FBE4E7;"><dependencies>是直接依赖，在父工程配置依赖，子工程会直接继承下来</font>

<font style="color:#E4495B;background-color:#FBE4E7;"><dependencyManagement>是统一管理依赖版本，不会直接依赖，还需要在子工程中引入所需依赖(无需指定版本)</font>

### 2.聚合
#### 概念:
将多个模块组织成一个整体，同时进行项目的构建

#### 聚合工程:
一个不具有业务功能的"空"工程(有且仅有一个pom文件)，打包方式为pom

#### 作用:
快速构建项目(无需根据依赖关系手动构建，直接在聚合工程上构建即可)

#### 实现
在maven中可以通过<modules>设置当前聚合工程所包含的子模块的名称

```xml
<modules>
  <module>../tlias-pojo</module>
  <module>../tlias-utils</module>
  <module>../tlias-web-management</module>
</modules>
```

maven中继承与聚合的联系与区别：

联系：继承与聚合都属于设计型模块，打包方式都为pom,常见两种关系制作到同一个pom文件中

区别:

1.继承用于简化依赖配置、统一管理依赖版本，是在子工程中配置继承关系

2.聚合用于快速构建项目，是在父工程(聚合工程)中配置聚合的模块

