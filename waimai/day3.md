# Day3知识点

## 1.利用AOP来自动填充公共字段

在数据库表中,有一些公共字段create_user、update_user、create_time、update_time

这些公共字段在insert和update的操作中存在大量的冗余代码，此时我们可以利用SpringAop来填充公共字段。

第一步:自定义一个注解

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AutoFill {
    //数据库操作类型：INSERT,UPDATE
    OperationType value();
}
```

第二步:编写一个切面类，设置切入点和通知

```java
@Component
@Aspect
@Slf4j
public class AutoFillAspect {

    //切入点
    @Pointcut("execution(* com.sky.mapper.*.*(..)) && @annotation(com.sky.annotation.AutoFill)")
    public void autoFillPointcut(){}

    //前置通知
    @Before("autoFillPointcut()")
    public void autoFill(JoinPoint joinPoint){
        log.info("开始进行数据填充");
        //1.获取目标方法前面上的@AutoFill注解的value的值
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        AutoFill autoFill = signature.getMethod().getAnnotation(AutoFill.class);
        OperationType value = autoFill.value();
        //2.获取方法参数，即实体对象
        Object[] args = joinPoint.getArgs();
        if (args == null || args.length == 0){return;}
        Object object = args[0];
        //3.先获得要赋值的数据
        Long id = BaseContext.getCurrentId();
        LocalDateTime now = LocalDateTime.now();
        //4.根据注解不同的value值，为对应的属性赋值
        if (value == OperationType.INSERT){
            try {
                Method setCreateTime = object.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_TIME, LocalDateTime.class);
                Method setCreateUser = object.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_USER, Long.class);
                Method setUpdateTime = object.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME, LocalDateTime.class);
                Method setUpdateUser = object.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER, Long.class);
                setCreateTime.invoke(object,now);
                setCreateUser.invoke(object,id);
                setUpdateTime.invoke(object,now);
                setUpdateUser.invoke(object,id);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }else if(value == OperationType.UPDATE){
            try {
                Method setUpdateTime = object.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME, LocalDateTime.class);
                Method setUpdateUser = object.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER, Long.class);
                setUpdateTime.invoke(object,now);
                setUpdateUser.invoke(object,id);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }


    }
}
```

第三步:在需要的mapper方法中添加我们的自定义注解

```java
@Mapper
public interface EmployeeMapper {

    @Select("select * from employee where username = #{username}")
    Employee getByUsername(String username);

    @AutoFill(value = OperationType.INSERT)
    @Insert("insert into employee (name, username, password, phone, sex, id_number, create_time, update_time, create_user, update_user) " +
            "values (#{name},#{username},#{password},#{phone},#{sex},#{idNumber},#{createTime},#{updateTime},#{createUser},#{updateUser})")
    void insert(Employee employee);

    List<Employee> getPage(String name);

    @AutoFill(value = OperationType.UPDATE)
    void update(Employee employee);

    @Select("select * from employee where id = #{id}")
    Employee getById(Long id);
}
```

## 2.主键回显

有时在service层中会操纵多张表，如果是两张表，关系是一对多，在插入第一张表之后，需要获取id,此时就需要主键回显，在mapper层加代码，然后就可以在service层中直接用

基于注解的方式:

```java
/**
* 新增员工数据
*/
//重点就是@Options
@Options(useGeneratedKeys = true, keyProperty = "id")
@Insert("insert into emp(username, name, gender, phone, job, salary, image, entry_date, dept_id, create_time, update_time) " +
        "values (#{username},#{name},#{gender},#{phone},#{job},#{salary},#{image},#{entryDate},#{deptId},#{createTime},#{updateTime})")
void insert(Emp emp);
```

基于xml映射的方式:

```xml
<insert id="insert" useGeneratedKeys="true" keyProperty="id">
    insert into dish(name, category_id, price, image, description, status, create_time, update_time, create_user, update_user)
    values(#{name}, #{categoryId}, #{price}, #{image}, #{description}, #{status}, #{createTime}, #{updateTime}, #{createUser}, #{updateUser})
</insert>
```

配置了之后service层调用了这个mapper,就会将数据库的id值封装到对象中id属性的上

## 3.批量删除@RequestParam

在删除接口时，通常有批量删除的功能，查询参数传递"?ids=1,2,3"

此时如果我们在Controller层想要接受这个参数，需要显示声明@RequesParam 同时参数类型需要List<T>

```java
@DeleteMapping
@ApiOperation("批量删除菜品")
public Result deleteDishByIds(@RequestParam List<Long> ids){
    log.info("批量删除菜品：{}",ids);
    dishService.deleteDishByIds(ids);
    return Result.success();
}
```

