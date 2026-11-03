@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "PORT=8787"
if not "%MEALLENS_PORT%"=="" set "PORT=%MEALLENS_PORT%"
set "URL=http://127.0.0.1:%PORT%/"

echo.
echo   ============================================
echo      食光 MealLens · 热量查询与饮食指南
echo   ============================================
echo.

rem ---- 1. 找一个可用的 Python ----
set "PY="
if not "%MEALLENS_PYTHON%"=="" if exist "%MEALLENS_PYTHON%" set "PY=%MEALLENS_PYTHON%"
if not defined PY if exist "%~dp0..\.venv\Scripts\python.exe" set "PY=%~dp0..\.venv\Scripts\python.exe"
if not defined PY if exist "%~dp0..\python\python.exe" set "PY=%~dp0..\python\python.exe"
if not defined PY if exist "%USERPROFILE%\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe" set "PY=%USERPROFILE%\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
if not defined PY if exist "D:\编程算法\python\python.exe" set "PY=D:\编程算法\python\python.exe"
if not defined PY (
  where python >nul 2>nul
  if !errorlevel! equ 0 set "PY=python"
)
if not defined PY (
  where py >nul 2>nul
  if !errorlevel! equ 0 set "PY=py"
)
if not defined PY (
  echo   [X] 没有找到 Python。请安装 Python 3.9+ 后重试。
  echo       或设置环境变量 MEALLENS_PYTHON 指向 python.exe
  echo.
  pause
  exit /b 1
)

echo   [1/3] Python: %PY%
"%PY%" -c "import sys;print('       版本:',sys.version.split()[0])" 2>nul

rem ---- 2. 检查关键文件 ----
set "MISSING="
if not exist "index.html" set "MISSING=!MISSING! index.html"
if not exist "server\server.py" set "MISSING=!MISSING! server\server.py"
if not exist "data\foods.json" set "MISSING=!MISSING! data\foods.json"
if not exist "data\dishes.json" set "MISSING=!MISSING! data\dishes.json"
if not exist "data\guide.json" set "MISSING=!MISSING! data\guide.json"
if defined MISSING (
  echo   [注意] 缺少文件:!MISSING!
  echo       查询与配餐功能需要这些数据文件。
)

rem ---- 3. 视觉识别状态 ----
set "VEXE="
if exist "vision\bin\vulkan\llama-server.exe" set "VEXE=vision\bin\vulkan\llama-server.exe"
if not defined VEXE if exist "vision\bin\cpu\llama-server.exe" set "VEXE=vision\bin\cpu\llama-server.exe"
set "VMODEL="
if exist "vision\models\Qwen2.5-VL-3B-Instruct-Q4_K_M.gguf" if exist "vision\models\mmproj-F16.gguf" set "VMODEL=1"
if defined VMODEL if defined VEXE (
  echo   [2/3] 视觉识别: 就绪 ^(Qwen2.5-VL-3B + llama.cpp^)，首次进拍照页约 10-60 秒预热，之后单张 1-4 秒
) else (
  if defined VMODEL (
    echo   [2/3] 视觉识别: 模型已就位但缺 vision\bin 下的 llama-server.exe，拍照页用手动模式
  ) else (
    echo   [2/3] 视觉识别: 未安装本地模型，拍照页用手动模式 ^(查询/配餐/记录不受影响，安装见 README^)
  )
)

rem ---- 3.4 手机版提示 ----
if exist "dist\MealLens.apk" echo   [手机版] dist\MealLens.apk 已打包，传到安卓手机安装即可离线使用

rem ---- 3.5 端口占用检查 ----
netstat -ano | findstr /c:":%PORT%" | findstr /c:"LISTENING" >nul 2>nul
if not errorlevel 1 (
  echo   [注意] 端口 %PORT% 已被占用 —— 多半是上次的服务窗口还开着，这不是错误。
  "%PY%" -X utf8 "tools\_healthline.py"
  echo       若上面显示"识别引擎就绪"，直接打开 %URL% 就能拍照识别；
  echo       若显示【无法读取服务状态】，说明占着端口的是已退出的旧进程，等 30 秒再双击本脚本；
  echo       仍不行就换个端口：先执行 set MEALLENS_PORT=8790 再双击本脚本。
  echo.
  start "" "%URL%"
  pause
  exit /b 0
)

rem ---- 4. 启动服务并打开浏览器 ----
echo   [3/3] 正在启动本地服务 %URL%
echo.
echo   ------------------------------------------------
echo    手机与电脑在同一 WiFi 时，可用局域网地址访问
echo    识别一直不行？关掉本窗口后双击 自检.bat，会把问题定位到具体环节
echo    关闭本窗口即停止服务
echo   ------------------------------------------------
echo.

start "" /b cmd /c "ping -n 3 127.0.0.1 >nul & start "" "%URL%""
"%PY%" -u "server\server.py"

echo.
echo   服务已退出。
pause
