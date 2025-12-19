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

