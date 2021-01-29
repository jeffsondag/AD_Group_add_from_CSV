$results = Invoke-Sqlcmd -ServerInstance "cls-md-sql01" -Database "Laserfiche_Forms" -Query "SELECT * FROM dbo.newManagers"
#$results | Export-Csv ".\dbo.newManagers.csv" -NoTypeInformation


#$inputFile = "G:\NorthStar\HR_Export_Reports\ITOC\management_position_list.csv"
$GroupName = "Orion-Company-Managers"

if ($results.Count -gt 100) {
   Get-ADGroupMember $GroupName | ForEach-Object {Remove-ADGroupMember $GroupName $_ -Confirm:$false}
}


#$data = Import-CSV $inputFile

#$data | ForEach {
$results | ForEach {
    #$management = $_.{This is a Management position}
    #$email = $_.{Work Contact: Work Email}
    #$GivenName = $_.{First Name}
    #$Surname = $_.{Last Name}

    $email = $_.{WorkEmail}
    $GivenName = $_.{firstN}
    $Surname = $_.{lastN}

    $systems = $false

        #if ($management -eq "Yes") {


            $userObject = Get-ADUser -Filter "userPrincipalName -eq '$email'" 

            if ($userObject -eq $null) {
                $userObject = Get-ADUser -Filter "(GivenName -eq '$GivenName') -and (Surname -eq '$Surname')"
                $Gi 
            }

            if ($userObject -eq $null) {
                $userObject = Get-ADUser -Filter "emailAddress -eq '$email'"
            }

            if ($userObject -eq $null) {
                $userObject = Get-ADUser -Filter "proxyAddresses -like '*${email}*'"
            }

            if ($userObject -eq $null) {
                $userObject = Get-ADUser -Filter "(GivenName -eq '$GivenName') -and (Surname -eq '$Surname')" -Server systems

                if ($userObject -ne $null) {$systems = $True}
            }

            if ($userObject -eq $null) {
                $userObject = $userObject = Get-ADUser -Filter "emailAddress -eq '$email'" -Server systems
                
                if ($userObject -ne $null) {$systems = $True}
            }
                

            if ($userObject -eq $null) {
                $userObject = Get-ADUser -Filter "proxyAddresses -like '*${email}*'" -Server systems
                if ($userObject -ne $null) {$systems = $True}
            }
            
            if ($userObject -ne $null) {Add-ADGroupMember -Identity $GroupName -Members $userObject}

            
            #$email
            $userObject = $userObject.sAMAccountName
            if ($systems) {write-host "systems\${userObject}"} else {
            Write-Host $userObject
            }
            
        #}
}
$GroupMembers = Get-ADGroupMember -Identity $GroupName
$GroupMembers.count
#$GroupMembers | Export-Csv ".\groupmembers.csv"
