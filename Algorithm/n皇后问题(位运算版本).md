# N皇后问题

## 1.常规版本

常规版本有两个核心:

1. 每行开始找，确保每一行只存储一个，同时有一个int[] path 来存储每一行的皇后放置的列

2. 利用数学知识来巧妙判断对角线能不能够放置


详情请看代码:

```java
    public int totalNQueens1(int n) {
        int[] path = new int[n];
        return f1(0,path,n);
    }
    public int f1(int curRow,int[] path,int n){
        if(curRow == n){
            return 1;
        }
        int ans = 0;
        for(int i=0;i<n;i++){
            path[curRow]=i;
            if(check(path,curRow,i)){
                ans += f1(curRow+1,path,n);
            }
        }
        return ans;
    }
    private boolean check(int[] path, int curRow, int curCol) {
        for(int i=0;i<curRow;i++){
            if(path[i]==curCol || Math.abs(curRow-i)==Math.abs(curCol-path[i])){
                return false;
            }
        }
        return true;
    }
```

## 2.位运算版本

```java
    //用位运算实现递归版本
    public int totalNQueens2(int n) {
        int limit = (1<<n) -1;
        return f2(limit,0,0,0);
    }
    public int f2(int limit,int col,int left,int right){
        if(col == limit){
            return 1;
        }
        int cadidate = col | left | right;
        cadidate = ((~cadidate) & limit);
        int ans = 0;
        while(cadidate != 0){
            int choice = cadidate & (~cadidate+1);
            cadidate ^= choice;
            ans += f2(limit,col | choice,(left | choice)<<1 ,(right | choice) >>1);
        }
        return ans;
    }
```

这个核心就是，int col 里面有32位，利用每一位去判断当前列之前有没有元素放置，0代表没有元素放置，1代表有元素放置

int left,是从右上角到左下角对角线的判断，依然是0代表可以放，1代表不可放

int right是左上角到右下角对角线的判断，0可放，1不可放

这个代码利用|,很巧妙的把所有不可以放置的位置集中了起来

然后利用(~cadidate) &limit 就将数据限制在了n皇后的问题里面，同时取反代表1可以放，0不可以放

然后传递下去也很巧妙，其中对角线的传递巧妙的运用了位运算的左移和右移




