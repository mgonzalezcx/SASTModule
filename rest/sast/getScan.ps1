param(
    [Parameter(Mandatory=$true)]
    [hashtable]$session,
    [Parameter(Mandatory=$true)]
    [string]$scanId,
    [string]$apiVersion
)

. "support/rest_util.ps1"

$rest_url = [String]::Format("/cxrestapi/reports/sastScan/{0}", $scanId)
$request_url = New-Object System.Uri $session.base_url, $rest_url

Write-Debug "Scans API URL: $request_url"

$headers = GetRestHeadersForJsonRequest($session)

if($apiVersion){
    $contentType = "application/json;v=$apiVersion"
    Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers -ContentType $contentType
}
else{
    Invoke-RestMethod -Method 'Get' -Uri $request_url -Headers $headers
}