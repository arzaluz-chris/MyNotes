# MyNotes

Aplicación iOS nativa de notas desarrollada con **UIKit** y **Swift**, construida completamente de forma programática (sin Storyboards). Proyecto académico del Tecnológico de Monterrey enfocado en el dominio de interfaces gráficas adaptables para iOS.

## Demo en Video

[![Video Demo](https://img.youtube.com/vi/TPNoHEKkuPc/maxresdefault.jpg)](https://youtu.be/TPNoHEKkuPc?si=OSZDF7Obh7_f_pYX)

## Screenshots

<p align="center">
  <img src="screenshots/01-empty-state.png" width="200" alt="Estado vacío" />
  <img src="screenshots/02-new-note.png" width="200" alt="Nueva nota" />
  <img src="screenshots/03-note-filled.png" width="200" alt="Nota con contenido" />
</p>
<p align="center">
  <em>Estado vacío con mensaje orientativo — Formulario de nueva nota — Nota con contenido, slider de fuente y negritas</em>
</p>

<p align="center">
  <img src="screenshots/04-validation-alert.png" width="200" alt="Alerta de validación" />
  <img src="screenshots/05-edit-note.png" width="200" alt="Editar nota" />
  <img src="screenshots/06-notes-list.png" width="200" alt="Lista de notas" />
</p>
<p align="center">
  <em>Validación de campos vacíos — Edición de nota existente — Lista de notas con fecha y navegación</em>
</p>

## Funcionalidades

- **Crear notas** con título y contenido
- **Editar notas** existentes
- **Eliminar notas** con confirmación mediante alerta
- **Validación de entrada** — alertas al intentar guardar campos vacíos
- **Personalizar texto** — slider para tamaño de fuente (12–32pt) y toggle para negritas
- **Estado vacío** — mensaje orientativo cuando no hay notas
- **Interfaz adaptable** — compatible con iPhone y iPad mediante Auto Layout

## Arquitectura y Estructura

```
MyNotes/
├── AppDelegate.swift                # Ciclo de vida de la app
├── SceneDelegate.swift              # Configuración de la ventana y navegación raíz
├── Note.swift                       # Modelo de datos (struct con UUID, título, contenido, fecha)
├── NoteStore.swift                  # Almacén en memoria (CRUD de notas)
├── NotesListViewController.swift    # Pantalla principal — UITableView con estado vacío
├── NoteDetailViewController.swift   # Editor de nota — formulario con scroll y teclado
├── NoteCell.swift                   # Celda personalizada con UIStackView
└── Assets.xcassets/                 # Iconos de app (light, dark, tinted)
```

## Stack Técnico

| Concepto | Implementación |
|---|---|
| **Framework** | UIKit (100% programático, sin Storyboards) |
| **Navegación** | UINavigationController con push/pop |
| **Layout** | Auto Layout con NSLayoutConstraint, Safe Area y Keyboard Layout Guide |
| **Componentes UI** | UITableView, UITextField, UITextView, UISlider, UISwitch, UIButton, UIStackView, UILabel, UIAlertController |
| **Patrón de datos** | Store inyectado desde SceneDelegate (almacenamiento en memoria) |
| **Lenguaje** | Swift |
| **IDE** | Xcode |

## Conceptos Clave Aplicados

- **Auto Layout programático** — constraints activados con `NSLayoutConstraint.activate()` y `translatesAutoresizingMaskIntoConstraints = false`
- **Safe Area Layout Guide** — respeto de márgenes seguros en todos los view controllers
- **Keyboard Layout Guide** — el scroll se ajusta automáticamente al aparecer el teclado
- **UIStackView** — composición de formularios y celdas con spacing personalizado vía `setCustomSpacing(after:)`
- **UIAlertController** — confirmación destructiva para eliminación y validación de campos vacíos
- **Swipe-to-delete** — gesto nativo de UITableView con acción destructiva
- **Large Titles** — navegación con títulos grandes estilo iOS nativo

## Requisitos

- Xcode 15+
- iOS 17+
- No requiere dependencias externas

## Cómo Ejecutar

1. Clona el repositorio:
   ```bash
   git clone https://github.com/arzaluz-chris/MyNotes.git
   ```
2. Abre `MyNotes.xcodeproj` en Xcode
3. Selecciona un simulador (iPhone o iPad) y presiona **Cmd + R**
