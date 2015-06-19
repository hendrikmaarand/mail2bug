$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$nugetDir = $($Env:TF_BUILD_BINARIESDIRECTORY + "\nuget")

write-output "package.nuspec: $($PSScriptRoot + '\package.nuspec')"
write-output "nugetdir: $nugetDir"
 
Copy-Item $($PSScriptRoot + "\package.nuspec") $nugetDir 

write-output "after copy"

$newVersion = GetVersionByReason
& 'c:\tools\nuget\nuget.exe' pack $($nugetDir + "\package.nuspec") -Version "$newVersion" -OutputDirectory $nugetDir

write-output "end"
