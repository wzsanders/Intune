choco uninstall tailscale -y

$TailscalePath = "$env:ProgramFiles\Tailscale IPN"

if (Test-Path -Path $TailscalePath) {
    Remove-Item -Path $TailscalePath -Recurse -Force -ErrorAction SilentlyContinue
}