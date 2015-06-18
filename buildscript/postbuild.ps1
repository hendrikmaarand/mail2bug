$commonFile = $PSScriptRoot + "\common.ps1"
. $commonFile

if($Env:TF_BUILD_BUILDREASON -eq "Manual")
{
    Push-Location $Env:TF_BUILD_SOURCESDIRECTORY
    
    # increment minor version
    $versionSplit = $Env:TF_BUILD_BUILDNUMBER.Split(".")
    $minorVersion = 1 + $versionSplit[1]
    $newVersion = $versionSplit[0] + "." + $minorVersion + "." + $versionSplit[2]
    $oldVersion = GetVersionByReason

    # create tag
    $argument = "tag -a master/" + $oldVersion + " -m tagging HEAD"
    Start-Process -FilePath 'git.exe' -ArgumentList  $argument  -NoNewWindow -Wait -WorkingDirectory $Env:TF_BUILD_SOURCESDIRECTORY 
    & git.exe push origin --tags 2>$null

    # push new version to master
	& git.exe status
    & git.exe reset --hard #> $null 2>&1 # must reset as changes were made in prebuild script
    & git.exe checkout master #> $null 2>&1 # checking out master here to battle detached head issue
	& git.exe pull
    ReplaceVersions $Env:TF_BUILD_SOURCESDIRECTORY $newVersion
	& git.exe add **\AssemblyInfo.cs
    & git.exe commit -m "Increased Assembly Version" #2>$null
    & git.exe push origin master

    Pop-Location
}