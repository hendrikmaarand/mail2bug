function ReplaceVersion($assemblyFile, $version)
{
    (Get-Content $assemblyFile) | 
    Foreach-Object {$_ -replace "(?<=^\[assembly: Assembly\w*Version\(`")\d+\.\d+\.\d+(\.\d+)?(?=`"\)\])", $version} | 
    Set-Content -Encoding UTF8 $assemblyFile
}

function ReplaceVersions($sourcePath, $buildVersion)
{
    ReplaceVersion $($sourcePath + "\Mail2Bug\Properties\AssemblyInfo.cs") $buildVersion
}

function GetVersionByReason
{
    if($Env:TF_BUILD_BUILDREASON -eq "Manual")
    {
        $versionSplit = $Env:TF_BUILD_BUILDNUMBER.Split(".")
        $newVersion = $versionSplit[0] + "." + $versionSplit[1] + "." + $versionSplit[2]
    }
    else
    {
        $newVersion = $Env:TF_BUILD_BUILDNUMBER
    }
    return $newVersion
}