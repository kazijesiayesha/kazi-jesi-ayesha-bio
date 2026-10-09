@echo off
setlocal
cd /d "%~dp0" || exit /b 1

set /p "repoUrl=GitHub Repository Link: "
if not defined repoUrl (
    echo Repository link cannot be blank.
    exit /b 1
)

git init
if errorlevel 1 goto failed

git add .
if errorlevel 1 goto failed

git commit -m "first commit"
if errorlevel 1 goto failed

git branch -M main
if errorlevel 1 goto failed

git remote add origin "%repoUrl%"
if errorlevel 1 goto failed

git push -u origin main
if errorlevel 1 goto failed

set "SOURCE_FILE=%~f0"
set "OUTPUT_FILE=%~dp0push_to_github.bat"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$raw = [IO.File]::ReadAllText($env:SOURCE_FILE); $marker = ':' + ':PUSH_PAYLOAD_BEGIN:' + ':'; $index = $raw.IndexOf($marker, [StringComparison]::Ordinal); if ($index -lt 0) { throw 'Could not find the embedded push script.' }; $body = $raw.Substring($index + $marker.Length).TrimStart([char[]]@([char]13,[char]10)); [IO.File]::WriteAllText($env:OUTPUT_FILE, $body, [Text.Encoding]::ASCII)"
if errorlevel 1 goto failed

del /q "%~f0"
if errorlevel 1 goto delete_failed

echo Setup complete. Created push_to_github.bat.
exit /b 0

:delete_failed
echo Push succeeded and push_to_github.bat was created, but connect_to_github.bat could not be deleted.
exit /b 1

:failed
echo GitHub setup failed. Check the error above, Git installation, and repository link.
exit /b 1

::PUSH_PAYLOAD_BEGIN::
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
