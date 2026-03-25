# Claude Local - Ollama Bridge

Este directorio contiene el proxy que permite usar Claude Code con Ollama local.

## Estructura

```
claude-code/
├── CLAUDE-PROXY-V2.cjs  # Proxy Node.js (puerto 4000)
├── package.json          # Metadatos del proyecto
└── README.md             # Este archivo
```

## Inicio rápido

### 1. Asegurar que Ollama esté corriendo

```cmd
ollama serve
```

Si no tienes Ollama, descárgalo de: https://ollama.ai

### 2. Iniciar el proxy

```cmd
cd C:\Users\Mash\claude-code
node CLAUDE-PROXY-V2.cjs
```

El proxy escuchará en `http://localhost:4000`

### 3. Usar Claude Code local

Ejecuta en cualquier terminal:

```cmd
claude-local
```

Esto iniciará automáticamente:
- Ollama (si no está activo)
- El proxy (si no está activo)
- Claude Code conectado al modelo local

## Comandos útiles

```cmd
# Verificar que el proxy responde
curl http://localhost:4000/health

# Iniciar solo el proxy
node CLAUDE-PROXY-V2.cjs

# Iniciar solo Ollama
ollama serve

# Detener todo
taskkill /F /IM node.exe
taskkill /F /IM ollama.exe
```

## Configuración

- **Puerto del proxy**: 4000 (hardcoded, cambiar en CLAUDE-PROXY-V2.cjs línea 70 si es necesario)
- **Modelo por defecto**: `llama3.1` (configurable en claude-local.bat línea 22)
- **URL de Ollama**: `http://localhost:11434` (hardcoded en el proxy)

## Solución de problemas

### Error: "No se esperaba..."
Revisa que Node.js esté instalado: `node --version`

### Error: "ollama no se reconoce como..."
Instala Ollama desde https://ollama.ai y reinicia la terminal.

### El proxy no responde
Verifica que el archivo `CLAUDE-PROXY-V2.cjs` existe en esta carpeta.
Ejecuta manualmente: `node CLAUDE-PROXY-V2.cjs`

### Claude Code no se conecta
Asegúrate de que las variables de entorno están seteadas:
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_API_KEY%
```

Deben mostrar:
```
http://localhost:4000
sk-local-temp
```

## Cómo funciona

1. **claude-local.bat**: Script principal que orquesta todo
2. **CLAUDE-PROXY-V2.cjs**: Convierte API de Claude a formato Ollama
3. **Ollama**: Procesa las peticiones con el modelo local (llama3.1)
4. **Claude Code**: Cli de Anthropic que se conecta al proxy

El proxy transforma automáticamente las peticiones de Claude Code al formato que entiende Ollama.
