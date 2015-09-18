param(
    [string]$pathToLogs = ".\Logs",
    [int]$minutesToLookBack = 5,
    [int]$numLastLinesOfLog = 10000
)

$log_file_timestap = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date
$timestamp = $timestamp.AddMinutes(-$minutesToLookBack)
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm" $timestamp


$filename = "$pathToLogs\$log_file_timestap.log"

$pattern = "^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}),[0-9]{3} \[[0-9]+\] (.*)"
$stack_pattern = "^\s{3}at\s.*"

$processing_pattern = "*Reading messages from inbox*"
$error_pattern = "*ERROR*"


$processing = $false
$errors = $false

$contents = Get-Content $filename -Tail $numLastLinesOfLog
$count = $contents.Count

# find the starting point of relevant logs
for($i = 0; $i -le $count; $i++) {
    if($contents[$i] -match $pattern) {
        $datetime = $matches[1]
        $date = Get-Date -Date $datetime

        if($date -ge $timestamp) {
            break
        }
    }
} 

# process the relevant logs
for($i; $i -le $count; $i++) {
    $line = $contents[$i]

    if($line -match $pattern) {
        $datetime = $matches[1]
        $text = $matches[2]

        $date = Get-Date -Date $datetime

        if($date -ge $timestamp) {
            if($text -like $processing_pattern) {
                $processing = $true
            }

            if($text -like $error_pattern) {
                $errors = $true
                write $line
            }            
        }
        else {
            # log date should not be less than the timestamp; something odd here
        }        
    }
	elseif(-not $line) {
		# ignore
	}
    else {
        # if the line does not match the pattern then it is probably stack trace or something
        $errors = $true
        if(-not ($line -match $stack_pattern)) {
            write $line # do not write stack trace to output 
        }        
    }
}

if(-not $processing -and -not $errors) {
    write "No log entries indicating that Mail2Bug is processing were found!"
}

if(-not $processing -or $errors) {
    # not processing mails or having errors is a problem
    exit 2
} 
else {
    Write-Host 'Logs are OK'
    exit 0
}