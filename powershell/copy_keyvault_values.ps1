param (
    [string]$originVault,
    [string]$destinationVault
)

$originSecretKeys = az keyvault secret list --vault-name $originVault -o json --query "[].name" | ConvertFrom-Json
$originSecretKeys | ForEach-Object {
    $secretName = $_
    Write-Host " - Getting '$($secretName)' from origin, and setting in destination..."
    az keyvault secret set --name $secretName --vault-name $destinationVault -o none --value (az keyvault secret show --name $secretName --vault-name $originVault -o json --query "value")
}