# AutoWebFlow

**AutoWebFlow** 是一个功能强大的自动化框架，专为提升日常工作效率而设计。基于该框架，你可以轻松实现**网页浏览任务自动化**、**数据采集与整理**、**信息检索与研报编写**、**自动化测试**以及各类**自动化网页办公**场景。

它通过 **CDP (Chrome DevTools Protocol)** 接管现有的浏览器会话，结合 **Playwright** 的强大控制力，并内置了 **AI Agent** 接口，使编写复杂的"人机协同"或"AI 驱动"的任务变得简单。

## ✨ 特性

*   **⚡ 高效办公**: 自动化处理重复性网页操作，释放人力。
*   **📊 数据洞察**: 轻松采集、清洗和整理网页数据，辅助决策。
*   **🧩 模块化设计**: 核心驱动、任务逻辑、配置管理完全解耦。
*   **🤖 AI Ready**: 内置 `AIAgent` 接口，支持打通 LLM 进行智能分析和报告生成。
*   **🔌 自动发现**: 编写任务脚本即插即用，框架自动扫描并注册任务。
*   **🐍 Python 优先**: 纯 Python 实现，易于扩展和维护。
*   **📝 双语注释**: 核心代码全中文/英文双语注释，降低源码阅读门槛。

## 👤 作者信息

*   **作者**: shenyulong2004
*   **GitHub**: [shenyulong2004-maker](https://github.com/shenyulong2004-maker)

## 🚀 快速开始

### 1. 安装依赖

```bash
pip install playwright pyyaml
playwright install
```

### 2. 启动浏览器
使用内置脚本一键启动开启了远程调试端口的 Chrome：
```bash
python launch_browser.py
```
*(注意：请在弹出的浏览器窗口中登录你需要访问的网站)*

### 3. 运行示例任务

框架自带了两个浏览 [Linux.do](https://linux.do) 论坛的示例任务，可用于完成社区日常阅读任务：

#### 📖 示例一：刷主题阅读数
从配置的入口页面收集未读话题（通过小蓝点标记识别），逐一访问完成主题阅读数任务。支持配置多个入口 URL。
```bash
python main.py --task linux_do
```
在 `config/settings.yaml` 中可配置参数：
```yaml
tasks:
  linux_do_target_count: 500         # 目标阅读主题数
  linux_do_entry_urls:               # 入口页面（支持多个）
    - "https://linux.do/c/develop/4"
    - "https://linux.do/c/resource/14"
```

#### 📝 示例二：刷帖子阅读数
从配置的入口页面收集未读话题（小蓝点=全新主题、蓝框数字=有未读帖子），逐一进入并模拟真实用户行为滚动阅读帖子（渐进式滚动、随机停顿、偶尔回滚等）。阅读时会自动为中文字数达标的帖子点赞（70% 概率触发，可配置上限）。支持配置多个入口 URL。
```bash
python main.py --task linux_do_posts
```
在 `config/settings.yaml` 中可配置参数：
```yaml
tasks:
  linux_do_posts_target_count: 10000  # 目标阅读帖子数
  linux_do_posts_skip_top: 3         # 跳过前 N 个热门话题
  linux_do_posts_read_time_min: 1    # 每个帖子最短阅读停顿（秒）
  linux_do_posts_read_time_max: 3    # 每个帖子最长阅读停顿（秒）
  linux_do_posts_like_min_chars: 50  # 帖子中文字数达到此值时点赞
  linux_do_posts_like_max_count: 30  # 最多点赞数量
  linux_do_posts_entry_urls:         # 入口页面（支持多个）
    - "https://linux.do/hot?order=posts"
```

### 4. 配置文件说明 (可选)
框架会读取 `config/settings.yaml`。你可以修改它来适应你的环境（如 Chrome 路径、调试端口等）：
```yaml
chrome:
  executable_path: "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
  debug_port: 9222
  user_data_dir: "c:\\temp_chrome_data"

logging:
  level: "INFO"
  file: "auto_chrome.log"
```

## 🛠️ 开发指南

### 创建新任务
在 `tasks/` 目录下创建一个新文件，例如 `my_task.py`，继承 `BaseTask` 即可：

```python
from framework.core.task_base import BaseTask

class MyTask(BaseTask):
    name = "my_task"

    def run(self):
        page = self.driver.get_page()
        page.goto("https://www.google.com")
        self.logger.info("Opened Google")
```

然后直接运行：
```bash
python main.py --task my_task
```

**提示：** `tasks/templates/task_template.py` 包含详细注释和 AI 示例的开发模板，建议直接复制该文件开始开发。

### 核心组件说明

#### BrowserDriver
浏览器驱动类，负责：
- 通过 CDP 连接到已运行的 Chrome 浏览器
- 智能选择可见页面（跳过扩展页面、devtools 页面）
- 提供页面操作接口

#### BaseTask
任务基类，提供：
- `setup()`：初始化环境，连接浏览器
- `run()`：任务核心逻辑（需子类实现）
- `teardown()`：清理资源
- `execute()`：模板方法，安全执行任务

#### AIAgent
AI 代理抽象接口，提供：
- `analyze_page(content)`：分析页面内容
- `extract_structure(content, schema)`：提取结构化数据
- 内置 `MockAgent` 用于测试

#### Context
上下文管理类，负责：
- 加载配置文件
- 管理日志实例
- 提供全局配置访问

## 📂 目录结构

```text
autowebflow/
├── framework/          # 核心框架代码
│   ├── core/           # 驱动、基类、上下文
│   │   ├── driver.py   # BrowserDriver - 浏览器连接与控制
│   │   ├── task_base.py # BaseTask - 任务基类
│   │   ├── context.py  # Context - 上下文管理
│   │   └── registry.py # 任务自动发现与注册
│   ├── ai/             # AI Agent 接口
│   │   └── agent.py    # AIAgent 抽象类与 MockAgent
│   └── utils/          # 工具函数
│       ├── logger.py   # 日志配置
│       └── launcher.py # 浏览器启动工具
├── tasks/              # 任务目录
│   ├── examples/       # 示例任务
│   │   ├── linux_do_browser.py      # 刷主题阅读数
│   │   └── linux_do_posts_browser.py # 刷帖子阅读数
│   └── templates/      # 任务模板
│       └── task_template.py # 开发模板（含 AI 示例）
├── config/             # 配置文件
│   └── settings.yaml   # 全局配置
├── launch_browser.py   # 浏览器启动器（带远程调试端口）
├── main.py             # 主入口
├── .gitignore          # Git 忽略规则
├── LICENSE             # MIT 许可证
└── README.md           # 项目说明文档
```

## 🤝 贡献
欢迎提交 Issue 和 Pull Request！

## 📄 许可证
MIT License