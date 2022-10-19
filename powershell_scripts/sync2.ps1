#Merge using PowerShell
$headers = @{
    'PRIVATE-TOKEN' = $($env:CICD_token)
}

#create merge request
$mergereq=Invoke-RestMethod -Method Post -Headers $headers "https://$($env:CI_SERVER_HOST)/api/v4/projects/$($env:CI_PROJECT_ID)/merge_requests?source_branch=$($env:branch)&target_branch=$($env:CI_DEFAULT_BRANCH)&title=$($env:pull_request)"
Start-Sleep 5
#auto approve merge request
Invoke-RestMethod -Method post -Headers $headers "https://$($env:CI_SERVER_HOST)/api/v4/projects/$($env:CI_PROJECT_ID)/merge_requests/$($mergereq.iid)/approve"
#auto accept merge request
Invoke-RestMethod -Method put -Headers $headers "https://$($env:CI_SERVER_HOST)/api/v4/projects/$($env:CI_PROJECT_ID)/merge_requests/$($mergereq.iid)/merge?should_remove_source_branch=true&squash=true&squash_commit_message=Pull_from_Azure_to_automated_branch" 
