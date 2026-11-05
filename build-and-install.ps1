# Windows: build and install Bing Wallpaper on Android TV / Google TV.
#
# Usage: .\build-and-install.ps1 [-TvHost 192.168.1.33]
#        .\build-and-install.ps1 -Uninstall
param(
    [string]$TvHost,
    [switch]$Uninstall
)
$ErrorActionPreference = 'Stop'
$pkg = 'com.gathin.bingwallpaper'
$here = $PSScriptRoot

if ($TvHost) {
    adb connect $TvHost | Out-Null
}

if ($Uninstall) {
    adb uninstall $pkg
    Write-Host "Uninstalled $pkg"
    exit 0
}

if (-not $env:JAVA_HOME -or -not (Test-Path "$env:JAVA_HOME\bin\java.exe")) {
    $jbr = Get-ChildItem 'C:\Program Files\Android' -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'jbr' } | Where-Object { Test-Path "$_\bin\java.exe" } | Select-Object -First 1
    if ($jbr) { $env:JAVA_HOME = $jbr }
}
if (-not $env:ANDROID_HOME) { $env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk" }

Push-Location $here
try {
    & .\gradlew.bat assembleRelease -q
    if ($LASTEXITCODE) { throw 'build failed (JDK 17 and Android SDK 34 needed)' }
} finally { Pop-Location }

$apk = Join-Path $here 'app\build\outputs\apk\release\app-release.apk'
adb install -r $apk
adb shell "pm grant $pkg android.permission.WRITE_SECURE_SETTINGS 2>/dev/null; true" | Out-Null
adb shell "appops set $pkg AUTO_START allow 2>/dev/null; appops set $pkg APP_AUTO_START allow 2>/dev/null; appops write-settings 2>/dev/null; true" | Out-Null
Write-Host "Installed $pkg and granted permissions."
