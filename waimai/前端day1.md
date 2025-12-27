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



