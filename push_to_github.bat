@echo off
setlocal
cd /d "%~dp0" || exit /b 1

set /p "commitMessage=Commit message: "
if not defined commitMessage (
    echo Commit message cannot be blank.
    exit /b 1
)

git add .
if errorlevel 1 goto failed

git commit -m "%commitMessage%"
if errorlevel 1 goto failed

git push
if errorlevel 1 goto failed

echo Push complete.
exit /b 0

:failed
echo Push failed. Check the Git error above.
exit /b 1
