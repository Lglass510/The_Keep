<#
.SYNOPSIS
    Creates GlassLab manager and employee accounts in Active Directory from two CSV files.

.DESCRIPTION
    This is the onboarding code from the 2026-08-24 lab session, collected into one script.
    The logic is the code shown in the screenshots in ../screenshots and ../*.png:
    managers first, then employees with OU placement, a duplicate check, manager lookup
    through $ManagerMap, the Manager attribute (a DN), and Contractor/Remote group membership.

    Changes from the interactive session:
      - The initial password is prompted for (Read-Host -AsSecureString), never typed in plain text.
      - Paths and the domain are parameters.
      - -WhatIf is supported, so the run can be previewed before anything is written to AD.

    Requires: the ActiveDirectory module (RSAT), the Employees/<Dept>, Managers/<Dept> and Groups
    OUs, and the Contractor and Remote global security groups.

.EXAMPLE
    .\Invoke-EmployeeOnboarding.ps1 -WhatIf
    .\Invoke-EmployeeOnboarding.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$EmployeeCsv = "C:\Users\Administrator\Documents\Data\mavlab_employees.csv",
    [string]$ManagerCsv  = "C:\Users\Administrator\Documents\Data\managers.csv",
    [string]$DomainDN    = "DC=glasslab,DC=local",
    [string]$UpnSuffix   = "glasslab.local"
)

Import-Module ActiveDirectory -ErrorAction Stop

$Password = Read-Host "Initial password for new accounts" -AsSecureString

# Employee CSV uses role labels; this maps each label to the manager's real username.
$ManagerMap = @{
    "it.manager"      = "mkowal"
    "hr.manager"      = "rsolomon"
    "legal.manager"   = "khosseini"
    "finance.manager" = "sjmaas"
    "sales.manager"   = "matwood"
}

# --- Managers ---------------------------------------------------------------
foreach ($Manager in (Import-Csv $ManagerCsv)) {
    if (Get-ADUser -Filter "SamAccountName -eq '$($Manager.Username)'") {
        Write-Host "$($Manager.Username) already exists - skipping"
        continue
    }
    $OU = "OU=$($Manager.Department),OU=Managers,$DomainDN"
    if ($PSCmdlet.ShouldProcess($Manager.Username, "Create manager in $OU")) {
        New-ADUser `
            -Name $Manager.Name `
            -SamAccountName $Manager.Username `
            -UserPrincipalName "$($Manager.Username)@$UpnSuffix" `
            -Title $Manager.Title `
            -Department $Manager.Department `
            -Path $OU `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true
    }
}

# --- Employees --------------------------------------------------------------
foreach ($Employee in (Import-Csv $EmployeeCsv)) {

    $OU = "OU=$($Employee.Department),OU=Employees,$DomainDN"

    if (Get-ADUser -Filter "SamAccountName -eq '$($Employee.Username)'") {
        Write-Host "$($Employee.Username) already exists - skipping"
        continue
    }

    $ManagerUsername = $ManagerMap[$Employee.Manager]
    if (-not $ManagerUsername) {
        Write-Warning "$($Employee.Username): No manager mapping found for '$($Employee.Manager)' - skipping"
        continue
    }

    $Manager = Get-ADUser -Identity $ManagerUsername -ErrorAction SilentlyContinue
    if (-not $Manager) {
        Write-Warning "$($Employee.Username): Manager '$ManagerUsername' not found in AD - skipping"
        continue
    }

    if (-not $PSCmdlet.ShouldProcess($Employee.Username, "Create employee in $OU")) { continue }

    New-ADUser `
        -Name "$($Employee.FirstName) $($Employee.LastName)" `
        -GivenName $Employee.FirstName `
        -Surname $Employee.LastName `
        -SamAccountName $Employee.Username `
        -UserPrincipalName "$($Employee.Username)@$UpnSuffix" `
        -Title $Employee.Title `
        -Department $Employee.Department `
        -Path $OU `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true
    Write-Host "Created: $($Employee.FirstName) $($Employee.LastName)"

    Set-ADUser -Identity $Employee.Username -Manager $Manager.DistinguishedName
    Write-Host "  Manager: $($Manager.Name)"

    if ($Employee.Contractor -eq "TRUE") {
        Add-ADGroupMember -Identity "Contractor" -Members $Employee.Username
        Write-Host "  Added to Contractor Group"
    }
    if ($Employee.Remote -eq "TRUE") {
        Add-ADGroupMember -Identity "Remote" -Members $Employee.Username
        Write-Host "  Added to Remote Group"
    }
}

# --- Verification -----------------------------------------------------------
# Run after the onboarding pass and screenshot the output as evidence.
Write-Host "`nAccounts per department OU:"
"HR","IT","Legal","Finance","Sales" | ForEach-Object {
    $n = (Get-ADUser -Filter * -SearchBase "OU=$_,OU=Employees,$DomainDN" | Measure-Object).Count
    "{0,-8} {1}" -f $_, $n
}
"Managers  {0}" -f (Get-ADUser -Filter * -SearchBase "OU=Managers,$DomainDN" | Measure-Object).Count
"Contractor members  {0}" -f (Get-ADGroupMember -Identity "Contractor" | Measure-Object).Count
"Remote members      {0}" -f (Get-ADGroupMember -Identity "Remote" | Measure-Object).Count
