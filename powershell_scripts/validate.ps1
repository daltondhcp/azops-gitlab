Import-PSFConfig -Path settings.json -Schema MetaJson -EnableException
Initialize-AzOpsEnvironment
$diff = Get-Content -Path /tmp/diff.txt
$module = Get-Module -Name AzOps
if(Test-Path -Path "/tmp/diffdeletedfiles.txt")
{
  $diffdeletedfiles = Get-Content -Path /tmp/diffdeletedfiles.txt
  $module.Invoke({ Invoke-AzOpsPush -ChangeSet $diff -DeleteSetContents $diffdeletedfiles -WhatIf })
}
else{
  $module.Invoke({ Invoke-AzOpsPush -ChangeSet $diff -WhatIf })
}
Get-Job | Remove-Job -Force


#Merge using PowerShell
$headers = @{
  'PRIVATE-TOKEN' = $($env:CICD_token)
}

$body = Get-Content  -Raw /tmp/OUTPUT.md
$postParams = @{body=$body}
Invoke-RestMethod -Method Post -Body $postParams  -Headers $headers "$($env:CI_SERVER_HOST)/api/v4/projects/$($env:CI_PROJECT_ID)/merge_requests/$($env:CI_MERGE_REQUEST_IID)/notes"
