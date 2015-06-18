$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

$newVersion = GetVersionByReason
ReplaceVersions $Env:TF_BUILD_SOURCESDIRECTORY $newVersion