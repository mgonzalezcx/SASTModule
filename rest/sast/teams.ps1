param(
    [Parameter(Mandatory=$true)]
    [hashtable]$session,
    [Parameter(Mandatory=$true)]
    [string]$modulePath
)

. "$modulePath/rest_util.ps1"

#$request_url = New-Object System.Uri $session.base_url, "/cxrestapi/auth/teams"
$request_url = $session.base_url + "/cxrestapi/auth/teams"

Write-Debug "Teams API URL: $request_url"

$headers = GetRestHeadersForJsonRequest($session)

$teams = Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers

return $teams