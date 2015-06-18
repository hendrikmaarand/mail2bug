$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$nugetDir = $($Env:TF_BUILD_BINARIESDIRECTORY + "\nuget")
 
Copy-Item $($PSScriptRoot + "\package.nuspec") $nugetDir

$newVersion = GetVersionByReason
& 'c:\tools\nuget\nuget.exe' pack $($nugetDir + "\package.nuspec") -Version "$newVersion" -OutputDirectory $nugetDir
