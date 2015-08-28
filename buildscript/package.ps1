$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$nugetDir = $($Env:TF_BUILD_BINARIESDIRECTORY + "\nuget")
$mail2BugDir = $($nugetDir + "\Mail2Bug")
$binaryPath = $Env:TF_BUILD_BINARIESDIRECTORY

New-Item -ItemType directory -Path $nugetDir
New-Item -ItemType directory -Path $mail2BugDir

Copy-Item $($PSScriptRoot + "\package.nuspec") $nugetDir 
Copy-Item $($binaryPath + "\*.dll") $mail2BugDir
Copy-Item $($binaryPath + "\*.config") $mail2BugDir
Copy-Item $($binaryPath + "\Mail2Bug.exe") $mail2BugDir
Copy-Item $($binaryPath + "\DpapiTool.exe") $mail2BugDir
Copy-Item $($binaryPath + "Scripts\build-config.ps1") $mail2BugDir

$newVersion = GetVersionByReason
& 'c:\tools\nuget\nuget.exe' pack $($nugetDir + "\package.nuspec") -Version "$newVersion" -OutputDirectory $nugetDir
