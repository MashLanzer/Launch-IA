@echo off
title Claude Code + Obsidian MCP

echo ========================================
echo Claude Code con acceso a Obsidian via MCP
echo ========================================
echo.

:: Verificar que Node.js esté instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no está instalado o no está en PATH
    echo Por favor, instala Node.js desde: https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js detectado

:: Ruta al vault de Obsidian (modificar si es necesario)
set "OBSIDIAN_VAULT=C:\Users\Mash\obsidian\Mash\Mash"

:: Verificar que el vault existe
if not exist "%OBSIDIAN_VAULT%" (
    echo [ERROR] Vault de Obsidian no encontrado en:
    echo   %OBSIDIAN_VAULT%
    echo.
    echo Por favor, verifica la ruta y modifica este archivo si es necesario.
    pause
    exit /b 1
)

echo [OK] Vault de Obsidian encontrado en:
echo   %OBSIDIAN_VAULT%
echo.

:: Configurar variables de entorno para MCP
set MCP_CONFIG_FILE=%CD%\mcp-config.json
echo Creando configuración MCP temporal en: %MCP_CONFIG_FILE%

:: Crear archivo de configuración MCP temporal
echo { > "%MCP_CONFIG_FILE%"
echo   "mcpServers": { >> "%MCP_CONFIG_FILE%"
echo     "obsidian": { >> "%MCP_CONFIG_FILE%"
echo       "command": "npx", >> "%MCP_CONFIG_FILE%"
echo       "args": [ >> "%MCP_CONFIG_FILE%"
echo         "-y", >> "%MCP_CONFIG_FILE%"
echo         "@modelcontextprotocol/server-filesystem", >> "%MCP_CONFIG_FILE%"
echo         "%OBSIDIAN_VAULT%" >> "%MCP_CONFIG_FILE%"
echo       ] >> "%MCP_CONFIG_FILE%"
echo     } >> "%MCP_CONFIG_FILE%"
echo   } >> "%MCP_CONFIG_FILE%"
echo } >> "%MCP_CONFIG_FILE%"

echo [OK] Configuración MCP creada
echo.

:: Iniciar Claude Code con MCP
echo Iniciando Claude Code con MCP configurado...
echo.
echo Para salir escribe: /exit
echo.
echo ========================================
echo.

claude --mcp-config "%MCP_CONFIG_FILE%"

:: Limpiar archivo temporal
del "%MCP_CONFIG_FILE%" 2>nul

endlocal
