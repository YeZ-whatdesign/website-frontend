<template>
  <div class="admin-container">
    <!-- 登录页面 -->
    <div v-if="!isLoggedIn" class="login-page">
      <div class="login-form">
        <h2>CMS管理后台</h2>
        <el-form :model="loginForm" @submit.prevent="login">
          <el-form-item label="用户名">
            <el-input v-model="loginForm.username" placeholder="请输入用户名" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="login" :loading="loginLoading">登录</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <!-- 管理界面 -->
    <div v-else class="admin-dashboard">
      <div class="admin-header">
        <h1>CMS管理后台</h1>
        <el-button @click="logout">退出登录</el-button>
      </div>

      <el-tabs v-model="activeTab" class="admin-tabs">
        <!-- 博客管理 -->
        <el-tab-pane label="博客管理" name="blog">
          <div class="blog-management">
            <div class="blog-header">
              <h3>博客文章管理</h3>
              <el-button type="primary" @click="openBlogDialog()">新增文章</el-button>
            </div>

            <el-table :data="blogPosts" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="title" label="标题" />
              <el-table-column prop="author" label="作者" width="120" />
              <el-table-column prop="published" label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="scope.row.published ? 'success' : 'warning'">
                    {{ scope.row.published ? '已发布' : '草稿' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="created_at" label="创建时间" width="180">
                <template #default="scope">
                  {{ new Date(scope.row.created_at).toLocaleString('zh-CN') }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="200">
                <template #default="scope">
                  <el-button size="small" @click="openBlogDialog(scope.row)">编辑</el-button>
                  <el-button size="small" type="danger" @click="deleteBlogPost(scope.row.id)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>

            <el-pagination
              v-model:current-page="blogPagination.page"
              v-model:page-size="blogPagination.limit"
              :total="blogPagination.total"
              @current-change="loadBlogPosts"
              layout="total, prev, pager, next"
              style="margin-top: 20px; text-align: center;"
            />
          </div>
        </el-tab-pane>

        <!-- 内容管理 -->
        <el-tab-pane label="内容管理" name="content">
          <div class="content-management">
            <h3>页面内容管理</h3>
            <el-form :model="contentData" label-width="120px">
              <el-card style="margin-bottom: 20px;">
                <template #header>
                  <span>首页横幅</span>
                </template>
                <el-form-item label="标题">
                  <el-input v-model="contentData.hero.title" />
                </el-form-item>
                <el-form-item label="副标题">
                  <el-input v-model="contentData.hero.subtitle" type="textarea" :rows="2" />
                </el-form-item>
                <el-form-item label="背景图片">
                  <el-input v-model="contentData.hero.image" />
                </el-form-item>
              </el-card>

              <el-card style="margin-bottom: 20px;">
                <template #header>
                  <span>关于我们</span>
                </template>
                <el-form-item label="标题">
                  <el-input v-model="contentData.about.title" />
                </el-form-item>
                <el-form-item label="公司名称">
                  <el-input v-model="contentData.about.companyName" />
                </el-form-item>
                <el-form-item label="描述">
                  <el-input v-model="contentData.about.description" type="textarea" :rows="4" />
                </el-form-item>
                <el-form-item label="Logo">
                  <el-input v-model="contentData.about.logo" />
                </el-form-item>
              </el-card>

              <el-form-item>
                <el-button type="primary" @click="saveContent">保存内容</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 联系表单 -->
        <el-tab-pane label="联系表单" name="contacts">
          <div class="contacts-management">
            <h3>联系表单管理</h3>
            <el-table :data="contacts" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="name" label="姓名" width="120" />
              <el-table-column prop="email" label="邮箱" width="200" />
              <el-table-column prop="subject" label="主题" />
              <el-table-column prop="message" label="留言" show-overflow-tooltip />
              <el-table-column prop="created_at" label="提交时间" width="180">
                <template #default="scope">
                  {{ new Date(scope.row.created_at).toLocaleString('zh-CN') }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="100">
                <template #default="scope">
                  <el-button size="small" type="danger" @click="deleteContact(scope.row.id)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>

        <!-- 培训报名 -->
        <el-tab-pane label="培训报名" name="training">
          <div class="training-management">
            <h3>培训报名管理</h3>
            <el-table :data="trainingApplications" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="name" label="姓名" width="120" />
              <el-table-column prop="email" label="邮箱" width="200" />
              <el-table-column prop="phone" label="电话" width="150" />
              <el-table-column prop="degree" label="学校专业" />
              <el-table-column prop="message" label="留言" show-overflow-tooltip />
              <el-table-column prop="created_at" label="报名时间" width="180">
                <template #default="scope">
                  {{ new Date(scope.row.created_at).toLocaleString('zh-CN') }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="100">
                <template #default="scope">
                  <el-button size="small" type="danger" @click="deleteTrainingApplication(scope.row.id)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 博客编辑对话框 -->
    <el-dialog v-model="blogDialogVisible" :title="editingBlog.id ? '编辑文章' : '新增文章'" width="80%">
      <el-form :model="editingBlog" label-width="100px">
        <el-form-item label="标题">
          <el-input v-model="editingBlog.title" />
        </el-form-item>
        <el-form-item label="摘要">
          <el-input v-model="editingBlog.excerpt" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="editingBlog.author" />
        </el-form-item>
        <el-form-item label="封面图片">
          <div style="display: flex; gap: 10px; align-items: flex-start;">
            <el-input v-model="editingBlog.image" placeholder="图片URL" style="flex: 1;" />
            <el-upload
              :action="uploadUrl"
              :headers="uploadHeaders"
              :show-file-list="false"
              :on-success="handleImageUploadSuccess"
              :on-error="handleImageUploadError"
              :before-upload="beforeImageUpload"
              name="image"
              accept="image/*"
            >
              <el-button type="primary">上传图片</el-button>
            </el-upload>
          </div>
          <div v-if="editingBlog.image" style="margin-top: 10px;">
            <img :src="editingBlog.image" style="max-width: 200px; max-height: 150px; border-radius: 4px;" />
          </div>
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="editingBlog.content" type="textarea" :rows="10" />
        </el-form-item>
        <el-form-item label="发布状态">
          <el-switch v-model="editingBlog.published" active-text="发布" inactive-text="草稿" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="blogDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveBlogPost">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'

// 响应式数据
const isLoggedIn = ref(false)
const activeTab = ref('blog')
const loginLoading = ref(false)

const loginForm = ref({
  username: '',
  password: ''
})

const blogPosts = ref([])
const blogPagination = ref({
  page: 1,
  limit: 10,
  total: 0
})

const contacts = ref([])
const trainingApplications = ref([])

const contentData = ref({
  hero: {
    title: '',
    subtitle: '',
    image: ''
  },
  about: {
    title: '',
    companyName: '',
    description: '',
    logo: ''
  }
})

const blogDialogVisible = ref(false)
const editingBlog = ref({
  id: null,
  title: '',
  excerpt: '',
  content: '',
  image: '',
  author: '',
  published: false
})

// 上传相关
const uploadUrl = `${import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001'}/api/cms/upload`
const uploadHeaders = ref({})

// 更新上传headers
const updateUploadHeaders = () => {
  const token = localStorage.getItem('token')
  if (token) {
    uploadHeaders.value = {
      'Authorization': `Bearer ${token}`
    }
  }
}

// 方法
const login = async () => {
  loginLoading.value = true
  try {
    const response = await axios.post('/api/auth/login', loginForm.value)
    localStorage.setItem('token', response.data.token)
    axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`
    updateUploadHeaders() // 更新上传headers
    isLoggedIn.value = true
    ElMessage.success('登录成功')
    loadData()
  } catch (error) {
    ElMessage.error('登录失败：' + (error.response?.data?.error || '未知错误'))
  } finally {
    loginLoading.value = false
  }
}

const logout = () => {
  localStorage.removeItem('token')
  delete axios.defaults.headers.common['Authorization']
  isLoggedIn.value = false
  ElMessage.success('已退出登录')
}

const checkAuth = async () => {
  const token = localStorage.getItem('token')
  if (token) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    updateUploadHeaders() // 更新上传headers
    try {
      await axios.get('/api/auth/verify')
      isLoggedIn.value = true
      loadData()
    } catch (error) {
      localStorage.removeItem('token')
      delete axios.defaults.headers.common['Authorization']
      uploadHeaders.value = {} // 清空上传headers
    }
  }
}

const loadData = () => {
  loadBlogPosts()
  loadContacts()
  loadTrainingApplications()
  loadContent()
}

const loadBlogPosts = async () => {
  try {
    const response = await axios.get(`/api/blog/admin/all?page=${blogPagination.value.page}&limit=${blogPagination.value.limit}`)
    blogPosts.value = response.data.posts
    blogPagination.value = response.data.pagination
  } catch (error) {
    ElMessage.error('加载博客文章失败')
  }
}

const loadContacts = async () => {
  try {
    const response = await axios.get('/api/cms/contacts')
    contacts.value = response.data
  } catch (error) {
    ElMessage.error('加载联系表单失败')
  }
}

const loadTrainingApplications = async () => {
  try {
    const response = await axios.get('/api/cms/training-applications')
    trainingApplications.value = response.data
  } catch (error) {
    ElMessage.error('加载培训报名失败')
  }
}

const loadContent = async () => {
  try {
    const response = await axios.get('/api/cms/content')
    if (response.data.hero) contentData.value.hero = response.data.hero
    if (response.data.about) contentData.value.about = response.data.about
  } catch (error) {
    ElMessage.error('加载内容失败')
  }
}

const openBlogDialog = (blog = null) => {
  if (blog) {
    editingBlog.value = { ...blog }
  } else {
    editingBlog.value = {
      id: null,
      title: '',
      excerpt: '',
      content: '',
      image: '',
      author: '',
      published: false
    }
  }
  blogDialogVisible.value = true
}

const saveBlogPost = async () => {
  try {
    if (editingBlog.value.id) {
      await axios.put(`/api/blog/${editingBlog.value.id}`, editingBlog.value)
      ElMessage.success('文章更新成功')
    } else {
      await axios.post('/api/blog', editingBlog.value)
      ElMessage.success('文章创建成功')
    }
    blogDialogVisible.value = false
    loadBlogPosts()
  } catch (error) {
    ElMessage.error('保存失败：' + (error.response?.data?.error || '未知错误'))
  }
}

const deleteBlogPost = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这篇文章吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await axios.delete(`/api/blog/${id}`)
    ElMessage.success('删除成功')
    loadBlogPosts()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const deleteContact = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这条联系记录吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await axios.delete(`/api/cms/contacts/${id}`)
    ElMessage.success('删除成功')
    loadContacts()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const deleteTrainingApplication = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这条培训报名记录吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await axios.delete(`/api/cms/training-applications/${id}`)
    ElMessage.success('删除成功')
    loadTrainingApplications()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const saveContent = async () => {
  try {
    await axios.put('/api/cms/content/hero', { data: contentData.value.hero })
    await axios.put('/api/cms/content/about', { data: contentData.value.about })
    ElMessage.success('内容保存成功')
  } catch (error) {
    ElMessage.error('保存失败：' + (error.response?.data?.error || '未知错误'))
  }
}

// 图片上传处理方法
const beforeImageUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  
  // 更新上传headers
  updateUploadHeaders()
  return true
}

const handleImageUploadSuccess = (response) => {
  if (response.success) {
    editingBlog.value.image = response.url
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error('图片上传失败：' + (response.error || '未知错误'))
  }
}

const handleImageUploadError = (error) => {
  console.error('上传错误:', error)
  ElMessage.error('图片上传失败，请重试')
}

onMounted(() => {
  checkAuth()
})
</script>

<style scoped>
.admin-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.login-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

.login-form {
  background: white;
  padding: 40px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  width: 400px;
}

.login-form h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}

.admin-dashboard {
  padding: 20px;
}

.admin-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.admin-header h1 {
  margin: 0;
  color: #333;
}

.admin-tabs {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.blog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.blog-header h3 {
  margin: 0;
  color: #333;
}

.content-management h3,
.contacts-management h3,
.training-management h3 {
  margin-bottom: 20px;
  color: #333;
}
</style>