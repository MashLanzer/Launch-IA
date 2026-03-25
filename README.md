# Launch-IA: Configuración de Claude Code CLI con múltiples backends

Este repositorio contiene scripts listos para usar **Claude Code CLI** con diferentes configuraciones: Ollama local, Open Router (modelos gratuitos) y modelos locales a través de proxy.

## 📋 Contenido del Repositorio

- `claude-ollama.bat` - Ejecuta Claude usando Ollama con modelo `claude` (vía `ollama launch claude`)
- `claude-local.bat` - Configuración avanzada con proxy local para usar cualquier modelo de Ollama
- `claude-free.bat` - Usa Open Router con modelos gratuitos
- `Instalar IAs.instructions.md` - Instrucciones breves de instalación

---

## 🚀 Instalación y Configuración

### Requisitos Previos

1. **Git** (para clonar el repositorio)
2. **Node.js** (para el proxy local) - [Descargar](https://nodejs.org/)
3. **Ollama** (para modelos locales) - [Descargar](https://ollama.com/)
4. **Claude Code CLI** - Se instala automáticamente o manualmente:

```powershell
# En PowerShell como Administrador:
irm https://claude.ai/install.ps1 | iex
```

---

## 🔧 Método 1: Ollama Directo (Más Simple)

Este método usa Ollama con el modelo Claude ya disponible en Ollama.

### Instalación

1. Instala Ollama: https://ollama.com/install
2. Descarga el modelo Claude en Ollama:
   ```bash
   ollama pull claude
   ```
   o ejecuta directamente:
   ```bash
   ollama launch claude
   ```

3. Edita `claude-ollama.bat` si es necesario para ajustar el modelo.

### Uso

```bash
# Desde el directorio Launch-IA:
.\claude-ollama.bat
```

Esto abrirá Claude Code CLI conectado a Ollama ejecutando el modelo `claude`.

---

## 🔧 Método 2: Ollama + Proxy Local (Avanzado)

Este método usa un **proxy HTTP** que transforma las peticiones de Claude Code al formato de Ollama API, permitiendo usar cualquier modelo de Ollama (llama3.1, mistral, codellama, etc.) without needing Claude-specific models.

### Estructura Requerida

```
C:\Users\Mash\
├── claude-code\           # Directorio de Claude Code
│   └── CLAUDE-PROXY-V2.cjs  # Proxy Node.js ⚠️ DEBE ESTAR AQUÍ
├── .local\bin\            # Claude Code CLI binario
│   └── claude.exe
└── Launch-IA\             # Este repositorio
```

### Instalación del Proxy

**IMPORTANTE**: El archivo `CLAUDE-PROXY-V2.cjs` NO está incluido en este repositorio. Debes obtenerlo:

1. Busca el archivo `CLAUDE-PROXY-V2.cjs` en la documentación oficial de Claude Code o en repositorios relacionados
2. Colócalo en: `C:\Users\Mash\claude-code\CLAUDE-PROXY-V2.cjs`

### Instalación Paso a Paso

```bash
# 1. Instalar Node.js (si no lo tienes)
#    Verifica: node --version

# 2. Instalar Ollama
irm https://ollama.com/install.ps1 | iex

# 3. Descargar un modelo en Ollama (ejemplo: llama3.1)
ollama pull llama3.1

# 4. Instalar Claude Code CLI
irm https://claude.ai/install.ps1 | iex

# 5. Obtener CLAUDE-PROXY-V2.cjs y colocarlo en:
#    C:\Users\Mash\claude-code\CLAUDE-PROXY-V2.cjs

# 6. Editar claude-local.bat si es necesario:
#    - MODEL: cambiar a tu modelo preferido (llama3.1, mistral, etc.)
#    - CLAUDE_CODE_DIR: ruta a tu directorio claude-code
#    - CLAUDE_EXE: ruta al ejecutable de Claude
```

### Uso

```bash
# Desde el directorio Launch-IA:
.\claude-local.bat
```

El script automáticamente:
- ✅ Verifica si Ollama está corriendo, si no, lo inicia
- ✅ Inicia el proxy Node.js en puerto 4000
- ✅ Configura variables de entorno
- ✅ Ejecuta Claude Code CLI

**Servicios activos:**
- Ollama: `http://localhost:11434`
- Proxy: `http://localhost:4000`

---

## 🔧 Método 3: Open Router (Modelos Gratuitos)

Usa Open Router API con acceso a múltiples modelos gratuitos. Requiere token de API de Open Router.

### Obtener Token de Open Router

1. Regístrate en: https://openrouter.ai/
2. Ve a: https://openrouter.ai/keys
3. Copia tu API key (comienza con `sk-or-v1-`)

### Configuración

1. Edita `claude-free.bat` y reemplaza el token:

```batch
set ANTHROPIC_AUTH_TOKEN=sk-or-v1-TU_TOKEN_AQUI
```

⚠️ **IMPORTANTE**: El archivo actual contiene un token de ejemplo que NO funciona. Debes reemplazarlo con tu propio token.

2. Opcional: Cambia el modelo. Por defecto usa `openrouter/free`. Modelos gratuitos populares:

   - `openrouter/free` (automáticamente selecciona uno gratis)
   - `mistralai/mixtral-8x7b-instruct`
   - `meta-llama/llama-2-70b-chat`
   - `google/gemma-7b-it`

   Para cambiar el modelo, edita la línea:
   ```batch
   claude --model openrouter/free %*
   ```

   Por ejemplo:
   ```batch
   claude --model mistralai/mixtral-8x7b-instruct %*
   ```

### Uso

```bash
# Desde el directorio Launch-IA:
.\claude-free.bat
```

Claude Code CLI se conectará a Open Router y usará el modelo gratuito especificado.

---

## 🔄 Flujo de Trabajo Recomendado

### Para uso diario con IA local (sin límites):
```
Método 2 (Ollama + Proxy) → Mejor calidad, totalmente offline after setup
```

### Para uso ocasional sin instalar nada local:
```
Método 3 (Open Router) → Solo requieres token de API
```

### Para pruebas rápidas:
```
Método 1 (Ollama directo) → Más simple, pero limitado al modelo claude de Ollama
```

---

## 📝 Variables de Entorno Clave

| Variable | Método(s) | Descripción |
|----------|-----------|-------------|
| `ANTHROPIC_BASE_URL` | 1, 2, 3 | URL base de la API (proxy local o Open Router) |
| `ANTHROPIC_AUTH_TOKEN` | 3 | Token de Open Router |
| `ANTHROPIC_API_KEY` | 2 | Key fake para Claude CLI (no se usa) |
| `MODEL` | 1, 2 | Nombre del modelo a usar |

---

## 🐛 Solución de Problemas

### Error: "claude no es reconocido como comando..."
```bash
# Claude CLI no está en PATH
# Usa la ruta completa:
"C:\Users\Mash\.local\bin\claude.exe" --model openrouter/free
```

### Error: Ollama no responde
```bash
# Inicia Ollama manualmente:
ollama serve

# En otra terminal, verifica:
ollama list

# Prueba la API:
curl http://localhost:11434/api/tags
```

### Error: Proxy en puerto 4000 ya en uso
```bash
# Cambia PROXY_URL en claude-local.bat a otro puerto:
set "PROXY_URL=http://localhost:4001"
# Actualiza también puerto en CLAUDE-PROXY-V2.cjs
```

### Error: "Proxy no responde"
- Verifica que Node.js esté instalado: `node --version`
- Asegúrate que `CLAUDE-PROXY-V2.cjs` existe en la ruta especificada
- Revisa que no haya errores en el archivo .cjs

### Error: Modelo no encontrado en Open Router
```bash
# Lista modelos disponibles:
curl -H "Authorization: Bearer TU_TOKEN" \
     https://openrouter.ai/api/v1/models
```

---

## 🔒 Seguridad

- ⚠️ **No compartas** tu token de Open Router
- ✅ Los archivos `.bat` contienen tokens de ejemplo - **reemplázalos** antes de usar
- ✅ Considera usar variables de entorno del sistema en lugar de hardcodear tokens
- 🔐 Para mayor seguridad, crea un archivo `.env` y cárgalo antes de ejecutar

---

## 📚 Recursos Adicionales

- [Claude Code CLI Docs](https://docs.anthropic.com/en/docs/claude-code)
- [Ollama](https://ollama.com/)
- [Open Router](https://openrouter.ai/)
- [CLAUDE-PROXY-V2](https://github.com/konojunya/claude-proxy) (repositorio del proxy)

---

## 🤝 Contribuciones

Si encuentras el archivo `CLAUDE-PROXY-V2.cjs` faltante, considera agregarlo al repo para simplificar la instalación para otros usuarios.

---

**¡Listo! Ahora puedes usar Claude Code CLI con Ollama local o Open Router.**

Para cualquier problema, revisa lasVariables de entorno y las rutas especificadas en cada `.bat`.
