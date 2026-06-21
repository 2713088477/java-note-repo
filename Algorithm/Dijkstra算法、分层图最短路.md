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

