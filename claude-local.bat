@echo off
setlocal enabledelayedexpansion

title Claude Local - Ollama (No Login)
color 0A
cls

echo =====================================================
echo      CLAUDE CODE + OLLAMA - TODO EN UNO
echo =====================================================
echo.
echo Iniciando servicios locales...
echo.

:: CONFIGURACION DE RUTAS
set "PROXY_URL=http://localhost:4000"
set "MODEL=llama3.1"
set "CLAUDE_CODE_DIR=C:\Users\Mash\claude-code"
set "CLAUDE_EXE=C:\Users\Mash\.local\bin\claude.exe"

echo Configurando para usar modelo local...
echo   ANTHROPIC_BASE_URL=%PROXY_URL%
echo   Modelo: %MODEL%
echo.

:: ======================
:: PASO 1: VERIFICAR OLLAMA
:: ======================
echo [1/3] Verificando estado de Ollama...
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I "ollama.exe" >NUL
if %errorlevel% equ 0 (
    echo    [OK] Ollama ya esta corriendo
) else (
    echo    [INFO] Ollama no detectado - iniciando servicio...
    start "" "ollama serve"
    echo    Esperando 15 segundos para que Ollama inicie...
    timeout /t 15 /nobreak >nul
)

:: ======================
:: PASO 2: VERIFICAR PROXY
:: ======================
echo.
echo [2/3] Verificando estado del Proxy (Node.js)...
netstat -ano 2>NUL | findstr ":4000" | findstr "LISTENING" >NUL
if %errorlevel% equ 0 (
    echo    [OK] Proxy ya esta activo en puerto 4000
) else (
    echo    [INFO] Proxy no detectado - iniciando servicio Node.js...
    start "" "node" "%CLAUDE_CODE_DIR%\CLAUDE-PROXY-V2.cjs"
    echo    Esperando 10 segundos para que el proxy inicie...
    timeout /t 10 /nobreak >nul
)

:: ======================
:: PASO 3: VERIFICACION FINAL
:: ======================
echo.
echo [3/3] Verificando conexion completa entre servicios...
curl -s "%PROXY_URL%/health" >NUL 2>&1
if %errorlevel% equ 0 (
    echo    [OK] Proxy respondiendo correctamente
    echo    [OK] Conexion Ollama-Proxy establecida
) else (
    echo    [WARN] Proxy no responde inmediatamente - reintentando...
    timeout /t 5 /nobreak >nul
    curl -s "%PROXY_URL%/health" >NUL 2>&1
    if %errorlevel% neq 0 (
        echo    [ERROR] Fallo al conectar con el proxy
        echo    Posibles causas:
        echo      1. Ollama no esta corriendo (ejecute 'ollama serve')
        echo      2. Node.js no esta instalado o no esta en PATH
        echo      2. El archivo CLAUDE-PROXY-V2.cjs no existe en:
        echo         %CLAUDE_CODE_DIR%
        echo.
        pause
        exit /b 1
    )
)

:: ======================
:: INICIAR CLAUDE CODE CLI
:: ======================
echo.
echo =====================================================
echo ✅ TODO LISTO! Claude Code CLI está listo para usar (sin login).
echo =====================================================
echo.
echo Servicios activos:
echo   Ollama   : http://localhost:11434
echo   Proxy    : %PROXY_URL%
echo.
echo Configurando variables de entorno y ejecutando CLI...
echo.
echo Para salir escribe: /exit
echo.
echo =====================================================
echo.

:: Configurar variables temporales y ejecutar Claude CLI
set "ANTHROPIC_BASE_URL=%PROXY_URL%"
set "ANTHROPIC_API_KEY=sk-ant-api03-11111111111111111111111111111111"

:: Ejecutar directamente Claude en esta ventana
"%CLAUDE_EXE%" --model %MODEL%

endlocal