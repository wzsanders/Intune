Stop-Service -Name Tailscale -ErrorAction SilentlyContinue

choco uninstall tailscale -y

$TailscalePath = (Get-ChildItem -Path 'C:\Program Files\','C:\Program Files (x86)\' -Filter 'Tailscale IPN' -ErrorAction SilentlyContinue).FullName

if (Test-Path -Path $TailscalePath) {
    Remove-Item -Path $TailscalePath -Recurse -Force -ErrorAction SilentlyContinue
}