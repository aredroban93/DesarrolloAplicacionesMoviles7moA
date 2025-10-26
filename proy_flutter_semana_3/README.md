# 🖥️ Gestión de Computadoras - Flutter SQLite

Una aplicación móvil desarrollada en Flutter que permite gestionar un inventario de computadoras utilizando SQLite como base de datos local. La aplicación implementa todas las operaciones CRUD (Create, Read, Update, Delete).

## 📋 Características

- ✅ **Crear** nuevas computadoras
- 📖 **Leer** y visualizar lista de computadoras
- ✏️ **Actualizar** información de computadoras existentes
- 🗑️ **Eliminar** computadoras del inventario
- 💾 **Almacenamiento local** con SQLite
- 🎨 **Interfaz intuitiva** con Material Design 3
- 📱 **Responsive design** para diferentes tamaños de pantalla

## 🗃️ Estructura de Datos

Cada computadora contiene los siguientes campos:
- **ID**: Identificador único (auto-incrementable)
- **Tipo**: Escritorio o Laptop
- **Marca**: Fabricante (Lenovo, Dell, HP, Apple, etc.)
- **CPU**: Procesador (i7, i5, M4, Ryzen, etc.)
- **RAM**: Memoria RAM (16 GB, 32 GB, etc.)
- **HDD**: Disco duro (1 TB, 500 GB, 2TB, etc.)

## 📊 Datos de Ejemplo

La aplicación viene con datos pre-cargados:
1. Escritorio, Lenovo, i7, 16 GB, 1 TB
2. Laptop, Acer, i5, 16GB, 500 GB
3. Escritorio, Asus, i7, 32 GB, 1 TB
4. Escritorio, iMac, M4, 32 GB, 2TB

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/
│   └── computer.dart           # Modelo de datos Computer
├── helpers/
│   └── database_helper.dart    # Helper para operaciones SQLite
└── screens/
    ├── computer_list_screen.dart    # Pantalla principal con lista
    └── computer_form_screen.dart    # Formulario para agregar/editar
```

## 🔧 Dependencias

- **sqflite**: ^2.3.0 - Base de datos SQLite
- **path**: ^1.8.3 - Manejo de rutas de archivos
- **flutter**: SDK de Flutter

## 🚀 Instalación y Uso

1. **Clonar el repositorio** (o descargar el proyecto)

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## 📱 Funcionalidades de la Aplicación

### Pantalla Principal
- Lista todas las computadoras registradas
- Muestra información resumida de cada computadora
- Botón flotante (+) para agregar nueva computadora
- Pull-to-refresh para actualizar la lista
- Menú contextual en cada item para editar/eliminar

### Formulario de Computadora
- Campos de entrada validados
- Dropdown para selección de tipo (Escritorio/Laptop)
- Guardado automático en base de datos SQLite
- Validación de campos obligatorios

### Operaciones CRUD

#### Create (Crear)
- Toca el botón (+) en la pantalla principal
- Completa todos los campos del formulario
- Presiona "Guardar Computadora"

#### Read (Leer)
- La lista se carga automáticamente al abrir la app
- Usa pull-to-refresh para actualizar

#### Update (Actualizar)
- Toca el menú (⋮) en cualquier computadora
- Selecciona "Editar"
- Modifica los campos necesarios
- Presiona "Actualizar Computadora"

#### Delete (Eliminar)
- Toca el menú (⋮) en cualquier computadora
- Selecciona "Eliminar"
- Confirma la eliminación en el diálogo

## 🎨 Diseño de UI

- **Material Design 3**: Interfaz moderna y consistente
- **Colores**: Esquema de colores basado en índigo
- **Tipografía**: Fuentes legibles y jerárquicas
- **Iconografía**: Íconos intuitivos para cada acción
- **Feedback visual**: Snackbars para confirmaciones y errores

## 💾 Base de Datos

La aplicación utiliza SQLite para almacenamiento local:
- **Tabla**: `computers`
- **Esquema**: id, tipo, marca, cpu, ram, hdd
- **Ubicación**: Base de datos local del dispositivo
- **Persistencia**: Los datos se mantienen entre sesiones

## 🔧 Desarrollo

### Estructura del Código
- **Modelo de datos**: Clase `Computer` con métodos de serialización
- **Helper de BD**: `DatabaseHelper` como singleton para operaciones SQLite
- **Pantallas**: Separación clara entre lista y formulario
- **Validaciones**: Formularios con validación completa

### Buenas Prácticas Implementadas
- Singleton pattern para el helper de base de datos
- Validación de formularios
- Manejo de errores con try-catch
- Feedback visual para el usuario
- Código organizado y comentado

## 📄 Licencia

Este proyecto es parte de un ejercicio académico para la materia de Desarrollo de Aplicaciones Móviles.
