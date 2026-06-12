# Convert-MP4ToMP3

> **A production-grade PowerShell script for converting MP4 video files to high-quality MP3 audio using FFmpeg**

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-green.svg)
![License](https://img.shields.io/badge/License-User%20Defined-orange.svg)
![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎬 **Self-Installation** | Auto-installs to `%HOMEDRIVE%\myTech.Today\Convert-MP4ToMP3\` |
| 🔗 **Shortcut Management** | Creates `mp4 2 mp3.lnk` on Desktop & Start Menu (version-aware) |
| 📝 **Structured Logging** | JSONL format with monthly archiving, size rotation, Windows Event Log |
| 🔧 **FFmpeg Auto-Management** | Detects PATH → Winget → Chocolatey → Direct download |
| ⚡ **Progress Indicators** | Spinner during download/install, per-file conversion feedback |
| 📁 **Recursive Processing** | Scans directories recursively with `-Recurse` |
| 🛡️ **Fault Tolerance** | Continues after individual file failures |
| 🔒 **Skip/Overwrite Logic** | Smart handling of existing MP3 files |
| 🌐 **Remote Execution** | Run directly from GitHub raw URL (no download needed) |

---

## 📋 Requirements

- **PowerShell 5.1+** (Windows 10/11)
- **Administrative rights** (recommended for FFmpeg installation)
- **Internet access** (for automatic FFmpeg download)

---

## 🚀 Quick Start

### Option 1: Run Directly from GitHub (No Download)
```powershell
# Basic execution (prompts for directory)
irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1> | iex

# With parameters (use ScriptBlock syntax!)
& ([scriptblock]::Create((irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1)))> -Directory "C:\Videos" -Recurse -Verbose
Option 2: Local Installation
Code
· powershell
# Save and run
irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1> -OutFile "Convert-MP4ToMP3.ps1"
.\Convert-MP4ToMP3.ps1 -Recurse -Verbose
⌨️ Parameters
Parameter	Type	Description
-Directory	String	Source directory containing MP4 files
-Recurse	Switch	Process subdirectories recursively
-Overwrite	Switch	Overwrite existing MP3 files
-SkipExisting	Switch	Skip files that already have MP3 output
-DryRun	Switch	Preview conversions without processing
-ForceInstall	Switch	Force self-installation/update
-OutputBitrate	String	MP3 bitrate (default: 320k)
-OutputSampleRate	Int	Sample rate 8000-192000 (default: 44100)
-MaxParallelJobs	Int	Parallel jobs 1-32 (default: 1)
-NoLog	Switch	Disable logging
-NoShortcut	Switch	Skip shortcut creation
-CreateShortcut	Switch	Force shortcut creation/update
-Verbose	Switch	Verbose output
-Debug	Switch	Debug output
💡 Usage Examples
Basic Conversions
Code
· powershell
# Run installed copy
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1"

# With directory and recursion
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -Directory "D:\Media" -Recurse

# Dry run to preview
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -DryRun -Directory "C:\Videos" -Recurse

# Custom bitrate
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -OutputBitrate 192k -Recurse
Shortcut Management
Code
· powershell
# Install/update shortcuts on Desktop & Start Menu
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -CreateShortcut

# Skip shortcut creation
& "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -NoShortcut
Remote Execution (GitHub)
Code
· powershell
# Basic
& ([scriptblock]::Create((irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1)))>

# With parameters
& ([scriptblock]::Create((irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1)))> -Directory "$env:USERPROFILE\Videos" -Recurse -OutputBitrate 320k -SkipExisting

# Force shortcut creation
& ([scriptblock]::Create((irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1)))> -CreateShortcut
📁 Output Structure
Code
%HOMEDRIVE%\myTech.Today\
├── Convert-MP4ToMP3\
│   ├── Convert-MP4ToMP3.ps1    (installed script)
│   └── ffmpeg\                 (local FFmpeg if downloaded)
└── logs\
    ├── convert-mp4tomp3.jsonl         (current month)
    ├── convert-mp4tomp3.2026-01.jsonl (archived month)
    └── convert-mp4tomp3_archived_*.jsonl (size-rotated)
📝 Log Format (JSONL)
Code
· json
{
  "timestamp": "2026-01-15T14:30:45.1234567Z",
  "level": "SUCCESS",
  "message": "Conversion succeeded",
  "script": { "name": "Convert-MP4ToMP3", "version": "1.0.0" },
  "system": {
    "computer": "DESKTOP-ABC123",
    "user": "jdoe",
    "platform": "Windows",
    "psVersion": "5.1.19041.1"
  },
  "metadata": {
    "processId": 12345,
    "threadId": 5,
    "sessionId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "logPath": "C:\\Users\\jdoe\\myTech.Today\\logs\\convert-mp4tomp3.jsonl"
  },
  "context": "Source: C:\\Videos\\song.mp4 -> Output: C:\\Videos\\song.mp3",
  "component": "Converter"
}


---

## 🎯 Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Fatal Error |
| `2` | FFmpeg Failure |
| `3` | Invalid Input |
| `4` | User Cancelled |

---

## ⚙️ FFmpeg Detection Order

1. **System PATH** → `Get-Command ffmpeg`
2. **Winget** → `winget install --id Gyan.FFmpeg`
3. **Chocolatey** → `choco install ffmpeg -y`
4. **Direct Download** → `gyan.dev/ffmpeg-release-essentials.zip`

---

## 🛡️ Security Notes

<div style="background:#fff3cd; padding:12px; border-radius:6px; border:1px solid #ffc107; color:#856404;">
⚠️ <strong>Always verify script content before running with IEX</strong><br><br>
<strong>Inspect first:</strong><br>
<code>irm <https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1></code><br><br>
<strong>Save locally first:</strong><br>
<code>irm ... -OutFile "$env:TEMP\Convert-MP4ToMP3.ps1"</code><br>
<code>notepad "$env:TEMP\Convert-MP4ToMP3.ps1"</code>
</div>

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| **FFmpeg Not Found** | Script auto-installs; run as Admin if needed |
| **Conversion Failed** | Check JSONL logs in `%USERPROFILE%\myTech.Today\logs\` |
| **Access Denied** | Run PowerShell as Administrator |
| **Shortcuts Not Created** | Run with `-CreateShortcut` flag |

---

## 📦 Repository

**GitHub:** [mytech-today-now/Convert-MP4ToMP3](https://github.com/mytech-today-now/Convert-MP4ToMP3)

---

## 📄 License

User Defined — See repository for details.

---

<div align="center" style="margin-top:24px; color:#6a737d;">
Made with PowerShell • Structured logging via <a href="<https://github.com/mytech-today-now/scripts>">myTech.Today Logging Module</a>
</div>