# Day11知识点

## 1.正确接受日期类的数据

想要在controller正确接受日期类型，需要在上面加一个@DateTimeFormat的注解，并在pattern属性中写好其格式。

```java
@GetMapping("turnoverStatistics")
@ApiOperation("营业额统计")
public Result<TurnoverReportVO> turnoverStatistics(@DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate begin,
                                                   @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate end){
    log.info("营业额统计，开始时间：{}，结束时间：{}", begin, end);
    TurnoverReportVO vo= reportService.getTurnoverStatistics(begin, end);
    return Result.success(vo);
}
```

