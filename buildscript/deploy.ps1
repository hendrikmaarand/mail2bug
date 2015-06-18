$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$newVersion = GetVersionByReason
& 'c:\tools\nuget\nuget.exe' push $($Env:TF_BUILD_BINARIESDIRECTORY + "\nuget\Mail2Bug." + $newVersion + ".nupkg") -source "https://nexus-partner.skype.net/service/local/nuget/thirdparty-nuget/"