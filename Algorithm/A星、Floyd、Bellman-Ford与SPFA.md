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



>Bellman-Ford 与 SPFA

Bellman-Ford + SPFA优化(Shortest Path Faster Algorithm)

很轻易就能发现，每一轮考察所有的边看看能否做松弛操作是不必要的

因为只有上一次被某条边松弛过的节点，所连接的边，才有可能需求下一次的松弛操作

所以用队列来维护"这一轮哪些节点的distance变小了"

下一轮只需要对这些点的所有边，考察有没有松弛操作即可



SPFA只优化了常数时间，在大多数情况下跑得很快，但时间复杂度为O(n*m)

看复杂度就知道只适用于小图，根据数据量谨慎使用，在没有负权边时要使用Dijkstra算法



Bellman-Ford+SPFA优化的用途

1) 适用于小图

2) 解决有负边(没有负环)的图的单源最短路径问题

3) 可以判断从某个点出发是否能遇到负环，<font color="red">如果想判断整张有向图有没有负环，需要设置虚拟源点</font>

4) 并行计算时会有很大优势，因为每一轮多点判断松弛操作是相互独立的，可以交给多线程处理



注意:

SPFA的另一个重要的用途是解决"费用流"问题，当然也可以被Primal-Dual原始对偶算法替代





洛谷模板题:

```java
import java.io.*;
import java.util.Arrays;

//测试链接: https://www.luogu.com.cn/problem/P3385

/**
 * Bellman_Ford + SPFA
 * 判断是否存在负环
 */
public class Code04_SPFA {
    public static int MAX_N = (int)2E3+1,MAX_M = (int)6E3;
    //链式前向星建图
    public static int[] head = new int[MAX_N];
    public static int[] next = new int[MAX_M];
    public static int[] to = new int[MAX_M];
    public static int[] value = new int[MAX_M];
    public static int edgeId = 1;

    //distance表
    public static int[] distance = new int[MAX_N];

    //SPFA优化所需要的队列
    public static int[] queue = new int[MAX_N*MAX_N];
    public static int l,r;
    //SPFA优化所需要的判断是否在队列中的数组
    public static boolean[] entry = new boolean[MAX_N];

    //判断负环所特需要的count数组
    public static int[] updateCount = new int[MAX_N];

    public static int n,m;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while(in.nextToken() != StreamTokenizer.TT_EOF){
            int t = (int)in.nval;
            while((t--)>0){
                in.nextToken(); n = (int) in.nval;
                in.nextToken(); m = (int) in.nval;
                build(n);
                for(int i=0,fromNode,toNode,weight;i<m;i++){
                    in.nextToken(); fromNode = (int) in.nval;
                    in.nextToken(); toNode = (int) in.nval;
                    in.nextToken(); weight = (int) in.nval;
                    if(weight>=0){
                        addEdge(fromNode,toNode,weight);
                        addEdge(toNode,fromNode,weight);
                    }else{
                        addEdge(fromNode,toNode,weight);
                    }
                }
                out.println(spfa()?"YES":"NO");
            }

        }
        out.flush();
        out.close();
        br.close();
    }
    //初始化
    public static void build(int n){
        edgeId = 1;
        Arrays.fill(head,1,n+1,0);
        Arrays.fill(distance,1,n+1,Integer.MAX_VALUE);
        l=r=0;
        Arrays.fill(entry,1,n+1,false);
        Arrays.fill(updateCount,1,n+1,0);
    }
    public static void addEdge(int fromNode,int toNode,int weight){
        next[edgeId] = head[fromNode];
        to[edgeId] = toNode;
        value[edgeId] = weight;
        head[fromNode] = edgeId++;
    }
    public static boolean spfa(){
        distance[1] = 0;
        entry[1] = true;
        queue[r++] = 1;
        while(l<r){
            int pollNode = queue[l++];
            entry[pollNode] = false;
            for(int edge = head[pollNode];edge!=0;edge = next[edge]){
                int toNode =to[edge],weight = value[edge];
                if(distance[pollNode] + weight < distance[toNode]){
                    if(!entry[toNode]){
                        if(++updateCount[toNode] >= n ){
                            return true;
                        }
                        queue[r++] =toNode;
                        entry[toNode] = true;
                    }
                    distance[toNode] = distance[pollNode] + weight;
                }

            }
        }
        return false;
    }
}

```

