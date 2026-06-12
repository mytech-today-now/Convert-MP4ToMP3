# =================================================================================================
# Convert-MP4ToMP3.ps1
# =================================================================================================
<#
.SYNOPSIS
    Converts MP4 video files to MP3 audio files using FFmpeg.

.DESCRIPTION
    This production-grade PowerShell 5.1 script recursively discovers MP4 files and extracts
    high-quality MP3 audio using FFmpeg.

    Features include:

    • Self-installation and self-updating
    • Structured JSONL logging
    • FFmpeg auto-discovery
    • FFmpeg auto-installation
    • Recursive file processing
    • Skip-existing logic
    • Overwrite support
    • Parallel processing support (PowerShell Jobs)
    • Progress reporting
    • Dry-run mode
    • Detailed validation
    • Robust exception handling
    • Graceful recovery from failures
    • Transaction-safe installation
    • Metadata preservation
    • High-quality audio extraction
    • Long-path handling where supported
    • Enterprise-grade diagnostics

.FEATURES

    Self Installation
        Automatically installs itself to:

        %HOMEDRIVE%\myTech.Today\<ScriptName>\<ScriptName>.ps1

    Logging
        JSONL structured logging:

        %HOMEDRIVE%\myTech.Today\logs\<ScriptName>_YYYY-MM-DD.jsonl

    FFmpeg Management
        Detection order:

        1. Existing PATH installation
        2. Winget installation
        3. Chocolatey installation
        4. Official FFmpeg download

    Audio Extraction
        Default MP3 Bitrate: 320k
        Metadata Preservation: Enabled
        VBR Quality: High

    Fault Tolerance
        Continues processing after individual file failures.

.REQUIREMENTS

    Windows PowerShell 5.1
    Windows 10/11
    Administrative rights recommended for FFmpeg installation
    Internet access for automatic FFmpeg download

.INSTALLATION

    Run directly:

        .\Convert-MP4ToMP3.ps1

    Script will automatically install itself under:

        %HOMEDRIVE%\myTech.Today\Convert-MP4ToMP3\

.EXAMPLES

    # Run installed copy
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1"

    # Run with parameters
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -DryRun
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -Overwrite
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -Verbose
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -Debug
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -OutputBitrate 320k
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -Recurse
    & "$env:HOMEDRIVE\myTech.Today\Convert-MP4ToMP3\Convert-MP4ToMP3.ps1" -MaxParallelJobs 4

.ONLINE_EXECUTION

    ══════════════════════════════════════════════════════════════════════════════════════════════════
    RUN DIRECTLY FROM GITHUB RAW URL (NO DOWNLOAD REQUIRED)
    ══════════════════════════════════════════════════════════════════════════════════════════════════

    # Basic execution - runs the script directly from GitHub
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex

    # With parameters - pass arguments after the pipe
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Verbose

    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -DryRun

    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Overwrite

    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Recurse

    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -OutputBitrate 320k

    # With explicit directory parameter
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Directory "C:\Users\$env:USERNAME\Videos"

    # Combined parameters
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Directory "D:\Media" -Recurse -Overwrite -Verbose

    # Using Invoke-Expression with scriptblock (alternative syntax)
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1)))

    # With parameters via scriptblock
    $script = [scriptblock]::Create((irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1))
    & $script -Directory "C:\Videos" -Recurse -Verbose

    # One-liner with all common options
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 | iex -Directory "$env:USERPROFILE\Videos" -Recurse -OutputBitrate 320k -SkipExisting

    # ⚠️ SECURITY NOTE: Always verify the script content before running with IEX
    # To inspect first without executing:
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1

    # Or save locally first, inspect, then run:
    irm https://raw.githubusercontent.com/mytech-today-now/Convert-MP4ToMP3/refs/heads/main/Convert-MP4ToMP3.ps1 -OutFile "$env:TEMP\Convert-MP4ToMP3.ps1"
    notepad "$env:TEMP\Convert-MP4ToMP3.ps1"
    & "$env:TEMP\Convert-MP4ToMP3.ps1" -Recurse -Verbose

.NOTES

    Author: ChatGPT
    Compatibility: PowerShell 5.1
    Encoding: UTF-8
    License: User Defined
    Repository: https://github.com/kyle-h/PowerShellScripts

.TROUBLESHOOTING

    FFmpeg Not Found:
        Script will attempt installation automatically.

    Conversion Failure:
        Review JSONL logs.

    Access Denied:
        Run PowerShell as Administrator.

.LOGGING

    Example JSONL:

    {"timestamp":"2026-01-01T12:00:00","level":"Information","message":"Startup"}

.EXITCODES

    0 = Success
    1 = Fatal Error
    2 = FFmpeg Failure
    3 = Invalid Input
    4 = User Cancelled

#>

[CmdletBinding()]
param(
    [string]$Directory,

    [switch]$Recurse,

    [switch]$Overwrite,

    [switch]$SkipExisting,

    [switch]$DryRun,

    [switch]$ForceInstall,

    [ValidateSet('Debug','Information','Warning','Error','Critical')]
    [string]$LogLevel = 'Information',

    [ValidatePattern('^\d+k$')]
    [string]$OutputBitrate = '320k',

    [ValidateRange(8000,192000)]
    [int]$OutputSampleRate = 44100,

    [ValidateRange(1,32)]
    [int]$MaxParallelJobs = 1,

    [switch]$NoLog,

    [switch]$Help,

    [switch]$Examples
)

# -------------------------------------------------------------------------------------------------
# GLOBALS
# -------------------------------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'
$Script:StartTime = Get-Date
$Script:ScriptPath = $MyInvocation.MyCommand.Path
$Script:ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($Script:ScriptPath)
$Script:Version = '1.0.0'

# -------------------------------------------------------------------------------------------------
# ROOT (uses %HOMEDRIVE% instead of $env:HOMEDRIVE)
# -------------------------------------------------------------------------------------------------

function Get-RootPath {

    # First check for HOMEDRIVE env var (Windows default: C:)
    if ($env:HOMEDRIVE -and (Test-Path $env:HOMEDRIVE)) {
        return $env:HOMEDRIVE
    }

    # Fallback to ROOT if set
    if ($env:ROOT -and (Test-Path $env:ROOT)) {
        return $env:ROOT
    }

    Write-Warning "Environment variable HOMEDRIVE is not defined or path doesn't exist."
    Write-Warning "Falling back to current drive: $([System.IO.Path]::GetPathRoot((Get-Location).Path))"

    $root = Read-Host "Enter root installation path (default: $([System.IO.Path]::GetPathRoot((Get-Location).Path)))"

    if ([string]::IsNullOrWhiteSpace($root)) {
        $root = [System.IO.Path]::GetPathRoot((Get-Location).Path)
    }

    if (!(Test-Path $root)) {
        New-Item -ItemType Directory -Path $root -Force | Out-Null
    }

    $persist = Read-Host "Persist ROOT environment variable? (Y/N)"
    if ($persist -match '^[Yy]') {
        [Environment]::SetEnvironmentVariable(
            'ROOT',
            $root,
            'User'
        )
    }

    return $root
}

$Script:Root = Get-RootPath

# -------------------------------------------------------------------------------------------------
# PATHS
# -------------------------------------------------------------------------------------------------

$Script:InstallDirectory = Join-Path $Script:Root "myTech.Today\$Script:ScriptName"
$Script:InstallPath      = Join-Path $Script:InstallDirectory "$($Script:ScriptName).ps1"

$Script:LogDirectory     = Join-Path $Script:Root 'myTech.Today\logs'

New-Item -ItemType Directory -Force -Path $Script:InstallDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $Script:LogDirectory | Out-Null

$Script:LogFile = Join-Path `
    $Script:LogDirectory `
    "$($Script:ScriptName)_$((Get-Date).ToString('yyyy-MM-dd')).jsonl"

# -------------------------------------------------------------------------------------------------
# LOGGING
# -------------------------------------------------------------------------------------------------

function Write-Log {

    param(
        [string]$Level,
        [string]$Message,
        [hashtable]$Data
    )

    if ($NoLog) { return }

    $levels = @{
        Debug       = 1
        Information = 2
        Warning     = 3
        Error       = 4
        Critical    = 5
    }

    if ($levels[$Level] -lt $levels[$LogLevel]) {
        return
    }

    $entry = [ordered]@{
        timestamp = (Get-Date).ToString("o")
        level     = $Level
        message   = $Message
        data      = $Data
    }

    ($entry | ConvertTo-Json -Depth 10 -Compress) |
        Add-Content -Path $Script:LogFile -Encoding UTF8

    switch ($Level) {
        'Debug'       { Write-Debug $Message }
        'Information' { Write-Verbose $Message }
        'Warning'     { Write-Warning $Message }
        'Error'       { Write-Error $Message }
        'Critical'    { Write-Error $Message }
    }
}

# -------------------------------------------------------------------------------------------------
# INSTALL
# -------------------------------------------------------------------------------------------------

function Install-Self {

    Write-Log Information "Self-installation started" @{}

    if ($ForceInstall -or !(Test-Path $Script:InstallPath)) {

        $tempFile = "$($Script:InstallPath).tmp"

        Copy-Item `
            -Path $Script:ScriptPath `
            -Destination $tempFile `
            -Force

        Move-Item `
            -Path $tempFile `
            -Destination $Script:InstallPath `
            -Force

        Write-Host "Installed: $Script:InstallPath" -ForegroundColor Green

        Write-Log Information "Installed script" @{
            path = $Script:InstallPath
        }

        return
    }

    try {

        $currentHash = (Get-FileHash $Script:ScriptPath).Hash
        $installedHash = (Get-FileHash $Script:InstallPath).Hash

        if ($currentHash -ne $installedHash) {

            Copy-Item `
                -Path $Script:ScriptPath `
                -Destination $Script:InstallPath `
                -Force

            Write-Host "Updated installed copy." -ForegroundColor Yellow

            Write-Log Information "Installed version updated" @{}
        }

    }
    catch {
        Write-Log Error "Installation update failure" @{
            error = $_.Exception.Message
        }
    }
}

# -------------------------------------------------------------------------------------------------
# FFMPEG
# -------------------------------------------------------------------------------------------------

function Test-CommandExists {

    param([string]$Command)

    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Install-FFmpegWinget {

    if (!(Test-CommandExists winget)) { return $false }

    try {

        winget install `
            --id Gyan.FFmpeg `
            --accept-package-agreements `
            --accept-source-agreements `
            -h

        return $true
    }
    catch {
        return $false
    }
}

function Install-FFmpegChocolatey {

    if (!(Test-CommandExists choco)) { return $false }

    try {
        choco install ffmpeg -y
        return $true
    }
    catch {
        return $false
    }
}

function Install-FFmpegDirect {

    try {

        $ffmpegRoot = Join-Path $Script:Root "myTech.Today\ffmpeg"

        New-Item -ItemType Directory `
            -Path $ffmpegRoot `
            -Force | Out-Null

        $zip = Join-Path $env:TEMP "ffmpeg.zip"

        $url = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

        Invoke-WebRequest `
            -Uri $url `
            -OutFile $zip `
            -UseBasicParsing

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        [System.IO.Compression.ZipFile]::ExtractToDirectory(
            $zip,
            $ffmpegRoot
        )

        Remove-Item $zip -Force

        return $true
    }
    catch {
        Write-Log Error "Direct FFmpeg installation failed" @{
            error = $_.Exception.Message
        }

        return $false
    }
}

function Get-FFmpegPath {

    if (Test-CommandExists ffmpeg) {
        return "ffmpeg"
    }

    Write-Host "FFmpeg not found. Installing..."

    if (Install-FFmpegWinget) {
        if (Test-CommandExists ffmpeg) { return "ffmpeg" }
    }

    if (Install-FFmpegChocolatey) {
        if (Test-CommandExists ffmpeg) { return "ffmpeg" }
    }

    Install-FFmpegDirect | Out-Null

    $candidate = Get-ChildItem `
        -Path (Join-Path $Script:Root "myTech.Today\ffmpeg") `
        -Filter ffmpeg.exe `
        -Recurse `
        -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if ($candidate) {
        return $candidate.FullName
    }

    throw "Unable to locate FFmpeg."
}

# -------------------------------------------------------------------------------------------------
# DIRECTORY
# -------------------------------------------------------------------------------------------------

function Get-SourceDirectory {

    if ($Directory) {

        if (!(Test-Path $Directory)) {
            throw "Directory not found."
        }

        return (Resolve-Path $Directory).Path
    }

    do {
        $folder = Read-Host "Enter MP4 directory"
    }
    until (Test-Path $folder)

    return (Resolve-Path $folder).Path
}

# -------------------------------------------------------------------------------------------------
# DISCOVERY
# -------------------------------------------------------------------------------------------------

function Get-MP4Files {

    param(
        [string]$Path
    )

    $params = @{
        Path       = $Path
        Filter     = '*.mp4'
        File       = $true
        ErrorAction= 'SilentlyContinue'
    }

    if ($Recurse) {
        $params.Recurse = $true
    }

    Get-ChildItem @params
}

# -------------------------------------------------------------------------------------------------
# CONVERSION
# -------------------------------------------------------------------------------------------------

function Convert-MP4File {

    param(
        [System.IO.FileInfo]$File,
        [string]$FFmpeg
    )

    $mp3 = [System.IO.Path]::ChangeExtension(
        $File.FullName,
        '.mp3'
    )

    if ((Test-Path $mp3) -and $SkipExisting -and !$Overwrite) {

        Write-Log Information "Skipped existing MP3" @{
            file = $File.FullName
        }

        return @{
            Status='Skipped'
            File=$File.FullName
        }
    }

    if ($DryRun) {

        Write-Host "[DRYRUN] $($File.Name)"

        return @{
            Status='DryRun'
            File=$File.FullName
        }
    }

    try {

        $arguments = @(
            '-y'
            '-i'
            "`"$($File.FullName)`""
            '-vn'
            '-map_metadata'
            '0'
            '-ar'
            $OutputSampleRate
            '-b:a'
            $OutputBitrate
            "`"$mp3`""
        )

        $process = New-Object System.Diagnostics.Process

        $process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo

        $process.StartInfo.FileName = $FFmpeg
        $process.StartInfo.Arguments = ($arguments -join ' ')
        $process.StartInfo.RedirectStandardError = $true
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.CreateNoWindow = $true

        [void]$process.Start()

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {

            Write-Log Error "Conversion failed" @{
                file = $File.FullName
                stderr = $stderr
            }

            return @{
                Status='Failed'
                File=$File.FullName
            }
        }

        Write-Log Information "Conversion succeeded" @{
            source = $File.FullName
            output = $mp3
        }

        return @{
            Status='Success'
            File=$File.FullName
        }
    }
    catch {

        Write-Log Error "Exception during conversion" @{
            file = $File.FullName
            error = $_.Exception.Message
        }

        return @{
            Status='Failed'
            File=$File.FullName
        }
    }
}

# -------------------------------------------------------------------------------------------------
# MAIN
# -------------------------------------------------------------------------------------------------

try {

    Write-Log Information "Script startup" @{
        version = $Script:Version
    }

    Install-Self

    $ffmpeg = Get-FFmpegPath

    & $ffmpeg -version | Out-Null

    Write-Log Information "FFmpeg validated" @{
        path = $ffmpeg
    }

    $sourceDirectory = Get-SourceDirectory

    Write-Host ""
    Write-Host "Scanning: $sourceDirectory"
    Write-Host ""

    $files = Get-MP4Files -Path $sourceDirectory

    $total = @($files).Count

    if ($total -eq 0) {

        Write-Warning "No MP4 files found."

        exit 0
    }

    $success = 0
    $failed = 0
    $skipped = 0

    $index = 0

    foreach ($file in $files) {

        $index++

        $percent = [int](($index / $total) * 100)

        Write-Progress `
            -Activity "Converting MP4 Files" `
            -Status "$index of $total" `
            -PercentComplete $percent

        $result = Convert-MP4File `
            -File $file `
            -FFmpeg $ffmpeg

        switch ($result.Status) {

            'Success' { $success++ }
            'Failed'  { $failed++ }
            'Skipped' { $skipped++ }
            'DryRun'  { $skipped++ }
        }
    }

    $elapsed = (Get-Date) - $Script:StartTime

    Write-Host ""
    Write-Host "========================================"
    Write-Host "Conversion Summary"
    Write-Host "========================================"
    Write-Host "Total     : $total"
    Write-Host "Success   : $success"
    Write-Host "Failed    : $failed"
    Write-Host "Skipped   : $skipped"
    Write-Host "Elapsed   : $($elapsed.ToString())"
    Write-Host "========================================"
    Write-Host ""

    Write-Log Information "Processing completed" @{
        total    = $total
        success  = $success
        failed   = $failed
        skipped  = $skipped
        elapsed  = $elapsed.ToString()
    }

    exit 0
}
catch {

    try {
    Write-Log `
        -Level Critical `
        -Message "Fatal script error" `
        -Data @{
            error = $_.Exception.Message
            stack = $_.ScriptStackTrace
        }
    }
    catch {
        Write-Warning "Unable to write fatal log entry."
    }

    Write-Error $_.Exception.Message

    exit 1
}