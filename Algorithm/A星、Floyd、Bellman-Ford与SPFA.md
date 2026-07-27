# A星、Floyd、Bellman-Ford与SPFA

## 1.精炼总结

>
>
>A*算法

A*算法、指定源点、指定目标点、求源点到达目标点的最短距离

增加了当前点与终点的预估函数

在堆中根据<font color="red">从源点出发到达当前点的距离+当前点到终点的预估距离</font>来进行排序

剩下的所有细节与Dijskra算法完全一致



 <font color="red"> 预估函数要求:当前点与终点的预估距离<=当前点到终点的真实最短距离</font>

预估函数是一种吸引力

1)合适的吸引力可以提升算法的速度，吸引力更强会出现错误

2)保证 预估距离 <= 真实最短距离 的情况下，尽量接近真实最短距离，可以做到功能正确且最快



预估终点距离经常选择:

曼哈顿距离: Math.abs(x1-x2)+Math.abs(y1-y2)

欧式距离: 勾股定理

对角线距离: Math.max(Math.abs(x1-x2),Math.abs(y1-y2))



示例代码:

```java
import java.util.Arrays;
import java.util.PriorityQueue;
import java.util.Random;

public class Code01_AStarAlgorithm {

    public static int[] direction = new int[]{1,0,-1,0,1};
    /**
         * 寻找从开始点到结束点，最短需要途径几个点
         * @param grid    0表示有障碍，1表示可以到达该点
         * @param startX  开始点的x坐标
         * @param startY  开始点的y坐标
         * @param targetX 目标点的x坐标
         * @param targetY 开始点的y坐标
         * @return 如果无法到达返回-1
         */
    public static int minDistance1(int[][] grid,int startX,int startY,int targetX,int targetY){
        if(grid[startX][startY] == 0 || grid[targetX][targetY] == 0){
            return -1;
        }
        int row = grid.length,col = grid[0].length;
        int[][] distance = new int[row][col];
        boolean[][] visit = new boolean[row][col];
        for(int[] dis:distance) Arrays.fill(dis,Integer.MAX_VALUE);
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a,b)->a[2]-b[2]);
        minHeap.add(new int[]{startX,startY,1});
        while(!minHeap.isEmpty()){
            int[] poll = minHeap.poll();
            int x = poll[0],y=poll[1],curCost = poll[2];
            if(visit[x][y]) continue;
            distance[x][y] = curCost;
            visit[x][y] = true;
            if(x == targetX && y == targetY){
                return curCost;
            }
            for(int i=0,nx,ny,nCost;i<4;i++){
                nx = x + direction[i];ny=y+direction[i+1];nCost = curCost+1;
                if(nx <0 || nx>=row || ny<0 || ny>=col || grid[nx][ny]==0) continue;
                if(!visit[nx][ny] && distance[nx][ny] > curCost){
                    minHeap.add(new int[]{nx,ny,nCost});
                    distance[nx][ny] = curCost;
                }
            }
        }
        return -1;
    }


    /**
         * 寻找从开始点到结束点，最短需要途径几个点
         * @param grid    0表示有障碍，1表示可以到达该点
         * @param startX  开始点的x坐标
         * @param startY  开始点的y坐标
         * @param targetX 目标点的x坐标
         * @param targetY 开始点的y坐标
         * @return 如果无法到达返回-1
         */
    public static int minDistance2(int[][] grid,int startX,int startY,int targetX,int targetY){
        if(grid[startX][startY] == 0 || grid[targetX][targetY] == 0){
            return -1;
        }
        int row = grid.length,col = grid[0].length;
        int[][] distance = new int[row][col];
        boolean[][] visit = new boolean[row][col];
        for(int[] dis:distance) Arrays.fill(dis,Integer.MAX_VALUE);
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a,b)->a[2]-b[2]);
        minHeap.add(new int[]{startX,startY,1+f(startX,startY,targetX,targetY)});
        distance[startX][startY] = 1;
        while(!minHeap.isEmpty()){
            int[] poll = minHeap.poll();
            int x = poll[0],y=poll[1];
            if(visit[x][y]) continue;
            visit[x][y] = true;
            if(x == targetX && y == targetY){
                return distance[x][y];
            }
            for(int i=0,nx,ny,nCost;i<4;i++){
                nx = x + direction[i];ny=y+direction[i+1];
                if(nx <0 || nx>=row || ny<0 || ny>=col || grid[nx][ny]==0) continue;
                if(!visit[nx][ny] && distance[nx][ny] > distance[x][y]+1){
                    minHeap.add(new int[]{nx,ny,distance[x][y]+1+f(nx,ny,targetX,targetY)});
                    distance[nx][ny] = distance[x][y]+1;
                }
            }
        }
        return -1;
    }

    public static int f(int x,int y,int targetX,int targetY){
        return Math.abs(x-targetX) + Math.abs(y-targetY);
    }

    public static void main(String[] args){
        int MAX_ROW = 1000,MAX_COL = 1000;
        Random random = new Random();
        int[][] grid = new int[MAX_ROW][MAX_COL];
        for(int i=0;i<MAX_ROW;i++){
            for(int j=0;j<MAX_COL;j++){
                grid[i][j] = random.nextInt(5) ==0 ? 0 :1;
            }
        }
        System.out.println("随机数据生成完毕");
        for(int i=0;i<MAX_ROW;i++){
            for(int j=0;j<MAX_COL;j++){
                System.out.print(grid[i][j]+" ");
            }
            System.out.println();
        }
        int startX = random.nextInt(MAX_ROW);
        int startY = random.nextInt(MAX_COL);
        int targetX = random.nextInt(MAX_ROW);
        int targetY = random.nextInt(MAX_COL);
        System.out.println(String.format("测试开始: startX:%d startY:%d targetX:%d targetY:%d",startX,startY,targetX,targetY));
        long start = System.currentTimeMillis();
        int ans = minDistance1(grid, startX, startY, targetX, targetY);
        long end =  System.currentTimeMillis();
        System.out.println(String.format("dj算法测试结束: 答案:%d 耗时:%d ms",ans,(end-start)));
        start = System.currentTimeMillis();
        ans = minDistance2(grid,startX,startY,targetX,targetY);
        end = System.currentTimeMillis();
        System.out.println(String.format("A*算法测试结束: 答案:%d 耗时:%d ms",ans,(end-start)));
    }


}

```





>
>
>Floyd算法，得到图中<font color="red">任意两点之间的最短距离</font>

时间复杂度O(n^3)，空间复杂度O(n^2),常数时间小，容易实现

适用于任何图，不管有向无向、不管边权正负、但是不能有负环(保证最短路存在)

![](assets\负环.png)

比如上面这个绿色圈起来的就是"负环"，因为A->A,B->B,C->C的距离会无限小



过程简述:

`distance[i][j]`表示i和j之间的最短距离

`distance[i][j]=,min(distance[i][j],distance[i][k]+distance[k][j])`

枚举所有的k即可，实现时一定要最先枚举跳板!



洛谷模板题:

```java
package ZuoVideo65;

import java.io.*;

//测试链接: https://www.luogu.com.cn/problem/P2910
public class Code02_FloydTemplate {
    public static int MAX_N = 101;
    public static int MAX_M = (int)1E4+1;
    public static int[][] distance = new int[MAX_N][MAX_N];
    public static int[] direction = new int[MAX_M];

    public static int n,m;
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF){
            n = (int)in.nval;
            in.nextToken(); m = (int)in.nval;
            for(int i=0;i<m;i++){
                in.nextToken(); direction[i] = (int)in.nval;
            }
            build();
            for(int i=1;i<=n;i++){
                for(int j=1;j<=n;j++){
                    in.nextToken(); distance[i][j]= (int)in.nval;
                }
            }
            floyd();
            int ans = 0;
            for(int i=1;i<=m;i++){
                ans += distance[direction[i-1]][direction[i]] ;
            }
            out.println(ans);
        }
        out.flush();
        out.close();
        br.close();
    }
    public static void build(){
        for(int i=1;i<=n;i++){
            for(int j=1;j<=n;j++){
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
    }
    public static void floyd(){
        for(int step = 1;step<=n;step++){
            for(int i = 1;i<=n;i++){
                for(int j=1;j<=n;j++){
                    if(distance[i][step] != Integer.MAX_VALUE && distance[step][j] != Integer.MAX_VALUE
                    && distance[i][j] > distance[i][step]+distance[step][j]){
                        distance[i][j] = distance[i][step] + distance[step][j];
                    }
                }
            }
        }
    }
}

```



> Bellman-Ford算法，解决可以有负边但是不能有负环(保证最短路存在)的图，单源最短路算法

松弛操作：

假设源点为A，从A到任意点F的最短距离为distance[F]

假设从点P出发某条边，去往点S，边权为W

如果发现，distance[P] + W < distance[S]，也就是通过改变可以让distance[S]变小

那么就说，P出发的这条边对点S进行了松弛操作



Bellman-Ford过程

1.每一轮考察每条边，每条边都尝试进行松弛操作，那么若干点的distance会变小

2.当某一轮发现不再有松弛操作出现时，算法停止



Bellman-Ford算法时间复杂度

假设点的数量为N，边的数量为M，每一轮时间复杂度O(M)

最短路存在的情况下，因为1次松弛操作会使1个点的最短路的边数+1

而从源点出发到任何点 的最短路最多走过全部的n个点，所以松弛的轮数必然 <= n-1

所以Bellman-Ford算法时间复杂度O(M*N)



重要推广：判断从某个点出发能不能到达负环

上面已经说了，如果从A出发存在最短路（没有负环），那么松弛的轮数必然 <= n-1

而如果从A点出发到达一个负环，那么松弛操作显然会无休止地进行下去

所以，如果发现从A点出发，在第n轮时松弛操作依然存在，说明从A点出发能够到达一个负环



类模板题:

```java
package ZuoVideo65;

import java.util.Arrays;

/**
 * 这道题不是严格地bellman-ford,因为原始的算法每一轮是实时看distance去算的
 * 而这道题不是，这道题是有自己的一个题意，需要看上一轮的distance
 */
//测试链接: https://leetcode.cn/problems/cheapest-flights-within-k-stops/description/
public class Code03_Bellman_Ford {
    public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        int[] distance = new int[n];
        Arrays.fill(distance,Integer.MAX_VALUE);
        distance[src] = 0;
        //这里注意循环k轮
        for(int i=0;i<=k;i++){
            int[] nextDistance = Arrays.copyOf(distance, n);
            for(int[] flight:flights){
                int from = flight[0],to = flight[1],value = flight[2];
                if( distance[from] != Integer.MAX_VALUE &&  nextDistance[to] > distance[from] + value){
                    nextDistance[to] = distance[from] + value;
                }
            }
            distance = nextDistance;
        }
        return distance[dst] == Integer.MAX_VALUE ? -1: distance[dst];
    }
}

```

