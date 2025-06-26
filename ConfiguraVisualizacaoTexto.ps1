# SCRIPT POWERSHELL PARA ADICIONAR OU ATUALIZAR VISUALIZADORES DE TEXTO NO EXPLORADOR DO WINDOWS 11

# ATENÇÃO: Recomenda-se criar um ponto de restauração manual antes da execução.

# ------------------ CONFIGURAÇÕES ------------------

$extensions = @(".md", ".yml", ".json", ".php", ".conf")
$fileNamesWithoutExtension = @("Dockerfile", ".env", ".env.example")
$previewHandlerCLSID = "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"

# ------------------ FUNÇÕES ------------------

function Set-PreviewHandler {
    param (
        [string]$RegistryPath
    )

    Write-Host "  - RegistryPath: $RegistryPath" -ForegroundColor Magenta

    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "  - Chave criada: $RegistryPath" -ForegroundColor Green
    } else {
        Write-Host "  - Chave já existe: $RegistryPath" -ForegroundColor Yellow
    }

    Set-ItemProperty -Path $RegistryPath -Name "PerceivedType" -Value "text" -Force
    Write-Host "  - PerceivedType configurado para 'text' em '$RegistryPath'" -ForegroundColor Green

    $associationKeyPath = "HKCU:\Software\Classes\SystemFileAssociations\text\" + (Split-Path -Leaf $RegistryPath)

    if (-not (Test-Path $associationKeyPath)) {
        New-Item -Path $associationKeyPath -Force | Out-Null
        Write-Host "  - Chave de associação criada: $associationKeyPath" -ForegroundColor Green
    } else {
        Write-Host "  - Chave de associação já existe: $associationKeyPath" -ForegroundColor Yellow
    }

    Set-ItemProperty -Path $associationKeyPath -Name "PreviewHandler" -Value $previewHandlerCLSID -Force
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

    # Reiniciar Explorer automaticamente para aplicar mudanças imediatamente
    Write-Host "`nReiniciando o Explorador do Windows para aplicar as alterações..." -ForegroundColor Yellow
    Stop-Process -Name explorer -Force

    Write-Host "`nProcesso concluído. Verifique o Painel de Visualização." -ForegroundColor Green

} catch {
    Write-Host "`nErro durante a configuração: $_" -ForegroundColor Red
}
