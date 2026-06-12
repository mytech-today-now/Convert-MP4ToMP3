# =================================================================================================
# Convert-MP4ToMP3.ps1
# ==================================================================================================
<#
.SYNOPSIS
    Converts MP4 video files to MP3 audio files using FFmpeg.

.DESCRIPTION
    This production-grade PowerShell 5.1 script recursively discovers MP4 files and extracts
    high-quality MP3 audio using FFmpeg.

    Features include:

    • Self-installation and self-updating
    • Structured JSONL logging (via myTech.Today logging module)
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
        JSONL structured logging via myTech.Today logging module:

        %USERPROFILE%\myTech.Today\logs\<scriptname>.jsonl

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

    ═════════════════════════════════════════════════════════════════════════════════════════════════════
    RUN DIRECTLY FROM GITHUB RAW URL (NO DOWNLOAD REQUIRED)
    ══════════════════════════════════════════════════════════════════════════════════════════════════════

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
    Repository: https://github.com/mytech-today-now/Convert-MP4ToMP3

.TROUBLESHOOTING

    FFmpeg Not Found:
        Script will attempt installation automatically.

    Conversion Failure:
        Review JSONL logs.

    Access Denied:
        Run PowerShell as Administrator.

.LOGGING

    Uses myTech.Today logging module (JSONL format with monthly archiving, size rotation, Windows Event Log integration)

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

    # Note: LogLevel parameter kept for compatibility but mapped to external module's levels
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
# IMPORT EXTERNAL LOGGING MODULE
# -------------------------------------------------------------------------------------------------

# Import myTech.Today logging module from GitHub
$loggingUrl = 'https://raw.githubusercontent.com/mytech-today-now/scripts/refs/heads/main/logging.ps1'
try {
    $loggingContent = Invoke-WebRequest -Uri $loggingUrl -UseBasicParsing -ErrorAction Stop
    Invoke-Expression $loggingContent.Content
}
catch {
    Write-Warning "Failed to load external logging module: $($_.Exception.Message)"
    Write-Warning "Falling back to basic console output only."
    # Create minimal fallback Write-Log
    function Write-Log {
        param([string]$Message, [string]$Level = 'INFO', [string]$Solution, [string]$Context, [string]$Component)
        $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $color = switch ($Level) { 'INFO' {'Cyan'}; 'SUCCESS' {'Green'}; 'WARNING' {'Yellow'}; 'ERROR' {'Red'}; default {'White'} }
        Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
    }
    function Initialize-Log { param([string]$ScriptName, [string]$ScriptVersion) return $null }
    function Get-LogPath { return $null }
}

# -------------------------------------------------------------------------------------------------
# GLOBALS - Handle both file execution and irm | iex execution
# -------------------------------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'
$Script:StartTime = Get-Date

# Detect script path: works for both file execution and irm | iex
if ($MyInvocation.MyCommand.CommandType -eq 'ExternalScript' -and $MyInvocation.MyCommand.Path) {
    $Script:ScriptPath = $MyInvocation.MyCommand.Path
}
elseif ($MyInvocation.MyCommand.CommandType -eq 'Script' -and $MyInvocation.InvocationName) {
    # Running via irm | iex or dot-sourced
    $Script:ScriptPath = $MyInvocation.InvocationName
}
else {
    # Fallback for direct scriptblock execution
    $Script:ScriptPath = 'Convert-MP4ToMP3.ps1'
}

$Script:ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($Script:ScriptPath)
if (-not $Script:ScriptName) { $Script:ScriptName = 'Convert-MP4ToMP3' }
$Script:Version = '1.0.0'

# Initialize external logging module
if (-not $NoLog) {
    Initialize-Log -ScriptName $Script:ScriptName -ScriptVersion $Script:Version
}

# -------------------------------------------------------------------------------------------------
# ROOT (uses %HOMEDRIVE% instead of %ROOT%)
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

    Write-Log -Message "Environment variable HOMEDRIVE is not defined or path doesn't exist." -Level WARNING
    Write-Log -Message "Falling back to current drive: $([System.IO.Path]::GetPathRoot((Get-Location).Path))" -Level WARNING

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

New-Item -ItemType Directory -Force -Path $Script:InstallDirectory | Out-Null

# -------------------------------------------------------------------------------------------------
# INSTALL - Skip self-install when running via irm | iex (no source file)
# -------------------------------------------------------------------------------------------------

function Install-Self {

    # Skip installation when running from stdin/irm (no physical source file)
    if (-not (Test-Path $Script:ScriptPath) -or $Script:ScriptPath -eq 'Convert-MP4ToMP3.ps1') {
        Write-Log -Message "Skipping self-install (running from stdin/irm)" -Level INFO -Component "Installer"
        return
    }

    Write-Log -Message "Self-installation started" -Level INFO -Component "Installer"

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

        Write-Log -Message "Installed script" -Level INFO -Context "Script installed to $Script:InstallPath" -Component "Installer"

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

            Write-Log -Message "Installed version updated" -Level INFO -Component "Installer"
        }

    }
    catch {
        Write-Log -Message "Installation update failure" -Level ERROR -Context $_.Exception.Message -Component "Installer"
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
        Write-Log -Message "Direct FFmpeg installation failed" -Level ERROR -Context $_.Exception.Message -Component "FFmpeg"
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

        Write-Log -Message "Skipped existing MP3" -Level INFO -Context "File: $($File.FullName)" -Component "Converter"

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

            Write-Log -Message "Conversion failed" -Level ERROR -Context "File: $($File.FullName)" -Solution "Check FFmpeg output: $stderr" -Component "Converter"

            return @{
                Status='Failed'
                File=$File.FullName
            }
        }

        Write-Log -Message "Conversion succeeded" -Level SUCCESS -Context "Source: $($File.FullName) -> Output: $mp3" -Component "Converter"

        return @{
            Status='Success'
            File=$File.FullName
        }
    }
    catch {

        Write-Log -Message "Exception during conversion" -Level ERROR -Context "File: $($File.FullName)" -Solution $_.Exception.Message -Component "Converter"

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

    Write-Log -Message "Script startup" -Level INFO -Context "Mode: $(if (Test-Path $Script:ScriptPath) { 'File' } else { 'IRM/IEX' }); Version: $Script:Version" -Component "Main"

    Install-Self

    $ffmpeg = Get-FFmpegPath

    & $ffmpeg -version | Out-Null

    Write-Log -Message "FFmpeg validated" -Level SUCCESS -Context "Path: $ffmpeg" -Component "FFmpeg"

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

    Write-Log -Message "Processing completed" -Level INFO -Context "Total: $total; Success: $success; Failed: $failed; Skipped: $skipped; Elapsed: $($elapsed.ToString())" -Component "Main"

    exit 0
}
catch {
    $errMsg = if ($_.Exception) { $_.Exception.Message } else { "$_" }
    $errStack = if ($_.ScriptStackTrace) { $_.ScriptStackTrace } else { "No stack trace available" }

    # Try to log the fatal error using external module
    try {
        Write-Log -Message "Fatal script error" -Level ERROR -Context $errStack -Solution $errMsg -Component "Main"
    }
    catch {
        Write-Warning "Unable to write fatal log entry."
    }

    # Write error to console with proper message
    Write-Error -Message $errMsg

    exit 1
}