# SCRIPT POWERSHELL PARA ADICIONAR VISUALIZADORES DE TEXTO NO EXPLORADOR DE ARQUIVOS DO WINDOWS 11

# ATENÇÃO: Recomenda-se criar um ponto de restauração manual antes da execução.

# ------------------ CONFIGURAÇÕES ------------------

$extensions = @(".md", ".yml", ".json", ".php", ".conf")
$fileNamesWithoutExtension = @("Dockerfile", ".env", ".env.example")
$previewHandlerCLSID = "{0C6C4200-3E5A-11D1-8F9B-00A0C90F26E2}"
# ------------------ FUNÇÕES ------------------

function Set-PreviewHandler {
    param (
        [string]$RegistryPath
    )

    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "  - Chave criada: $RegistryPath" -ForegroundColor Green
    }

    Set-ItemProperty -LiteralPath $RegistryPath -Name "PerceivedType" -Value "text" -Force -ErrorAction Stop
    Write-Host "  - PerceivedType definido como 'text' em '$RegistryPath'" -ForegroundColor Green

    $associationKeyPath = "HKCU:\Software\Classes\SystemFileAssociations\text\" + (Split-Path -Leaf $RegistryPath)

    if (-not (Test-Path $associationKeyPath)) {
        New-Item -Path $associationKeyPath -Force | Out-Null
        Write-Host "  - Chave de associação criada: $associationKeyPath" -ForegroundColor Green
    }

    Set-ItemProperty -LiteralPath $associationKeyPath -Name "PreviewHandler" -Value $previewHandlerCLSID -Force -ErrorAction Stop
    Write-Host "  - PreviewHandler configurado em '$associationKeyPath'" -ForegroundColor Green
}

# ------------------ EXECUÇÃO COM CONFIRMAÇÃO ------------------

Write-Host "Este script configurará o Explorador do Windows para exibir arquivos específicos como texto simples no Painel de Visualização." -ForegroundColor Cyan
$confirm = Read-Host "Deseja continuar? (S/N)"

if ($confirm -notin @("S", "s")) {
    Write-Host "Operação cancelada pelo usuário." -ForegroundColor Red
    exit
}

try {
    Write-Host "`nConfigurando extensões..." -ForegroundColor Yellow
    foreach ($ext in $extensions) {
        Write-Host "`nProcessando extensão: $ext" -ForegroundColor Cyan
        Set-PreviewHandler -RegistryPath "HKCU:\Software\Classes\$ext"
    }

    Write-Host "`nConfigurando arquivos sem extensão..." -ForegroundColor Yellow
    foreach ($fileName in $fileNamesWithoutExtension) {
        Write-Host "`nProcessando arquivo: $fileName" -ForegroundColor Cyan
        Set-PreviewHandler -RegistryPath "HKCU:\Software\Classes\$fileName"
    }

    Write-Host "`nConfiguração concluída com sucesso." -ForegroundColor Green

    # Reiniciar Explorer (opcional, comentado por padrão)
    Write-Host "`nReiniciando o Explorador..." -ForegroundColor Yellow
    Stop-Process -Name explorer -Force

    Write-Host "`nPara aplicar as alterações imediatamente, reinicie o Explorador manualmente ou faça logoff e login novamente." -ForegroundColor Yellow

} catch {
    Write-Host "`nErro durante a configuração: $_" -ForegroundColor Red
}
