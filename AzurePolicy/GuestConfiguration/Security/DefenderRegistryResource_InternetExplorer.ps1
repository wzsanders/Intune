<#
    .SYNOPSIS
    Block outdated ActiveX controls for Internet Explorer
    If the registry key value VersionCheckEnabled under the key
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\VersionCheckEnabled' does not exist,
    creates it with the DWORD value 1.

    If the registry key value VersionCheckEnabled under the key
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext\VersionCheckEnabled' already exists,
    overwrites it with the DWORD value 1.

    Disable running or installing downloaded software with invalid signature
    If the registry key value RunInvalidSignatures under the key
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Download\RunInvalidSignatures' does not exist,
    creates it with the DWORD value 0.

    If the registry key value RunInvalidSignatures under the key
    'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Download\RunInvalidSignatures' already exists,
    overwrites it with the DWORD value 0.
#>
Configuration DefenderRegistryResource_InternetExplorer
{
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost
    {
        Registry "Block outdated ActiveX controls for Internet Explorer" {
            Key       = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext'
            Ensure    = 'Present'
            ValueName = 'VersionCheckEnabled'
            ValueData = 1
            ValueType = 'DWORD'
            Force     = $true
        }

        Registry "Disable running or installing downloaded software with invalid signature" {
            Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Download'
            Ensure    = 'Present'
            ValueName = 'RunInvalidSignatures'
            ValueData = 0
            ValueType = 'DWORD'
            Force     = $true
        }
    }
}

DefenderRegistryResource_InternetExplorer