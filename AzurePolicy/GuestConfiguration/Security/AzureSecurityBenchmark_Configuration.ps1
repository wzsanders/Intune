Configuration AzureSecurityBenchmark_Configuration
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry "AZ-WIN-00120: Devices: Allow undock without having to log on" {
            Key       = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Ensure    = 'Present'
            ValueName = 'UndockWithoutLogon'
            ValueData = 0
            ValueType = 'DWord'
            Force     = $true
        }

        Registry "AZ-WIN-00145: Ensure 'Turn off multicast name resolution' is set to 'Enabled'" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient'
            Ensure    = 'Present'
            ValueName = 'EnableMulticast'
            ValueData = 0
            ValueType = 'DWord'
            Force     = $true
        }

        Registry "AZ-WIN-00155: System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers'
            Ensure    = 'Present'
            ValueName = 'AuthenticodeEnabled'
            ValueData = 1
            ValueType = 'DWord'
            Force     = $true
        }

        Registry "AZ-WIN-00171: Ensure 'Enable insecure guest logons' is set to 'Disabled'" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation'
            Ensure    = 'Present'
            ValueName = 'AllowInsecureGuestAuth'
            ValueData = 0
            ValueType = 'DWord'
            Force     = $true
        }

        Registry "AZ-WIN-00172: Ensure 'Prohibit use of Internet Connection Sharing on your DNS domain network' is set to 'Enabled'" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections'
            Ensure    = 'Present'
            ValueName = 'NC_ShowSharedAccessUI'
            ValueData = 0
            ValueType = 'DWord'
            Force     = $true
        }

        UserRightsAssignment "AZ-WIN-00184: Bypass traverse checking" {
            Policy   = 'Bypass_traverse_checking'
            Identity = 'Administrators', 'Authenticated Users', 'Backup Operators', 'LOCAL SERVICE', 'NETWORK SERVICE'
        }
    }
}

AzureSecurityBenchmark_Configuration