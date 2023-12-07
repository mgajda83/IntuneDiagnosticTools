Function Get-IntuneEnrollment
{
      [CmdletBinding(
            SupportsShouldProcess=$True,
            ConfirmImpact="High")]
      Param()

      $EnrollmentsPath = "HKLM:\SOFTWARE\Microsoft\Enrollments\"
      $Enrollments = Get-ChildItem -Path $EnrollmentsPath
      Foreach ($Enrollment in $Enrollments)
      {
            $EnrollmentObject = Get-ItemProperty Registry::$Enrollment
            if ($EnrollmentObject."DiscoveryServiceFullURL" -eq "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc")
            {
                  $EnrollmentPath = $EnrollmentsPath + $EnrollmentObject."PSChildName"
                  Write-Verbose "Intune Enrollment Path: $EnrollmentPath"

                  if($null -ne $EnrollmentPath)
                  {
                        If ($pscmdlet.ShouldProcess($Env:COMPUTERNAME,"Are you sure you want to clear your local Intune enrollment settings?"))
                        {
                              reg export $($EnrollmentPath.Replace(":","")) $($ENV:ProgramData+"\EnrollmentPath.reg") /y
                              Remove-Item -Path $EnrollmentPath -Recurse
                              C:\Windows\System32\DeviceEnroller.exe /c /AutoEnrollMDM
                              gpupdate /force
                        }
                  }
                  break
            }
      }
}
