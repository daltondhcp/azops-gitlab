Import-PSFConfig -Path settings.json -Schema MetaJson -EnableException
Initialize-AzOpsEnvironment
$diff = Get-Content -Path /tmp/diff.txt
$module = Get-Module -Name AzOps
if(Test-Path -Path "/tmp/diffdeletedfiles.txt")
{
  $diffdeletedfiles = Get-Content -Path /tmp/diffdeletedfiles.txt
  $module.Invoke({ Invoke-AzOpsPush -ChangeSet $diff -DeleteSetContents $diffdeletedfiles })
}
else {
  $module.Invoke({ Invoke-AzOpsPush -ChangeSet $diff })
}
Get-Job | Remove-Job -Force