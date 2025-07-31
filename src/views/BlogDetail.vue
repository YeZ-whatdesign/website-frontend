<template>
  <div class="blog-detail-page">
    <!-- 导航栏 -->
    <nav class="navbar">
      <div class="nav-container">
        <div class="nav-brand">
          <a href="//what-tech.cn" target="_blank">
            <img src="/images/logo_horizontal.png" alt="What Tech" class="logo">
          </a>
        </div>
        <div class="nav-links">
          <a href="//what-tech.cn" class="nav-link">首页</a>
          <router-link to="/" class="nav-link">博客</router-link>
        </div>
      </div>
    </nav>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading-container">
      <div class="container">
        <el-skeleton :rows="5" animated />
      </div>
    </div>

    <!-- 博客详情 -->
    <div v-else-if="blog" class="blog-detail">
      <!-- 博客头部 -->
      <section class="blog-header">
        <div class="container">
          <div class="breadcrumb">
            <a href="//what-tech.cn">首页</a>
            <span>/</span>
            <router-link to="/">博客</router-link>
            <span>/</span>
            <span>{{ blog.title }}</span>
          </div>
          
          <h1 class="blog-title">{{ blog.title }}</h1>
          
          <div class="blog-meta">
            <div class="meta-item">
              <el-icon><Calendar /></el-icon>
              <span>{{ formatDate(blog.created_at) }}</span>
            </div>
            <div class="meta-item">
              <el-icon><User /></el-icon>
              <span>{{ blog.author || '管理员' }}</span>
            </div>
            <div class="meta-item">
              <el-icon><View /></el-icon>
              <span>{{ blog.views || 0 }} 次阅读</span>
            </div>
          </div>
        </div>
      </section>

      <!-- 博客内容 -->
      <section class="blog-content-section">
        <div class="container">
          <div class="blog-layout">
            <article class="blog-article">
              <div v-if="blog.image" class="featured-image">
                <img :src="blog.image" :alt="blog.title" />
              </div>
              
              <div class="content" v-html="formattedContent"></div>
              
              <!-- 标签 -->
              <div v-if="blog.tags && blog.tags.length" class="blog-tags">
                <h4>标签</h4>
                <div class="tags">
                  <el-tag 
                    v-for="tag in blog.tags" 
                    :key="tag" 
                    type="primary"
                    effect="plain"
                  >
                    {{ tag }}
                  </el-tag>
                </div>
              </div>

              <!-- 分享按钮 -->
              <div class="share-section">
                <h4>分享文章</h4>
                <div class="share-buttons">
                  <el-button @click="shareToWeChat" icon="ChatDotRound">微信</el-button>
                  <el-button @click="shareToWeibo" icon="Share">微博</el-button>
                  <el-button @click="copyLink" icon="Link">复制链接</el-button>
                </div>
              </div>
            </article>

            <!-- 侧边栏 -->
            <aside class="blog-sidebar">
              <div class="sidebar-widget">
                <h3>相关文章</h3>
                <div v-if="relatedBlogs.length" class="related-blogs">
                  <div 
                    v-for="relatedBlog in relatedBlogs" 
                    :key="relatedBlog.id"
                    class="related-item"
                    @click="goToBlog(relatedBlog.id)"
                  >
                    <img :src="relatedBlog.image" :alt="relatedBlog.title" />
                    <div class="related-content">
                      <h4>{{ relatedBlog.title }}</h4>
                      <span class="related-date">{{ formatDate(relatedBlog.created_at) }}</span>
                    </div>
                  </div>
                </div>
                <div v-else class="no-related">
                  <p>暂无相关文章</p>
                </div>
              </div>

              <div class="sidebar-widget">
                <h3>返回博客列表</h3>
                <el-button type="primary" @click="goToBlogList" style="width: 100%;">
                  <el-icon><ArrowLeft /></el-icon>
                  查看所有博客
                </el-button>
              </div>
            </aside>
          </div>
        </div>
      </section>
    </div>

    <!-- 博客不存在 -->
    <div v-else class="blog-not-found">
      <div class="container">
        <el-result
          icon="warning"
          title="博客不存在"
          sub-title="您访问的博客文章不存在或已被删除"
        >
          <template #extra>
            <el-button type="primary" @click="goToBlogList">返回博客列表</el-button>
          </template>
        </el-result>
      </div>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-info">
           <p>&copy; 2024 What Tech. 保留所有权利。</p>
           <div class="footer-beian">
             <a href="https://beian.miit.gov.cn/" target="_blank" rel="noopener noreferrer">
               沪ICP备20003145号-2
             </a>
             <span class="beian-separator">|</span>
             <a href="https://beian.miit.gov.cn/" target="_blank" rel="noopener noreferrer">
               工信部备案管理系统
             </a>
           </div>
         </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const router = useRouter()
const route = useRoute()
const blog = ref(null)
const relatedBlogs = ref([])
const loading = ref(true)

const formattedContent = computed(() => {
  if (!blog.value?.content) return ''
  
  // 简单的内容格式化，将换行转换为段落
  return blog.value.content
    .split('\n\n')
    .map(paragraph => `<p>${paragraph.replace(/\n/g, '<br>')}</p>`)
    .join('')
})

const loadBlog = async () => {
  try {
    loading.value = true
    const blogId = route.params.id
    console.log('开始加载博客详情，ID:', blogId)
    
    const response = await axios.get(`/api/blog/${blogId}`)
    console.log('博客详情API响应:', response.data)
    
    if (response.data.success) {
      blog.value = {
        ...response.data.post,
        image: response.data.post.image ? 
          response.data.post.image.replace('http://localhost:3001', '') : 
          '/images/default-blog.jpg'
      }
      console.log('博客详情加载成功:', blog.value)
      
      // 加载相关文章
      await loadRelatedBlogs()
    } else {
      console.log('博客详情API返回失败状态')
      blog.value = null
    }
  } catch (error) {
    console.error('加载博客失败:', error)
    console.error('错误详情:', error.response?.data || error.message)
    
    // 使用默认数据进行演示
    const blogId = parseInt(route.params.id)
    const defaultBlogs = [
      {
        id: 1,
        title: '数据建模最佳实践',
        content: `数据建模是现代企业数字化转型的核心环节。一个优秀的数据模型不仅能够准确反映业务需求，还能为后续的数据分析和决策提供坚实的基础。

在进行数据建模时，我们需要遵循以下几个核心原则：

1. **业务导向**：数据模型必须紧密结合业务需求，确保每个数据实体和属性都有明确的业务含义。

2. **标准化设计**：采用标准的建模方法和规范，确保模型的一致性和可维护性。

3. **性能优化**：在满足业务需求的前提下，优化模型结构以提升查询性能。

4. **扩展性考虑**：设计时要考虑未来业务发展的需要，确保模型具有良好的扩展性。

通过遵循这些原则，我们可以构建出高质量的数据模型，为企业的数据驱动决策提供有力支撑。`,
        image: '/images/modeler.jpg',
        created_at: new Date().toISOString(),
        author: '技术团队',
        tags: ['数据建模', '最佳实践', '企业架构']
      },
      {
        id: 2,
        title: '全栈开发技术栈选择',
        content: `在当今快速发展的技术环境中，选择合适的全栈开发技术栈对项目成功至关重要。

前端技术选择：
- React/Vue.js：现代化的前端框架
- TypeScript：提供类型安全
- Tailwind CSS：快速样式开发

后端技术选择：
- Node.js/Python：高效的后端开发
- Express/FastAPI：轻量级框架
- PostgreSQL/MongoDB：数据存储方案

通过合理的技术栈组合，可以大大提升开发效率和项目质量。`,
        image: '/images/developer.jpg',
        created_at: new Date().toISOString(),
        author: '开发团队',
        tags: ['全栈开发', '技术栈', '前端', '后端']
      },
      {
        id: 3,
        title: '数据可视化设计原则',
        content: `数据可视化是将复杂数据转化为直观图表的艺术与科学。

核心设计原则：
1. 清晰性：确保图表传达的信息清晰明了
2. 准确性：数据表示必须准确无误
3. 美观性：良好的视觉设计提升用户体验
4. 交互性：适当的交互增强数据探索能力

选择合适的图表类型对于有效的数据可视化至关重要。`,
        image: '/images/visualization.jpg',
        created_at: new Date().toISOString(),
        author: '设计团队',
        tags: ['数据可视化', '设计原则', 'UI/UX']
      }
    ]
    
    const foundBlog = defaultBlogs.find(b => b.id === blogId)
    if (foundBlog) {
      blog.value = foundBlog
      console.log('使用默认博客数据:', blog.value)
      // 设置相关文章
      relatedBlogs.value = defaultBlogs.filter(b => b.id !== blogId).slice(0, 3)
    } else {
      blog.value = null
      console.log('未找到对应的默认博客数据')
    }
  } finally {
    loading.value = false
  }
}

const loadRelatedBlogs = async () => {
  try {
    const response = await axios.get('/api/blog?limit=3')
    if (response.data.success) {
      relatedBlogs.value = response.data.posts
        .filter(post => post.id !== blog.value.id)
        .slice(0, 3)
        .map(post => ({
          ...post,
          image: post.image ? post.image.replace('http://localhost:3001', '') : '/images/default-blog.jpg'
        }))
    }
  } catch (error) {
    console.error('加载相关文章失败:', error)
  }
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const goToBlog = (id) => {
  // 检查当前是否在博客子域名下
  if (window.location.hostname.startsWith('blog.')) {
    router.push(`/${id}`)
  } else {
    router.push(`/blog/${id}`)
  }
}

const goToBlogList = () => {
  // 检查当前是否在博客子域名下
  if (window.location.hostname.startsWith('blog.')) {
    router.push('/')
  } else {
    router.push('/blog')
  }
}

const shareToWeChat = () => {
  ElMessage.info('请复制链接分享到微信')
}

const shareToWeibo = () => {
  const url = window.location.href
  const title = blog.value.title
  window.open(`//service.weibo.com/share/share.php?url=${encodeURIComponent(url)}&title=${encodeURIComponent(title)}`)
}

const copyLink = async () => {
  try {
    await navigator.clipboard.writeText(window.location.href)
    ElMessage.success('链接已复制到剪贴板')
  } catch (error) {
    ElMessage.error('复制失败，请手动复制')
  }
}

onMounted(() => {
  loadBlog()
})
</script>

<style scoped>
/* 全局样式 */
.blog-detail-page {
  min-height: 100vh;
  background: var(--bg-primary);
  color: var(--text-primary);
}

/* 导航栏 */
.navbar {
  background: var(--card-bg);
  border-bottom: 1px solid var(--border-color);
  padding: 1rem 0;
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-brand .logo {
  height: 40px;
}

.nav-links {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: var(--text-secondary);
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
}

.nav-link:hover {
  color: var(--accent-color);
}

/* 容器 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* 加载状态 */
.loading-container {
  padding: 4rem 0;
}

/* 博客头部 */
.blog-header {
  background: var(--card-bg);
  border-bottom: 1px solid var(--border-color);
  padding: 3rem 0;
}

.breadcrumb {
  margin-bottom: 2rem;
  font-size: 0.9rem;
  color: var(--text-secondary);
}

.breadcrumb a {
  color: var(--accent-color);
  text-decoration: none;
}

.breadcrumb span {
  margin: 0 0.5rem;
}

.blog-title {
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  line-height: 1.2;
  color: var(--text-primary);
}

.blog-meta {
  display: flex;
  gap: 2rem;
  flex-wrap: wrap;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

/* 博客内容区域 */
.blog-content-section {
  padding: 4rem 0;
}

.blog-layout {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 3rem;
}

/* 博客文章 */
.blog-article {
  background: var(--card-bg);
  border-radius: 12px;
  padding: 2rem;
  border: 1px solid var(--border-color);
}

.featured-image {
  margin-bottom: 2rem;
  border-radius: 8px;
  overflow: hidden;
}

.featured-image img {
  width: 100%;
  height: 300px;
  object-fit: cover;
}

.content {
  line-height: 1.8;
  font-size: 1.1rem;
  margin-bottom: 3rem;
}

.content :deep(p) {
  margin-bottom: 1.5rem;
  color: var(--text-primary);
}

.content :deep(h1),
.content :deep(h2),
.content :deep(h3),
.content :deep(h4) {
  margin: 2rem 0 1rem 0;
  color: var(--text-primary);
}

.content :deep(code) {
  background: var(--bg-secondary);
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.content :deep(pre) {
  background: var(--bg-secondary);
  padding: 1rem;
  border-radius: 8px;
  overflow-x: auto;
  margin: 1rem 0;
}

/* 标签 */
.blog-tags {
  margin-bottom: 2rem;
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
}

.blog-tags h4 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.tags {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

/* 分享区域 */
.share-section {
  padding-top: 2rem;
  border-top: 1px solid var(--border-color);
}

.share-section h4 {
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.share-buttons {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

/* 侧边栏 */
.blog-sidebar {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.sidebar-widget {
  background: var(--card-bg);
  border-radius: 12px;
  padding: 1.5rem;
  border: 1px solid var(--border-color);
}

.sidebar-widget h3 {
  margin-bottom: 1rem;
  color: var(--text-primary);
  font-size: 1.2rem;
}

.related-blogs {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.related-item {
  display: flex;
  gap: 1rem;
  padding: 1rem;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.related-item:hover {
  background: var(--bg-secondary);
}

.related-item img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 6px;
  flex-shrink: 0;
}

.related-content h4 {
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
  color: var(--text-primary);
  line-height: 1.3;
}

.related-date {
  font-size: 0.8rem;
  color: var(--text-muted);
}

.no-related {
  text-align: center;
  color: var(--text-secondary);
  padding: 2rem 0;
}

/* 博客不存在 */
.blog-not-found {
  padding: 4rem 0;
}

/* 页脚 */
.footer {
  background: var(--card-bg);
  border-top: 1px solid var(--border-color);
  padding: 2rem 0;
  text-align: center;
  color: var(--text-secondary);
}

.footer-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.footer-info p {
  margin: 0;
  color: var(--text-secondary);
}

.footer-beian {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.footer-beian a {
  color: var(--text-muted);
  text-decoration: none;
  font-size: 0.9rem;
  transition: color 0.3s ease;
}

.footer-beian a:hover {
  color: var(--accent-color);
  text-decoration: underline;
}

.beian-separator {
  color: var(--text-muted);
  font-size: 0.9rem;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .blog-layout {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .blog-sidebar {
    order: -1;
  }
}

@media (max-width: 768px) {
  .nav-container {
    padding: 0 1rem;
  }
  
  .container {
    padding: 0 1rem;
  }
  
  .blog-title {
    font-size: 2rem;
  }
  
  .blog-meta {
    gap: 1rem;
  }
  
  .blog-article {
    padding: 1.5rem;
  }
  
  .share-buttons {
    justify-content: center;
  }
}
</style>