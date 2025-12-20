# Day7知识点

## 1.Redis通配符

在删除Redis的数据时，这个key是不能有通配符的

```java
@DeleteMapping
@ApiOperation("批量删除菜品")
public Result deleteDishByIds(@RequestParam List<Long> ids){
    log.info("批量删除菜品：{}",ids);
    dishService.deleteDishByIds(ids);
    //清理Redis缓存
    Set dishes = redisTemplate.keys("dish_*"); //获取时可以有通配符
    redisTemplate.delete(dishes); //删除时不能有通配符
    return Result.success();
}
```

## 2.Spring Cache

Spring Cache是一个框架，实现了基于注解的缓存功能，只需要简单地加一个注解，就能实现缓存功能。

Spring Cache提供了一层抽象，底层可以切换不同的缓存实现，例如:

1. EHCache
2. Caffeine
3. Redis

Maven坐标:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
    <version>2.7.3</version>
</dependency>
```

常用注解:

| 注解           | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| @EnableCaching | 开启缓存注解功能，通常加在启动类上                           |
| @Cacheable     | 在方法执行前先查询缓存中是否有数据，如果有数据，则直接返回缓存数据;如果没有缓存数据，调用方法并将方法返回值放到缓存中 |
| @CachePut      | 将方法的返回值放到缓存中                                     |
| @CacheEvict    | 将一条或多条数据从缓存中删除                                 |

## 3.spEL

Spring Expression Language,可以在Spring注解的属性值中使用，用来动态引用方法参数,Bean,系统属性等

```java
@CachePut(cacheNames = "userCache",key = "#user.id") //key的生成 userCache::user.id
//@CachePut(cacheNames = "userCache",key = "#result.id")  //对象导航
//@CachePut(cacheNames = "userCache",key = "#p0.id") //参数导航 p0是第一个参数
//@CachePut(cacheNames = "userCache",key = "#a0.id")
//@CachePut(cacheNames = "userCache",key = "#root.args[0].id")
@PostMapping
public User save(@RequestBody User user){
    userMapper.insert(user);
    return user;
}
```

注意:

在Redis中可以有树形结构的key,如果"a：b：c"就是a->b->c这样一个树形结构的key

所以上面代码的key的结构是这样的

![edis树形结构ke](.\assets\Redis树形结构key.png)

调试代码:

```java
@RestController
@RequestMapping("/user")
@Slf4j
public class UserController {

    @Autowired
    private UserMapper userMapper;

    @CachePut(cacheNames = "userCache",key = "#user.id") //key的生成 userCache::user.id
    //@CachePut(cacheNames = "userCache",key = "#result.id")  //对象导航
    //@CachePut(cacheNames = "userCache",key = "#p0.id") //参数导航 p0是第一个参数
    //@CachePut(cacheNames = "userCache",key = "#a0.id")
    //@CachePut(cacheNames = "userCache",key = "#root.args[0].id")
    @PostMapping
    public User save(@RequestBody User user){
        userMapper.insert(user);
        return user;
    }

    @CacheEvict(cacheNames = "userCache",key = "#id")
    @DeleteMapping
    public void deleteById(Long id){
        userMapper.deleteById(id);
    }

    @CacheEvict(cacheNames = "userCache",allEntries = true) //删除userCache中所有键值对
	@DeleteMapping("/delAll")
    public void deleteAll(){
        userMapper.deleteAll();
    }

    @Cacheable(cacheNames = "userCache",key = "#id")
    @GetMapping
    public User getById(Long id){
        User user = userMapper.getById(id);
        return user;
    }

}
```

## 4.数据库表中冗余字段

在购物车这个表中，需不需要关联对应物品的名称和图片，需要有以下衡量:

1.好处肯定是提升了查询效率，单表的查询肯定比多表的查询快

2.坏处就是浪费了空间，其次就是这些数据如果经常容易变，维护也是很高的成本

