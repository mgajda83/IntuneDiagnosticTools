Function Test-IntuneCert
{
    [CmdletBinding()]
    Param()

    $Enrollment = Get-IntuneEnrollment
    $Cert = Get-ChildItem Cert:\LocalMachine\My\$($Enrollment.DMPCertThumbPrint)
    if ($Cert)
    {
        if($Cert.NotAfter -ge (Get-Date))
        {
            Write-Verbose "Intune Device Certificate $($Cert.Thumbprint) is valid to $($Cert.NotAfter)"
        } else {
            Write-Warning "Intune Device Certificate $($Cert.Thumbprint) is expired: $($Cert.NotAfter)!"
        }

        if($Cert.HasPrivateKey)
        {
            Write-Verbose "Intune Device Certificate $($Cert.Thumbprint) has private key"
        } else {
            Write-Warning "Intune Device Certificate $($Cert.Thumbprint) has no private key!"
        }

        $Cert | Select-Object *
    } else {
        Write-Warning "Missing current Intune Device Certificate"
        $Cert = Get-ChildItem Cert:\LocalMachine\My\ | Where-Object { $_.issuer -like "*Microsoft Intune MDM Device CA*" }
        $Cert
    }
}
