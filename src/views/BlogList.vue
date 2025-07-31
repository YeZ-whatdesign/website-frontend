<template>
  <div class="blog-list-page">
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
          <router-link to="/" class="nav-link active">博客</router-link>
        </div>
      </div>
    </nav>

    <!-- 页面头部 -->
    <section class="page-header">
      <div class="container">
        <h1>技术博客</h1>
        <p>分享最新的技术见解和行业动态</p>
      </div>
    </section>

    <!-- 博客列表 -->
    <section class="blog-list-section">
      <div class="container">
        <div class="blog-filters">
          <el-input
            v-model="searchQuery"
            placeholder="搜索博客..."
            prefix-icon="Search"
            class="search-input"
            @input="handleSearch"
          />
        </div>

        <div v-if="loading" class="loading">
          <el-skeleton :rows="3" animated />
        </div>

        <div v-else-if="filteredBlogs.length === 0" class="no-blogs">
          <el-empty description="暂无博客文章" />
        </div>

        <div v-else class="blog-grid">
          <div 
            v-for="blog in filteredBlogs" 
            :key="blog.id" 
            class="blog-card"
            @click="goToBlogDetail(blog.id)"
          >
            <div class="blog-image">
              <img :src="blog.image" :alt="blog.title" />
            </div>
            <div class="blog-content">
              <h3>{{ blog.title }}</h3>
              <p class="blog-excerpt">{{ blog.excerpt }}</p>
              <div class="blog-meta">
                <span class="blog-date">{{ formatDate(blog.created_at) }}</span>
                <span class="blog-author">{{ blog.author || '管理员' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div v-if="totalPages > 1" class="pagination">
          <el-pagination
            v-model:current-page="currentPage"
            :page-size="pageSize"
            :total="totalBlogs"
            layout="prev, pager, next"
            @current-change="handlePageChange"
          />
        </div>
      </div>
    </section>

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
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const blogs = ref([])
const loading = ref(true)
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(9)
const totalBlogs = ref(0)

const filteredBlogs = computed(() => {
  if (!searchQuery.value) {
    return blogs.value
  }
  return blogs.value.filter(blog => 
    blog.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    blog.excerpt.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const totalPages = computed(() => {
  return Math.ceil(totalBlogs.value / pageSize.value)
})

const loadBlogs = async () => {
  try {
    loading.value = true
    console.log('开始加载博客数据...')
    const response = await axios.get('/api/blog', {
      params: {
        page: currentPage.value,
        limit: pageSize.value
      }
    })
    
    console.log('API响应:', response.data)
    
    if (response.data.success) {
      // 处理图片URL
      blogs.value = response.data.posts.map(post => ({
        ...post,
        image: post.image ? post.image.replace('http://localhost:3001', '') : '/images/default-blog.jpg',
        excerpt: post.content ? post.content.substring(0, 150) + '...' : '暂无内容'
      }))
      totalBlogs.value = response.data.total || blogs.value.length
      console.log('博客数据加载成功:', blogs.value)
    } else {
      console.log('API返回失败状态')
      // 使用默认数据
      blogs.value = [
        {
          id: 1,
          title: '数据建模最佳实践',
          excerpt: '探讨现代数据建模的核心原则和实践方法，帮助企业构建高效的数据架构...',
          image: '/images/modeler.jpg',
          created_at: new Date().toISOString(),
          author: '技术团队'
        },
        {
          id: 2,
          title: '全栈开发技术栈选择',
          excerpt: '分析当前主流的全栈开发技术栈，为项目选择最适合的技术组合...',
          image: '/images/developer.jpg',
          created_at: new Date().toISOString(),
          author: '开发团队'
        },
        {
          id: 3,
          title: '数据可视化设计原则',
          excerpt: '深入了解数据可视化的设计原则，创建更有效的数据展示方案...',
          image: '/images/visualization.jpg',
          created_at: new Date().toISOString(),
          author: '设计团队'
        }
      ]
      totalBlogs.value = blogs.value.length
    }
  } catch (error) {
    console.error('加载博客失败:', error)
    console.error('错误详情:', error.response?.data || error.message)
    // 使用默认数据
    blogs.value = [
      {
        id: 1,
        title: '数据建模最佳实践',
        excerpt: '探讨现代数据建模的核心原则和实践方法，帮助企业构建高效的数据架构...',
        image: '/images/modeler.jpg',
        created_at: new Date().toISOString(),
        author: '技术团队'
      },
      {
        id: 2,
        title: '全栈开发技术栈选择',
        excerpt: '分析当前主流的全栈开发技术栈，为项目选择最适合的技术组合...',
        image: '/images/developer.jpg',
        created_at: new Date().toISOString(),
        author: '开发团队'
      },
      {
        id: 3,
        title: '数据可视化设计原则',
        excerpt: '深入了解数据可视化的设计原则，创建更有效的数据展示方案...',
        image: '/images/visualization.jpg',
        created_at: new Date().toISOString(),
        author: '设计团队'
      }
    ]
    totalBlogs.value = blogs.value.length
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  // 搜索功能已通过computed实现
}

const handlePageChange = (page) => {
  currentPage.value = page
  loadBlogs()
}

const goToBlogDetail = (id) => {
  // 检查当前是否在博客子域名下
  if (window.location.hostname.startsWith('blog.')) {
    router.push(`/${id}`)
  } else {
    router.push(`/blog/${id}`)
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

onMounted(() => {
  loadBlogs()
})
</script>

<style scoped>
/* 全局样式 */
.blog-list-page {
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

.nav-link:hover,
.nav-link.active {
  color: var(--accent-color);
}

/* 页面头部 */
.page-header {
  background: linear-gradient(135deg, var(--accent-color), var(--accent-hover));
  color: white;
  padding: 4rem 0;
  text-align: center;
}

.page-header h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  font-weight: 700;
}

.page-header p {
  font-size: 1.2rem;
  opacity: 0.9;
}

/* 容器 */
.container {
  max-width: 1200px;
  margin: 0 auto;
}

/* 博客列表区域 */
.blog-list-section {
  padding: 4rem 0;
}

.blog-filters {
  margin-bottom: 3rem;
  display: flex;
  justify-content: center;
}

.search-input {
  max-width: 400px;
}

.loading,
.no-blogs {
  text-align: center;
  padding: 3rem 0;
}

.blog-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 3rem;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
  justify-content: flex-start;
}

.blog-card {
  flex: 0 0 calc(33.333% - 1.33rem);
  min-width: 300px;
  background: var(--card-bg);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-dark);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color);
  cursor: pointer;
}

.blog-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.blog-image {
  height: 200px;
  overflow: hidden;
}

.blog-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.blog-card:hover .blog-image img {
  transform: scale(1.05);
}

.blog-content {
  padding: 1.5rem;
}

.blog-content h3 {
  font-size: 1.3rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
  line-height: 1.4;
}

.blog-excerpt {
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 1rem;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.blog-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.9rem;
  color: var(--text-muted);
}

.blog-date,
.blog-author {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 3rem;
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
@media (max-width: 768px) {
  .nav-container {
    padding: 0 1rem;
  }
  
  .nav-links {
    gap: 1rem;
  }
  
  .page-header h1 {
    font-size: 2rem;
  }
  
  .container {
    padding: 0 1rem;
  }
  
  .blog-grid {
    justify-content: center;
  }
  
  .blog-card {
    flex: 0 0 100%;
    min-width: unset;
  }
}

@media (max-width: 1024px) and (min-width: 769px) {
  .blog-card {
    flex: 0 0 calc(50% - 1rem);
  }
}

/* Element Plus 暗色主题覆盖 */
:deep(.el-input__wrapper) {
  background-color: var(--input-bg) !important;
  border-color: var(--border-color) !important;
}

:deep(.el-input__inner) {
  color: var(--text-primary) !important;
}

:deep(.el-pagination) {
  --el-pagination-text-color: var(--text-primary);
  --el-pagination-bg-color: var(--card-bg);
  --el-pagination-border-color: var(--border-color);
}
</style>