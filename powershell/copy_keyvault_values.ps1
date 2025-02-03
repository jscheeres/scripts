#
# Description: This script clones all the secrets from one key vault to another.
#
# originVault: The name of the source key vault.
# destinationVault: The name of the destination key vault.
#

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