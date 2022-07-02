$PackageName = 'tailscale'

$ProcessOutput = & {choco uninstall $PackageName -y} *>&1 | Out-String -NoNewline