# ACM风格的输入和输出

## 1.高效的IO流

```java
public class Code01_Main {
    public static void main(String[] args) throws IOException {
        FileReader input = new FileReader("F:\\code\\Ideal\\AlgorithmCode\\Code\\src\\main\\java\\ZuoVideo19\\input.txt");
        FileWriter output = new FileWriter("F:\\code\\Ideal\\AlgorithmCode\\Code\\src\\main\\java\\ZuoVideo19\\output.txt");
//        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        BufferedReader br = new BufferedReader(input);
        PrintWriter out = new PrintWriter(output);
        StreamTokenizer in = new StreamTokenizer(br);
        while(in.nextToken() != StreamTokenizer.TT_EOF){
            double v = in.nval;
            out.println(v);
        }
        out.flush();
        out.close();
        br.close();
    }
}
```

BufferedReader会有**缓存的空间**,对比Scanner会**减少IO的操作**

StreamTokenizer会自动帮我们规避掉**空格和换行**,让我们输入处理得更加高效

PrintWriter也有**缓存空间**，同样减少了**IO操作**

## 2.按行读取

按行读取就不用StreamTokenizer了，我们自己读取一行然后用字符串**split方法**分割

```java
public class Code02_Main {
    public static String line;
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while((line= br.readLine()) != null){
            String[] split = line.split(" ");
            int sum = 0;
            for (String s : split) {
                sum += Integer.valueOf(s);
            }
            out.println(sum);
        }
        out.flush();
        out.close();
        br.close();
    }
}
```

## 3.全局静态空间

在做算法题时，经常用到数组，我们可以声明成全局静态，这样就不用每次测试的时候频繁的创建和销毁空间了。




