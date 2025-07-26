import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import BlogApp from './BlogApp.vue'
import BlogList from './views/BlogList.vue'
import BlogDetail from './views/BlogDetail.vue'

// 博客子域名的路由配置
const routes = [
  { path: '/', component: BlogList }, // 默认显示博客列表
  { path: '/blog', redirect: '/' }, // 重定向到根路径
  { path: '/:id(\\d+)', component: BlogDetail, props: true } // 博客详情页，只匹配数字ID
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(BlogApp)

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(ElementPlus)
app.use(router)
app.mount('#app')