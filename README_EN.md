# AutoWebFlow

**AutoWebFlow** is a powerful automation framework designed to boost daily productivity. It enables you to easily automate **web browsing tasks**, **data collection & organization**, **information retrieval & report writing**, **automated testing**, and various **web-based office automation** scenarios.

By taking over existing browser sessions via **CDP (Chrome DevTools Protocol)** and leveraging the power of **Playwright**, along with built-in **AI Agent** interfaces, it makes writing complex "Human-in-the-loop" or "AI-driven" automation tasks effortless.

## ✨ Features

*   **⚡ Efficient Office Work**: Automate repetitive web operations to free up manpower.
*   **📊 Data Insights**: Easily collect, clean, and organize web data to assist decision-making.
*   **🧩 Modular Design**: Decoupled core driver, task logic, and configuration management.
*   **🤖 AI Ready**: Built-in `AIAgent` interface for seamless integration with LLMs for intelligent analysis and report generation.
*   **🔌 Auto Discovery**: Plug-and-play task scripts. The framework automatically scans and registers tasks.
*   **🐍 Python First**: Pure Python implementation, easy to extend and maintain.
*   **📝 Bilingual Comments**: Core code contains full Chinese/English bilingual comments for easier source reading.

## 👤 Author Info

*   **Author**: shenyulong2004
*   **GitHub**: [shenyulong2004-maker](https://github.com/shenyulong2004-maker)

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install playwright pyyaml
playwright install
```

### 2. Launch Browser
Use the built-in script to launch Chrome with remote debugging enabled:
```bash
python launch_browser.py
```
*(Note: Please log in to your target websites in the popped-up browser window)*

### 3. Run Example Task

The framework includes two example tasks for browsing the [Linux.do](https://linux.do) forum, useful for completing community daily reading tasks:

#### 📖 Example 1: Read Topics
Collects unread topics (identified by blue dot markers) from configured entry pages and visits them one by one to complete the topic reading task. Supports multiple entry URLs.
```bash
python main.py --task linux_do
```
Configure parameters in `config/settings.yaml`:
```yaml
tasks:
  linux_do_target_count: 500         # Target number of topics to read
  linux_do_entry_urls:               # Entry pages (supports multiple)
    - "https://linux.do/c/develop/4"
    - "https://linux.do/c/resource/14"
```

#### 📝 Example 2: Read Posts
Collects unread topics (blue dot = new topic, blue framed number = unread posts) from configured entry pages and simulates real user behavior to scroll through posts (progressive scrolling, random pauses, occasional rollbacks, etc.). Automatically likes posts with sufficient Chinese characters (70% probability, configurable limit). Supports multiple entry URLs.
```bash
python main.py --task linux_do_posts
```
Configure parameters in `config/settings.yaml`:
```yaml
tasks:
  linux_do_posts_target_count: 10000  # Target number of posts to read
  linux_do_posts_skip_top: 3         # Skip top N hot topics
  linux_do_posts_read_time_min: 1    # Minimum read pause per post (seconds)
  linux_do_posts_read_time_max: 3    # Maximum read pause per post (seconds)
  linux_do_posts_like_min_chars: 50  # Like post when Chinese chars reach this value
  linux_do_posts_like_max_count: 30  # Maximum likes per session
  linux_do_posts_entry_urls:         # Entry pages (supports multiple)
    - "https://linux.do/hot?order=posts"
```

### 4. Configuration (Optional)
The framework reads `config/settings.yaml`. You can modify it to fit your environment (e.g., Chrome path, debug port):
```yaml
chrome:
  executable_path: "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
  debug_port: 9222
  user_data_dir: "c:\\temp_chrome_data"

logging:
  level: "INFO"
  file: "auto_chrome.log"
```

## 🛠️ Development Guide

### Create a New Task
Create a new file in the `tasks/` directory, e.g., `my_task.py`, and inherit from `BaseTask`:

```python
from framework.core.task_base import BaseTask

class MyTask(BaseTask):
    name = "my_task"

    def run(self):
        page = self.driver.get_page()
        page.goto("https://www.google.com")
        self.logger.info("Opened Google")
```

Then run it directly:
```bash
python main.py --task my_task
```

**Tip:** `tasks/templates/task_template.py` contains a detailed template with comments and AI examples. It's recommended to copy this file to start development.

### Core Components

#### BrowserDriver
Browser driver class responsible for:
- Connecting to running Chrome via CDP
- Intelligently selecting visible pages (skipping extension pages, devtools pages)
- Providing page operation interfaces

#### BaseTask
Base task class providing:
- `setup()`: Initialize environment, connect browser
- `run()`: Core task logic (implement in subclass)
- `teardown()`: Clean up resources
- `execute()`: Template method for secure task execution

#### AIAgent
AI agent abstract interface providing:
- `analyze_page(content)`: Analyze page content
- `extract_structure(content, schema)`: Extract structured data
- Built-in `MockAgent` for testing

#### Context
Context management class responsible for:
- Loading configuration files
- Managing logger instances
- Providing global configuration access

## 📂 Project Structure

```text
autowebflow/
├── framework/          # Core framework code
│   ├── core/           # Driver, BaseTask, Context
│   │   ├── driver.py   # BrowserDriver - Browser connection & control
│   │   ├── task_base.py # BaseTask - Task base class
│   │   ├── context.py  # Context - Context management
│   │   └── registry.py # Task auto-discovery & registration
│   ├── ai/             # AI Agent Interface
│   │   └── agent.py    # AIAgent abstract class & MockAgent
│   └── utils/          # Utilities
│       ├── logger.py   # Logging configuration
│       └── launcher.py # Browser launch utilities
├── tasks/              # Task scripts
│   ├── examples/       # Example tasks
│   │   ├── linux_do_browser.py      # Read topics
│   │   └── linux_do_posts_browser.py # Read posts
│   └── templates/      # Task templates
│       └── task_template.py # Development template (with AI examples)
├── config/             # Configuration files
│   └── settings.yaml   # Global configuration
├── launch_browser.py   # Browser launcher (with remote debugging)
├── main.py             # Main entry point
├── .gitignore          # Git ignore rules
├── LICENSE             # MIT License
└── README.md           # Project documentation
```

## 🤝 Contribution
Issues and Pull Requests are welcome!

## 📄 License
MIT License