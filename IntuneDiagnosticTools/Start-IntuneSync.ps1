Function Start-IntuneSync
{
    [CmdletBinding()]
    Param()

    $Timestamp = Get-Date

    $Shell = New-Object -ComObject Shell.Application
    Write-Verbose "$Timestamp Start app sync now"
    $Shell.open("intunemanagementextension://syncapp")

    Write-Verbose "$Timestamp Start compliance sync now"
    $Shell.open("intunemanagementextension://synccompliance")

    Start-Sleep -Seconds 10
    Get-IntuneSync -Last
}
