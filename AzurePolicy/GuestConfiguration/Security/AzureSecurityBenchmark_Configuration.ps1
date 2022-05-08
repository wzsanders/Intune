Configuration AzureSecurityBenchmark_Configuration
{
    Import-DscResource -ModuleName 'PSDscResources'
    Import-DscResource -ModuleName 'SecurityPolicyDsc'
    Import-DscResource -ModuleName 'AuditPolicyDsc'

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
            Force    = $true
        }

        UserRightsAssignment "AZ-WIN-00185: Increase a process working set" {
            Policy   = 'Increase_a_process_working_set'
            Identity = 'Administrators', 'LOCAL SERVICE'
            Force    = $true
        }

        UserRightsAssignment "CCE-35818-4: Configure 'Access this computer from the network'" {
            Policy   = 'Access_this_computer_from_the_network'
            Identity = 'Administrators', 'Authenticated Users'
            Force    = $true
        }

        SecurityOption "CCE-36077-6: Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled' (MS only)" {
            Name                                                              = 'Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts'
            Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts = 'Enabled'
        }

        UserRightsAssignment "CCE-36867-0: Ensure 'Deny log on through Remote Desktop Services' is configured" {
            Policy   = 'Deny_log_on_through_Remote_Desktop_Services'
            Identity = ''
            Force    = $true
        }

        Registry "CCE-37346-4: Ensure 'Enable RPC Endpoint Mapper Client Authentication' is set to 'Disabled'" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc'
            Ensure    = 'Present'
            ValueName = 'EnableAuthEpResolution'
            ValueData = 1
            ValueType = 'DWord'
            Force     = $true
        }

        UserRightsAssignment "CCE-37659-0: Configure 'Allow log on locally'" {
            Policy   = 'Allow_log_on_locally'
            Identity = 'Administrators'
            Force    = $true
        }

        AuditPolicyGUID "CCE-37741-6: Ensure 'Audit Credential Validation' is set to 'Success'" {
            Name      = 'Credential Validation'
            AuditFlag = 'Success'
            Ensure    = 'Present'
        }

        AuditPolicyGUID "CCE-37741-6: Ensure 'Audit Credential Validation' is set to 'Failure'" {
            Name      = 'Credential Validation'
            AuditFlag = 'Failure'
            Ensure    = 'Present'
        }
    }
}

AzureSecurityBenchmark_Configuration