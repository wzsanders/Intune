#region Config
$AppName = "Detect-Defender-ASR-Recommendations"
$client = "William Sanders"
$logPath = "$env:ProgramData\$client\logs"
$logFile = "$logPath\$AppName.log"
#region GUIDs
# 0 = Disable, 1 = Block, 2 = Audit, 6 = Warn
# Warn is available for most ASR rules.
$asrRules = @(
    [PSCustomObject]@{
        Id     = "56a863a9-875e-4185-98a7-b882c64b5ce5"
        Name   = "Block abuse of exploited vulnerable signed drivers"
        Action = 1
    }
)
#endregion
#endregion
#region Functions
function Get-AttackSurfaceReductionState {
    <#
    .SYNOPSIS
        This function will get the current state of the attack surface reduction rules and return an array of objects mapping attack
        surface ids to their state.
    .EXAMPLE
        PS> Get-AttackSurfaceReductionState | Select-Object -Property Id, Action
    #>

    $currentAsrRules = @{}
    
    $asrIds = (Get-MpPreference | Select-Object -Property AttackSurfaceReductionRules_*).AttackSurfaceReductionRules_Ids
    $asrActions = (Get-MpPreference | Select-Object -Property AttackSurfaceReductionRules_*).AttackSurfaceReductionRules_Actions
    $asrCount = $asrIds.Length

    for ($i = 0; $i -lt $asrCount; $i++) {
        $key = $asrIds[$i]
        $value = $asrActions[$i]
        $currentAsrRules.Add($key, $value)
    }    

    return $currentAsrRules
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
    Write-Host -Object "Detecting ASR rules" -ForegroundColor Green

    $currentAsrState = Get-AttackSurfaceReductionState

    foreach ($rule in $asrRules) {
        if ($currentAsrState[$rule.Id] -eq $rule.Action) {
            Write-Host -Object "Rule '$($rule.Name)' is already in the desired state" -ForegroundColor Green
        } else {
            # Write-Host -Object "Rule '$($rule.Name)' is not in the desired state. Rule requires '$($rule.Action)'" -ForegroundColor Yellow
            throw "Rule '$($rule.Name)' is not in the desired state. Rule requires '$($rule.Action)'"
            # Set-MpPreference -AttackSurfaceReductionRules_Ids $rule.Id -AttackSurfaceReductionRules_Actions $rule.Action
        }
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
