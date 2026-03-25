# Claude Code con acceso a Obsidian via MCP
# Requiere: Node.js instalado

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Claude Code + Obsidian MCP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Node.js
try {
    $nodeVersion = node --version
    Write-Host "[OK] Node.js detectado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js no está instalado o no está en PATH" -ForegroundColor Red
    Write-Host "Por favor, instala Node.js desde: https://nodejs.org/"
    pause
    exit 1
}

# Ruta al vault de Obsidian
$obsidianVault = "C:\Users\Mash\obsidian\Mash\Mash"

# Verificar vault
if (-not (Test-Path $obsidianVault)) {
    Write-Host "[ERROR] Vault de Obsidian no encontrado en:" -ForegroundColor Red
    Write-Host "  $obsidianVault" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Por favor, verifica la ruta y modifica este script si es necesario."
    pause
    exit 1
}

Write-Host "[OK] Vault de Obsidian encontrado en:" -ForegroundColor Green
Write-Host "  $obsidianVault" -ForegroundColor Cyan
Write-Host ""

# Crear configuración MCP temporal
$mcpConfigFile = Join-Path $PSScriptRoot "mcp-config.json"
Write-Host "Creando configuración MCP temporal en: $mcpConfigFile"

@"
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$obsidianVault"
      ]
    }
  }
}
"@ | Out-File -FilePath $mcpConfigFile -Encoding UTF8

Write-Host "[OK] Configuración MCP creada" -ForegroundColor Green
Write-Host ""

# Iniciar Claude Code con MCP
Write-Host "Iniciando Claude Code con MCP configurado..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Para salir escribe: /exit" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

claude --mcp-config $mcpConfigFile

# Limpiar
Remove-Item $mcpConfigFile -ErrorAction SilentlyContinue
