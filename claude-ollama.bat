@echo off
:: ------------------------------------------------------------
:: CLAUDE CODE LAUNCHER v6.0 - Fixed
:: ------------------------------------------------------------

set CONFIG_DIR=%USERPROFILE%\.claude
set CONFIG_FILE=%CONFIG_DIR%\claude.json

:MAIN_MENU
cls
set SELECTED_MODEL=
echo ========================================
echo CLAUDE CODE LAUNCHER v6.0
echo ========================================
echo.
echo   [1] OpenRouter Cloud (Gratis)
echo   [2] Ollama Local (CPU)
echo   [3] Descargar modelos para Ollama
echo   [4] Ver modelos instalados
echo   [5] Salir
echo.
set /p choice="Opcion (1-5): "

if "%choice%"=="1" goto OPENROUTER_MODE
if "%choice%"=="2" goto OLLAMA_MODE
if "%choice%"=="3" goto DOWNLOAD_MENU
if "%choice%"=="4" goto LIST_MODELS
if "%choice%"=="5" exit /b 0

echo Opcion no valida.
pause
goto MAIN_MENU

:: ========================================
:: MODO 1: OPENROUTER CLOUD
:: ========================================
:OPENROUTER_MODE
cls
echo.
echo ========================================
echo MODO: OpenRouter Cloud
echo ========================================
echo.

:: ELIMinar config anterior primero
if exist "%CONFIG_FILE%" del "%CONFIG_FILE%"

if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

echo Configurando claude.json...
echo { > "%CONFIG_FILE%"
echo   "provider": "openai", >> "%CONFIG_FILE%"
echo   "apiKey": "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", >> "%CONFIG_FILE%"
echo   "baseUrl": "https://openrouter.ai/api/v1", >> "%CONFIG_FILE%"
echo   "model": "openrouter/free" >> "%CONFIG_FILE%"
echo } >> "%CONFIG_FILE%"

echo.
echo Configuracion creada:
type "%CONFIG_FILE%"
echo.

goto START_CLAUDE

:: ========================================
:: MODO 2: OLLAMA LOCAL (CPU)
:: ========================================
:OLLAMA_MODE
cls
echo.
echo ========================================
echo MODO: Ollama Local (CPU)
echo ========================================
echo.

:: Configurar variables de entorno para Ollama
set OLLAMA_NUM_PARALLEL=4
set OLLAMA_MAIN_GPU=-1
echo Variables de entorno:
echo   OLLAMA_NUM_PARALLEL=%OLLAMA_NUM_PARALLEL%
echo   OLLAMA_MAIN_GPU=%OLLAMA_MAIN_GPU%
echo.

:: Verificar instalación de Ollama
where ollama >NUL 2>NUL
if errorlevel 1 (
    echo ERROR: Ollama no encontrado en PATH.
    echo Instala desde: https://ollama.com/download/windows
    pause
    goto MAIN_MENU
)

:: Iniciar Ollama si no está corriendo
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" >NUL
if errorlevel 1 (
    echo Iniciando Ollama...
    start "" ollama
    timeout /t 5 /nobreak >NUL
) else (
    echo Ollama ya corriendo.
)

:: Verificar conexión
echo Verificando conexion...
curl -s http://localhost:11434/api/tags >NUL 2>&1
if errorlevel 1 (
    echo Reintentando...
    timeout /t 3 /nobreak >NUL
    curl -s http://localhost:11434/api/tags >NUL 2>&1
    if errorlevel 1 (
        echo ERROR: No hay conexion con Ollama.
        pause
        goto MAIN_MENU
    )
)
echo Ollama activo.
echo.

:: Seleccionar modelo
echo Modelos disponibles:
echo   [1] mistral:7b-instruct-q4_K_M
echo   [2] llama2:7b-chat-q4_K_M
echo   [3] phi3:mini
echo   [4] codellama:7b-instruct-q4_K_M
echo   [5] Volver
echo.
set /p model_choice="Elige (1-5): "

if "%model_choice%"=="1" set SELECTED_MODEL=mistral:7b-instruct-q4_K_M
if "%model_choice%"=="2" set SELECTED_MODEL=llama2:7b-chat-q4_K_M
if "%model_choice%"=="3" set SELECTED_MODEL=phi3:mini
if "%model_choice%"=="4" set SELECTED_MODEL=codellama:7b-instruct-q4_K_M
if "%model_choice%"=="5" goto MAIN_MENU

if "%SELECTED_MODEL%"=="" (
    echo Opcion invalida. Usando mistral...
    set SELECTED_MODEL=mistral:7b-instruct-q4_K_M
)

echo Modelo: %SELECTED_MODEL%
echo.

:: ELIMinar config anterior y crear nueva
if exist "%CONFIG_FILE%" del "%CONFIG_FILE%"

echo { > "%CONFIG_FILE%"
echo   "provider": "openai", >> "%CONFIG_FILE%"
echo   "apiKey": "sk-local-temp", >> "%CONFIG_FILE%"
echo   "baseUrl": "http://localhost:11434/v1", >> "%CONFIG_FILE%"
echo   "model": "%SELECTED_MODEL%" >> "%CONFIG_FILE%"
echo } >> "%CONFIG_FILE%"

echo Configuracion actualizada:
type "%CONFIG_FILE%"
echo.

goto START_CLAUDE

:: ========================================
:: OPCION 3: DESCARGAR MODELOS
:: ========================================
:DOWNLOAD_MENU
cls
echo ========================================
echo DESCARGAR MODELOS OLLAMA
echo ========================================
echo.
echo   [1] mistral:7b-instruct-q4_K_M
echo   [2] llama2:7b-chat-q4_K_M
echo   [3] phi3:mini
echo   [4] codellama:7b-instruct-q4_K_M
echo   [5] llama2:13b-chat-q4_K_M
echo   [6] Volver
echo.
set /p dl_choice="Modelo (1-6): "

if "%dl_choice%"=="1" set MODEL_TO_PULL=mistral:7b-instruct-q4_K_M
if "%dl_choice%"=="2" set MODEL_TO_PULL=llama2:7b-chat-q4_K_M
if "%dl_choice%"=="3" set MODEL_TO_PULL=phi3:mini
if "%dl_choice%"=="4" set MODEL_TO_PULL=codellama:7b-instruct-q4_K_M
if "%dl_choice%"=="5" set MODEL_TO_PULL=llama2:13b-chat-q4_K_M
if "%dl_choice%"=="6" goto MAIN_MENU

if "%MODEL_TO_PULL%"=="" (
    echo Opcion no valida.
    pause
    goto DOWNLOAD_MENU
)

cls
echo.
echo ========================================
echo DESCARGANDO: %MODEL_TO_PULL%
echo ========================================
echo.

where ollama >NUL 2>NUL
if errorlevel 1 (
    echo ERROR: Ollama no encontrado.
    pause
    goto MAIN_MENU
)

tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe" >NUL
if errorlevel 1 (
    echo Iniciando Ollama...
    start "" ollama
    timeout /t 5 /nobreak >NUL
)

echo Descargando...
ollama pull %MODEL_TO_PULL%

if errorlevel 1 (
    echo.
    echo ERROR: La descarga fallo.
    pause
    goto DOWNLOAD_MENU
)

echo.
echo ========================================
echo DESCARGA COMPLETADA
echo ========================================
echo.
pause
goto MAIN_MENU

:: ========================================
:: OPCION 4: LISTAR MODELOS
:: ========================================
:LIST_MODELS
cls
echo ========================================
echo MODELOS OLLAMA INSTALADOS
echo ========================================
echo.
where ollama >NUL 2>NUL
if errorlevel 1 (
    echo ERROR: Ollama no encontrado.
    pause
    goto MAIN_MENU
)
ollama list
echo.
pause
goto MAIN_MENU

:: ========================================
:: INICIO CLAUDE CODE
:: ========================================
:START_CLAUDE
cls
echo ========================================
echo INICIANDO CLAUDE CODE
echo ========================================
echo.
echo Configuracion actual:
if exist "%CONFIG_FILE%" (
    type "%CONFIG_FILE%"
) else (
    echo ERROR: No hay configuracion en %CONFIG_FILE%
    pause
    goto MAIN_MENU
)
echo.
echo Iniciando...
echo.

:: Ejecutar Claude con la config existente
claude --dangerously-skip-permissions

echo.
echo Claude Code cerrado.
pause
goto MAIN_MENU
