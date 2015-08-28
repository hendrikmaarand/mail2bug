param(
    [string]$git = "git.exe",
    [string]$configurationRepository = "https://vstfskype.europe.corp.microsoft.com/tfs/Skype/ES/_git/internal_tfs_mail2bug-config",
    [string]$instance = "skype.txt",
    [string]$generate = "generate.ps1",
    [string]$generatedFolder = "Resources",
    [string]$deployFolder = "."
)

$tmpConfDirectory = "tmp-conf-directory-git"


# remove old conf stuff
if(Test-Path $tmpConfDirectory) {
    write "delete $tmpConfDirectory"
    rm -Recurse -Force $tmpConfDirectory
}

write "clone $configurationRepository"
# clone fresh configuration source
&$git clone $configurationRepository $tmpConfDirectory

# build the configurations
try {
    Push-Location "$tmpConfDirectory"
    write "build"
    write ""
    
    $cmd = ".\$generate -configuration $instance"
    iex "& $cmd"
    write ""
}
catch {
    write-error $_.Exception

    # We could not build the configurations, exit the script so the existing in the deployment is not messed up
    Exit
}
finally {
    Pop-Location
}

# delete existing configuration"
if(Test-Path "$deployFolder/$generatedFolder") {
    write "delete deployed conf: $deployFolder/$generatedFolder"    
    rm -Recurse "$deployFolder/$generatedFolder"
}

write "copy"
# copy the configurations 
cp "$tmpConfDirectory/$generatedFolder" "$deployFolder" -Recurse



Write-Host "Done!"