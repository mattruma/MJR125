param (
    [string]$Tenant,
    [string]$SubscriptionId
)

$ParametersFile = ".\scripts\authenticate.parameters.json"

if (Test-Path $ParametersFile -PathType leaf) {
    $Parameters = (Get-Content $ParametersFile | Out-String | ConvertFrom-Json) 
}

if ($Tenant.Trim() -eq "") { 
    $Tenant = $Parameters.Tenant;
}

if ($Tenant.Trim() -eq "" ) { 
    throw "'Tenant' is required, please provide a value for '-TenantName' argument or add a $($ParametersFile) file with a value for 'Tenant' property."
}

if ($SubscriptionId.Trim() -eq "") { 
    $SubscriptionId = $Parameters.SubscriptionId;
}

if ($SubscriptionId.Trim() -eq "" ) { 
    throw "'SubscriptionId' is required, please provide a value for '-SubscriptionId' argument or add a $($ParametersFile) file with a value for 'SubscriptionId' property."
}

Connect-AzAccount -Tenant $Tenant -Subscription $SubscriptionId

az login --tenant $Tenant

az account set --subscription $SubscriptionId

az account show