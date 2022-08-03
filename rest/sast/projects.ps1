param(
    [Parameter(Mandatory=$true)]
    [hashtable]$session,
    [string]$apiVersion,
    [Parameter(Mandatory=$true)]
    [string]$modulePath
)

. "$modulePath/rest_util.ps1"

#$request_url = New-Object System.Uri $session.base_url, "/cxrestapi/projects"
$request_url = $session.base_url + "/cxrestapi/projects"

Write-Debug "Projects API URL: $request_url"
Write-Output "$request_url"

$headers = GetRestHeadersForJsonRequest($session)

if($apiVersion){
    $contentType = "application/json;v=$apiVersion"
    $projects = Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers -ContentType $contentType
}
else{
    $projects = Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers
}

return $projects