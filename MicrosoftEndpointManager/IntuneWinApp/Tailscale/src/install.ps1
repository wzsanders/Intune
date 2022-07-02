$PackageName = 'tailscale'
$ProcessOutput = & {choco install $PackageName -y} *>&1 | Out-String -NoNewline

if ($ProcessOutput -match "The install of $PackageName was successful") {
    exit 0    
} else {
    # Exit indicating retry.
    exit 1618
}