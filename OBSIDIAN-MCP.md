# 🧠 Claude Code + Obsidian vía MCP

Guía completa para conectar **Claude Code CLI** con tu vault de Obsidian usando el **Model Context Protocol (MCP)**.

---

## 📋 Índice

1. [¿Qué es MCP?](#qué-es-mcp)
2. [Requisitos](#requisitos)
3. [Instalación](#instalación)
4. [Configuración](#configuración)
5. [Uso](#uso)
6. [Permisos de Claude](#permisos-de-claude)
7. [Solución de problemas](#solución-de-problemas)
8. [Ejemplos prácticos](#ejemplos-prácticos)
9. [Configuración avanzada](#configuración-avanzada)

---

## ¿Qué es MCP?

**MCP (Model Context Protocol)** es un protocolo abierto que permite a aplicaciones de IA como Claude conectarse a fuentes de datos externas y herramientas.

Con MCP, Claude Code puede:
- ✅ Leer archivos de tu vault de Obsidian
- ✅ Buscar notas específicas
- ✅ Acceder a metadata (tags, fechas, enlaces)
- ✅ Analizar múltiples notas en contexto
- ✅ Escribir y modificar notas (si concedes permiso)

**Analogía:** MCP es como un USB-C para Claude - un estándar que permite conectar Claude a cualquier fuente de datos.

---

## Requisitos

### Software necesario

| Herramienta | Versión | Instalación |
|-------------|---------|-------------|
| **Claude Code CLI** | Latest | `irm https://claude.ai/install.ps1 \| iex` |
| **Node.js** | 18+ | https://nodejs.org/ |
| **Obsidian** | Cualquier versión | https://obsidian.md/ |
| **Git** | Opcional | Para control de versiones del vault |

### Tu vault de Obsidian

- Asegúrate de knowing la **ruta completa** de tu vault
- Por defecto suele estar en:
  - Windows: `C:\Users\[USER]\Documents\Obsidian\[VAULT]`
  - Mac: `~/Documents/Obsidian/[VAULT]`
  - Linux: `~/Documents/Obsidian/[VAULT]`

En tu caso: `C:\Users\Mash\obsidian\Mash\Mash`

---

## Instalación

### Paso 1: Verificar Node.js

```bash
node --version
```

Debe devolver `v18.x` o superior. Si no, descarga e instala desde [nodejs.org](https://nodejs.org/).

### Paso 2: Verificar Claude Code CLI

```bash
claude --version
```

Si no está instalado:
```powershell
irm https://claude.ai/install.ps1 | iex
```

### Paso 3: (Opcional) Instalar el Filesystem MCP Server globalmente

Para no depender de `npx` cada vez:

```bash
npm install -g @modelcontextprotocol/server-filesystem
```

**Ventaja:** Más rápido, funciona sin conexión después de la primera instalación.

---

## Configuración

### Opción A: Usar el script preparado (Recomendado)

En el repositorio `Launch-IA` encontrarás:

1. **`claude-obsidian.bat`** - Para Windows Command Prompt
2. **`claude-obsidian.ps1`** - Para PowerShell (recomendado)

#### Configurar la ruta del vault

Edita el archivo y modifica la línea:

```batch
set "OBSIDIAN_VAULT=C:\Users\Mash\obsidian\Mash\Mash"
```

O en PowerShell:
```powershell
$obsidianVault = "C:\Users\Mash\obsidian\Mash\Mash"
```

**Nota:** El script ya tiene tu ruta configurada. Solo ejecuta si no la has movido.

---

### Opción B: Configuración manual permanente

Si quieres una configuración permanente que no requiera scripts:

#### 1. Crear `settings.json` de Claude

Ubicación:
- **Windows:** `%APPDATA%\claude\settings.json`
- **Mac/Linux:** `~/.config/claude/settings.json`

**NOTA:** Claude Code buscando la configuración en diferentes lugares. En tu caso, ya creamos:
```
C:\Users\Mash\.config\claude\settings.json
```

Pero ten en cuenta que Claude Code puede buscar en otras rutas dependiendo de cómo se instaló.

#### 2. Configuración para MCP

```json
{
  "$schema": "https://code.claude.com/settings.json",
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\Mash\\obsidian\\Mash\\Mash"
      ],
      "env": {},
      "disabled": false
    }
  },
  "permissions": {
    "allow": [
      "mcp__obsidian-vault__*"
    ]
  }
}
```

**Importante:**
- Usa doble barra `\\` en Windows JSON
- Si instalaste el server globalmente, cambia `"command": "npx"` a `"command": "mcp-server-filesystem"`

#### 3. Habilitar permisos

Claude Code necesita permisos explícitos para usar MCP servers. En el mismo `settings.json`:

```json
{
  "permissions": {
    "allow": [
      "mcp__obsidian-vault__*"
    ]
  }
}
```

Esto permite **todas** las operaciones MCP en el vault. Para mayor seguridad, puedes especificar:

```json
"allow": [
  "mcp__obsidian-vault__list_resources",
  "mcp__obsidian-vault__read_resource",
  "mcp__obsidian-vault__list_tools",
  "mcp__obsidian-vault__call_tool"
]
```

---

## Uso

### Inicio rápido

1. Navega al directorio `Launch-IA`:
   ```bash
   cd ~/Launch-IA
   ```

2. Ejecuta el script:
   - **CMD:** `.\claude-obsidian.bat`
   - **PowerShell:** `.\claude-obsidian.ps1`
     - Si PowerShell bloquea la ejecución: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`

3. Claude Code CLI iniciará con MCP activado

### Probar que funciona

Una vez dentro de Claude Code, prueba:

```
Usa el MCP server de Obsidian. ¿Qué notas tengo en mi vault?
```

Claude debería responder listando los archivos `.md` que encuentra.

**Comandos útiles de Claude Code:**
- `/exit` - Salir de Claude Code
- `/cost` - Ver estadísticas de uso
- `/settings` - Ver configuración actual
- `/mcp` - Ver MCP servers conectados

---

## Permisos de Claude

### ¿Qué permisos se necesitan?

Para acceder a Obsidian, Claude necesita permisos MCP. Hay dos formas:

#### 1. A través de `settings.json` (automático)

Configura `permissions.allow` como se muestra arriba.

#### 2. A través de preguntas en tiempo de ejecución

Cuando Claude intente usar MCP por primera vez, te preguntará:
```
"Claude wants to use obsidian MCP server. Allow? (y/n)"
```

Responde `y` para permitir.

---

## Solución de problemas

### Error: `npx: command not found`

**Causa:** Node.js no está en PATH

**Solución:**
```bash
# Reinicia la terminal o
# Añade Node.js al PATH manualmente
# O usa la ruta completa: C:\Program Files\nodejs\npx.exe
```

### Error: `MCP server failed to start`

**Causa:** El paquete `@modelcontextprotocol/server-filesystem` no está instalado

**Solución:**
```bash
npm install -g @modelcontextprotocol/server-filesystem
```

O modifica el `settings.json` para usar `npx` y asegúrate de tener conexión a internet.

### Claude no encuentra el vault

**Verifica:**
```bash
# Que la ruta es correcta
dir "C:\Users\Mash\obsidian\Mash\Mash"
# Deberías ver archivos .md y carpetas
```

**Si usas PowerShell y el path tiene espacios:**

```json
"args": [
  "-y",
  "@modelcontextprotocol/server-filesystem",
  "C:\\Users\\Mash\\My Vault"  // Escapar correctamente
]
```

### MCP no aparece en Claude

**Verifica:**
1. El archivo `settings.json` está en la ubicación correcta
2. Claude Code está leyendo ese archivo:
   ```bash
   claude --print-settings 2>&1 | grep mcp
   ```
3. El servidor MCP está habilitado (`"disabled": false`)

### Claude tiene permisos limitados

Si Claude dice something like "I don't have permission to access MCP":

1. Revisa la sección `permissions` en `settings.json`
2. O responde `y` cuando Claude pregunte en tiempo real
3. Reinicia Claude Code después de modificar settings

---

## Ejemplos prácticos

### Ejemplo 1: Resumir una nota

```
¿Puedes leer la nota "Proyectos/2024-03-Producto-X.md" y hacer un resumen ejecutivo?
```

Claude usará MCP para leer el archivo y responder.

### Ejemplo 2: Buscar notas sobre un tema

```
Busca en mi vault todas las notas que mencionen "machine learning" y dame una lista con las ideas principales.
```

Claude listará recursos y filtrará.

### Ejemplo 3: Crear una nueva nota

```
Crea una nueva nota llamada "Reunión con equipo - 2024-03-25.md" con el contenido que te voy a dictar...
```

Claude usará la herramienta `write_file` del MCP server.

### Ejemplo 4: Conectar notas relacionadas

```
¿Qué notas están enlazadas con "Arquitectura del sistema"? Muéstrame el grafo de relaciones.
```

Claude puede analizar enlaces `[[...]]` en tus notas.

---

## Configuración avanzada

### Usar múltiples vaults

```json
{
  "mcpServers": {
    "obsidian-personal": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\Mash\\obsidian\\personal"
      ]
    },
    "obsidian-trabajo": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\Mash\\obsidian\\trabajo"
      ]
    }
  }
}
```

### Restringir acceso a carpetas específicas

El Filesystem MCP server puede limitarse a subcarpetas:

```json
"args": [
  "-y",
  "@modelcontextprotocol/server-filesystem",
  "C:\\Users\\Mash\\obsidian\\Mash\\Mash\\Notas Proyecto A"
]
```

### Configurar tiempo de expiración de caché

```json
"args": [
  "-y",
  "@modelcontextprotocol/server-filesystem",
  "C:\\Users\\Mash\\obsidian\\Mash\\Mash",
  "--cache-ttl", "3600"
]
```

### Logging para depuración

```json
"env": {
  "DEBUG": "mcp:*",
  "MCP_LOG_FILE": "C:\\Users\\Mash\\mcp.log"
}
```

---

## Compartir notas con Claude de forma segura

### ¿Qué puede ver Claude?

Con la configuración actual, Claude **puede**:
- ✅ Leer **todos** los archivos `.md` en el vault
- ✅ Leer imágenes (metadatos, no contenido visual)
- ✅ Ver estructura de carpetas
- ✅ Escribir/modificar archivos (si se le pide)
- ❌ **NO** puede ejecutar comandos del sistema
- ❌ **NO** puede acceder fuera del vault especificado
- ❌ **NO** puede acceder a internet a través del filesystem server

### Recomendaciones de seguridad

1. **Vault limpio:** No guardes credenciales, passwords, o información sensible en el vault si planeas usar MCP
2. **Backup:** Siempre ten un backup de tus notas
3. **Revisar cambios:** Claude puede modificar archivos. Revisa los cambios antes de guardar
4. **Limitaciones:** Configura `permissions.allow` solo a las operaciones necesarias
5. **Auditoría:** Revisa regularmente los logs de MCP

---

## Arquitectura técnica

```
┌─────────────┐
│  Claude CLI │
└──────┬──────┘
       │ MCP (stdio/JSON-RPC)
       │
┌──────▼────────────┐
│  Filesystem MCP   │
│    Server         │
│  (npx/local)      │
└──────┬────────────┘
       │ File I/O
       │
┌──────▼────────────┐
│  Obsidian Vault   │
│                   │
│  📁 notas/        │
│  📁 proyectos/    │
│  📁 recursos/     │
│  📄 *.md files    │
└───────────────────┘
```

**Flujo:**
1. Claude Code lee `settings.json` y lanza el MCP server
2. El Filesystem MCP server se conecta al directorio especificado
3. Claude envía peticiones (read_file, list_directory, etc.)
4. MCP server ejecuta operaciones de filesystem
5. Claude recibe los datos y los procesa

---

## Rendimiento y límites

### Tamaño de archivos

El Filesystem MCP server carga archivos completos en memoria:
- ⚠️ Archivos > 1MB pueden ralentizar el sistema
- ✅ Divide notas largas en múltiples archivos

### Número de archivos

- Para vaults con > 10,000 archivos, considera:
  - Usar múltiples MCP servers por subcarpeta
  - O excluir carpetas con archivos binarios

### Cache

- MCP cachea respuestas por defecto
- Para:vaults que cambian frecuentemente, reinicia Claude Code

---

## Alternativas a MCP

Si MCP no funciona para ti, considera:

1. **Copiar y pegar manualmente** - Para uso ocasional
2. **Exportar a PDF** - Claude puede leer PDFs
3. **Script personalizado** - Crea tu propio MCP server con metadata específica de Obsidian

---

## Recursos adicionales

- [MCP Official Docs](https://modelcontextprotocol.io/)
- [Claude Code MCP Guide](https://code.claude.com/docs/en/mcp)
- [Filesystem MCP Server Source](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
- [Obsidian Help - Vaults](https://help.obsidian.md/)

---

## Próximos pasos

1. ✅ Ejecuta `.\claude-obsidian.ps1` o `.\claude-obsidian.bat`
2. ✅ Prueba con: "¿Qué notas tengo sobre machine learning?"
3. ✅ Explora el grafo de conocimiento de tu vault
4. ✅ Crea nuevas notas asistiéndote con Claude

---

**¡Listo!** Ahora Claude Code puede acceder a todo tu conocimiento en Obsidian.

¿Problemas? Consulta la sección [Solución de problemas](#solución-de-problemas).
