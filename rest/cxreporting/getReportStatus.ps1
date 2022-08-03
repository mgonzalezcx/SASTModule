param(
    [Parameter(Mandatory=$true)]
    [hashtable]$session,
    [Parameter(Mandatory=$true)]
    [string]$reportID
)

. "support/rest_util.ps1"

$rest_url = [String]::Format("/api/reports/{0}/status", $reportID)
$request_url = New-Object System.Uri $session.reporting_url, $rest_url

Write-Debug "CxReporting API URL: $request_url"

$headers = GetRestHeadersForJsonRequest($session)

$response = Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers
return $response