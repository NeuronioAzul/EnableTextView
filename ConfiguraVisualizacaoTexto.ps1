# SCRIPT POWERSHELL PARA ADICIONAR VISUALIZADORES DE TEXTO NO EXPLORADOR DE ARQUIVOS DO WINDOWS 11
#
# Este script modifica o Registro do Windows para permitir que o Painel de Visualização do Explorador de Arquivos
# exiba o conteúdo de certos tipos de arquivos como texto simples, mesmo que não tenham suporte nativo.
#
# ATENÇÃO: A modificação do Registro pode causar problemas se não for feita corretamente.
# É ALTAMENTE RECOMENDADO CRIAR UM PONTO DE RESTAURAÇÃO DO SISTEMA ANTES DE EXECUTAR ESTE SCRIPT.
# Para criar um ponto de restauração, pesquise "Criar um ponto de restauração" no menu Iniciar do Windows.

# --- Etapa 1: Definir as Extensões e Nomes de Arquivo ---
$extensions = @(
    ".md",
    ".yml",
    ".json",
    ".php",
    ".conf"
)

# Para arquivos sem extensão, adicione o nome completo do arquivo
# (Ex: Dockerfile, que não tem ".txt" ou ".conf" no final)
$fileNamesWithoutExtension = @(
    "Dockerfile",
    ".env",
    ".env.example" # Embora tenha um ponto, é um nome de arquivo completo sem uma extensão tradicional para visualização
)

# CLSID do visualizador de texto padrão do Windows
$previewHandlerCLSID = "{65235BB8-85EF-491F-88FD-C7B68ECAE551}" 

# --- Etapa 2: Adicionar ou Modificar Entradas do Registro para Extensões ---
Write-Host "Iniciando a configuração para extensões..." -ForegroundColor Yellow

foreach ($ext in $extensions) {
    Write-Host "Processando extensão: $ext" -ForegroundColor Cyan

    # Caminho base no HKEY_CLASSES_ROOT
    $baseKeyPath = "HKCU:\Software\Classes\$ext"
    # Adicionado HKCU (Current User) para evitar problemas de permissão e afetar apenas o usuário atual.
    # Se desejar aplicar a todos os usuários, mude para HKLM:\SOFTWARE\Classes (requer execução como admin).

    # Certifica-se de que a chave da extensão existe
    If (-not (Test-Path $baseKeyPath)) {
        New-Item -Path $baseKeyPath -Force | Out-Null
        Write-Host "  - Chave '$ext' criada em HKCU:\Software\Classes" -ForegroundColor Green
    }

    # Define PerceivedType como "text"
    Set-ItemProperty -LiteralPath $baseKeyPath -Name "PerceivedType" -Value "text" -Force
    Write-Host "  - PerceivedType definido como 'text' para '$ext'" -ForegroundColor Green

    # Caminho no SystemFileAssociations\text
    $associationKeyPath = "HKCU:\Software\Classes\SystemFileAssociations\text\$ext"

    # Certifica-se de que a chave de associação existe
    If (-not (Test-Path $associationKeyPath)) {
        New-Item -Path $associationKeyPath -Force | Out-Null
        Write-Host "  - Chave '$ext' criada em HKCU:\Software\Classes\SystemFileAssociations\text" -ForegroundColor Green
    }

    # Define o PreviewHandler
    Set-ItemProperty -LiteralPath $associationKeyPath -Name "PreviewHandler" -Value $previewHandlerCLSID -Force
    Write-Host "  - PreviewHandler definido para '$ext'" -ForegroundColor Green
}

# --- Etapa 3: Adicionar ou Modificar Entradas do Registro para Nomes de Arquivo sem Extensão ---
Write-Host "`nIniciando a configuração para nomes de arquivo sem extensão..." -ForegroundColor Yellow

foreach ($fileName in $fileNamesWithoutExtension) {
    Write-Host "Processando nome de arquivo: $fileName" -ForegroundColor Cyan

    # Caminho base no HKEY_CLASSES_ROOT (o nome do arquivo é a chave)
    $baseKeyPath = "HKCU:\Software\Classes\$fileName"

    # Certifica-se de que a chave do nome do arquivo existe
    If (-not (Test-Path $baseKeyPath)) {
        New-Item -Path $baseKeyPath -Force | Out-Null
        Write-Host "  - Chave '$fileName' criada em HKCU:\Software\Classes" -ForegroundColor Green
    }

    # Define PerceivedType como "text"
    Set-ItemProperty -LiteralPath $baseKeyPath -Name "PerceivedType" -Value "text" -Force
    Write-Host "  - PerceivedType definido como 'text' para '$fileName'" -ForegroundColor Green

    # Caminho no SystemFileAssociations\text
    $associationKeyPath = "HKCU:\Software\Classes\SystemFileAssociations\text\$fileName"

    # Certifica-se de que a chave de associação existe
    If (-not (Test-Path $associationKeyPath)) {
        New-Item -Path $associationKeyPath -Force | Out-Null
        Write-Host "  - Chave '$fileName' criada em HKCU:\Software\Classes\SystemFileAssociations\text" -ForegroundColor Green
    }

    # Define o PreviewHandler
    Set-ItemProperty -LiteralPath $associationKeyPath -Name "PreviewHandler" -Value $previewHandlerCLSID -Force
    Write-Host "  - PreviewHandler definido para '$fileName'" -ForegroundColor Green
}

Write-Host "`nConfiguração concluída." -ForegroundColor Green
Write-Host "Para que as mudanças entrem em vigor, você pode precisar reiniciar o Explorador de Arquivos ou o computador." -ForegroundColor Yellow