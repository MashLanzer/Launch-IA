# Capacidades de Claude Code - Guía Completa

## 1. Desarrollo de Software

### Escritura y Edición de Código
- **Escribir código nuevo** desde cero en cualquier lenguaje (Python, JavaScript, TypeScript, Go, Rust, C#, GDScript, etc.)
- **Editar archivos existentes** con precisión usando diffs exactos
- **Refactorizar** para mejorar estructura, legibilidad y eficiencia
- **Renombrar** variables, funciones, clases de forma segura en todo el proyecto

### Depuración (Debugging)
- Identificar bugs mediante análisis de código
- Proponer correcciones con explicación del problema
- Agregar logs y puntos de debug
- Explicar mensajes de error

### Explicación de Código
- Describir qué hace código existente
- Explicar la lógica y el flujo
- Documentar funciones y módulos
- Traducir conceptos técnicos a lenguaje accesible

### Búsqueda en Proyectos
- Buscar archivos por nombre o patrón (`*.gd`, `*.cs`, `*.ts`)
- Buscar texto dentro de archivos (funciones, variables, strings)
- Explorar estructura de proyectos grandes
- Entender relaciones entre módulos

### Testing
- Escribir tests unitarios
- Ejecutar suites de tests
- Verificar cobertura de código

---

## 2. Tareas Técnicas

### Terminal y Comandos
- Ejecutar cualquier comando de shell (bash en Windows con Git Bash/WSL)
- Instalar dependencias (`npm`, `pip`, `cargo`, etc.)
- Compilar y construir proyectos
- Ejecutar scripts automatizados

### Gestión de Archivos
- Crear, leer, editar, mover, eliminar archivos y carpetas
- Trabajar con rutas (Windows usa `\` pero yo uso `/` en comandos)
- Gestionar permisos y atributos

### Git y Control de Versiones
- **Commits:** crear, ver historial, diffs
- **Branches:** crear, cambiar, listar, eliminar
- **Pull Requests:** crear, ver, comentar vía `gh`
- **Merge y rebase** con confirmación previa
- **Push/pull** con remote

### Investigación Web
- Buscar documentación oficial
- Investigar errores comunes
- Consultar APIs y libraries
- Acceder a recursos técnicos

### Agentes de Investigación
- Usar agentes especializados para búsquedas profundas
- Explorar codebases complejos
- Investigar múltiples fuentes en paralelo

---

## 3. Gestión de Proyectos

### Planificación (EnterPlanMode)
- Para tareas complejas o ambiguas
- Diseña pasos de implementación
- Identifica archivos críticos
- Presenta el plan para aprobación antes de ejecutar

### Sistema de Tareas
- Crear tareas con `TaskCreate`
- Trackear progreso con estados (pending, in_progress, completed)
- Establecer dependencias entre tareas
- Listar y actualizar tareas

### Programación (Cron)
- Tareas recurrentes basadas en tiempo
- Recordatorios automáticos
- Agentes remotos programados

---

## 4. Sistema y Configuración

### Memoria Persistente
- Guarda información sobre el usuario (perfil, preferencias, feedback)
- Ubicación: `C:\Users\braya\.claude\projects\C--Users-braya\memory\`
- Se usa en futuras conversaciones

### Configuración de Claude Code
- **Settings.json:** permisos, hooks, variables de entorno
- **Permisos:** aprobar/denegar comandos específicos
- **Hooks:** acciones automáticas antes/después de eventos
- **update-config skill:** para configurar

---

## 5. Proyecto Godot

### Ubicación
```
C:/Godot/new-game-project
```

### Qué puedo hacer
- Leer y editar archivos `.gd` (GDScript)
- Leer y editar archivos de configuración `.godot`
- Ayudar con la estructura del proyecto
- Explicar APIs de Godot
- Depurar escenas y nodos
- Trabajar con recursos y exportadores

### Lenguaje
- GDScript (preferido en Godot)
- C# si el proyecto lo usa
- Shaders (GLSL)

---

## 6. Preferencias del Usuario

### Información Personal (Brayan)
- **Sistema:** Windows 11 Pro 10.0.26200
- **Idioma:** Español
- **Directorio de usuario:** `C:/Users/braya`

### Estilo de Comunicación
- Respuestas cortas y directas
- Sin summaries o recapitulaciones al final
- Confirmar antes de acciones destructivas o riesgosas

### Proyecto Activo
- Godot en `C:/Godot/new-game-project`
- Última actividad: Marzo 2026

---

## 7. Cómo Usar Esta Guía

Esta guía documenta las capacidades disponibles. Si necesitas algo específico:

1. **Pregunta directamente** - "puedes hacer X?"
2. **Pide una tarea** - "haz X en el proyecto"
3. **Usa /slash commands** - `/plan`, `/remember`, `/help`
4. **Consulta memoria** - "qué recuerdas de mí?"

---

*Última actualización: 2026-03-25*
