Import-PSFConfig -Path settings.json -Schema MetaJson -EnableException
Invoke-AzOpsPull -Rebuild
Get-Job | Remove-Job -Force