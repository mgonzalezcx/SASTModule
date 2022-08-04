function Get-SASTSession {
    param(
        [System.Uri]$sast_url,
        [String]$username,
        [String]$password,
        [Switch]$dbg,
        [hashtable]$existing_session
    )

    $modulePath = [System.IO.Path]::GetDirectoryName((Get-Module -ListAvailable SASTModule).path)

    if(!$username){
        $credentials = Get-Credential -Credential $null
        $username = $credentials.UserName
        $password = $credentials.GetNetworkCredential().Password
    } 

    try{
        . "$modulePath\rest\sast\login.ps1" $sast_url $username $password $modulePath
    }
    catch{
        Write-Output "Login Faield. Please confirm your credentials"
    }
    
}

function Get-CredentialFromFile{
    $credLocation = $HOME + "/.sast/creds.cxl"
    $encryptedCreds = Get-Content $credLocation | ConvertTo-SecureString
    $test = ConvertFrom-SecureString -SecureString $encryptedCreds -AsPlainText
    #Write-Output $test
    #$Marshal = [System.Runtime.InteropServices.Marshal]
    #$Bstr = $Marshal::SecureStringToBSTR($encryptedCreds)
    #$decrypted = $Marshal::PtrToStringAuto($Bstr)

    $psSession = $test | ConvertFrom-Json
    $session = @{}
    $psSession.PSObject.properties | Foreach {$session[$_.Name] = $_.Value}

    return $session

}

function Get-SASTSessionwithAPIToken {
    param(
    [System.Uri]$sast_url,
    [String]$refreshToken,
    [Switch]$dbg
    )

    &"./rest/sast/apiTokenLogin.ps1" $sast_url $refreshToken $dbg
}

function Get-SASTProjectDetails{
    param(
        [Parameter(Mandatory=$true)]
        [string]$projectName,
        [Parameter(Mandatory=$true)]
        [string]$teamName
    )

    $modulePath = [System.IO.Path]::GetDirectoryName((Get-Module -ListAvailable SASTModule).path)

    $session = Get-CredentialFromFile
    
    try{
        $teams = . "$modulePath\rest\sast\teams.ps1" -session $session -modulePath $modulePath
        $projects = . "$modulePath\rest\sast\projects.ps1" -session $session -modulePath $modulePath
    }
    catch{
        Write-Output "Please refresh token and try again"
    }

    $targetTeam = $teams | Where-Object{$_.name -eq $teamName}
    $targetProject = $projects | Where-Object{$_.name -eq $projectName -and $_.teamId -eq $targetTeam.id}

    return $targetProject
}

function Create-LocalSASTscan{
    param(
        [Parameter(Mandatory=$true)]
        [string]$teamName,
        [Parameter(Mandatory=$true)]
        [string]$projectName,
        [Parameter(Mandatory=$true)]
        [string]$zipLocation
    )

    $modulePath = [System.IO.Path]::GetDirectoryName((Get-Module -ListAvailable SASTModule).path)

    $session = Get-CredentialFromFile
    
    try{
        $targetProject = (Get-ProjectDetails -projectName $projectName -teamName $teamName)
        
    }
    catch{
        Write-Output "Failed to find a project with team: $team and project name: $projectName"
    }

    $scanId = . "$modulePath\rest\sast\scanWithSettings.ps1" -session $session -projectId $targetProject.Id -zipLocation $zipLocation -modulePath $modulePath
    
    Write-Output "A scan has been created for $projectName with id = " + $scanId.id

}

function Create-SASTscan{
    param(
        [Parameter(Mandatory=$true)]
        [string]$teamName,
        [Parameter(Mandatory=$true)]
        [string]$projectName
    )

    $modulePath = [System.IO.Path]::GetDirectoryName((Get-Module -ListAvailable SASTModule).path)

    $session = Get-CredentialFromFile
    
    try{
        $targetProject = (Get-ProjectDetails -projectName $projectName -teamName $teamName)
        
    }
    catch{
        Write-Output "Failed to find a project with team: $team and project name: $projectName"
    }

    $scanId = . "$modulePath\rest\sast\scanWithSettings.ps1" -session $session -projectId $targetProject.Id -zipLocation $zipLocation -modulePath $modulePath
    
    Write-Output "A scan has been created for $projectName with id = " + $scanId.id

}
