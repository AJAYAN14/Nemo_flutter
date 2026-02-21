# 🌊 Nemo

<p align="center">
  <strong>一款基于现代 Android 技术栈构建的灵动日语词法学习应用</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Language-Japanese-red?style=flat-square" alt="Language">
  <img src="https://img.shields.io/badge/Kotlin-1.9+-7F52FF?logo=kotlin&logoColor=white" alt="Kotlin">
  <img src="https://img.shields.io/badge/Jetpack%20Compose-latest-4285F4?logo=jetpackcompose&logoColor=white" alt="Compose">
  <img src="https://img.shields.io/badge/Supabase-Database%20%26%20Auth-3ECF8E?logo=supabase&logoColor=white" alt="Supabase">
</p>

---

## ✨ 项目简介

**Nemo** 是一款专为日语学习者设计的灵动词汇应用。它不仅提供了优雅的交互体验，更结合了日语学习的特点，通过沉浸式的设计和云端同步功能，助你高效攻克日语词汇难关。

### 🚀 核心特性

- 🇯🇵 **日语专属**：针对假名、汉字词汇学习优化，支持灵活的分类管理。
- 📚 **灵动词库**：支持单词的分类管理、搜索与快速查看。
- 🧠 **智能学习**：内置科学的复习算法，针对薄弱环节进行强化训练。
- 📊 **学习统计**：可视化的学习轨迹，清晰记录你的每一点进步。
- ☁️ **全量同步**：基于 Supabase 构建的云端存储，多设备数据实时无缝衔接。
- 🎨 **现代 UI**：采用 Jetpack Compose 构建的全动态界面，支持深色模式与灵动交互。

---

## 🛠️ 技术栈

- **UI 框架**：Jetpack Compose (声明式 UI 最佳实践)
- **网络层**：Ktor / Supabase Kotlin SDK
- **依赖注入**：Hilt (Dagger)
- **异步处理**：Kotlin Coroutines & Flow
- **架构模式**：模块化架构 + MVI (Model-View-Intent)
- **持久化**：Supabase Postgrest (云端) + Room (本地缓存/规划中)

---

## ⚙️ 快速开始

为了保护敏感信息，项目采用了 **最佳安全实践**。在克隆项目后，你需要进行以下配置：

### 1. 获取 Supabase 配置
1. 注册并登录 [Supabase](https://supabase.com/)。
2. 创建一个新项目，并在 `Project Settings -> API` 中获取你的 `URL` 和 `anon key`。

### 2. 本地配置 (local.properties)
在项目根目录的 `local.properties` 文件中添加以下信息（**注意：该文件已在 .gitignore 中忽略，不会被上传**）：

```properties
SUPABASE_URL=你的项目URL
SUPABASE_ANON_KEY=你的项目ANON_KEY
```

### 3. 运行项目
完成上述配置后，直接使用 Android Studio 打开项目并运行即可。Gradle 脚本会自动读取变量并完成初始化。

---

## 📂 模块结构说明

项目采用严格的模块化设计，以提高可维护性和编译速度：

- `:app`：主程序入口
- `:core`：核心通用逻辑（数据层、领域层、基础 UI 组件）
- `:feature`：功能模块化封装
  - `:library`：词库管理
  - `:learning`：学习训练
  - `:user`：用户体系与注销逻辑
  - `:settings`：个性化配置

---

## 📄 开源协议

本项目遵循 [MIT License](LICENSE) 协议。
