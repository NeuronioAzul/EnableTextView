# SCRIPT POWERSHELL PARA ADICIONAR OU ATUALIZAR VISUALIZADORES DE TEXTO NO EXPLORADOR DO WINDOWS 11

# ATENÇÃO: Recomenda-se criar um ponto de restauração manual antes da execução.

# ------------------ CONFIGURAÇÕES ------------------

# $extensions = @(".md", ".yml", ".json", ".php", ".conf", ".txt", ".log", ".ini", ".xml", ".csv", ".js", ".ts", ".html", ".css", ".bat", ".ps1", ".sh")
# $fileNamesWithoutExtension = @("Dockerfile", ".env", ".env.example")
# $previewHandlerCLSID = "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"


#Testando no Powershell direto ( Funciona )
New-Item -Path "HKCU:\Software\Classes\.php" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\.php" -Name "PerceivedType" -Value "text"
New-Item -Path "HKCU:\Software\Classes\SystemFileAssociations\text\.php" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\SystemFileAssociations\text\.php" -Name "PreviewHandler" -Value "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"


# ------------------ FUNÇÕES ------------------

# function Set-PreviewHandler($extOrFilename) {
#     $basePath = "HKCU:\Software\Classes\$extOrFilename"
#     $assocPath = "HKCU:\Software\Classes\SystemFileAssociations\text\$extOrFilename"

#     # Criar ou atualizar a chave principal
#     if (-not (Test-Path $basePath)) {
#         New-Item -Path $basePath -Force | Out-Null
#         Write-Host "  - Chave criada: $basePath" -ForegroundColor Green
#     } else {
#         Write-Host "  - Chave já existe: $basePath" -ForegroundColor Yellow
#     }
#     Set-ItemProperty -Path $basePath -Name "PerceivedType" -Value "text" -Force
#     Write-Host "  - PerceivedType definido para 'text' em '$basePath'" -ForegroundColor Green

#     # Criar ou atualizar chave associada ao preview handler
#     if (-not (Test-Path $assocPath)) {
#         New-Item -Path $assocPath -Force | Out-Null
#         Write-Host "  - Chave criada: $assocPath" -ForegroundColor Green
#     } else {
#         Write-Host "  - Chave já existe: $assocPath" -ForegroundColor Yellow
#     }
#     Set-ItemProperty -Path $assocPath -Name "PreviewHandler" -Value $previewHandlerCLSID -Force
#     Write-Host "  - PreviewHandler definido em '$assocPath'" -ForegroundColor Green
# }

# # ------------------ EXECUÇÃO COM CONFIRMAÇÃO ------------------

# Write-Host "Este script configurará o Explorador do Windows para exibir arquivos específicos como texto simples no Painel de Visualização." -ForegroundColor Cyan
# $confirm = Read-Host "Deseja continuar? (S/N)"

# if ($confirm -notin @("S", "s")) {
#     Write-Host "Operação cancelada pelo usuário." -ForegroundColor Red
#     exit
# }

# try {
#     Write-Host "`nConfigurando extensões..." -ForegroundColor Yellow
#     foreach ($ext in $extensions) {
#         Write-Host "`nProcessando extensão: $ext" -ForegroundColor Cyan
#         Set-PreviewHandler $ext
#     }

#     Write-Host "`nConfigurando arquivos sem extensão..." -ForegroundColor Yellow
#     foreach ($fileName in $fileNamesWithoutExtension) {
#         Write-Host "`nProcessando arquivo: $fileName" -ForegroundColor Cyan
#         Set-PreviewHandler $fileName
#     }

#     Write-Host "`nConfiguração concluída com sucesso." -ForegroundColor Green

#     # Reiniciar Explorer automaticamente para aplicar mudanças imediatamente
#     Write-Host "`nReiniciando o Explorador do Windows para aplicar as alterações..." -ForegroundColor Yellow
#     Stop-Process -Name explorer -Force

#     Write-Host "`nProcesso concluído. Verifique o Painel de Visualização." -ForegroundColor Green

# } catch {
#     Write-Host "`nErro durante a configuração: $_" -ForegroundColor Red
# }
