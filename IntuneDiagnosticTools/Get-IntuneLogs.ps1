Function Get-IntuneLogs
{
    [CmdletBinding()]
    Param
    (
        [String]$Path = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log",
        [String]$SelectString,
        [Int]$Tail
    )

    if($Tail)
    {
        $SyncEvents = Get-Content $Path -Tail $Tail
    } else {
        $SyncEvents = Get-Content $Path
    }

    if($SelectString)
    {
        $SyncEvents = $SyncEvents | Select-String $SelectString
    }

    $Total = $(($SyncEvents | Measure-Object).Count)
    $Counter = 1

    $Events = @()
    Foreach($SyncEvent in $SyncEvents)
    {
        Write-Progress -Activity "Processing" -status "$Counter / $Total" -percentcomplete $([Int](($Counter/$Total)*100))
        $Counter++

        if($SyncEvent -Match '^\<\!\[LOG\[(?<message>.*)]LOG\].*\<time="(?<hour>[0-9]{1,2}):(?<minute>[0-9]{1,2}):(?<second>[0-9]{1,2}).(?<milisecond>[0-9]{1,})".*date="(?<month>[0-9]{1,2})-(?<day>[0-9]{1,2})-(?<year>[0-9]{4})" component="(?<component>.*?)" context="(?<context>.*?)" type="(?<type>.*?)" thread="(?<thread>.*?)" file="(?<file>.*?)">$')
        {
            $Event = [PSCustomObject]@{
                Message = $Matches.message
                DateTime = Get-Date -Year $Matches.year -Month $Matches.month -Day $Matches.day -Hour $Matches.hour -Minute $Matches.minute -Second $Matches.second
                File = $Matches.file
                Thread = $Matches.thread
                Type = $Matches.type
                Component = $Matches.component
                Context = $Matches.context
            }
            $Events += $Event
        }
    }

    Return $Events
}
