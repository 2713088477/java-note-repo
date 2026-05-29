# JUC重要知识

## 1.Sleep

Sleep方法可以当当前的线程休眠，CPU调度器会让出当前资源

这个方法有一个很常用的场景就是，需要一直运行的服务器，比如Tomcat上

```java
public static void myTomcat(){
    Thread thread = new Thread(()->{
        while(true){
            //如果只写死循环,cpu资源会飙高，所以需要配合Thread.slepp
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                //被中断就会抛异常，同时会把中断的标志清空，相当于没有被中断
                throw new RuntimeException(e);
            }
        }
    });
    thread.start();

}
```

## 2.Interupt

```java
import java.util.concurrent.TimeUnit;

public class InterruptDemo {
    public static void main(String[] args)  {
        Thread thread = new Thread(()->{
            while (true){
                try {
                    TimeUnit.SECONDS.sleep(1);
                } catch (InterruptedException e) {
                    //出现打断异常，这个会把打断的标记清楚
                    System.out.println(Thread.currentThread().isInterrupted());
                    e.printStackTrace();
                    Thread.currentThread().interrupt();

                }
                if(Thread.currentThread().isInterrupted()){ //类名调用的isInterrupt会清除打断标记 -> 撤销打断
                    break;
                }
                System.out.println(Thread.currentThread().getName() + "正在输出");

            }
        });
        thread.start();
        //通知这个线程需要中断，但是不会立即中断
        thread.interrupt();
        System.out.println(thread.isInterrupted());//true,已经被打断了    由实列调用的isInterrupt不会清除打断标记 -> 不撤销打断


    }
}
```

## 3.join方法

```java
import java.util.concurrent.TimeUnit;

public class JoinDemo {
    static int value = 0;
    public static void main(String[] args) {
        Thread thread = new Thread(()->{
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            value = 10;
            System.out.println("子线程业务方法结束");

        },"joinThread");
        thread.start();
        try {
            thread.join(); //等待这个线程结束，这样调用相当于是同步,可以传入等待时间，这样调用就是主线程等待子线程

        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println(value);
    }

}
```

## 4.isAlive判断线程是否存活

```java
import java.util.concurrent.TimeUnit;

public class JoinDemo {
    static int value = 0;
    public static void main(String[] args) {
        Thread thread = new Thread(()->{
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            value = 10;
            System.out.println("子线程业务方法结束");

        },"joinThread");
        thread.start();
        System.out.println("子线程存活状态:"+thread.isAlive());
        try {
            thread.join(); //等待这个线程结束，这样调用相当于是同步,可以传入等待时间，这样调用就是主线程等待子线程

        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("子线程存活状态:"+thread.isAlive());
        System.out.println(value);
    }

}
```

## 5.守护线程

线程一般有两种，一种是普通线程，一种是守护线程。

进程需要等到所有的普通线程结束之后才会关闭，那守护线程怎么办呢？

如果设置了某个子线程为守护线程的话，当普通线程关闭的时候，子线程会立马关闭。

```java
public class DaemonDemo {
    public static void main(String[] args) {
        Thread thread = new Thread(()->{
            for(int i=0;i<100;i++){
                System.out.println("子线程输出"+i);
            }
        });
        thread.setDaemon(true);//需要在start方法之前加上这句
        thread.start();
        System.out.println("主线程结束"); //只会输出这一句
    }
}

```

应用：

> 1.垃圾回收器线程属于守护进程
>
> 2.tomcat用来接收外部的请求的线程就是守护线程

## 6.线程状态

| 标准状态      | 含义                                      | 进入原因                                                     |
| :------------ | :---------------------------------------- | :----------------------------------------------------------- |
| NEW           | 线程已创建，但还没调用 `start()`          | `new Thread(...)`                                            |
| RUNNABLE      | 可运行：可能在执行，也可能在等待CPU时间片 | `start()` 之后，没在阻塞/等待                                |
| BLOCKED       | 阻塞：等待进入 `synchronized` 代码块/方法 | 锁被其他线程占用                                             |
| WAITING       | 无限期等待：需要被显式唤醒                | `Object.wait()`、`Thread.join()`（无超时）、`LockSupport.park()` |
| TIMED_WAITING | 有限时间等待：超时后自动唤醒              | `Thread.sleep()`、`wait(timeout)`、`join(timeout)`           |
| TERMINATED    | 已结束：`run()` 方法执行完毕              | 线程自然退出或异常退出                                       |

示例代码：

```java
import java.util.concurrent.TimeUnit;

public class ThreadStateDemo {
    public static void newState(){
        Thread thread = new Thread(()->{

        });
        System.out.println(thread.getState()); //NEW
    }
    public static void runnableState(){
        Thread thread = new Thread(()->{

        });
        thread.start();
        System.out.println(thread.getState()); //RUNNABLE
    }
    public static void blockState(){
        Object LOCK = new Object();
        Thread t1 = new Thread(()->{
           synchronized (LOCK){
               try {
                   TimeUnit.SECONDS.sleep(2);
               } catch (InterruptedException e) {
                   throw new RuntimeException(e);
               }
               System.out.println(Thread.currentThread().getName()+"拿到了锁");
           }
        },"t1");
        Thread t2 = new Thread(()->{
            synchronized (LOCK){
                System.out.println(Thread.currentThread().getName()+"拿到了锁");
            }
        },"t2");
        t1.start();
        //确保线程1拿到锁
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        t2.start();
        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println(t2.getState());//BLOCKED

    }
    public static void waitState(){


    }

    public static void main(String[] args) {
        blockState();
    }
}
```

## 7.线程状态间的转换

![](assets\线程状态.png)

线程状态都需要从Runnable进入Blocked、Waiting、Timed Waiting

线程的生命周期是不可逆的，一个线程只有一个New和Terminated的状态

## 8.Callable和FutureTask

这种创建线程的方式，适用于需要返回值的。

其中需要用FutureTask包装Callable是因为其实现了Runnable的接口

代码:

```java
public class CallableDemo {
    public static void main(String[] args) {
        FutureTask<Integer> task = new FutureTask<>(()->{
            TimeUnit.SECONDS.sleep(5);
            int sum  = 0;
            for(int i=1;i<=100;i++){
                sum += i;
            }
            return sum;
        });
        Thread thread = new Thread(task);

        thread.start();
        System.out.println(thread.getState());
        try {
            //阻塞等待子线程返回
            System.out.println(task.get());
        } catch (InterruptedException | ExecutionException e) {
            throw new RuntimeException(e);
        }
    }
}
```

## 9.线程的三种创建方式

> 1.继承Thread类，实现run方法
>
> 2.实现Runnable接口，实现Run方法
>
> 3.使用FutureTask（实现Callable接口）

## 10.线程池Executors

Executors提供了几种常见的线程池

| 线程池                   | 创建方式                              | 特点                         | 适用场景               |
| ------------------------ | ------------------------------------- | ---------------------------- | ---------------------- |
| **FixedThreadPool**      | `Executors.newFixedThreadPool(5)`     | 固定线程数，无界队列         | 已知并发量，稳定负载   |
| **CachedThreadPool**     | `Executors.newCachedThreadPool()`     | 线程数动态增减，空闲60秒回收 | 大量短任务，突发流量   |
| **SingleThreadExecutor** | `Executors.newSingleThreadExecutor()` | 单线程，无界队列             | 顺序执行，保证任务串行 |
| **ScheduledThreadPool**  | `Executors.newScheduledThreadPool(5)` | 支持延迟和定时执行           | 定时任务，延迟任务     |

```java
//代码演示
public class ExecutorDemo {
    static class Task implements Runnable{
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getName() + "正在执行");
        }
    }
    public static void main(String[] args) {
        Task task = new Task();
        //ExecutorService executorService = Executors.newFixedThreadPool(5);
        //ExecutorService executorService = Executors.newCachedThreadPool();
        //ExecutorService executorService = Executors.newSingleThreadExecutor();
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(5); //定时,延迟执行
        for(int i=0;i<10;i++){
            scheduledExecutorService.schedule(task,5, TimeUnit.SECONDS);
        }
    }
}
```

## 11.线程池的关闭

```java
public static void main(String[] args) {
    Task task = new Task();
    ExecutorService executorService = Executors.newFixedThreadPool(5);
    //ExecutorService executorService = Executors.newCachedThreadPool();
    //ExecutorService executorService = Executors.newSingleThreadExecutor();
    //ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(5); //定时,延迟执行
    try {
        for(int i=0;i<10;i++){
            executorService.execute(task);
        }
    }catch (Exception e){
        e.printStackTrace();
    }finally {
        //不会立马关闭线程池,会等所有的任务执行完毕
        //executorService.shutdown();

        //也不会立马关闭线程池，直到所有线程执行完毕
        executorService.shutdownNow();
        try {

            executorService.awaitTermination(10,TimeUnit.SECONDS);

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //判断线程是否真正关闭,代表线程已经执行完毕
        System.out.println(executorService.isTerminated());
    }

}
```

## 12.线程池的execute和submit有什么区别？

1) 参数上的区别：

execute只能传入runnable接口，submit可以传入callable接口

2) 返回值：

execute 返回void

submit 返回Future

3) 异常:

两个好像都是需要用get()方法返回的时候才会抛出异常

```java
static class TaskCallable implements Callable<Integer>{
    @Override
    public Integer call() throws Exception {
        System.out.println("我是call方法里面的代码");
        return 1/0;
    }
}
//execute和submit的区别？
public static void main(String[] args) {
    TaskCallable taskCallable = new TaskCallable();
    ExecutorService executorService = Executors.newFixedThreadPool(5);

    try {
        for(int i=0;i<10;i++){
            /*Future<Integer> future = executorService.submit(taskCallable);
                System.out.println(future.get()); //如果不调用get()方法不会抛异常，但是代码会执行*/

            FutureTask<Integer> future = new FutureTask<>(taskCallable);
            executorService.execute(future); //如果不调用get()方法，也不会抛异常
            future.get();

        }
    }catch (Exception e){
        e.printStackTrace();
        System.out.println("出错了");
    }finally {
        //不会立马关闭线程池,会等所有的任务执行完毕
        executorService.shutdown();

        //也不会立马关闭线程池，直到所有线程执行完毕
        //executorService.shutdownNow();
        try {

            executorService.awaitTermination(10,TimeUnit.SECONDS);

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        //判断线程是否真正关闭,代表线程已经执行完毕
        System.out.println(executorService.isTerminated());
    }

}
```

## 13.线程池参数

线程池的构造方法:

```java
public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler) {
    if (corePoolSize < 0 ||
        maximumPoolSize <= 0 ||
        maximumPoolSize < corePoolSize ||
        keepAliveTime < 0)
        throw new IllegalArgumentException();
    if (workQueue == null || threadFactory == null || handler == null)
        throw new NullPointerException();
    this.corePoolSize = corePoolSize;
    this.maximumPoolSize = maximumPoolSize;
    this.workQueue = workQueue;
    this.keepAliveTime = unit.toNanos(keepAliveTime);
    this.threadFactory = threadFactory;
    this.handler = handler;

    String name = Objects.toIdentityString(this);
    this.container = SharedThreadContainer.create(name);
}
```

具体执行的流程图：

![](assets\线程池参数.png)



代码验证:

```java
import java.util.concurrent.*;

public class ThreadPoolExecutorDemo {
    static class Task implements Runnable{
        private int id;
        public Task(int id){
            this.id = id;
        }
        @Override
        public void run() {
            System.out.println(String.format("id为%d的正在执行任务",id));
            try {
                TimeUnit.SECONDS.sleep(2);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
    public static void main(String[] args) {
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(10, 30, 0, TimeUnit.SECONDS,
                new ArrayBlockingQueue<>(10)
        );
        for(int i=0;i<30;i++){
            Task task = new Task(i);
            threadPoolExecutor.execute(task);

        }
        threadPoolExecutor.shutdown();
    }
}
```

## 14.Tomcat线程池和jdk线程池的区别

在jdk中，如果写了以下的代码:

```java
ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(10, 30, 0, TimeUnit.SECONDS,
                new ArrayBlockingQueue<>(10)
        );
```

此时线程池有几个线程？答案是0个，需要我们自己调用`threadPoolExecutor.prestartCoreThread();` 才能提前启动核心线程



但是在tomcat中线程池的构造函数下面加了这样一行:

```java
public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit,
                          BlockingQueue<Runnable> workQueue, ThreadFactory threadFactory, RejectedExecutionHandler handler) {
    if (corePoolSize < 0 || maximumPoolSize <= 0 || maximumPoolSize < corePoolSize || keepAliveTime < 0) {
        throw new IllegalArgumentException();
    }
    if (workQueue == null || threadFactory == null || handler == null) {
        throw new NullPointerException();
    }
    this.corePoolSize = corePoolSize;
    this.maximumPoolSize = maximumPoolSize;
    this.workQueue = workQueue;
    this.keepAliveTime = unit.toNanos(keepAliveTime);
    this.threadFactory = threadFactory;
    this.handler = handler;

    prestartAllCoreThreads();//tomcat中提前创建好了所有的核心线程
}
```

## 15.线程池如何创建线程？

直接看源代码:

```java
    public void execute(Runnable command) {
        if (command == null)
            throw new NullPointerException();
        /*
         * Proceed in 3 steps:
         *
         * 1. If fewer than corePoolSize threads are running, try to
         * start a new thread with the given command as its first
         * task.  The call to addWorker atomically checks runState and
         * workerCount, and so prevents false alarms that would add
         * threads when it shouldn't, by returning false.
         *
         * 2. If a task can be successfully queued, then we still need
         * to double-check whether we should have added a thread
         * (because existing ones died since last checking) or that
         * the pool shut down since entry into this method. So we
         * recheck state and if necessary roll back the enqueuing if
         * stopped, or start a new thread if there are none.
         *
         * 3. If we cannot queue task, then we try to add a new
         * thread.  If it fails, we know we are shut down or saturated
         * and so reject the task.
         */
        int c = ctl.get();
        if (workerCountOf(c) < corePoolSize) {
            if (addWorker(command, true))
                return;
            c = ctl.get();
        }
        if (isRunning(c) && workQueue.offer(command)) {
            int recheck = ctl.get();
            if (! isRunning(recheck) && remove(command))
                reject(command);
            else if (workerCountOf(recheck) == 0)
                addWorker(null, false);
        }
        else if (!addWorker(command, false))
            reject(command);
    }
```

所以就是这样的流程图和之前13点的流程图一样的

![](assets\线程池参数.png)

所以现在问题来了

如果核心线程是10，当前是最开始的第四个任务，此时前面3个任务的线程已经执行完了，现在是新建第四的线程，还是复用之前前3个线程？

答：创建新线程

## 16.线程池拒绝策略

1）抛异常

```java
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
    throw new RejectedExecutionException("Task " + r.toString() +
    " rejected from " +
    e.toString());
}
```

2）让主线程执行

```java
public static class CallerRunsPolicy implements RejectedExecutionHandler {
    /**
         * Creates a {@code CallerRunsPolicy}.
         */
    public CallerRunsPolicy() { }

    /**
         * Executes task r in the caller's thread, unless the executor
         * has been shut down, in which case the task is discarded.
         *
         * @param r the runnable task requested to be executed
         * @param e the executor attempting to execute this task
         */
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            r.run();
        }
    }
}
```

3）淘汰掉阻塞队列中等的最久的

```java
public static class DiscardOldestPolicy implements RejectedExecutionHandler {
    /**
         * Creates a {@code DiscardOldestPolicy} for the given executor.
         */
    public DiscardOldestPolicy() { }

    /**
         * Obtains and ignores the next task that the executor
         * would otherwise execute, if one is immediately available,
         * and then retries execution of task r, unless the executor
         * is shut down, in which case task r is instead discarded.
         *
         * @param r the runnable task requested to be executed
         * @param e the executor attempting to execute this task
         */
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        if (!e.isShutdown()) {
            e.getQueue().poll();
            e.execute(r);
        }
    }
}
```

4）啥也不干(冷暴力说是)

```java
public static class DiscardPolicy implements RejectedExecutionHandler {
    /**
         * Creates a {@code DiscardPolicy}.
         */
    public DiscardPolicy() { }

    /**
         * Does nothing, which has the effect of discarding task r.
         *
         * @param r the runnable task requested to be executed
         * @param e the executor attempting to execute this task
         */
    public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
    }
}
```

## 17.线程池淘汰策略-正常执行完毕

啥也不说，先看源码:

```java
final void runWorker(Worker w) {
    Thread wt = Thread.currentThread();
    Runnable task = w.firstTask;
    w.firstTask = null;
    w.unlock(); // allow interrupts
    boolean completedAbruptly = true;
    try {
        while (task != null || (task = getTask()) != null) { //如果线程需要退出，只需要这个getTask()方法返回空即可
            w.lock();
            // If pool is stopping, ensure thread is interrupted;
            // if not, ensure thread is not interrupted.  This
            // requires a recheck in second case to deal with
            // shutdownNow race while clearing interrupt
            if ((runStateAtLeast(ctl.get(), STOP) ||
                 (Thread.interrupted() &&
                  runStateAtLeast(ctl.get(), STOP))) &&
                !wt.isInterrupted())
                wt.interrupt();
            try {
                beforeExecute(wt, task);
                try {
                    task.run();
                    afterExecute(task, null);
                } catch (Throwable ex) {
                    afterExecute(task, ex);
                    throw ex;
                }
            } finally {
                task = null;
                w.completedTasks++;
                w.unlock();
            }
        }
        completedAbruptly = false;
    } finally {
        processWorkerExit(w, completedAbruptly);
    }
}
```

```java
private Runnable getTask() {
    boolean timedOut = false; // Did the last poll() time out?

    for (;;) {
        int c = ctl.get();

        // Check if queue empty only if necessary.
        if (runStateAtLeast(c, SHUTDOWN)
            && (runStateAtLeast(c, STOP) || workQueue.isEmpty())) {
            decrementWorkerCount();
            return null;
        }

        int wc = workerCountOf(c);

        // Are workers subject to culling?
        boolean timed = allowCoreThreadTimeOut || wc > corePoolSize;

        if ((wc > maximumPoolSize || (timed && timedOut))
            && (wc > 1 || workQueue.isEmpty())) {
            if (compareAndDecrementWorkerCount(c)) //如果线程池的线程数 > 核心线程数 timed=true，CAS减少,所以核心线程并不是固定的，而是竞争得来的。
                return null;
            continue;
        }

        try {
            Runnable r = timed ?
                workQueue.poll(keepAliveTime, TimeUnit.NANOSECONDS) :
            workQueue.take();
            if (r != null)
                return r;
            timedOut = true;
        } catch (InterruptedException retry) {
            timedOut = false;
        }
    }
}
```

