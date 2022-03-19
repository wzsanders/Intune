#region Config
$AppName = "Detect-Defender-Registry-Recommendations"
$client = "William Sanders"
$logPath = "$env:ProgramData\$client\logs"
$logFile = "$logPath\$AppName.log"
#region Keys
$hkcuKeys = @()
# $hkcuKeys = @(
#     [PSCustomObject]@{
#         Guid  = "{639eb309-1f65-4071-a4df-6d0443c87236}"
#         Name  = "RunAsPPL"
#         Type  = "DWord"
#         Value = 1
#         Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
#     }
# )
$hklmKeys = @(
    [PSCustomObject]@{
        Path  = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        Name  = "RunAsPPL"
        Type  = "DWord"
        Value = 1
    },
    [PSCustomObject]@{
        Path  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name  = "MaxDevicePasswordFailedAttempts"
        Type  = "DWord"
        Value = 10
    }
)
#endregion
#endregion
#region Functions
function Compare-RegistryKey {
    <#
    .SYNOPSIS
        This function will set the specified registry key to the specified value. If the key path does not exist, it will be created.
    .EXAMPLE
        PS> Set-RegistryKey -RegistryInstance @{'Name' = 'Setting'; 'Type' = 'String'; 'Value' = 'someval'; 'Path' = 'SOFTWARE\Microsoft\Windows\Something'}
        This example would modify the string reigstry key 'Setting' to 'someval' in the registry key 'SOFTWARE\Microsoft\Windows\Something'.
    .PARAMETER RegistryInstance
        A hash table containing key names of 'Name' designating the registry value name, 'Type' to designate the type
        of registry value which can be 'String, Binary, DWord, ExpandString, or MultiString', 'Value' which is the
        value of the registry key, and 'Path' designating the parent registry key the registry value is in.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $RegistryInstance
    )
    try {
        foreach ($instance in $RegistryInstance) {
            # Check if the registry key exists
            if (-Not (Test-Path -Path $instance.Path)) {
                Write-Host -Object "$($instance.Path) with target property $($instance.Name): Not compliant" -ForegroundColor Red
                throw "Key path does not exist"
            }
            
            # Check if the registry property exists
            $Property = Get-ItemProperty -Path $instance.Path -Name $instance.Name -ErrorAction Stop | Select-Object -ExpandProperty $instance.Name
            # Check expected value
            if ($Property) {
                if ($Property -eq $instance.Value) {
                    Write-Host -Object "$($instance.Path) with target property $($instance.Name): Compliant" -ForegroundColor Green                
                } else {
                    Write-Host -Object "$($instance.Path) with target property $($instance.Name): Not compliant" -ForegroundColor Red                
                    throw "Key value does not match expected value"
                }
            } else {
                Write-Host -Object "$($instance.Path) with target property $($instance.Name): Not compliant" -ForegroundColor Red
                throw "Key property does not exist"
            }
        }
    }
    catch {
        throw $_.Exception.Message
    }
}
#endregion
#region Logging
if (!(Test-Path -Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
}
$errorOccurred = $false
Start-Transcript -Path $logFile -ErrorAction SilentlyContinue -Force
#endregion
#region Process
try {
    if ($hkcuKeys) {
        Write-Host -Object "Detecting HKCU registry keys" -ForegroundColor Green
        foreach ($key in $hkcuKeys) {
            # TODO: Add support for setting registry keys for all users
        }
    }

    Write-Host -Object "Detecting HKLM registry keys" -ForegroundColor Green
    foreach ($key in $hklmKeys) {
        Compare-RegistryKey -RegistryInstance $key
    }
}
catch {
    $errorOccurred = $_.Exception.Message
}
finally {
    if ($errorOccurred) {
        Write-Warning -Message $errorOccurred
        Stop-Transcript
        throw $errorOccurred
    }
    else {
        Write-Host -Object "Script completed successfully"
        Stop-Transcript -ErrorAction SilentlyContinue
    }
}
#endregion
