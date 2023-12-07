Function Get-IntuneSync
{
    [CmdletBinding()]
    Param
    (
        [Switch]$Last
    )

    $Events = Get-IntuneLogs -SelectString "sync now"

    if($Last)
    {
        $Events | Where-Object Message -Match "Started app sync now" | Sort-Object DateTime | Select-Object -Last 1
        $Events | Where-Object Message -Match "Started compliance sync now" | Sort-Object DateTime | Select-Object -Last 1
    } else {
        $Events
    }
}
