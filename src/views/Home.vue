<template>
  <div class="home">
    <!-- 导航栏 -->
    <nav class="navbar">
      <div class="nav-container">
        <div class="nav-logo">
          <img src="/images/logo_198x72.png" alt="几何原本" />
        </div>
        <ul class="nav-menu" :class="{ 'nav-menu-mobile': mobileMenuOpen }">
          <li><a href="#about" @click="scrollToSection('about'); mobileMenuOpen = false">关于我们</a></li>
          <li><a href="#services" @click="scrollToSection('services'); mobileMenuOpen = false">产品展示</a></li>
          <li><a href="#cases" @click="scrollToSection('cases'); mobileMenuOpen = false">客户案例</a></li>
          <li><a href="#training" @click="scrollToSection('training'); mobileMenuOpen = false">培训服务</a></li>
          <li><a href="#contact" @click="scrollToSection('contact'); mobileMenuOpen = false">联系我们</a></li>
          <li><a href="//blog.what-tech.cn" target="_blank" @click="mobileMenuOpen = false">博客</a></li>
          <li><a href="//forum.what-tech.cn" target="_blank" @click="mobileMenuOpen = false">论坛</a></li>
        </ul>
        <div class="nav-toggle" @click="toggleMobileMenu">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </nav>

    <!-- 英雄区域 -->
    <section class="hero">
      <div class="hero-background">
        <div class="hero-overlay"></div>
        <!-- 粒子效果容器 -->
        <div class="particles-container" ref="particlesContainer">
          <canvas ref="particlesCanvas" class="particles-canvas"></canvas>
        </div>
      </div>
      <div class="hero-container">
        <div class="hero-content">
          <div class="hero-text">
            <h1>{{ heroData.title }}</h1>
            <p>{{ heroData.subtitle }}</p>
            <div class="hero-buttons">
              <el-button type="primary" size="large" @click="scrollToSection('about')">
                了解更多
              </el-button>
              <el-button size="large" class="hero-btn-secondary" @click="scrollToSection('contact')">
                联系我们
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 关于我们 -->
    <section id="about" class="about">
      <div class="container">
        <h2>{{ aboutData.title }}</h2>
        <div class="about-content">
          <div class="about-text">
            <div class="company-logo">
              <img :src="aboutData.logo" alt="几何原本" />
            </div>
            <p>{{ aboutData.description }}</p>
            <h4>{{ aboutData.companyName }}</h4>
          </div>
          
          <!-- 服务内容 - 按照1.html的布局方式 -->
          <div class="services-content-simple">
            <div class="service-simple-item">
              <img src="/images/logo_CAS.png" alt="计算机辅助样式设计" />
              <h3>计算机辅助样式设计</h3>
              <p>基于丰富的三维想象力，利用先进的软件工具将设计概念转化为具体的三维设计并实现需要的造型样式。</p>
            </div>
            
            <div class="service-simple-item">
              <img src="/images/logo_Class-A.png" alt="Class-A曲面开发" />
              <h3>Class-A曲面开发</h3>
              <p>基于丰富的工程及美学经验，将概念模型开发为满足量产需求的高精度曲面造型数据。</p>
            </div>
            
            <div class="service-simple-item">
              <img src="/images/logo_Visualization.png" alt="实时产品可视化" />
              <h3>实时产品可视化</h3>
              <p>基于优美的展示呈现，利用精确的材质、逼真的光照还原产品设计真实的情感表达，辅助获得准确快速的设计决策。</p>
            </div>
            
            <div class="service-simple-item">
              <img src="/images/logo_Develop.png" alt="软件技术开发" />
              <h3>软件技术开发</h3>
              <p>基于与客户及软件技术巨头长年的合作，精通工业软件技术需求分析，并具备创新性的软件技术开发能力。</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 产品展示 -->
    <section id="services" class="services">
      <div class="container">
        <h2>产品展示</h2>
        <div class="services-content">
          <div class="streaming-intro">
            <h3>{{ streamingData.title }}</h3>
            <h4>{{ streamingData.subtitle }}</h4>
            <p>{{ streamingData.description }}</p>
          </div>
          <div class="streaming-solutions">
            <div v-for="(solution, index) in streamingData.solutions" :key="solution.id" class="uiverse-card uiverse-card-hover solution-item">
              <img :src="solution.image" :alt="solution.name" />
              <h5>{{ solution.name }}</h5>
              <p class="solution-scenarios">{{ solution.scenarios }}</p>
              <p>{{ solution.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 客户案例 -->
    <section id="cases" class="clients">
      <div class="container">
        <h2>{{ clientsData.title }}</h2>
        <p class="section-subtitle">{{ clientsData.subtitle }}</p>
        <div class="clients-grid">
          <div v-for="(client, index) in clientsData.clients" :key="client.id" class="uiverse-card uiverse-card-hover client-item">
            <div class="client-logo">
              <img :src="client.logo" :alt="client.name" />
            </div>
            <div class="client-info">
              <h4>{{ client.name }}</h4>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 培训服务 -->
    <section id="training" class="training">
      <div class="container">
        <h2>线下能力培训</h2>
        <div class="training-grid">
          <div v-for="(course, index) in trainingData" :key="course.id" class="uiverse-card uiverse-card-hover training-item">
            <h3>{{ course.name }}</h3>
            <div class="price">{{ course.price }}</div>
            <ul class="features">
              <li v-for="feature in course.features" :key="feature">{{ feature }}</li>
            </ul>
            <el-button type="primary" @click="openTrainingForm">参加课程</el-button>
          </div>
        </div>
      </div>
    </section>

    <!-- 博客模块 -->
    <section id="blog" class="blog">
      <div class="container">
        <h2>最新博客</h2>
        <div class="blog-grid">
          <div v-for="(post, index) in blogData" :key="post.id" class="uiverse-card uiverse-card-hover blog-item" @click="goToBlogDetail(post.id)">
            <img :src="post.image" :alt="post.title" />
            <div class="blog-content">
              <h4>{{ post.title }}</h4>
              <p>{{ post.excerpt }}</p>
              <div class="blog-meta">
                <span>{{ post.date }}</span>
                <span>{{ post.author }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="blog-actions">
          <el-button type="primary" @click="goToBlogList">查看更多博客</el-button>
        </div>
      </div>
    </section>

    <!-- 加入我们 -->
    <section id="careers" class="careers">
      <div class="container">
        <h2>{{ careersData.title }}</h2>
        <p class="section-subtitle">{{ careersData.subtitle }}</p>
        
        <!-- 简化的职位列表 -->
        <div class="careers-simple">
          <div v-for="(job, index) in careersData.jobs" :key="job.id" class="uiverse-card uiverse-card-hover career-simple-item">
            <img :src="job.image" :alt="job.title" class="career-simple-image" />
            <h3 class="career-simple-title">{{ job.title }}</h3>
            
            <div class="career-simple-content">
              <div class="career-simple-salary">
                <strong>薪资待遇：</strong><br>
                {{ job.salary.join(' / ') }}
              </div>
              
              <div class="career-simple-requirements">
                <strong>职位需求：</strong><br>
                <span v-for="(requirement, index) in job.requirements" :key="index">
                  • {{ requirement }}<br>
                </span>
              </div>
              
              <div v-if="job.training" class="career-simple-training">
                <strong>无基础技能培训：</strong><br>
                {{ job.training.join('、') }}
              </div>
            </div>
            
            <button class="career-simple-btn" @click="openJobForm(job.title)">立即申请</button>
          </div>
        </div>
      </div>
    </section>

    <!-- 客户感言 -->
    <section class="testimonials">
      <div class="container">
        <h2>客户感言</h2>
        <div class="testimonials-slider">
          <div v-for="(testimonial, index) in testimonialsData" :key="testimonial.id" 
               class="testimonial-item">
            <div class="quote-icon">
              <el-icon><ChatDotRound /></el-icon>
            </div>
            <p>{{ testimonial.content }}</p>
            <div class="testimonial-author">
              <img :src="testimonial.avatar" :alt="testimonial.name" />
              <div>
                <h5>{{ testimonial.name }}</h5>
                <span>{{ testimonial.title }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 联系我们 -->
    <section id="contact" class="contact">
      <div class="container">
        <h2>联系我们</h2>
        <div class="contact-content">
          <div class="contact-info">
            <div class="contact-item">
              <h4>电话号码</h4>
              <p><a href="tel:+8613817009133">培训报名</a></p>
              <p><a href="tel:+8613817009133">联系热线</a></p>
            </div>
            <div class="contact-item">
              <h4>电子邮箱</h4>
              <p><a href="mailto:hello@what-design.cn">培训咨询</a></p>
              <p><a href="mailto:sales@what-design.cn">业务咨询</a></p>
            </div>
            <div class="contact-item">
              <h4>地址</h4>
              <p>上海·嘉定<br>安亭新镇·万创坊·526</p>
            </div>
            <div class="contact-item">
              <h4>工作时间</h4>
              <p>GMT+8 9:00am – 6:00pm<br>GMT+5.5 5:30am – 2:30pm</p>
            </div>
          </div>
          <div class="contact-form">
            <h3>与我们联系</h3>
            <el-form :model="contactForm" label-position="top">
              <el-form-item label="姓名">
                <el-input v-model="contactForm.name" placeholder="请输入您的姓名" />
              </el-form-item>
              <el-form-item label="邮箱">
                <el-input v-model="contactForm.email" type="email" placeholder="请输入您的邮箱" />
              </el-form-item>
              <el-form-item label="主题">
                <el-input v-model="contactForm.subject" placeholder="请输入主题" />
              </el-form-item>
              <el-form-item label="留言">
                <el-input v-model="contactForm.message" type="textarea" :rows="4" placeholder="请输入您的留言" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="submitContact">发送</el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-logo">
            <img src="/images/logo_white_only_640x640.png" alt="几何原本" />
            <span>几何原本</span>
          </div>
          <p>&copy; 2024 上海几何原本科技有限公司. 保留所有权利.</p>
        </div>
      </div>
    </footer>

    <!-- 培训报名弹窗 -->
    <el-dialog v-model="trainingDialogVisible" title="培训报名" width="500px">
      <el-form :model="trainingForm" label-position="top">
        <el-form-item label="姓名">
          <el-input v-model="trainingForm.name" placeholder="请输入您的姓名" />
        </el-form-item>
        <el-form-item label="学校及专业">
          <el-input v-model="trainingForm.degree" placeholder="请输入学校及专业" />
        </el-form-item>
        <el-form-item label="移动电话">
          <el-input v-model="trainingForm.phone" placeholder="请输入手机号码" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="trainingForm.email" type="email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="职位意向及其他信息">
          <el-input v-model="trainingForm.message" type="textarea" :rows="4" placeholder="请输入职位意向、工作经历等信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="trainingDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitTraining">提交报名</el-button>
      </template>
    </el-dialog>

    <!-- 求职申请对话框 -->
    <el-dialog v-model="jobDialogVisible" :title="`申请职位：${selectedJobTitle}`" width="500px">
      <el-form :model="jobForm" label-position="top">
        <el-form-item label="姓名">
          <el-input v-model="jobForm.name" placeholder="请输入您的姓名" />
        </el-form-item>
        <el-form-item label="学校及专业">
          <el-input v-model="jobForm.degree" placeholder="请输入学校及专业" />
        </el-form-item>
        <el-form-item label="移动电话">
          <el-input v-model="jobForm.phone" placeholder="请输入手机号码" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="jobForm.email" type="email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="自我介绍">
          <el-input v-model="jobForm.message" type="textarea" :rows="4" placeholder="请简单介绍一下您的经验和技能" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="jobDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitJob">提交申请</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ChatDotRound } from '@element-plus/icons-vue'
import axios from 'axios'

export default {
  name: 'Home',
  components: {
    ChatDotRound
  },
  setup() {
    const router = useRouter()
    const trainingDialogVisible = ref(false)
    const jobDialogVisible = ref(false)
    const selectedJobTitle = ref('')
    const mobileMenuOpen = ref(false)
    
    // 粒子效果相关
    const particlesContainer = ref(null)
    const particlesCanvas = ref(null)
    let particlesAnimation = null
    let particles = []
    
    // 滚动动画相关
    let observer = null
    
    // 表单数据
    const contactForm = reactive({
      name: '',
      email: '',
      subject: '',
      message: ''
    })
    
    const trainingForm = reactive({
      name: '',
      degree: '',
      phone: '',
      email: '',
      message: ''
    })

    const jobForm = reactive({
      name: '',
      degree: '',
      phone: '',
      email: '',
      message: '',
      position: ''
    })

    // 页面数据
    const heroData = ref({
      title: '几何原本 - 专业汽车设计服务',
      subtitle: '计算机辅助样式设计 | Class-A曲面开发 | 实时产品可视化 | 软件技术开发',
      backgroundImage: '/images/background.png'
    })

    const aboutData = ref({
      title: '关于我们 About US',
      logo: '/images/logo_horizontal.png',
      description: '几何原本（What Tech）前身是2017年成立的设计机构乜也设计（What Design），后因公司技术及业务发展需要更名为几何原本。创始人（黑暗森霖）与国际软件巨头其下高端工业设计品牌有长年的深入合作，主要从事计算机辅助样式设计、Class-A曲面开发、实时产品可视化及相关软件技术开发及培训。',
      companyName: '上海几何原本科技有限公司 Shanghai What Technology Co.,Ltd',
      services: [
        {
          id: 1,
          name: '计算机辅助样式设计',
          icon: '/images/logo_CAS.png',
          description: '基于丰富的三维想象力，利用先进的软件工具将设计概念转化为具体的三维设计并实现需要的造型样式。'
        },
        {
          id: 2,
          name: 'Class-A曲面开发',
          icon: '/images/logo_Class-A.png',
          description: '基于丰富的工程及美学经验，将概念模型开发为满足量产需求的高精度曲面造型数据。'
        },
        {
          id: 3,
          name: '实时产品可视化',
          icon: '/images/logo_Visualization.png',
          description: '基于优美的展示呈现，利用精确的材质、逼真的光照还原产品设计真实的情感表达，辅助获得准确快速的设计决策。'
        },
        {
          id: 4,
          name: '软件技术开发',
          icon: '/images/logo_Develop.png',
          description: '基于与客户及软件技术巨头长年的合作，精通工业软件技术需求分析，并具备创新性的软件技术开发能力。'
        }
      ]
    })

    const streamingData = ref({
      title: '流媒体 Streaming',
      subtitle: '迎接品牌展示的未来',
      description: '在线营销一直是企业品牌、产品推广重要的手段，利用最新的媒体技术吸引客户的关注度可以为产品销售带来可观的增长。几何原本深知客户对产品展示效果的挑剔需求，同时要求在线系统能长时间稳定地为用户提供良好的体验。',
      solutions: [
        {
          id: 1,
          name: '门店大屏',
          image: '/images/car_dealership.jpg',
          scenarios: '4S门店大厅 | 产品展厅 | 迎客大厅',
          description: '高效提供细致的产品介绍，用户可通过触控屏自助选配，支持VR、裸眼3D体验及平板AR'
        },
        {
          id: 2,
          name: '无人数字网点',
          image: '/images/automated_checkout_store.jpg',
          scenarios: '无人销售网点 | 街道互动展示',
          description: '无需人员值守的数字网点，降低门店建设费用，兼容各种智能服务程序及机器人'
        },
        {
          id: 3,
          name: '传统广告',
          image: '/images/traditional_advertising.jpg',
          scenarios: '街道屏幕 | 电梯广告 | 海报 | 传单',
          description: '随时随地获得高质量的互动内容，支持二维码访问、内置小程序，增加广告信任、增强引流'
        }
      ]
    })

    const clientsData = ref({
      title: '客户案例 Clients',
      subtitle: '与行业领导者共同成长',
      clients: [
        {
          id: 1,
          name: '大众汽车',
          logo: '/images/Volkswagen_logo.png',
          description: '与大众汽车在设计领域深度合作'
        },
        {
          id: 2,
          name: '小米',
          logo: '/images/XiaoMi_logo.png',
          description: '为小米提供专业的设计咨询服务'
        },
        {
          id: 3,
          name: '吉利汽车',
          logo: '/images/Geely_logo.png',
          description: '与吉利汽车在汽车设计方面合作'
        },
        {
          id: 4,
          name: '广汽集团',
          logo: '/images/GAC_logo.png',
          description: '为广汽集团提供产品开发和设计支持'
        },
        {
          id: 5,
          name: '上汽集团',
          logo: '/images/SAIC_logo.png',
          description: '与上汽集团在汽车设计领域合作'
        },
        {
          id: 6,
          name: '一汽集团',
          logo: '/images/FAW_logo.png',
          description: '与一汽集团在汽车设计方面合作'
        }
      ]
    })

    const trainingData = ref([
      {
        id: 1,
        name: '创意·三维设计',
        price: '￥2,998.00/人',
        features: [
          '80小时实训内容',
          '3种产品设计类型',
          'Alias Subdivision',
          '需自备笔记本工作站',
          '第二次参加·更优惠'
        ]
      },
      {
        id: 2,
        name: '极致·曲面光顺',
        price: '￥5,998.00/人',
        features: [
          '168小时实训内容',
          '全套汽车内外饰',
          'Alias Class-A Surfacing',
          '需自备笔记本工作站',
          '第二次参加·半价'
        ]
      },
      {
        id: 3,
        name: '实时·品质呈现',
        price: '￥8,998.00/人',
        features: [
          '80小时实训内容',
          '2全套汽车内外饰',
          'VRED Professional',
          '包含图形工作站费用',
          '第二次参加·半价'
        ]
      }
    ])

    const blogData = ref([])

    const testimonialsData = ref([
      {
        id: 1,
        content: '实时三维设计过程需要优质的可视化，它可以帮助设计团队了解实际的设计效果实时作出修改，并以此作出准确的设计决策！',
        name: '野大师',
        title: '资深·三维设计师',
        avatar: '/images/logo_white_only_640x640.png'
      },
      {
        id: 2,
        content: '除了获得准确的反射，光线追踪真正的作用是可以获得准确的材质、阴影效果。基于实时光线追踪技术的CMF验证流程可以通过最新的OpenXR设备获得逼真的视觉情感，这是绝佳的设计效率工具！',
        name: 'Willis',
        title: '资深·CGer',
        avatar: '/images/logo_white_only_640x640.png'
      }
    ])

    const careersData = ref({
      title: '加入我们 Join us',
      subtitle: '与我们一起创造汽车设计的未来',
      jobs: [
        {
          id: 1,
          title: '三维设计师（CAS / CLASS-A）',
          image: '/images/modeler.jpg',
          requirements: [
            '工艺美术或工业设计类专业优先',
            '热爱各类三维数字艺术及设计',
            '熟练掌握 Alias（优先）Rhino3D（优先）Cinema4D Maya Blender 以上任一三维曲面或多边形建模工具',
            '负责汽车、工业设计等产品三维设计'
          ],
          salary: [
            '应届毕业月薪5k起，2年以上从业经验者薪资面议'
          ],
          training: [
            '基础3K，中级6K，各阶段4周'
          ]
        },
        {
          id: 2,
          title: '可视化设计师（汽车 / 产品）',
          image: '/images/visualization.jpg',
          requirements: [
            '摄影、美术或工业设计类专业优先',
            '热爱各类三维数字图形艺术、摄影',
            '熟练掌握VRED Unreal-Engine Cinema4D Blender Maya以上任一渲染工具',
            '负责汽车、工业设计产品、建筑场景等进行高品质静态或动画渲染'
          ],
          salary: [
            '应届毕业月薪5k起，2年以上从业经验者薪资面议'
          ],
          training: [
            '基础入门到中级8.5K，共4周'
          ]
        },
        {
          id: 3,
          title: '软件技术开发',
          image: '/images/developer.jpg',
          requirements: [
            '计算机、软件工程、信息技术等相关专业，本科及以上学历，有数学、力学、机械工程相关专业背景者优先考虑',
            '3年以上C/C++软件工程开发经验, 熟练掌握C/C++及软件设计模式，了解计算机几何引擎、可视化引擎',
            '负责工业设计软件、数字孪生应用程序开发',
            '另外需要负责软件代码开发和测试工作的产品经理',
            '支撑完成软件产品和项目的需求分析和功能设计'
          ],
          salary: [
            '3年以上从业经验者，薪资面议',
            '无技能基础暂不接纳'
          ]
        }
      ]
    })

    // 方法
    const scrollToSection = (sectionId) => {
      const element = document.getElementById(sectionId)
      if (element) {
        element.scrollIntoView({ behavior: 'smooth' })
      }
    }

    const toggleMobileMenu = () => {
      mobileMenuOpen.value = !mobileMenuOpen.value
    }

    const openTrainingForm = () => {
      trainingDialogVisible.value = true
    }

    const openJobForm = (jobTitle) => {
      selectedJobTitle.value = jobTitle
      jobForm.position = jobTitle
      jobDialogVisible.value = true
    }

    const submitContact = async () => {
      try {
        await axios.post('/api/contact', contactForm)
        ElMessage.success('消息发送成功！')
        Object.keys(contactForm).forEach(key => contactForm[key] = '')
      } catch (error) {
        ElMessage.error('发送失败，请稍后重试')
      }
    }

    const submitTraining = async () => {
      try {
        await axios.post('/api/training', trainingForm)
        ElMessage.success('报名提交成功！')
        trainingDialogVisible.value = false
        Object.keys(trainingForm).forEach(key => trainingForm[key] = '')
      } catch (error) {
        ElMessage.error('提交失败，请稍后重试')
      }
    }

    const submitJob = async () => {
      try {
        await axios.post('/api/jobs', jobForm)
        ElMessage.success('求职申请提交成功！')
        jobDialogVisible.value = false
        Object.keys(jobForm).forEach(key => jobForm[key] = '')
      } catch (error) {
        ElMessage.error('提交失败，请稍后重试')
      }
    }

    // 博客跳转方法
    const goToBlogList = () => {
      // router.push('/blog')
      window.open('//blog.what-tech.cn')
    }

    const goToBlogDetail = (id) => {
      router.push(`/blog/${id}`)
    }

    // 加载CMS数据
    const loadCMSData = async () => {
      try {
        const response = await axios.get('/api/cms/content')
        if (response.data) {
          // 更新页面数据
          if (response.data.hero) heroData.value = response.data.hero
          if (response.data.about) aboutData.value = response.data.about
          if (response.data.streaming) streamingData.value = response.data.streaming
          if (response.data.clients) clientsData.value = response.data.clients
          if (response.data.training) trainingData.value = response.data.training
          if (response.data.testimonials) testimonialsData.value = response.data.testimonials
        }
      } catch (error) {
        console.log('使用默认数据')
      }
    }

    // 加载博客数据
    const loadBlogData = async () => {
      try {
        const response = await axios.get('/api/blog?limit=3')
        if (response.data && response.data.posts) {
          blogData.value = response.data.posts.map(post => {
            // 将完整URL转换为相对路径以使用代理
            let imageUrl = post.image || '/images/default-blog.jpg'
            const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001'
            if (imageUrl.startsWith(apiBaseUrl)) {
              imageUrl = imageUrl.replace(apiBaseUrl, '')
            }
            
            return {
              id: post.id,
              title: post.title,
              excerpt: post.excerpt,
              image: imageUrl,
              date: new Date(post.created_at).toLocaleDateString('zh-CN'),
              author: post.author
            }
          })
        }
      } catch (error) {
        console.log('加载博客数据失败，使用默认数据')
        // 如果API失败，使用默认数据
        blogData.value = [
          {
            id: 1,
            title: '汽车设计的未来趋势',
            excerpt: '探讨电动汽车时代的设计理念和技术创新...',
            image: '/images/modeler.jpg',
            date: '2024-01-15',
            author: '设计团队'
          },
          {
            id: 2,
            title: 'Class-A曲面建模技巧',
            excerpt: '分享专业的曲面建模方法和实战经验...',
            image: '/images/developer.jpg',
            date: '2024-01-10',
            author: '技术团队'
          },
          {
            id: 3,
            title: '实时渲染在汽车展示中的应用',
            excerpt: '介绍最新的实时渲染技术在汽车营销中的应用...',
            image: '/images/visualization.jpg',
            date: '2024-01-05',
            author: '可视化团队'
          }
        ]
      }
    }

    let cardObserver = null
    // 卡片滚动动画
    const initCardScrollAnimations = () => {
      cardObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('uiverse-card-visible')
            entry.target.classList.remove('uiverse-card-hide')
            cardObserver.unobserve(entry.target)
          }
        })
      }, {
        threshold: 0.15,
        rootMargin: '0px 0px -40px 0px'
      })
      const cards = document.querySelectorAll('.uiverse-card')
      cards.forEach(card => {
        card.classList.add('uiverse-card-hide')
        cardObserver.observe(card)
      })
    }

    // 点击外部关闭移动端菜单
    const handleClickOutside = (event) => {
      const navMenu = document.querySelector('.nav-menu')
      const navToggle = document.querySelector('.nav-toggle')
      
      if (mobileMenuOpen.value && 
          navMenu && 
          !navMenu.contains(event.target) && 
          navToggle && 
          !navToggle.contains(event.target)) {
        mobileMenuOpen.value = false
      }
    }

    onMounted(() => {
      loadCMSData()
      loadBlogData()
      // 延迟初始化动画，确保DOM已渲染
      setTimeout(() => {
        initParticles()
        initCardScrollAnimations()
      }, 100)
      
      // 添加点击外部关闭菜单的事件监听
      document.addEventListener('click', handleClickOutside)
    })

    onUnmounted(() => {
      // 清理粒子效果
      cleanupParticles()
      if (cardObserver) cardObserver.disconnect()
      
      // 移除事件监听
      document.removeEventListener('click', handleClickOutside)
    })

    return {
      // 粒子效果引用
      particlesContainer,
      particlesCanvas,
      // 对话框状态
      trainingDialogVisible,
      jobDialogVisible,
      selectedJobTitle,
      mobileMenuOpen,
      // 表单数据
      contactForm,
      trainingForm,
      jobForm,
      // 页面数据
      heroData,
      aboutData,
      streamingData,
      clientsData,
      trainingData,
      blogData,
      testimonialsData,
      careersData,
      // 方法
      scrollToSection,
      toggleMobileMenu,
      openTrainingForm,
      openJobForm,
      submitContact,
      submitTraining,
      submitJob,
      goToBlogList,
      goToBlogDetail
    }
  }
}
</script>

<style scoped>
/* 导航栏样式 */
.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  background: var(--bg-secondary);
  backdrop-filter: blur(10px);
  z-index: 1000;
  padding: 1rem 0;
  border-bottom: 1px solid var(--border-color);
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 2rem;
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.5rem;
  font-weight: bold;
  color: var(--text-primary);
}

.nav-logo img {
  height: 40px;
}

.nav-menu {
  display: flex;
  list-style: none;
  gap: 2rem;
}

.nav-menu a {
  text-decoration: none;
  color: var(--text-secondary);
  font-weight: 500;
  transition: color 0.3s;
}

.nav-menu a:hover {
  color: var(--accent-color);
}

.nav-toggle {
  display: none;
  flex-direction: column;
  cursor: pointer;
}

.nav-toggle span {
  width: 25px;
  height: 3px;
  background: var(--text-primary);
  margin: 3px 0;
  transition: 0.3s;
}

/* 移动端菜单样式 */
@media (max-width: 768px) {
  .nav-toggle {
    display: flex;
  }
  
  .nav-menu {
    position: fixed;
    top: 70px;
    left: -100%;
    width: 100%;
    height: calc(100vh - 70px);
    background: var(--bg-secondary);
    backdrop-filter: blur(10px);
    flex-direction: column;
    justify-content: flex-start;
    align-items: center;
    padding-top: 2rem;
    transition: left 0.3s ease;
    z-index: 999;
    border-top: 1px solid var(--border-color);
  }
  
  .nav-menu-mobile {
    left: 0;
  }
  
  .nav-menu li {
    margin: 1rem 0;
  }
  
  .nav-menu a {
    font-size: 1.2rem;
    padding: 1rem 2rem;
    display: block;
    width: 100%;
    text-align: center;
    border-bottom: 1px solid var(--border-color);
  }
  
  .nav-menu a:hover {
    background: var(--accent-color);
    color: white;
  }
}

/* 英雄区域 */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('/images/background.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  filter: blur(8px);
  transform: scale(1.1);
  z-index: 1;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    135deg,
    rgba(0, 0, 0, 0.4) 0%,
    rgba(0, 0, 0, 0.2) 50%,
    rgba(0, 0, 0, 0.3) 100%
  );
  z-index: 2;
}

/* 粒子效果样式 */
.particles-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 2;
  pointer-events: none;
}

.particles-canvas {
  width: 100%;
  height: 100%;
  display: block;
}

.hero-container {
  position: relative;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  z-index: 3;
}

.hero-content {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
  text-align: center;
}

.hero-text {
  color: white;
  max-width: 800px;
}

.hero-text h1 {
  font-size: 3.6rem;
  font-weight: 800;
  margin-bottom: 2rem;
  line-height: 1.1;
  color: #ffffff;
  text-shadow: 
    0 0 20px rgba(41, 171, 193, 0.6),
    0 0 40px rgba(41, 171, 193, 0.4),
    2px 2px 8px rgba(0, 0, 0, 0.8);
  letter-spacing: -0.01em;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
  word-break: keep-all;
  hyphens: none;
}

.hero-text p {
  font-size: 1.4rem;
  margin-bottom: 3rem;
  opacity: 0.95;
  line-height: 1.8;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.3);
  color: rgba(255, 255, 255, 0.9);
}

.hero-buttons {
  display: flex;
  gap: 2rem;
  justify-content: center;
  flex-wrap: wrap;
}

.hero-buttons .el-button {
  padding: 15px 40px;
  font-size: 1.2rem;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
  min-width: 160px;
}

.hero-buttons .el-button--primary {
  background: linear-gradient(135deg, var(--accent-color) 0%, #3bc9db 100%);
  border: none;
  transform: translateY(0);
}

.hero-buttons .el-button--primary:hover {
  background: linear-gradient(135deg, var(--accent-hover) 0%, #2fb3c7 100%);
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(41, 171, 193, 0.5);
}

.hero-btn-secondary {
  background: rgba(255, 255, 255, 0.1) !important;
  color: white !important;
  border: 2px solid rgba(255, 255, 255, 0.4) !important;
  backdrop-filter: blur(15px);
}

.hero-btn-secondary:hover {
  background: rgba(255, 255, 255, 0.2) !important;
  border-color: rgba(255, 255, 255, 0.6) !important;
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(255, 255, 255, 0.3);
}

/* 加入我们模块 - 简化版 */
.careers {
  padding: 80px 0;
  background: var(--bg-primary);
}

.careers-simple {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 40px;
  margin-top: 50px;
}

.career-simple-item {
  text-align: center;
  background: var(--card-bg);
  border-radius: 12px;
  padding: 30px 20px;
  box-shadow: var(--shadow-light);
  border: 1px solid var(--border-color);
  transition: all 0.3s ease;
}

.career-simple-item:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-dark);
}

.career-simple-image {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  object-fit: cover;
  margin-bottom: 20px;
}

.career-simple-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: var(--text-primary);
  margin-bottom: 20px;
}

.career-simple-content {
  text-align: left;
  margin-bottom: 25px;
  line-height: 1.6;
}

.career-simple-salary,
.career-simple-requirements,
.career-simple-training {
  margin-bottom: 15px;
  color: var(--text-secondary);
  font-size: 0.95rem;
}

.career-simple-salary strong,
.career-simple-requirements strong,
.career-simple-training strong {
  color: var(--text-primary);
  font-size: 1rem;
}

.career-simple-btn {
  width: 100%;
  max-width: 200px;
  padding: 12px 24px;
  background: linear-gradient(135deg, var(--accent-color), #3bc9db);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.career-simple-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(41, 171, 193, 0.3);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .careers-simple {
    grid-template-columns: 1fr;
    gap: 30px;
  }
  
  .career-simple-item {
    padding: 25px 15px;
  }
  
  .career-simple-title {
    font-size: 1.3rem;
  }
}
@media (max-width: 768px) {
  .hero-text h1 {
    font-size: 2.8rem;
  }
  
  .hero-text p {
    font-size: 1.2rem;
    margin-bottom: 2.5rem;
  }
  
  .hero-buttons {
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
  }
  
  .hero-buttons .el-button {
    width: 100%;
    max-width: 280px;
    padding: 12px 30px;
    font-size: 1.1rem;
  }
}

/* 通用容器 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* 章节样式 */
section {
  padding: 5rem 0;
  background: var(--bg-primary);
}

section h2 {
  text-align: center;
  font-size: 2.5rem;
  margin-bottom: 3rem;
  color: var(--text-primary);
}

.section-subtitle {
  text-align: center;
  font-size: 1.2rem;
  color: var(--text-secondary);
  margin-bottom: 2rem;
}

/* 关于我们 */
.about {
  background: var(--bg-secondary);
}

.about-content {
  display: grid;
  gap: 3rem;
}

.about-text {
  text-align: center;
}

.company-logo img {
  max-width: 300px;
  margin-bottom: 2rem;
}

.about-text p {
  font-size: 1.1rem;
  line-height: 1.8;
  margin-bottom: 2rem;
  color: var(--text-secondary);
}

.about-text h4 {
  font-size: 1.3rem;
  color: var(--text-primary);
}

.services-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.service-item {
  background: var(--card-bg);
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
  box-shadow: var(--shadow-dark);
  transition: transform 0.3s;
  border: 1px solid var(--border-color);
}

.service-item:hover {
  transform: translateY(-5px);
}

.service-item img {
  width: 60px;
  height: 60px;
  margin-bottom: 1rem;
}

.service-item h5 {
  font-size: 1.2rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.service-item p {
  color: var(--text-secondary);
  line-height: 1.6;
}

/* 新的简洁服务内容样式 - 参考1.html */
.services-content-simple {
  margin-top: 3rem;
  text-align: center;
}

.service-simple-item {
  margin-bottom: 3rem;
  padding: 2rem 0;
}

.service-simple-item img {
  width: 80px;
  height: 80px;
  margin-bottom: 1rem;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.service-simple-item h3 {
  font-size: 1.5rem;
  color: var(--text-primary);
  margin-bottom: 1rem;
  font-weight: 600;
}

.service-simple-item p {
  color: var(--text-secondary);
  line-height: 1.8;
  font-size: 1.1rem;
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
}

/* 产品展示 */
.services-content {
  text-align: center;
}

.streaming-intro {
  margin-bottom: 3rem;
}

.streaming-intro h3 {
  font-size: 2rem;
  margin-bottom: 1rem;
  color: var(--accent-color);
}

.streaming-intro h4 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.streaming-intro p {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--text-secondary);
  max-width: 800px;
  margin: 0 auto;
}

.streaming-solutions {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.solution-item {
  background: var(--card-bg);
  border-radius: 10px;
  overflow: hidden;
  box-shadow: var(--shadow-dark);
  transition: transform 0.3s;
  border: 1px solid var(--border-color);
}

.solution-item:hover {
  transform: translateY(-5px);
}

.solution-item img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.solution-item h5 {
  font-size: 1.3rem;
  margin: 1rem;
  color: var(--text-primary);
}

.solution-scenarios {
  color: var(--accent-color);
  font-weight: 500;
  margin: 0 1rem;
}

.solution-item p:last-child {
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 1rem;
  padding-bottom: 1rem;
}

/* 客户案例 */
.clients {
  background: var(--bg-secondary);
}

.clients-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  align-items: stretch;
}

.client-item {
  background: var(--card-bg);
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
  box-shadow: var(--shadow-dark);
  transition: transform 0.3s;
  display: flex;
  flex-direction: column;
  align-items: center;
  border: 1px solid var(--border-color);
}

.client-item:hover {
  transform: translateY(-5px);
}

.client-logo {
  margin-bottom: 1.5rem;
}

.client-logo img {
  max-width: 120px;
  max-height: 80px;
  object-fit: contain;
}

.client-info h4 {
  font-size: 1.3rem;
  color: var(--text-primary);
  margin-bottom: 1rem;
  font-weight: 600;
}

.client-info p {
  color: var(--text-secondary);
  line-height: 1.6;
  font-size: 0.95rem;
}

/* 培训服务 */
.training-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.training-item {
  background: var(--card-bg);
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
  box-shadow: var(--shadow-dark);
  transition: transform 0.3s;
  border: 1px solid var(--border-color);
}

.training-item:hover {
  transform: translateY(-5px);
}

.training-item h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.price {
  font-size: 1.8rem;
  font-weight: bold;
  color: var(--accent-color);
  margin-bottom: 1.5rem;
}

.features {
  list-style: none;
  margin-bottom: 2rem;
}

.features li {
  padding: 0.5rem 0;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--border-color);
}

/* 博客模块 */
.blog {
  background: var(--bg-secondary);
}

.blog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  justify-items: start;
}

.blog-item {
  background: var(--card-bg);
  border-radius: 10px;
  overflow: hidden;
  box-shadow: var(--shadow-dark);
  transition: transform 0.3s;
  border: 1px solid var(--border-color);
  width: 100%;
  max-width: 400px;
}

.blog-item:hover {
  transform: translateY(-5px);
}

.blog-item img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.blog-content {
  padding: 1.5rem;
}

.blog-content h4 {
  font-size: 1.2rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.blog-content p {
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 1rem;
}

.blog-meta {
  display: flex;
  justify-content: space-between;
  font-size: 0.9rem;
  color: var(--text-muted);
}

.blog-actions {
  text-align: center;
  margin-top: 3rem;
}

.blog-actions .el-button {
  padding: 12px 30px;
  font-size: 1.1rem;
  border-radius: 25px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(41, 171, 193, 0.3);
}

.blog-actions .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(41, 171, 193, 0.4);
}

/* 客户感言 */
.testimonials {
  background: var(--bg-tertiary);
  color: white;
}

.testimonials h2 {
  color: var(--text-primary);
}

.testimonials-slider {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 2rem;
}

.testimonial-item {
  background: rgba(255, 255, 255, 0.05);
  padding: 2rem;
  border-radius: 10px;
  text-align: center;
  border: 1px solid var(--border-color);
}

.quote-icon {
  font-size: 2rem;
  margin-bottom: 1rem;
  opacity: 0.7;
  color: var(--accent-color);
}

.testimonial-item p {
  font-size: 1.1rem;
  line-height: 1.8;
  margin-bottom: 2rem;
  font-style: italic;
  color: var(--text-primary);
}

.testimonial-author {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
}

.testimonial-author img {
  width: 50px;
  height: 50px;
  border-radius: 50%;
}

.testimonial-author h5 {
  margin-bottom: 0.25rem;
  color: var(--text-primary);
}

.testimonial-author span {
  opacity: 0.8;
  font-size: 0.9rem;
  color: var(--text-secondary);
}

/* 联系我们 */
.contact {
  background: var(--bg-secondary);
}

.contact-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
}

.contact-info {
  display: grid;
  gap: 2rem;
}

.contact-item h4 {
  font-size: 1.2rem;
  margin-bottom: 1rem;
  color: var(--text-primary);
}

.contact-item p {
  color: var(--text-secondary);
  line-height: 1.6;
}

.contact-item a {
  color: var(--accent-color);
  text-decoration: none;
}

.contact-item a:hover {
  text-decoration: underline;
  color: var(--accent-hover);
}

.contact-form {
  background: var(--card-bg);
  padding: 2rem;
  border-radius: 10px;
  box-shadow: var(--shadow-dark);
  border: 1px solid var(--border-color);
}

.contact-form h3 {
  margin-bottom: 2rem;
  color: var(--text-primary);
}

/* Element Plus 暗色主题覆盖 */
:deep(.el-input__wrapper) {
  background-color: var(--input-bg) !important;
  border-color: var(--border-color) !important;
}

:deep(.el-input__inner) {
  color: var(--text-primary) !important;
  background-color: transparent !important;
}

:deep(.el-textarea__inner) {
  background-color: var(--input-bg) !important;
  border-color: var(--border-color) !important;
  color: var(--text-primary) !important;
}

:deep(.el-form-item__label) {
  color: var(--text-primary) !important;
}

:deep(.el-button--primary) {
  background-color: var(--accent-color) !important;
  border-color: var(--accent-color) !important;
}

:deep(.el-button--primary:hover) {
  background-color: var(--accent-hover) !important;
  border-color: var(--accent-hover) !important;
}

:deep(.el-dialog) {
  background-color: var(--card-bg) !important;
  border: 1px solid var(--border-color) !important;
}

:deep(.el-dialog__header) {
  border-bottom: 1px solid var(--border-color) !important;
}

:deep(.el-dialog__title) {
  color: var(--text-primary) !important;
}

:deep(.el-dialog__body) {
  color: var(--text-secondary) !important;
}

/* 页脚 */
.footer {
  background: var(--bg-tertiary);
  color: var(--text-primary);
  padding: 2rem 0;
  text-align: center;
  border-top: 1px solid var(--border-color);
}

.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.footer-logo {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1.2rem;
  font-weight: bold;
  color: var(--text-primary);
}

.footer-logo img {
  height: 30px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
  
  .nav-toggle {
    display: flex;
  }
  
  .hero-content {
    grid-template-columns: 1fr;
    text-align: center;
  }
  
  .hero-content h1 {
    font-size: 2rem;
  }
  
  .contact-content {
    grid-template-columns: 1fr;
  }
  
  .testimonials-slider {
    grid-template-columns: 1fr;
  }
  
  .container {
    padding: 0 1rem;
  }
  
  section {
    padding: 3rem 0;
  }
}

/* 滚动动画样式 - 优化缓动效果 */
.animate-section,
.animate-element {
  opacity: 0;
  transition: opacity 1.2s cubic-bezier(0.16, 1, 0.3, 1),
              transform 1.2s cubic-bezier(0.16, 1, 0.3, 1);
  will-change: opacity, transform;
}

.animate-visible {
  opacity: 1;
}

/* 淡入向上动画 - 优雅的缓动 */
.animate-fade-up {
  transform: translateY(60px);
  transition: opacity 1s cubic-bezier(0.25, 0.46, 0.45, 0.94),
              transform 1s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.animate-visible.animate-fade-up {
  transform: translateY(0);
}

/* 淡入向左动画 - 流畅的滑动 */
.animate-fade-left {
  transform: translateX(80px);
  transition: opacity 1.1s cubic-bezier(0.23, 1, 0.32, 1),
              transform 1.1s cubic-bezier(0.23, 1, 0.32, 1);
}

.animate-visible.animate-fade-left {
  transform: translateX(0);
}

/* 淡入向右动画 - 流畅的滑动 */
.animate-fade-right {
  transform: translateX(-80px);
  transition: opacity 1.1s cubic-bezier(0.23, 1, 0.32, 1),
              transform 1.1s cubic-bezier(0.23, 1, 0.32, 1);
}

.animate-visible.animate-fade-right {
  transform: translateX(0);
}

/* 缩放动画 - 自然的缩放效果 */
.animate-zoom-in {
  transform: scale(0.85);
  transition: opacity 1.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              transform 1.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.animate-visible.animate-zoom-in {
  transform: scale(1);
}

/* 旋转淡入动画 - 优雅的旋转 */
.animate-rotate-in {
  transform: rotate(-15deg) scale(0.85);
  transition: opacity 1.4s cubic-bezier(0.175, 0.885, 0.32, 1.275),
              transform 1.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.animate-visible.animate-rotate-in {
  transform: rotate(0deg) scale(1);
}

/* 弹跳动画 - 更自然的弹性效果 */
.animate-bounce-in {
  transform: scale(0.4);
  transition: opacity 1.5s cubic-bezier(0.68, -0.55, 0.265, 1.55),
              transform 1.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.animate-visible.animate-bounce-in {
  transform: scale(1);
}

/* 滑入动画 - 平滑的滑动效果 */
.animate-slide-in-left {
  transform: translateX(-120px);
  transition: opacity 1.2s cubic-bezier(0.215, 0.61, 0.355, 1),
              transform 1.2s cubic-bezier(0.215, 0.61, 0.355, 1);
}

.animate-visible.animate-slide-in-left {
  transform: translateX(0);
}

.animate-slide-in-right {
  transform: translateX(120px);
  transition: opacity 1.2s cubic-bezier(0.215, 0.61, 0.355, 1),
              transform 1.2s cubic-bezier(0.215, 0.61, 0.355, 1);
}

.animate-visible.animate-slide-in-right {
  transform: translateX(0);
}

/* 翻转动画 - 3D翻转效果 */
.animate-flip-in {
  transform: perspective(600px) rotateY(90deg);
  transition: opacity 1.3s cubic-bezier(0.25, 0.46, 0.45, 0.94),
              transform 1.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.animate-visible.animate-flip-in {
  transform: perspective(600px) rotateY(0deg);
}

/* 特殊效果：为不同类型的元素添加不同的动画延迟和缓动 */
.service-simple-item.animate-element {
  transition-delay: 0.1s;
  transition: opacity 1.1s cubic-bezier(0.25, 0.46, 0.45, 0.94) 0.1s,
              transform 1.1s cubic-bezier(0.25, 0.46, 0.45, 0.94) 0.1s;
}

.client-item.animate-element {
  transition-delay: 0.05s;
  transition: opacity 0.9s cubic-bezier(0.23, 1, 0.32, 1) 0.05s,
              transform 0.9s cubic-bezier(0.23, 1, 0.32, 1) 0.05s;
}

.blog-item.animate-element {
  transition-delay: 0.15s;
  transition: opacity 1.2s cubic-bezier(0.34, 1.56, 0.64, 1) 0.15s,
              transform 1.2s cubic-bezier(0.34, 1.56, 0.64, 1) 0.15s;
}

.training-item.animate-element {
  transition-delay: 0.2s;
  transition: opacity 1.3s cubic-bezier(0.175, 0.885, 0.32, 1.275) 0.2s,
              transform 1.3s cubic-bezier(0.175, 0.885, 0.32, 1.275) 0.2s;
}

/* 悬停增强效果 - 更流畅的交互 */
.animate-visible .service-simple-item,
.animate-visible .client-item,
.animate-visible .blog-item,
.animate-visible .training-item {
  transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94),
              box-shadow 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94),
              filter 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.animate-visible .service-simple-item:hover,
.animate-visible .client-item:hover,
.animate-visible .blog-item:hover,
.animate-visible .training-item:hover {
  transform: translateY(-12px) scale(1.03);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  filter: brightness(1.05);
}

/* 为标题和文本添加特殊的缓动效果 */
h1.animate-element,
h2.animate-element,
h3.animate-element {
  transition: opacity 1.4s cubic-bezier(0.16, 1, 0.3, 1),
              transform 1.4s cubic-bezier(0.16, 1, 0.3, 1);
}

p.animate-element,
.animate-element p {
  transition: opacity 1.1s cubic-bezier(0.25, 0.46, 0.45, 0.94),
              transform 1.1s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

/* 按钮的特殊动画效果 */
.btn.animate-element,
button.animate-element {
  transition: opacity 1.2s cubic-bezier(0.34, 1.56, 0.64, 1),
              transform 1.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.btn.animate-element:hover,
button.animate-element:hover {
  transform: translateY(-3px) scale(1.05);
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* 减少动画在移动设备上的复杂度 - 优化缓动 */
@media (max-width: 768px) {
  .animate-section,
  .animate-element {
    transition: opacity 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94),
                transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  }
  
  .animate-fade-up,
  .animate-fade-left,
  .animate-fade-right {
    transform: translateY(30px);
    transition: opacity 0.7s cubic-bezier(0.23, 1, 0.32, 1),
                transform 0.7s cubic-bezier(0.23, 1, 0.32, 1);
  }
  
  .animate-visible.animate-fade-left,
  .animate-visible.animate-fade-right {
    transform: translateY(0);
  }
  
  /* 移动设备上简化复杂动画 */
  .animate-zoom-in,
  .animate-rotate-in,
  .animate-bounce-in {
    transition: opacity 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94),
                transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  }
  
  .animate-slide-in-left,
  .animate-slide-in-right {
    transform: translateX(0);
    transition: opacity 0.5s cubic-bezier(0.23, 1, 0.32, 1);
  }
  
  .animate-flip-in {
    transform: translateY(20px);
    transition: opacity 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94),
                transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  }
  
  .animate-visible.animate-flip-in {
    transform: translateY(0);
  }
  
  /* 移动设备上的悬停效果简化 */
  .animate-visible .service-simple-item:hover,
  .animate-visible .client-item:hover,
  .animate-visible .blog-item:hover,
  .animate-visible .training-item:hover {
    transform: translateY(-5px) scale(1.01);
    transition: transform 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  }
}

/* 为支持 prefers-reduced-motion 的用户禁用动画 */
@media (prefers-reduced-motion: reduce) {
  .animate-section,
  .animate-element {
    transition: none;
    opacity: 1;
    transform: none;
  }
}

/* uiverse.io 卡片动画样式 */
.uiverse-card {
  background: #18181b;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.10), 0 1.5px 6px rgba(0,0,0,0.10);
  transition: transform 0.35s cubic-bezier(.21,1.02,.73,1), box-shadow 0.35s cubic-bezier(.21,1.02,.73,1), filter 0.35s;
  will-change: transform, box-shadow, filter;
  position: relative;
  overflow: hidden;
}
.uiverse-card-hover:hover {
  transform: translateY(-10px) scale(1.04) rotateX(4deg) rotateY(-4deg);
  box-shadow: 0 12px 32px 0 rgba(41,171,193,0.18), 0 2px 8px rgba(0,0,0,0.10);
  filter: brightness(1.08) saturate(1.1);
  z-index: 2;
}
.uiverse-card::before {
  content: '';
  position: absolute;
  inset: 0;
  pointer-events: none;
  border-radius: 16px;
  background: linear-gradient(120deg,rgba(41,171,193,0.18) 0%,rgba(255,255,255,0.08) 100%);
  opacity: 0.7;
  transition: opacity 0.3s;
}
.uiverse-card-hover:hover::before {
  opacity: 1;
}

.uiverse-card-hide {
  opacity: 0;
  transform: translateY(60px) scale(0.98);
  transition: opacity 0.7s cubic-bezier(0.25,0.46,0.45,0.94), transform 0.7s cubic-bezier(0.25,0.46,0.45,0.94);
}
.uiverse-card-visible {
  opacity: 1;
  transform: translateY(0) scale(1);
}
</style>