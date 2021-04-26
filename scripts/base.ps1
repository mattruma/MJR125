param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [String] $ProductId,
    [Parameter(Mandatory = $true)]
    [String] $SubscriptionId, 
    [Parameter(Mandatory = $false)]
    [String] $ServicePrincipalId, 
    [Parameter(Mandatory = $false)]
    [String] $Location = "eastus",
    [Parameter(Mandatory = $false)]
    [String] $TemplateFile = './scripts/base.bicep'
)

bicep build $TemplateFile

$ResourceGroupName = "$($ProductId)rg"

az group create `
    -n $ResourceGroupName `
    -l $Location `
    --subscription $SubscriptionId

if ($ServicePrincipalId.Trim() -eq "") { 
    $ServicePrincipalId = ((az ad signed-in-user show) | ConvertFrom-Json).objectId
}

az deployment group create `
    -n ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
    -f $TemplateFile `
    -g $ResourceGroupName `
    --subscription $SubscriptionId `
    --parameters productId=$ProductId `
    --parameters servicePrincipalId=$ServicePrincipalId