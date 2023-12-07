Function Get-IntuneEnrollment
{
      [CmdletBinding()]
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

                  Get-ItemProperty $EnrollmentPath
                  break
            }
      }
}
