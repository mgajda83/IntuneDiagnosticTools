Function Get-IntuneDiagnostics
{
    [CmdletBinding()]
    Param
    (
        [String]$LogsPath = "C:\temp"
    )

    #Area
    $MdmDiagnosticsAreaPath = "HKLM:\SOFTWARE\Microsoft\MdmDiagnostics\Area\"
    $MdmDiagnosticsArea = Get-ChildItem -Path $MdmDiagnosticsAreaPath | Select-Object -exp PSChildName
    $DiagnosticsCommandArea = "-area '" + $($MdmDiagnosticsArea -join ";") + "'"

    #Out/Zip
    if($LogsPath -match "\.zip")
    {
        $DiagnosticsCommandPath = "-zip $LogsPath"
    } else {
        $LogsPath = Join-Path -Path $LogsPath -ChildPath $($Env:ComputerName + ".zip")
        $DiagnosticsCommandPath = "-zip $LogsPath"
    }

    if(Test-Path -Path $LogsPath)
    {
        Remove-Item -Path $LogsPath -Force
    }

    $DiagnosticsCommand = "MdmDiagnosticsTool.exe $DiagnosticsCommandArea $DiagnosticsCommandPath"
    Write-Verbose $DiagnosticsCommand

    Invoke-Expression -Command $DiagnosticsCommand
    Write-Verbose $LogsPath
}
