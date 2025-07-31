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
          <a href="https://what-tech.cn" class="nav-link">首页</a>
          <a href="https://what-tech.cn/blog" class="nav-link">博客</a>
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
            <a href="https://what-tech.cn">首页</a>
            <span>/</span>
            <a href="https://what-tech.cn/blog">博客</a>
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
import { marked } from 'marked'
import hljs from 'highlight.js'
import 'highlight.js/styles/github.css'
import axios from 'axios'

// 配置marked
marked.setOptions({
  highlight: function(code, lang) {
    const language = hljs.getLanguage(lang) ? lang : 'plaintext'
    return hljs.highlight(code, { language }).value
  },
  langPrefix: 'hljs language-',
  breaks: true,
  gfm: true
})

const router = useRouter()
const route = useRoute()
const blog = ref(null)
const relatedBlogs = ref([])
const loading = ref(true)

const formattedContent = computed(() => {
  if (!blog.value?.content) return ''
  
  // 使用marked渲染Markdown内容
  return marked(blog.value.content)
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
  margin-bottom: 2rem;
  line-height: 1.8;
  color: white;
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

/* 代码高亮样式 */
.hljs {
  display: block;
  overflow-x: auto;
  padding: 1em;
  background: #f8f9fa !important;
  border-radius: 8px;
  margin: 1em 0;
  border: 1px solid #e9ecef;
}

.hljs-comment,
.hljs-quote {
  color: #6a737d;
  font-style: italic;
}

.hljs-keyword,
.hljs-selector-tag,
.hljs-subst {
  color: #d73a49;
  font-weight: bold;
}

.hljs-number,
.hljs-literal,
.hljs-variable,
.hljs-template-variable,
.hljs-tag .hljs-attr {
  color: #005cc5;
}

.hljs-string,
.hljs-doctag {
  color: #032f62;
}

.hljs-title,
.hljs-section,
.hljs-selector-id {
  color: #6f42c1;
  font-weight: bold;
}

.hljs-subst {
  font-weight: normal;
}

.hljs-type,
.hljs-class .hljs-title,
.hljs-tag,
.hljs-regexp,
.hljs-link {
  color: #22863a;
}

.hljs-symbol,
.hljs-bullet,
.hljs-built_in,
.hljs-builtin-name {
  color: #e36209;
}

.hljs-meta,
.hljs-deletion {
  color: #b31d28;
}

.hljs-addition {
  color: #22863a;
}

.hljs-emphasis {
  font-style: italic;
}

.hljs-strong {
  font-weight: bold;
}

/* Markdown 样式增强 */
.content :deep(h1) {
  font-size: 2.5rem;
  font-weight: 700;
  margin: 2rem 0 1rem 0;
  color: var(--accent-color);
  border-bottom: 3px solid var(--accent-color);
  padding-bottom: 0.5rem;
}

.content :deep(h2) {
  font-size: 2rem;
  font-weight: 600;
  margin: 1.5rem 0 1rem 0;
  color: white;
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 0.3rem;
}

.content :deep(h3) {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 1.2rem 0 0.8rem 0;
  color: white;
}

.content :deep(h4) {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 1rem 0 0.5rem 0;
  color: white;
}

.content :deep(p) {
  margin: 1rem 0;
  line-height: 1.8;
  color: white;
}

.content :deep(ul), .content :deep(ol) {
  margin: 1rem 0;
  padding-left: 2rem;
  color: white;
}

.content :deep(li) {
  margin: 0.5rem 0;
  line-height: 1.6;
  color: white;
}

.content :deep(blockquote) {
  border-left: 4px solid #3182ce;
  background: rgba(247, 250, 252, 0.1);
  padding: 1rem 1.5rem;
  margin: 1.5rem 0;
  font-style: italic;
  color: white;
}

.content :deep(blockquote p) {
  margin: 0;
  color: white;
}

.content :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 1.5rem 0;
  background: rgba(0, 0, 0, 0.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  overflow: hidden;
}

.content :deep(th),
.content :deep(td) {
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 0.75rem;
  text-align: left;
  color: white;
}

.content :deep(th) {
  background: rgba(0, 0, 0, 0.2);
  font-weight: 600;
  color: white;
  border-bottom: 2px solid rgba(255, 255, 255, 0.3);
}

.content :deep(tr:nth-child(even)) {
  background: rgba(0, 0, 0, 0.05);
}

.content :deep(tr:hover) {
  background: rgba(0, 0, 0, 0.1);
}

.content :deep(code) {
  background: #f1f5f9 !important;
  padding: 0.2rem 0.4rem;
  border-radius: 4px;
  font-family: 'Fira Code', 'Monaco', 'Consolas', monospace;
  font-size: 0.9em;
  color: #e53e3e;
  border: 1px solid #e2e8f0;
}

.content :deep(pre) {
  background: #f8f9fa !important;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  padding: 1rem;
  overflow-x: auto;
  margin: 1.5rem 0;
}

.content :deep(pre code) {
  background: none;
  padding: 0;
  color: inherit;
  font-size: 0.9rem;
}

.content :deep(strong) {
  font-weight: 600;
  color: white;
}

.content :deep(em) {
  font-style: italic;
  color: white;
}

.content :deep(a) {
  color: #3182ce;
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s;
}

.content :deep(a:hover) {
  border-bottom-color: #3182ce;
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
  
  .content :deep(h1) {
    font-size: 2rem;
  }
  
  .content :deep(h2) {
    font-size: 1.5rem;
  }
  
  .content :deep(h3) {
    font-size: 1.25rem;
  }
  
  .content :deep(pre) {
    padding: 0.75rem;
    font-size: 0.8rem;
  }
  
  .content :deep(table) {
    font-size: 0.9rem;
  }
  
  .content :deep(th),
  .content :deep(td) {
    padding: 0.5rem;
  }
}
</style>