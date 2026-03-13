@echo off
echo Creating Agent Home directory structures...

REM Define agent names
set AGENTS=Tai_ProductManager Tai_SystemAnalyst Tai_Architect Tai_Developer Tai_Tester Tai_DevOps Tai_Documenter Tai_UserAgent

REM Define subdirectories
set SUBDIRS=outputs drafts configs notes resources temp backups

REM Create directories for each agent
for %%A in (%AGENTS%) do (
    echo Creating directories for %%A...
    for %%S in (%SUBDIRS%) do (
        powershell -Command "New-Item -ItemType Directory -Path 'd:\CodeBuddy-OpenClaw-Tutorial\03-multiagent\%%A_Home\%%S' -Force | Out-Null"
    )
)

echo All Agent Home directory structures created successfully!
pause
