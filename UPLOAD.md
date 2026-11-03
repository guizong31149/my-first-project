# 上传到 GitHub：三种方式（任选一种）

> 这个文件夹已经是「干净源码」：不含 3.1GB 模型、不含 Android SDK、不含原始成分表 JSON。
> 总体积约 5.8 MB / 125 个文件，可以直接上传。

---

## 方式 A：网页上传（不用装 Git，最省事，适合第一次）

1. 打开 <https://github.com/new>，填仓库名（如 `meallens`），选 **Public** 或 **Private**，
   **不要**勾 "Add a README file / .gitignore / license"（我们已经有），点 **Create repository**。
2. 在新仓库页面点 **uploading an existing file**（或 `Add file → Upload files`）。
3. 打开桌面上的 `meallens-github` 文件夹，**全选里面的内容**（不是选文件夹本身），拖进网页。
4. 等进度条走完（约 125 个文件、5.8 MB，1~2 分钟），下方填提交信息，比如
   `feat: 食光 MealLens v1.0 - 离线热量查询 + 拍照识别 + 三餐推荐`，点 **Commit changes**。
5. 仓库地址形如 `https://github.com/<你的用户名>/meallens`。

> 网页上传限制：单文件 ≤ 25MB（本仓库最大文件是 `data/embedded.js` 约 350KB，没问题）、
> **一次提交最多 100 个文件**。本仓库共 125 个文件，所以网页上传要分两批：
> - 第 1 批：根目录的文件 + `src` `server` `data` `docs` `dist` `icons`（约 40 个）
> - 第 2 批：`samples` `tests` `tools` `vision` `android`（其余文件）
>
> 两次都点 `Add file → Upload files`，第二次提交信息写 `chore: 补齐测试、工具与安卓工程`。
> 觉得麻烦就走方式 B / C（一次推完，还能持续提交）。

---

## 方式 B：GitHub Desktop（图形界面，推荐长期用）

1. 下载安装 <https://desktop.github.com/> ，用 GitHub 账号登录。
2. 菜单 `File → Add local repository…`，选桌面上的 `meallens-github` 文件夹；
   若提示 "not a Git repository"，点 **create a repository** 并确认。
3. 左下角填提交信息 → 点 **Commit to main**。
4. 点顶部 **Publish repository**，取消勾选 "Keep this code private"（想公开的话），确认。
5. 以后每次改完：Commit → Push origin。

---

## 方式 C：命令行 Git（最标准）

先装 Git：<https://git-scm.com/download/win>（一路 Next 即可），装完**重开**一个 PowerShell：

```powershell
cd "$env:USERPROFILE\Desktop\meallens-github"

git init
git add .
git commit -m "feat: 食光 MealLens v1.0 - 离线热量查询 + 拍照识别 + 三餐推荐"

# 第一次用 Git 需要设置身份（换成你自己的邮箱/昵称）
git config user.name  "你的名字"
git config user.email "you@example.com"

# 在 GitHub 上先建好空仓库，然后把下面地址换成你的
git branch -M main
git remote add origin https://github.com/<你的用户名>/meallens.git
git push -u origin main
```

推送时会弹窗要求登录：选 **Sign in with your browser** 最省事；
或者用 Personal Access Token 当密码（<https://github.com/settings/tokens>，勾 `repo` 权限）。

---

## 上传后建议做三件事

1. **改 README 里的占位**：把 `<你的用户名>` 换成真实账号，检查截图路径是否正常显示。
2. **写一句仓库简介**（About 右侧 ⚙️）：`离线优先的中文热量查询 App：582 条食物成分、108 道菜、拍照识别、三餐推荐、安卓 APK`
   并加上 Topics：`nutrition` `calorie-counter` `chinese-food` `qwen2.5-vl` `llama.cpp` `android` `vanilla-js` `offline-first`
3. **确认没把隐私传上去**：本文件夹已排除模型、SDK、签名密钥；如果你自己加过 `.env` 或 API Key，务必先删掉。

## 常见问题

- **提示某个文件超过 100MB**：本仓库不该有这种文件。若出现，说明你手动放进了模型（`vision/models/`），删掉再传。
- **想连模型一起备份**：不要放 Git！用网盘或 Git LFS；仓库只放代码与数据。
- **中文文件名**：Git 默认能处理，但建议在 `git config --global core.quotepath false` 后再 `git status`，中文不乱码。
