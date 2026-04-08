# Pass Monitor Alps — Proyecto SwiftUI

## Cómo crear el proyecto en Xcode

1. Abre Xcode → File → New → Project
2. Selecciona **iOS → App**
3. Configura:
   - Product Name: `PassMonitor`
   - Team: tu Apple ID (o "None" si no tienes Developer account aún)
   - Organization Identifier: `com.tuapellido` (ej: `com.juanjo`)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Desmarca "Include Tests"
4. Click "Next", elige dónde guardarlo, click "Create"

## Cómo añadir los archivos

Xcode habrá creado una carpeta con estos archivos por defecto:
- `PassMonitorApp.swift` (punto de entrada — NO tocar)
- `ContentView.swift` (la vista principal — REEMPLAZAR con nuestro código)
- `Assets.xcassets` (iconos y colores — lo dejamos por ahora)

Para añadir nuestros archivos:
1. En el panel izquierdo de Xcode (el "Navigator"), haz clic derecho en la carpeta "PassMonitor"
2. Selecciona "New File..." → "Swift File" → Next
3. Nómbralo exactamente como el archivo (ej: `PassData.swift`)
4. Pega el contenido del archivo correspondiente
5. Repite para cada archivo

## Orden recomendado para pegar archivos

1. `PassData.swift` — Modelos de datos (primero, porque todo depende de esto)
2. `Theme.swift` — Colores y estilos
3. `ContentView.swift` — Reemplaza el que ya existe (navegación principal)
4. `PassCardView.swift` — Tarjeta de cada pass (móvil)
5. `GanttBarView.swift` — La barra de temporada
6. `PassDetailView.swift` — Vista de detalle expandida
7. `MapTabView.swift` — El mapa con Leaflet (via WebView)
8. `WeatherBadge.swift` — Componente de weather

## Para ejecutar

- Pulsa **Cmd + R** o el botón ▶️ en Xcode
- Selecciona un simulador (ej: iPhone 16 Pro)
- La app se compilará y abrirá en el simulador

## Estructura de archivos

```
PassMonitor/
├── PassMonitorApp.swift     ← Xcode lo genera (no tocar)
├── ContentView.swift        ← Tab principal (Gantt / Map)
├── PassData.swift           ← Modelo de datos + array de passes
├── Theme.swift              ← Colores, fuentes, constantes
├── PassCardView.swift       ← Tarjeta de cada pass
├── GanttBarView.swift       ← Barra visual de temporada
├── PassDetailView.swift     ← Detalle expandido
├── MapTabView.swift         ← Mapa interactivo
├── WeatherBadge.swift       ← Componente de weather
└── Assets.xcassets/         ← Xcode lo genera (iconos, colores)
```
