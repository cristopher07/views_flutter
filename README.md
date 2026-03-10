
# views_flutter

Proyecto de vistas del curso de Flutter, hecho por Cristopher Rolando Sarceño González como prácticas.


Estructura básica del proyecto:

lib/
├── main.dart                           # Punto de entrada (inicia en LoginView)
├── features/
│   ├── login/
│   │   └── presentation/
│   │       └── views/
│   │           └── login_view.dart     
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       └── views/
│   │           └── dashboard_view.dart  # Tab 1: Dashboard
│   │
│   ├── transfers/
│   │   └── presentation/
│   │       └── views/
│   │           └── transfers_view.dart  # Tab 2: Transferencias
│   │
│   ├── history/
│   │   └── presentation/
│   │       └── views/
│   │           └── history_view.dart    # Tab 3: Historial
│   │
│   └── settings/
│       └── presentation/
│           └── views/
│               └── settings_view.dart   # Tab 4: Configuración
│
└── app/
    └── presentation/
        └── views/
            └── home_tabs_view.dart     

- Rama que contiene actualizado el proyecto es: configInit

- Para instalar dependencias debemos usar: flutter pub get

- Para instalar flutter use fvm, para correr nuestro proyecto podemos usar: fvm flutter run -d edge



