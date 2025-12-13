# 第五天核心知识

## 1.Redis

### 1.1Redis简介

Redis是一个基于**内存**的**key-value**结构数据库

1. 基于内存存储，读写性能高
2. 适合存储热点数据(热点商品、资讯、新闻)
3. 企业广泛应用

官网:[Redis - The Real-time Data Platform](https://redis.io/)

中文网:[Redis中文网](https://www.redis.net.cn/)

Redis和Mysql经常结合起来一起用，相辅相成。

Redis读写快，但不适合存太大的数据，经常访问的数据存储在Redis

Mysql存储在硬盘，存储量大，但是读写不如Redis

### 1.2Redis目录的重要文件

![nipaste_2025-12-11_20-34-0](.\assets\Snipaste_2025-12-11_20-34-07.png)

### 1.3Redis的5种常用数据结构

Redis存储的是key-value结构的数据，其中key是字符串类型,value有5种常用的数据类型:

1. 字符串string
2. 哈希hash
3. 列表list
4. 集合set
5. 有序结合sorted set/zset

![edis数据类](.\assets\Redis数据类型.png)



字串串(string):普通字符串，Redis中最简单的数据类型

哈希(hash):也叫散列，类似于Java中的HashMap结构

列表(list):按照插入顺序排序，可以有重复元素，类似于Java中的LinkedList

集合(set):无序集合，没有重复元素，类似于Java中的HashSet

有序集合(sorted set/zset):集合中每个元素关联一个分数(score),根据分数升序排序，没有重复元素

### 1.4Redis常用命令

#### 1.字符串常用命令

| 命令                    | 功能                                            |
| ----------------------- | ----------------------------------------------- |
| set key value           | 设置指定key的值                                 |
| get key                 | 获取指定key的值                                 |
| setex key seconds value | 设置指定key的值，并将key的过期时间设为seconds秒 |
| setnx key value         | 只有在key不存在时设置key的值                    |

#### 2.哈希操作命令

![edis-has](.\assets\Redis-hash.png)

Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象，常用命令:

| 命令                 | 功能                                  |
| -------------------- | ------------------------------------- |
| hset key field value | 将哈希表key中的字段field的值设为value |
| hget key field       | 获取存储在哈希表中指定字段的值        |
| hdel key field       | 删除存储在哈希表中的指定字段          |
| hkeys key            | 获取哈希表中的所有字段                |
| hvals key            | 获取哈希表中所有值                    |

#### 3.列表操作命令

![edis-lis](.\assets\Redis-list.png)

Redis列表是简单的字符串列表，按照插入顺序排序，常用命令:

| 命令                    | 功能                                                  |
| ----------------------- | ----------------------------------------------------- |
| lpush key value1 value2 | 将一个或多个值插入到列表头部(左边)                    |
| lrange key start stop   | 获取列表指定范围内的元素(eg:查看全部 lrange key 0 -1) |
| rpop key                | 移除并获取列表最后一个元素(右边)                      |
| llen key                | 获取列表长度                                          |

#### 4.集合操作命令

![edis-se](.\assets\Redis-set.png)

Redis set是string类型的无序集合。集合成员是唯一的，集合中不能出现重复的数据，常用命令:

| 命令                       | 功能                       |
| -------------------------- | -------------------------- |
| sadd key number1 [number2] | 向集合中添加一个或多个成员 |
| smembers key               | 返回集合中的所有成员       |
| scard key                  | 获取集合的成员数           |
| sinter key1 key2           | 返回给定所有集合的交集     |
| sunion key1 key2           | 返回所有给定集合的并集     |
| srem key member1 [member2] | 删除集合中一个或多个成员   |

#### 5.有序集合操作命令

![edis-se](.\assets\Redis-zset.png)

Redis有序集合是string类型元素的集合，且不允许有重复成员。每个元素都会关联一个double类型的分数，常用命令:

| 命令                                      | 功能                                        |
| ----------------------------------------- | ------------------------------------------- |
| zadd key score1 member 1 [score2 member2] | 向有序集合添加一个或多个成员                |
| zrange key start stop [withscores]        | 通过索引区间返回有序集合中指定区间内的成员  |
| zincreby key increment member             | 有序集合中对指定成员的分数加上增量increment |
| zrem key member [member...]               | 移除有序集合中的一个或多个成员              |

#### 6.通用命令

Redis的通用命令是不分数据类型的，都可以使用的命令:

| 命令         | 功能                                       |
| ------------ | ------------------------------------------ |
| keys pattern | 查找所有符合给定模式(pattern)的key,通配符* |
| exists key   | 检查给定key是否存在                        |
| type key     | 返回key所存储的值的类型                    |
| del key      | 该命令用于在key存在时删除key               |

