# Day12知识点

## 1.Apache POI

Apache POI是一个处理Miscrosoft Office各种文件格式的开源项目。简单来说，我们可以使用POI在Java程序中对Miscrosoft Office各种文件进行读写操作。

一般情况下，POI都是用于操作Excel文件。

Apache POI的maven坐标:

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>3.16</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.16</version>
</dependency>
```

## 2.入门案列

```java
@Test
public void testWrite() throws Exception {
    //在内存中创建一个excel文件
    SXSSFWorkbook excle = new SXSSFWorkbook();
    //创建一个sheet页
    SXSSFSheet sheet = excle.createSheet("南充人物");
    //创建第一行
    SXSSFRow rowFirst = sheet.createRow(0);
    rowFirst.createCell(0).setCellValue("序号");
    rowFirst.createCell(1).setCellValue("人物名称");
    rowFirst.createCell(2).setCellValue("人物简介");
    for(int i=1;i<=100;i++){
        SXSSFRow row = sheet.createRow(i);
        row.createCell(0).setCellValue(i);
        row.createCell(1).setCellValue("南充坤哥");
        row.createCell(2).setCellValue("谈古仔~");
    }
    excle.write(new FileOutputStream("C:/Users/Coder_Zhang/Desktop/南充人物.xlsx"));
    excle.close();
}
```

```java
@Test
public void testRead() throws Exception {
    FileInputStream fileInputStream = new FileInputStream("C:/Users/Coder_Zhang/Desktop/南充人物.xlsx");
    XSSFWorkbook excel = new XSSFWorkbook(fileInputStream);
    XSSFSheet sheet = excel.getSheetAt(0);

    int lastRowNum = sheet.getLastRowNum();
    for(int i=0;i<=lastRowNum;i++){
        XSSFRow row = sheet.getRow(i);
        String s1 = row.getCell(1).getStringCellValue();
        String s2 = row.getCell(2).getStringCellValue();
        System.out.println(s1+" "+s2);
    }
    excel.close();
    fileInputStream.close();

}
```

