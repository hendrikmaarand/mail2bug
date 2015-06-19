$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$nugetDir = $($Env:TF_BUILD_BINARIESDIRECTORY + "\nuget")
$binaryPath = $Env:TF_BUILD_BINARIESDIRECTORY

New-Item -ItemType directory -Path $nugetDir
Copy-Item $($PSScriptRoot + "\package.nuspec") $nugetDir 
Copy-Item $($binaryPath + "\*.dll") $nugetDir
Copy-Item $($binaryPath + "\*.config") $nugetDir
Copy-Item $($binaryPath + "\Mail2Bug.exe") $nugetDir
Copy-Item $($binaryPath + "\DpapiTool.exe") $nugetDir

$newVersion = GetVersionByReason
& 'c:\tools\nuget\nuget.exe' pack $($nugetDir + "\package.nuspec") -Version "$newVersion" -OutputDirectory $nugetDir
