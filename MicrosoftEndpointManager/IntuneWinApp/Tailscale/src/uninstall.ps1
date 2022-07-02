Stop-Service -Name Tailscale -ErrorAction SilentlyContinue

choco uninstall tailscale -y

$TailscaleProgramPath = (Get-ChildItem -Path 'C:\Program Files\','C:\Program Files (x86)\' -Filter 'Tailscale IPN' -ErrorAction SilentlyContinue).FullName

if (Test-Path -Path $TailscaleProgramPath) {
    Remove-Item -Path $TailscaleProgramPath -Recurse -Force -ErrorAction SilentlyContinue
}

$TailscaleProgramDataPath = (Get-ChildItem -Path 'C:\ProgramData', -Filter 'Tailscale' -ErrorAction SilentlyContinue).FullName

if (Test-Path -Path $TailscaleProgramDataPath) {
    Remove-Item -Path $TailscaleProgramDataPath -Recurse -Force -ErrorAction SilentlyContinue
}

$TailscaleUserDataPath = (Get-ChildItem -Path "C:\Users\*\AppData\Local\*" -Filter 'Tailscale' -ErrorAction SilentlyContinue).FullName

if (Test-Path -Path $TailscaleUserDataPath) {
    Remove-Item -Path $TailscaleUserDataPath -Recurse -Force -ErrorAction SilentlyContinue
}

if (Test-Path -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tailscale.lnk') {
    Remove-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Tailscale.lnk' -Recurse -ErrorAction SilentlyContinue
}

sc.exe delete tailscale