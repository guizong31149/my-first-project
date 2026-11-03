# 食光 MealLens · 热量查询与饮食指南

> 拍一张照，知道这顿吃了多少千卡；看一眼搭配，知道下一顿该吃什么。
> 由营养师视角设计的**本地离线**热量查询 App —— 不联网、不上传；电脑上双击即用，安卓手机可装 APK。

---

## 它能做什么

| 功能 | 说明 |
|---|---|
| 🔍 **热量查询** | **582 条**食物（《中国食物成分表 标准版 第 6 版》为底 + 家常折算），16 个类目，支持名称/别名/拼音/英文搜索，含每 100g 能量、蛋白、脂肪、碳水、膳食纤维、钠、GI 与常见份量 |
| 📷 **拍照识别** | 拍餐盘 → 本地视觉模型识别菜品与份量 → 逐项改名、拖动份量实时重算 → 一键计入今日记录。照片不出本机 |
| 🍱 **一日三餐推荐** | 身高体重年龄活动量 → Mifflin-St Jeor 算 BMR → TDEE → 目标热量与宏量 → 生成符合《中国居民膳食指南（2022）》的三餐搭配，可单菜换、整餐重配，营养达标自检 |
| 📊 **今日记录** | 热量环、蛋白/脂肪/碳水/纤维进度、三餐分布（点餐次可看明细、逐条删除）、营养师点评（评分 + 具体建议）、近 7 天回看与补记、JSON 导出导入 |
| ✍️ **手动记账** | 输菜名即自动匹配食物库/菜品库（带下拉候选），自动带出每 100g 营养与常见份量，改克数实时算热量 |
| 📖 **饮食指南** | 每日推荐摄入量（13 项）、膳食指南八准则、**11 个**生活场景（外卖/聚餐/加班/健身…）、**40 条** GI 速查、**10 组**食物交换份 |
| 🗂️ **菜品库** | **108 道**中式家常菜，热量由配料克数 × 成分表逐项折算，标注失水率与做法 |

**三个"不"**：不做伪精确（所有数字都标注为估算）、不做"少吃就行"（热量过低会提醒，不鼓励极端节食）、不做医疗诊断（只给通用原则 + 就医建议）。

---

## 界面一览

| 今日营养 | 查热量 | 拍照算热量 |
|---|---|---|
| ![今日营养](docs/screenshots/home.png) | ![查热量](docs/screenshots/search.png) | ![拍照算热量](docs/screenshots/camera.png) |

| 识别结果 | 一日三餐 | 饮食指南 |
|---|---|---|
| ![识别结果](docs/screenshots/camera-result.png) | ![一日三餐](docs/screenshots/plan.png) | ![饮食指南](docs/screenshots/guide.png) |


---

## 快速开始

### 方式一：双击启动（推荐）

双击根目录的 **`启动食光.bat`**，浏览器会自动打开 <http://127.0.0.1:8787/>。

脚本会自动寻找本机 Python（依次尝试 `MEALLENS_PYTHON` 环境变量、上级 `.venv`、本机 `~/.dsh` 运行时 Python、常见安装目录下的 `python`、PATH 中的 `python` / `py`），**服务端只用 Python 标准库，无需 pip 安装任何包**。

脚本还会检查：

- `index.html`、`server/server.py`、三个数据文件是否齐全
- `vision/bin/llama-server.exe` 与 `vision/models/*.gguf` 是否就绪（未就绪则拍照页自动转手动模式）
- 8787 端口是否已被占用（占用时会打印当前服务的识别状态，若显示"识别引擎已就绪"直接打开即可）

识别一直不成功时，关掉黑窗口后双击 **`自检.bat`**：它会逐项检查运行环境、模型文件、端口、`/api/health`，并真的跑一张样例照片，最后给出结论并存到 `诊断报告.txt`。

### 方式二：命令行

```bash
cd meallens
python server/server.py
# 输出：本机 http://127.0.0.1:8787/  局域网 http://192.168.x.x:8787/
```

自定义端口 / 开放给手机访问（同一 WiFi）：

```bash
set MEALLENS_PORT=8899
set MEALLENS_HOST=0.0.0.0
python server/server.py
```

### 不想开服务？

直接双击 `index.html` 也能用**查询 / 三餐 / 指南 / 记录**（浏览器对 `file://` 的 `fetch` 有差异，推荐用上面的方式）。只有**拍照识别**需要本地服务。

---

### 方式三：装到安卓手机

```powershell
# 重新打包（改了 src/ 或 data/ 后执行；脚本会自动同步图标、注入内置数据并签名）
python tools/build_apk.py     # 产物：dist/MealLens.apk（约 0.47 MB）
```

把 `dist/MealLens.apk` 传到手机（微信文件传输 / 数据线 / 手机浏览器打开 `http://<电脑IP>:8787/dist/MealLens.apk`）→ 点击安装 → 允许「未知来源」→ 桌面出现绿色图标 **食光**。

- **完全离线可用**：582 条食物、108 道菜、膳食指南与记录全部内置（`data/embedded.js`，351 KB），无需电脑、无需联网
- **拍照识别**需连电脑：手机与电脑同一 Wi-Fi，在 App 拍照页点「设置识别服务地址」填电脑窗口里打印的 `http://192.168.x.x:8787`
- 不想装 APK？手机 Chrome 打开电脑局域网地址 → `⋮` →「添加到主屏幕」也能得到一个桌面快捷方式

详见 [docs/手机安装与使用.md](docs/手机安装与使用.md)。

<img src="icons/icon-192.png" alt="食光 图标" width="88" />
<img src="docs/screenshots/home.png" alt="手机版首页" width="220" />

---

## 拍照识别（本地离线视觉模型）

| 项目 | 说明 |
|---|---|
| 运行时 | `llama.cpp` 预编译版 `llama-server`（`b12040`，Vulkan / CPU 两套） |
| 模型 | `Qwen2.5-VL-3B-Instruct` GGUF（`Q4_K_M`，**1.80 GB**）+ `mmproj-F16` 视觉投影（**1.25 GB**） |
| 加速 | NVIDIA/AMD/Intel 核显走 Vulkan（本机实测 RTX 4060 Laptop 8GB：`-ngl 99` 全量上卡，**显存占用约 3.9 GB**） |
| 速度 | 模型已加载时**单张 1.1～2.8 秒**（11 张样本实测均值 1.4 s）；`warmup()` 拉起+预热约 **6 秒**；完全冷启动首张最长 **46 秒**（返回 `cold_start:true`，非超时） |
| 准确率 | 11 张真实中餐照片：**菜名 11/11**、总热量在合理区间 **9/11**、份量在合理区间 7/11（份量误差 ±20~40%）→ 详见 [`vision/REPORT.md`](vision/REPORT.md) |
| 预热 | 打开「拍照」页时前端自动 `POST /api/warmup` 后台加载模型并轮询状态，横幅显示进度，不阻塞其他功能 |
| 隐私 | 照片以 base64 只发给 `127.0.0.1:8899` 的本机 llama-server，**不出本机、不留存** |
| 降级 | 没有模型时拍照页自动切「手动模式」，查询/三餐/指南/记录完全不受影响 |

### 安装模型（可选）

```powershell
# 1) llama.cpp 预编译版（走加速镜像，GitHub releases 直连很慢）
curl.exe -L -o llama.zip "https://gh-proxy.com/https://github.com/ggml-org/llama.cpp/releases/download/b12040/llama-b12040-bin-win-vulkan-x64.zip"
Expand-Archive llama.zip -DestinationPath vision/bin/vulkan

# 2) 模型权重（hf-mirror）
curl.exe -L -o vision/models/Qwen2.5-VL-3B-Instruct-Q4_K_M.gguf "https://hf-mirror.com/unsloth/Qwen2.5-VL-3B-Instruct-GGUF/resolve/main/Qwen2.5-VL-3B-Instruct-Q4_K_M.gguf?download=true"
curl.exe -L -o vision/models/mmproj-F16.gguf "https://hf-mirror.com/unsloth/Qwen2.5-VL-3B-Instruct-GGUF/resolve/main/mmproj-F16.gguf?download=true"
```

启动服务后 `GET /api/health` 的 `vision` 字段会给出后端、显存层数、模型文件是否就绪；控制台与 App 拍照页横幅同步显示。

---

## 目录结构

```
meallens/
├── index.html              单页应用入口（5 个 Tab）
├── manifest.webmanifest    PWA 清单（手机「添加到主屏幕」用）
├── icons/                  应用图标（192/512/maskable/apple-touch）
├── 启动食光.bat            一键启动（Windows）
├── 自检.bat                一键体检（环境 / 模型 / 端口 / 真跑一张识别 → 诊断报告.txt）
├── src/
│   ├── styles.css          设计系统（暖纸感 + 食物绿，移动优先）
│   ├── app.js              应用逻辑：路由、渲染、交互、数据层、降级兜底、离线/手机适配
│   ├── mealplan.js         营养算法：BMR / TDEE / 宏量 / 三餐搭配与自检
│   ├── advice.js           营养师点评规则引擎（评分 + 分级建议）
│   └── foodlog.js          饮食记录（localStorage，按日期分桶）
├── data/
│   ├── foods.json          食物成分库 582 条
│   ├── dishes.json         菜品库 108 道（配料折算）
│   ├── guide.json          膳食指南：推荐量 / 八准则 / 场景 / GI / 交换份
│   └── embedded.js         以上三者的打包版（APK 离线用，tools/build_embedded.py 生成）
├── server/
│   ├── server.py           静态托管 + 识别 API（纯标准库）
│   └── vision_service.py   本地视觉服务封装（llama-server 生命周期管理）
├── vision/                 llama.cpp 二进制 + Qwen2.5-VL 模型（可选），REPORT.md 为识别验收报告
├── android/                安卓壳工程（WebView，无 Gradle）：app/ 源码与资源、sdk/ 命令行工具链
├── dist/                   打包产物 MealLens.apk
├── tools/                  数据构建、校验、图标生成与 APK 打包脚本
├── tests/                  算法单元测试 + 浏览器端到端探针
├── docs/
│   ├── 产品设计文档.md      营养师视角完整 PRD（含方法论、精度分析与实测验收）
│   ├── 手机安装与使用.md    安卓 APK 安装、拍照服务配置、常见问题
│   ├── 菜品数据说明.md      108 道菜的折算方法、抽检明细与口径偏差
│   ├── 接口契约.md          模块与数据 schema 契约
│   └── screenshots/         六张界面截图
├── samples/                识别测试照片（含 manifest 标注）
└── raw/                    原始数据（下载自公开仓库，不参与运行）
```

---

## 技术栈

- **前端**：原生 HTML / CSS / JS，无框架、无构建、无依赖；移动优先（440px），桌面自动呈手机框居中
- **服务端**：Python 标准库 `ThreadingHTTPServer`，零第三方依赖（Python 3.9+）
- **视觉**：llama.cpp + Qwen2.5-VL-3B GGUF，本机 GPU / CPU 推理
- **安卓**：Android WebView 壳（Java，无 Gradle / 无 AndroidX），用 aapt2 + d8 + apksigner 命令行打包；minSdk 21 / targetSdk 34，内置数据离线可用
- **存储**：`localStorage`，键前缀 `meallens:`，数据不出本机

## API

| 方法 | 路径 | 说明 |
|---|---|---|
| GET | `/api/health` | 服务、视觉服务、数据文件状态 |
| POST | `/api/recognize` | 图片识别。JSON `{"image_base64":"..."}` 或 multipart 表单（字段名 `image`） |
| GET/POST | `/api/warmup` | 预热视觉模型（首次加载 10~60 秒） |

`POST /api/recognize` 成功返回：

```json
{
  "ok": true,
  "items": [
    {"name": "宫保鸡丁", "portion_g": 300, "kcal": 666, "protein": 61.8,
     "fat": 35.7, "carbs": 25.5, "fiber": 2.1, "sodium": 980,
     "confidence": 0.95, "matched": true, "bbox": null}
  ],
  "total_kcal": 666,
  "model": "qwen2.5-vl-3b",
  "latency_ms": 4329,
  "hint": null
}
```

失败时统一返回 `ok:false` + `error` + 中文 `hint`，**不返回 500**：

| `error` | 含义 | 前端行为 |
|---|---|---|
| `VISION_NOT_READY` | 未安装视觉模块 | 拍照页转手动模式 |
| `TIMEOUT` | 单张超过 25 秒 | 提示换小图重试 |
| `NO_IMAGE` / `TOO_SMALL` | 没收到图片 / 图片过小 | 提示重新选择 |
| `RECOGNIZE_FAILED` | 模型返回异常 | 提示重试或手动录入 |

---

## 数据来源

- 食物成分：**《中国食物成分表 标准版（第 6 版）》**，公开整理版 JSON（`Sanotsu/china-food-composition-data`），共 1677 条原始记录，筛出 465 条常用食材；另有 93 条按配料折算的家常菜/饮品与 24 条包装食品标签值，均带 `note` 说明依据，合计 **582 条**
- 膳食指南：**《中国居民膳食指南（2022）》**，每日推荐量、八条准则、场景建议、GI 表、交换份
- 菜品热量 = Σ(配料克数 × 每 100g 营养) / 100，再按做法失水率折算熟重，**为估算值**；108 道菜的 87 个配料全部命中成分表，复算偏差 ≤5%
- 能量自洽校验：所有条目 `energy ≈ 4×蛋白 + 9×脂肪 + 4×碳水`，偏差 >25% 的条目（酒类、高纤维食材、零卡饮品）在 `note` 中注明原因

### 数据口径说明

成分表是「可食部生重」口径，与日常直觉偶尔有差异，遇到时以成分表为准，页面备注里都写了依据：

| 条目 | 本产品值 | 说明 |
|---|---|---|
| 蒸红薯 | 63 千卡/100g | 按成分表「甘薯（红心）」生值 61 折算蒸制失水 6%；比常识（90-100 千卡，常指烤制/高糖品种）低，属数据口径差异 |
| 无糖豆浆 | 32 千卡/100g | 按成分表「豆浆」31 折算，为市售浓度；传统稀豆浆约 16 |
| 素炒藕片 | 70 千卡/100g | 按藕生值 73 + 少油清炒 |
| 白酒（52 度） | 287 千卡/100g | 酒精 7 千卡/g 不在 Atwater 4/9/4 体系内，故自洽校验偏差大，已注明 |

## 精度声明（重要）

数据与识别**均为估算**，请按相对趋势使用（今天比昨天多吃了多少、蛋白够不够），不要当精确计量：

| 误差来源 | 量级 |
|---|---|
| 份量估算（人工估重） | ±20%～40% |
| 拍照识别份量 | ±20%～45%（模型按餐盘比例估算） |
| 菜品名识别 | 主料通常正确，复合菜（麻辣烫/什锦）易拆项不全 |
| 烹饪用油/用盐 | ±50～150 千卡/餐 |
| 菜品与原料差异 | 因做法、地区、放油量而变大 |

识别页每个条目都显示置信度与可拖动份量条，鼓励用户按实际份量修正后再记账 —— **人比模型更懂自己吃的那一盘**。

## 隐私说明

- 无账号、无登录、无云端同步、无埋点
- 记录只存在本机浏览器 `localStorage`
- 照片只发往 `127.0.0.1:8899` 的本机模型，进程退出即释放
- 唯一的外部请求：页面加载本地数据文件（`data/*.json`），不涉及任何第三方域名

## 常见问题

**Q：双击 bat 后浏览器没打开？**
脚本会延迟 2 秒再开浏览器；若仍无反应，手动访问 <http://127.0.0.1:8787/>。

**Q：拍照页显示"模型还没装好"？**
属预期降级：没装模型时用手动模式，输入菜名（如"牛肉面"）与份量照样能算准热量。装模型见上文「安装模型」。

**Q：第一次识别很慢？**
首次要加载 1.8GB 模型到显存，约 10～60 秒；之后单张 1～4 秒。打开拍照页会自动预热。等待期间页面会显示"正在首次加载，已自动重试 N 次"，加载好会自动出结果，不用反复点。

**Q：点了「开始识别」没反应 / 提示连接不到识别服务？**
按顺序排查（多数是下面第 1、2 条）：

1. **别直接双击 `index.html`**，用 `启动食光.bat` 或 `python server/server.py`，浏览器地址应是 `http://127.0.0.1:8787/`。直接双击打开时页面是 `file://`，只能查数据、识别会连不上（Windows 上现在会自动回落到本机服务，但数据仍需服务端提供）。
2. **等模型加载完再点**：装完模型后第一次进拍照页，底部横幅显示"⏳ 正在加载本地视觉模型"是正常的，等它变成"✅ 本地视觉服务已就绪（vulkan）"即可。
3. **跑一次自检**：关掉黑窗口，双击 `自检.bat`。它会打印运行环境、模型文件、8787/8899 端口、`/api/health` 状态，并真跑一张样例照片，最后给出结论；报告同时写到 `诊断报告.txt`。
4. **手机端**：手机不跑模型，需在 App 里 ⚙️ 填电脑的局域网地址（如 `http://192.168.1.23:8787`），手机与电脑同一 Wi-Fi、电脑防火墙放行 8787。改过 `src/` 后要重新 `python tools/build_apk.py` 并重装 APK。
5. **跨域已内置**：服务端已返回 `Access-Control-Allow-Origin: *` 并支持 `OPTIONS` 预检，`file://` 页面（安卓 App、双击打开的网页）可以正常调用 `/api/recognize`；若你自己改过 `server/server.py`，别把这两段 CORS 头删掉。

**Q：热量数字和别的 App 不一样？**
数据基准、菜品配方、份量假设都不同。本 App 的每条数据都能追到《中国食物成分表》条目或配料表，遇差异优先看是不是份量假设不同。

**Q：页面提示"食物数据没有加载成功"？**
说明你是把 `index.html` 直接拖进浏览器打开的（地址以 `file://` 开头），浏览器禁止读取本地 JSON。请双击 `启动食光.bat` 或运行 `python server/server.py`，再访问 <http://127.0.0.1:8787/>。

**Q：能减到多少斤？**
本 App 按"目标热量 = TDEE − 400 kcal"给减脂建议，且不低于基础代谢下限（女 1200 / 男 1500 kcal）。不建议每天低于此线，速度以每周 0.3～0.7kg 为宜。

---

## 开发与校验

```bash
# 数据校验（结构、字段、能量自洽、类目覆盖）
python tools/validate_foods.py
python tools/validate_dishes.py --strict

# 算法单元测试（67 项：BMR/TDEE/宏量/配餐/点评/记录/契约）
node tests/run.mjs

# 视觉识别自测（需先装模型）
python tools/vision_test.py --all

# 浏览器端到端探针（需先启动服务）
python tests/_probe_search.py && python tests/_probe_photo.py && python tests/_probe_flow.py
python tests/_probe_manual.py && python tests/_probe_meal.py
# 然后用 msedge --headless=new --virtual-time-budget=30000 --dump-dom "http://127.0.0.1:8787/tests/_probe_photo.html?img=05_fried_rice.jpg"

# 全链路体检（运行环境 / 模型文件 / 端口 / 真跑一张识别），报告写入 诊断报告.txt
python tools/doctor.py            # 只查环境不跑识别：python tools/doctor.py --no-vision-test

# 安卓 APK：图标 / 内置数据 / 打包（改了 src/ 或 data/ 后重跑最后一条）
python tools/make_icons.py          # 重新生成 icons/ 与 android/app/res/mipmap-*
python tools/build_embedded.py      # data/*.json → data/embedded.js（351 KB）
python tools/build_apk.py           # → dist/MealLens.apk（含签名与自检）
```

安卓构建依赖（不入库，首次会自动检测）：JDK 17+、`android/sdk/android-14/`（build-tools：aapt2/d8/zipalign/apksigner）、`android/sdk/android-35/android.jar`。工具链获取过程见 [android/README.md](android/README.md)。

## 免责声明

本 App 仅提供食物营养信息与一般性饮食参考，**不构成医疗或营养治疗建议**。孕期、哺乳期、儿童青少年、老年人及慢性病人群（糖尿病、高血压、高血脂、肾病等）请在临床营养师或医师指导下调整饮食。若出现明显体重异常变化、进食障碍倾向，请及时就医。
