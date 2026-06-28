# Dijkstra算法、分层图最短路

## 1.精炼总结

分层图最短路，又叫扩点最短路



Dijkstra算法：给定一个源点，求解从源点到每个点的最短路径长度。单源最短路径算法。

适用范围:<font color="red">有向图、边的权值没有负数</font>



彻底暴力的Dijkstra算法，不讲、时间复杂度太差、无意义



普通堆实现的Dijlstra算法,<font color="red">最普遍、最常用</font>

算法核心过程:

节点弹出过就忽略

节点没弹出过，让其它没弹出节点距离变小的记录加入堆



反向索引堆实现的Dijkstra算法,<font color="red">最快速、最极致</font>

核心在于掌握<font color="red">反向索引堆</font>

## 题目一：LeetCode模板题

```java
import java.util.ArrayList;
import java.util.Arrays;
import java.util.PriorityQueue;

//测试链接:https://leetcode.cn/problems/network-delay-time/description/
public class Code01_Solution743 {
    public int networkDelayTime(int[][] times, int n, int k) {
        //邻接表建图
        ArrayList<ArrayList<int[]>> edges = new ArrayList<>();
        for(int i=0;i<=n;i++){
            edges.add(new ArrayList<>());
        }
        for (int[] time : times) {
            edges.get(time[0]).add(new int[]{time[1],time[2]});
        }
        int[] distance = new int[n+1];
        boolean[] visit = new boolean[n+1];
        Arrays.fill(distance,Integer.MAX_VALUE);
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a1,a2)->a1[1]-a2[1]);
        minHeap.add(new int[]{k,0});
        while(!minHeap.isEmpty()){
            int[] pop = minHeap.poll();
            if(visit[pop[0]]){
                continue;
            }
            visit[pop[0]] = true;
            distance[pop[0]] = pop[1];
            //System.out.println(String.format("%d 当前节点已经确认,distance=%d",pop[0],pop[1]));
            for(int[] next:edges.get(pop[0])){
                int to = next[0];
                int value = next[1];
                if(!visit[to] && pop[1] + value < distance[to]){
                    minHeap.add(new int[]{to,value+pop[1]});
                }
            }
        }
        int ans = Integer.MIN_VALUE;
        for(int i=1;i<distance.length;i++){
            if(distance[i] == Integer.MAX_VALUE){
                return -1;
            }
            ans = Math.max(ans,distance[i]);
        }
        return ans;
    }
}

```

这是普通堆实现的Dijkstra算法，<font color="red">时间复杂度O(m * log m ),m为边数</font>

### 反向索引堆优化

反向索引堆实现Dijkstra算法，<font color="red">时间复杂度O(m*logn)，n为节点数，m为边数</font>

实现步骤:

> 1.准备好反向索引堆，根据源点到当前点的距离组织小根堆，可以做到如下操作
>
> ​	a.新增记录(x,源点到x的距离)	b.当源点到x的距离更近时，可以进行堆的调整
>
> ​	c.x点一旦弹出，以后忽略x 	  d.弹出栈顶记录(u,源点到u的距离)
>
> 2.把(源点,0)加入反向索引堆，过程开始
>
> 3.反向索引堆弹出(u,源点到u的距离),考察u的每一条边，假设某边去往v,边权为w
>
> ​	1)如果v没有进入过反向索引堆，新增记录(v,源点到u的距离+w)
>
> ​	2)如果v曾经总反向索引堆弹出过，忽略
>
> ​	3)如果v在反向索引堆里，看看源点到v的距离能不能变得更小，如果能，调整堆；不能，忽略
>
> ​	4)处理完u的每一条边，重复步骤3
>
> 4.反向索引堆为空过程结束。反向索引堆里记录了源点到每个节点的最短距离。

代码

```java
    /**
     * 反向索引堆(极致)
     * @param times
     * @param n
     * @param k
     * @return
     */
    public static int networkDelayTime(int[][] times, int n, int k) {
        build(n);
        for(int[] time:times){
            int from = time[0],to = time[1],value = time[2];
            addEdge(from,to,value);
        }
        addOrUpdateOrIgnore(k,0);
        while(!isEmpty()){
            int pollNode = poll();
            for(int pollEdge = head[pollNode];pollEdge!=0;pollEdge = next[pollEdge]){
                addOrUpdateOrIgnore(to[pollEdge],distance[pollNode] + weight[pollEdge]);
            }
        }
        int ans = 0;
        for(int i=1;i<=n;i++){
            if(distance[i] == Integer.MAX_VALUE){
                return -1;
            }
            ans = Math.max(ans,distance[i]);
        }
        return ans;
    }

    public static int MAX_N = 101;
    public static int MAX_M = 6001;

    public static int[] head = new int[MAX_N];
    public static int[] next = new int[MAX_M];
    public static int[] to = new int[MAX_M];
    public static int[] weight = new int[MAX_M];
    public static int edgeId;

    public static int[] minHeap = new int[MAX_N];
    public static int[] where = new int[MAX_N];
    public static int heapSize;

    public static int[] distance = new int[MAX_N];
    public static void build(int n){
        edgeId = 1;
        Arrays.fill(head,1,n+1,0);
        Arrays.fill(where,1,n+1,-1);
        Arrays.fill(distance,1,n+1,Integer.MAX_VALUE);
        heapSize = 0;
    }
    public static void addEdge(int fromNode,int toNode,int value){
        next[edgeId] = head[fromNode];
        to[edgeId] = toNode;
        weight[edgeId] = value;
        head[fromNode] = edgeId++;
    }
    public static void addOrUpdateOrIgnore(int nodeId,int dis){
        if(where[nodeId] == -1){
            heapInsert(nodeId,dis);
        } else if (where[nodeId] >=0) {
            if(distance[nodeId] > dis){
                distance[nodeId] = dis;
                justifyToTop(where[nodeId]);
            }
        }
    }
    public static void heapInsert(int nodeId,int dis){
        int heapIndex = heapSize++;
        where[nodeId] = heapIndex;
        minHeap[heapIndex] = nodeId; //小根堆存放nodeId
        distance[nodeId] = dis;
        justifyToTop(heapIndex);
    }
    public static void justifyToTop(int heapIndex){
        int parent = (heapIndex-1)/2;
        while(distance[minHeap[parent]] > distance[minHeap[heapIndex]]){
            swap(parent,heapIndex);
            heapIndex = parent;
            parent = (heapIndex-1)/2;
        }
    }
    public static void heapify(int heapIndex){
        int left = 2*heapIndex+1;
        while(left<heapSize){
            int best = left+1 < heapSize && distance[minHeap[left]]> distance[minHeap[left+1]] ? left+1:left;
            if(distance[minHeap[best]] > distance[minHeap[heapIndex]]) break;
            swap(heapIndex,best);
            heapIndex = best;
            left = 2*heapIndex+1;
        }
    }
    public static void swap(int heapIndex1,int heapIndex2){
        where[minHeap[heapIndex1]] = heapIndex2;
        where[minHeap[heapIndex2]] = heapIndex1;
        int tmpNode = minHeap[heapIndex1];
        minHeap[heapIndex1] = minHeap[heapIndex2];
        minHeap[heapIndex2] = tmpNode;

    }
    public static boolean isEmpty(){
        return heapSize == 0;
    }
    public static int poll(){
        int pollNode = minHeap[0];
        where[pollNode] = -2;
        swap(0,--heapSize);
        heapify(0);
        return pollNode;
    }
```

## 题目二：最小体力消耗路径

代码:

```java
import java.util.Arrays;
import java.util.PriorityQueue;

//测试链接:https://leetcode.cn/problems/path-with-minimum-effort/description/
public class Code02_Solution1631 {
    //下,左,上，右
    public static int[] direction = new int[]{1,0,-1,0,1};
    public int minimumEffortPath(int[][] heights) {
        int row = heights.length,col = heights[0].length;
        int[][] distance = new int[row][col];
        boolean[][] computed = new boolean[row][col];
        for(int i=0;i<row;i++){
            for(int j=0;j<col;j++){
                distance[i][j] = Integer.MAX_VALUE;
                computed[i][j] = false;
            }
        }
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a,b)->a[2]-b[2]);
        minHeap.add(new int[]{0,0,0});
        while(!minHeap.isEmpty()){
            int[] poll = minHeap.poll();
            int x = poll[0],y = poll[1],value = poll[2];
            if(computed[x][y]) continue;
            computed[x][y] = true;
            distance[x][y] = value;
            if(x == row-1 && y == col-1){
                return value;
            }
            for(int i=0,nx,ny;i<4;i++){
                nx = x + direction[i];
                ny = y + direction[i+1];
                if(nx>=0 && nx<row && ny>=0 && ny<col){
                    int curValue = Math.max(value,Math.abs(heights[x][y]-heights[nx][ny]));
                    if(distance[nx][ny] > curValue){
                        minHeap.add(new int[]{nx,ny,curValue});
                    }
                }
            }
        }
        return -1;
    }
}

```

这道题就是考察dj算法，同时又略有修改，比如在计算距离的时候是这样计算的:`int curValue = Math.max(value,Math.abs(heights[x][y]-heights[nx][ny]));`

然后不需要考察所有点，只要把最右下角的点计算出来了就可以提前返回。

## 题目三：水位上升的泳池中游泳

代码:

```java
import java.util.Arrays;
import java.util.PriorityQueue;

//测试链接:https://leetcode.cn/problems/swim-in-rising-water/description/
public class Code03_Solution778 {
    public static int[] direction = new int[]{1,0,-1,0,1};
    public int swimInWater(int[][] grid) {
        int row = grid.length,col = grid[0].length;
        int[][] distance = new int[row][col];
        for(int[] dis:distance){
            Arrays.fill(dis,Integer.MAX_VALUE);
        }
        boolean[][] exist = new boolean[row][col];
        PriorityQueue<int[]> minHeap = new PriorityQueue<>((a,b)->a[2]-b[2]);
        minHeap.add(new int[]{0,0,grid[0][0]});
        while (!minHeap.isEmpty()){
            int[] poll = minHeap.poll();
            int x = poll[0],y = poll[1],value = poll[2];
            if(exist[x][y]) continue;
            exist[x][y] = true;
            distance[x][y] = value;
            if(x == row-1 && y==col-1){
                return value;
            }
            for(int i=0,nx,ny;i<4;i++){
                nx = x + direction[i];
                ny = y + direction[i+1];
                if(nx<0 || nx>=row || ny<0 || ny>=col || exist[nx][ny]){
                    continue;
                }
                int newDis = Math.max(value,grid[nx][ny]);
                if(newDis < distance[nx][ny]){
                    minHeap.add(new int[]{nx,ny,newDis});
                }
            }

        }
        return -1;
    }
}

```

这道题和题目二差不多，就不过多赘述了。