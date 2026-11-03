@echo off
chcp 936 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo.
echo   ============================================
echo      食光 MealLens · 一键自检
echo   ============================================
echo   会依次检查：运行环境、数据/模型文件、本地服务、识别引擎，
echo   并拿一张样例照片真的做一次识别，最后把报告存成 诊断报告.txt
echo.

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
  echo   [X] 没找到 Python，无法自检。请先安装 Python 3.9+。
  echo.
  pause
  exit /b 1
)

"%PY%" -u -X utf8 "tools\doctor.py" %*

echo.
echo   ------------------------------------------------
echo   上面就是全部检查结果；同样的内容已存到 诊断报告.txt
echo   如果第 4 节显示「识别链路正常」，但网页里还是识别不了：
echo     1) 在网页里按 Ctrl+F5 强制刷新
echo     2) 确认你打开的是 http://127.0.0.1:8787 而不是直接双击 index.html
echo   ------------------------------------------------
echo.
pause
