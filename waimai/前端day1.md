## 前端知识Day1

## 1.基于脚手架创建前端工程

使用Vue CLI创建前端工程

1. 方式一:vue create 项目名称
2. 方式二:vue ui

## 2.Vue工程项目结构

![ueProjec](assets\VueProject.png)

重点文件目录:

node_modules:当前项目依赖的js包

assets:静态资源存放目录

components:公共组件存放目录

App.vue:项目的主组件，页面的入口文件

main.js:整个项目的入口文件

package.json:项目的配置信息，依赖包管理

vue.config.js:vue-cli配置文件



前端项目启动后，服务端口默认为8080，很容易和后端tomcat端口号冲突。

如何修改前端服务的端口号?

在Vue.config.js中配置前端服务端端口

```javascript
const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 7070
  }
})

```

## 3.Vue基本使用方式

### 1.Vue组件

Vue的组件以.vue结尾，每个组件由三部分组成:

<template>:结构，只有一个根元素，由它生成HTML代码

<style>:样式，编写css,控制页面展示效果，全局样式影响所有组件，局部样式支作用于当前组件

<script>:逻辑,编写js代码，控制模板的数据来源和行为

### 2.vue基本使用方式-文本插值

作用:用来绑定data方法返回的对象属性

用法:{{}}，可以使用三目运算符

```vue
<template>
  <div class="hello">
    {{ userName }}
    {{ age>=60 ? '老年' : '青年' }}
  </div>
</template>

<script>
export default {
  data() {
    return {
       userName: '张三',
       age:60   
    }
  }
}
</script>
```

### 3.vue基本使用方式-属性绑定

作用:为标签的属性绑定data方法中返回的属性

用法:v-bind:xxx,简写为:xxx

```vue
<template>
  <div class="hello">
    <input type="text" v-bind:value="userName">
    <input type="text" :value="age">
    <img :src="src">
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
       userName: '张三',
       age:60,
       src: 'https://sky-take-out-yiyi.oss-cn-beijing.aliyuncs.com/3293e51d-4aed-4370-91d0-d33dd724c346.png'
    }
  }
}
```

### 4.vue基本使用方式-事件绑定

作用:为元素绑定对应的事件

用法:v-on:xxx,简写为@xxx

```vue
<template>
  <div class="hello">
    <input type="text" v-bind:value="userName">
    <input type="text" :value="age">
    <img :src="src">
    <input type="button" v-on:click="addAge" value="按钮">
    <input type="button" v-on:click="addAge" value="按钮">
  </div>
</template>

<script>
export default {
  data() {
    return {
       userName: '张三',
       age:60,
       src: 'https://sky-take-out-yiyi.oss-cn-beijing.aliyuncs.com/3293e51d-4aed-4370-91d0-d33dd724c346.png'
    }
  },
  methods: {
    addAge() {
      this.age++
    }
  }
}
</script>
```

### 5.vue基本使用方式-双向绑定

作用:表单输入项和data方法中的属性进行绑定，任意一方改变都会同步给另一方

用法:v-model

```vue
<template>
  <div class="hello">
    <input type="text" v-bind:value="userName">
    <input type="text" :value="age">
    <img :src="src">
    <input type="button" v-on:click="addAge" value="按钮">
    <input type="button" v-on:click="changeName" value="修改名字">
    <input type="text" v-model="userName">
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
       userName: '张三',
       age:60,
       src: 'https://sky-take-out-yiyi.oss-cn-beijing.aliyuncs.com/3293e51d-4aed-4370-91d0-d33dd724c346.png'
    }
  },
  methods: {
    addAge() {
      this.age++
    },
    changeName(){
      this.userName = '李四'
    }
  }
}
</script>
```

### 6.Vue基本使用方式-条件渲染

作用:根据表达式的值来动态渲染页面元素

用法:v-if,v-else.v-else-if

```vue
<template>
  <div class="hello">
    <input type="text" v-bind:value="userName">
    <input type="text" :value="age">
    <img :src="src">
    <input type="button" v-on:click="addAge" value="按钮">
    <input type="button" v-on:click="changeName" value="修改名字">
    <input type="text" v-model="userName">
    <span v-if="sex == 1">男</span>
    <span v-else-if="sex == 2">男</span>
    <span v-else>未知</span>

  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
       userName: '张三',
       age:60,
       sex:3,
       src: 'https://sky-take-out-yiyi.oss-cn-beijing.aliyuncs.com/3293e51d-4aed-4370-91d0-d33dd724c346.png'
    }
  },
  methods: {
    addAge() {
      this.age++
    },
    changeName(){
      this.userName = '李四'
    }
  }
}
</script>
```

### 7.Vue基本使用方式-axios

Axios是一个基于promise的网络请求库，作用于浏览器和node.js中

官网:https://www.axios-http.cn/docs/intro

安装命令:` npm install axios`

导入命令:`import axios from axios`

axios的API列表:

| 请求                             |
| -------------------------------- |
| axios.get(url[,config])          |
| axios.delete(url[,config])       |
| axios.head(url[,config])         |
| axios.options(url[,config])      |
| axios.post(url[,data[,config]])  |
| axios.put(url[,data[,config]])   |
| axios.patch(url[,data[,config]]) |

参数说明；

url:请求路径

data:请求体数据，最常见的是JSON格式数据

config:配置对象，可以设置查询参数，请求头信息



为了解决跨域问题，可以在vue.config.js文件中配置代理

```javascript
const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 7070,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        pathRewrite: {
          '^/api': ''
        }
      }
    }
  }
})

```

重启一下后，就可以代理请求了

```vue
<script>
import axios from 'axios';

export default {
  methods :{
    sendRequestPost(){
      axios.post('/api/admin/employee/login',{
        username:'admin',
        password:'123456'
      }).then(res =>{
        console.log(res.data)
      }).catch(error => {
        console.log(error.response)
      })
    },
    sendRequestGet(){
      axios.get('/api/admin/shop/status',{
        headers:{
          token:'eyJhbGciOiJIUzI1NiJ9.eyJlbXBJZCI6MSwiZXhwIjoxNzY2OTI4OTU1fQ.GDhluSWyB4L9atjQ2MR5rYLJVMdv7lkFppQG1V1xCxU'
        }
      })
      .then(res=>{
        console.log(res.data)
      })
    }
  }
  
}
</script>
```

统一请求方式:

```javascript
handleSend(){
    axios({
        url:'/api/admin/employee/login',
        method: 'post',
        data:{
            username:'admin',
            password:'123456'
        }
    }).then(res =>{
        console.log(res.data.data.token)
        axios({
            url:'/api/admin/shop/status',
            method: 'get',
            headers:{
                token:res.data.data.token
            }
        })
    })
}
```

### 8.Vue-Router介绍

vue属于单页面应用，所谓的路由，就是根据浏览器路径不同，用不同的视图组件替换这个页面内容

vue应用中如何实现路由:通过vue-router实现路由功能，需要安装js库(npm install vue-router)

![ue-route](assets\Vue-router.png)

路由组成:

1. VueRouter:路由器，根据路由请求在路由视图中动态渲染对应的视图组件
2. <router-link>:路由连接组件，浏览器会解析成<a>
3. <router-view>:路由视图组件，用来展示与路由路径匹配的视图组件

App.vue:

```vue
<template>
  <div id="app">
    <nav>
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </nav>
    <router-view/>
  </div>
</template>
```

router/index.js

```javascript
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  }
]

const router = new VueRouter({
  routes
})

export default router
```

实现路由跳转有两种方式:标签式和编程式

```vue
<template>
  <div id="app">
    <nav>
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
      <input type="button" @click="jump" value="编程式路由跳转">
    </nav>
    <router-view/>
  </div>
</template>
<script>
  export default{
    methods:{
      jump(){
        this.$router.push('/about')
      }
    }
  }
</script>
```

如果用户访问的路由地址不存在，如何处理?:

```javascript
const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  },
  {
    path: '/404',
    component: () => import(/* webpackChunkName: "about" */ '../views/404View.vue')
  },
  {
    path: '*',
    redirect: '/404'
  }
]
```

### 9.嵌套路由

嵌套路由:组件内要切换内容，就需要用到嵌套路由

路由表:

```javascript
{
    path: '/c',
    component: () => import(/* webpackChunkName: "about" */ '../views/container/AppContainer.vue'),
    redirect:'/c/p1',//默认展示p1
    children: [
      {
        path: '/c/p1',
        component: () => import('../views/container/P1View.vue')
      },
      {
        path: '/c/p2',
        component: () => import('../views/container/P2View.vue')
      },
      {
        path: '/c/p3',
        component: () => import('../views/container/P3View.vue')
      },
    ]
  }
```

组件:

```vue
<template>
  <el-container>
    <el-header>Header</el-header>
    <el-container>
      <el-aside width="200px">
        <router-link to="/c/p1">p1Vue</router-link><br>
        <router-link to="/c/p2">p2Vue</router-link><br>
        <router-link to="/c/p3">p3Vue</router-link><br>
      </el-aside>
      <el-main>
        <router-view/>
      </el-main>
    </el-container>
  </el-container>
</template>
```

### 10.Vuex

1. vuex是一个专为Vue.js应用程序开发的状态管理库
2. vuex可以在多个组件之间共享数据，并且共享的数据是响应式的，即数据的变更能及时渲染到模板
3. vuex采用集中式存储管理所有组件的状态

安装vuex:

`npm install vuex@next --save `

vuex介绍:

1. state:状态对象，集中定义各个组件共享的数据
2. mutations:类似于一个事件，用于修改共享数据，要求必须是同步函数
3. 类似于mutation,可以包含异步操作，通过调用mutation来改变共享数据

定义和展示数据:

```javascript
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    name: '未登录游客'
  },
  getters: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})

```

```vue
<template>
  <div class="hello">
    <h1>{{ $store.state.name }}</h1>
    
  </div>
</template>
```

修改数据:

```javascript
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    name: '未登录游客'
  },
  getters: {
  },
  //通过当前属性中定义的函数修改共享数据，必须都是同步操作
  mutations: {
    setName(state, newName) {
      state.name = newName
    }
  },
  actions: {
  },
  modules: {
  }
})

```

```vue
<template>
  <div id="app">
    欢迎您,{{ $store.state.name }}
    <button @click="handleUpdate">修改名字</button>
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  },
  methods:{
    handleUpdate(){
      this.$store.commit('setName','苏无名')
    }
  }
}
</script>
```

发送异步数据:

```javascript
import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    name: '未登录游客'
  },
  getters: {
  },
  //通过当前属性中定义的函数修改共享数据，必须都是同步操作
  mutations: {
    setName(state, newName) {
      state.name = newName
    }
  },
  //通过actions调用mutation,在actions中可以进行异步操作
  actions: {
    setNameByAxios(context) {
      axios({
        url: '/api/admin/employee/login',
        method: 'post',
        data: {
          username: 'admin',
          password: '123456'
        }
      }).then(res => {
        if (res.data.code) {
          //调用mutations的函数
          context.commit('setName', res.data.data.name)
        }
      })
    }
  },
  modules: {
  }
})

```

```vue
<template>
  <div id="app">
    欢迎您,{{ $store.state.name }}
    <button @click="handleUpdate">修改名字</button>
    <button @click="handleCallAction">发送异步请求</button>
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld/>
  </div>
</template>

<script>
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
  },
  methods:{
    handleUpdate(){
      //通过这种方式来调用mutations中的函数
      this.$store.commit('setName','苏无名')
    },
    handleCallAction(){
      //通过这种方式来调用actions中的函数
      this.$store.dispatch('setNameByAxios')
    }
  }
}
</script>


```

## 4.TypeScript介绍

TypeScript(简称:TS) 是微软推出的开源语言

TypeScript是JavaScript的超集(JS有的TS都有)

TypeScript=Type+JavaScript(在JS的基础上增加了类型支持)

TypeScript文件扩展名为ts

TypeScript可编译成标准的JavaScript，并且在编译时进行类型检查

```typescript
//TypeScript代码：有明确的类型，即:number(数值类型)
let age:number = 18
```

![s执行流](assets\ts执行流程.png)

安装typescript:

`npm install -g typescript` -g是全局安装



TS为什么要增加类型支持?

1. TS属于静态类型编程语言，JS属于动态类型编程语言
2. 静态类型在编译期做类型检查，动态类型在执行期做类型检查
3. 配合VSCode开发工具，TS可以提前到在编写代码的同时就发现代码中的错误，减少找Bug,改Bug的时间



TypeScript常用类型:

| 类型       | 例                          | 备注                           |
| ---------- | --------------------------- | ------------------------------ |
| 字符串类型 | string                      |                                |
| 数字类型   | number                      |                                |
| 布尔类型   | boolean                     |                                |
| 数组类型   | number[],string[].boolean[] |                                |
| 任意类型   | any                         | 相当于又回到了没有类型的时代   |
| 复杂类型   | type与interface             |                                |
| 函数类型   | () => void                  | 对函数的参数和返回值进行了说明 |
| 字面量类型 | "a"\|"b"\|"c"               | 限制变量或参数的取值           |
| class 类   | class Animal                |                                |

### 1.类型标注的位置

1. 标注变量
2. 标注参数
3. 标注返回值

```typescript
let username: string = 'itcast'
let age: number = 20
let isTrue: boolean = true
console.log(username)
console.log(age)
console.log(isTrue)
```

```typescript
//字面量类型:用于限定数据的取值范围
function printTest(s1: string, s2: 'left' | 'right' | 'center') {
  console.log(s1, s2);
}
printTest('hello', 'left')
printTest('hello', 'center')
```

```typescript
//interface类型
interface Cat {
  name: string,
  age: number,
  sex: '男' | '女'
}
let c1: Cat = { name: 'danking', age: 2, sex: '男' }
```

```typescript
//interface类型
interface Cat {
  name: string,
  age: number,
  sex?: '男' | '女' //属性名后面加?,表示当前属性可有可没有
}
let c1: Cat = { name: 'danking', age: 2, sex: '男' }
let c2: Cat = { name: 'jumyoung', age: 1 }
```

```typescript
//类
//使用class关键字来定义类,类中可以包含属性,构造方法，普通函数
class User {
  name: string
  constructor(name: string) {
    this.name = name
  }
  study() {
    console.log(`${this.name}正在学习`)
  }
}
const s1 = new User('张不才')
s1.study()
```

注意class在js中其实是个function

```javascript
//类
//使用class关键字来定义类,类中可以包含属性,构造方法，普通函数
var User = /** @class */ (function () {
    function User(name) {
        this.name = name;
    }
    User.prototype.study = function () {
        console.log("".concat(this.name, "\u6B63\u5728\u5B66\u4E60"));
    };
    return User;
}());
var s1 = new User('张不才');
s1.study();
```

```typescript
//class类-实现接口
interface Animal {
  name: string
  eat(): void
}
class Bird implements Animal {
  name: string
  constructor(name: string) {
    this.name = name
  }
  eat(): void {
    console.log(`${this.name}吃饭中`)
  }
}

const b1 = new Bird('杜鹃')
console.log(b1.name)
b1.eat()
```

```typescript
//class-类的继承
//定义Parrot类，并且继承Bird类
class Parrot extends Bird {
  say(): void {
    console.log(`${this.name} say hello`)
  }
}
const myParrot = new Parrot('polly')
myParrot.say()
myParrot.eat()
```



