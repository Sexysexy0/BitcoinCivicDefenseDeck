# OutlookMacroSanctifier.ps1
$OutlookPath = "$env:APPDATA\Microsoft\Outlook"
$MacroRegistryPath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Security"

# Detect suspicious macro-enabled files
Get-ChildItem -Path $OutlookPath -Recurse -Include *.otm | ForEach-Object {
    Write-Host "🔍 Scanning macro file: $($_.FullName)"
    $content = Get-Content $_.FullName
    if ($content -match "Application\.NewMailEx|MAPILogonComplete") {
        Write-Host "⚠️ Rogue macro detected in $($_.Name)"
        Rename-Item $_.FullName "$($_.FullName).disabled"
    }
}

# Disable macro execution
Set-ItemProperty -Path $MacroRegistryPath -Name "EnableUnsafeMacros" -Value 0
Set-ItemProperty -Path $MacroRegistryPath -Name "DisableAllMacros" -Value 1

Write-Host "✅ Macro sanctification complete. All rogue VBA disabled."
