# Guest Configuration
https://docs.microsoft.com/en-us/azure/governance/policy/concepts/guest-configuration-assignments

https://docs.microsoft.com/en-us/azure/governance/policy/how-to/guest-configuration-create-setup

https://docs.microsoft.com/en-us/azure/governance/policy/samples/built-in-packages

https://docs.microsoft.com/en-us/powershell/dsc/overview?view=dsc-1.1

https://github.com/dsccommunity/SecurityPolicyDsc

https://docs.microsoft.com/en-us/azure/governance/policy/how-to/guest-configuration-create-definition
## Create a configuration package artifact

```powershell
# Create a package that will only audit compliance
New-GuestConfigurationPackage `
  -Name 'MyConfig' `
  -Configuration './Config/MyConfig.mof' `
  -Type Audit `
  -Force
```

```powershell
# Create a package that will audit and apply the configuration (Set)
New-GuestConfigurationPackage `
  -Name 'MyConfig' `
  -Configuration './Config/MyConfig.mof' `
  -Type AuditAndSet `
  -Force
```

```powershell
$ConfigName = 'DefenderRegistryResource_InternetExplorer'
$ResourceGroupName = 'IT.Global-Management-GuestConfiguration-PROD-EUS1'
$StorageAccountName = 'guestconfigstorprodeus1'
$PolicyId = '8b214283-0faf-421a-929c-c7665d28fc8f'
$DisplayName = 'Audit Application (Internet Explorer)'
$Description = 'Defender for Endpoint recommendations for Application (Internet Explorer)'

New-GuestConfigurationPackage -Name $ConfigName -Configuration .\$ConfigName\localhost.mof -Path .\package -Type AuditAndSet -Force | Publish-GuestConfigurationPackage -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -Force | New-GuestConfigurationPolicy -PolicyId $PolicyId -DisplayName $DisplayName -Description $Description -Path '.\policies' -Platform Windows -Version 1.0.1 -Mode ApplyAndAutoCorrect | Publish-GuestConfigurationPolicy
```

## Extending guest configuration with third-party tools

The DSC resource requires custom development if a community solution doesn't already exist. Community solutions can be discovered by searching the PowerShell Gallery for tag [GuestConfiguration](https://www.powershellgallery.com/packages?q=Tags%3A%22GuestConfiguration%22).

## Security
