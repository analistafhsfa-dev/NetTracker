# ============================================================
# COMPILADOR - gera-frac.py
# Criado por Guilherme
# ============================================================

$ErrorActionPreference = "Stop"

# Pasta onde este PS1 está localizado
$Root = $PSScriptRoot

# Arquivo Python
$PythonFile = Join-Path $Root "gera-frac.py"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "       COMPILADOR - GERA-FRAC" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Pasta raiz:" -ForegroundColor Gray
Write-Host $Root
Write-Host ""

# Verifica se o Python existe
try {

    $pythonVersion = python --version 2>&1

    Write-Host "Python encontrado:" -ForegroundColor Green
    Write-Host $pythonVersion
    Write-Host ""

}
catch {

    Write-Host "ERRO: Python não encontrado." -ForegroundColor Red
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# Verifica o arquivo Python
if (-not (Test-Path $PythonFile)) {

    Write-Host "ERRO: gera-frac.py não encontrado." -ForegroundColor Red
    Write-Host ""
    Write-Host "Esperado em:"
    Write-Host $PythonFile
    Write-Host ""

    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "Arquivo encontrado:" -ForegroundColor Green
Write-Host $PythonFile
Write-Host ""

# Verifica / instala PyInstaller
Write-Host "Verificando PyInstaller..." -ForegroundColor Yellow

python -m PyInstaller --version 2>$null

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "PyInstaller não encontrado." -ForegroundColor Yellow
    Write-Host "Instalando..." -ForegroundColor Yellow
    Write-Host ""

    python -m pip install pyinstaller

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "ERRO ao instalar o PyInstaller." -ForegroundColor Red

        Read-Host "Pressione ENTER para sair"
        exit 1
    }
}

Write-Host ""
Write-Host "PyInstaller OK." -ForegroundColor Green
Write-Host ""

# Entra na pasta raiz
Set-Location $Root

# ============================================================
# COMPILAÇÃO
# ============================================================

Write-Host "Compilando gera-frac.py..." -ForegroundColor Cyan
Write-Host ""

python -m PyInstaller `
    --onefile `
    --windowed `
    --name gera-frac `
    "gera-frac.py"

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host " ERRO DURANTE A COMPILAÇÃO" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Write-Host ""

    Read-Host "Pressione ENTER para sair"
    exit 1
}

# ============================================================
# RESULTADO
# ============================================================

$ExePath = Join-Path $Root "dist\gera-frac.exe"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "       COMPILAÇÃO CONCLUÍDA" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

if (Test-Path $ExePath) {

    Write-Host "EXE criado com sucesso:" -ForegroundColor Green
    Write-Host ""
    Write-Host $ExePath -ForegroundColor White
    Write-Host ""

}
else {

    Write-Host "ATENÇÃO: o EXE não foi encontrado." -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Pressione ENTER para sair"
