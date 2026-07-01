# Decisiones tecnicas del proyecto

Este documento explica de forma sencilla las decisiones principales que tomamos para la aplicacion. La idea no es describir cada linea de codigo, sino poder explicar por que el proyecto esta organizado asi y que archivos son importantes para el flujo principal.

## Arquitectura usada

El proyecto usa una estructura basada en Clean Architecture y separacion por features.

Esto significa que no pusimos todas las pantallas, servicios y modelos juntos en una sola carpeta. En su lugar, cada funcionalidad importante tiene su propio modulo dentro de `lib/features`.

Ejemplos:

- `lib/features/login`
- `lib/features/dashboard`
- `lib/features/transfers`
- `lib/features/settings`
- `lib/features/mobile_topup`

Dentro de cada feature usamos, cuando aplica, tres capas:

- `domain`: contiene las entidades, contratos de repositorios y casos de uso.
- `data`: contiene la forma concreta de obtener datos, por ejemplo Firebase, mocks o almacenamiento local.
- `presentation`: contiene pantallas, providers, notifiers y estados.

Esta separacion ayuda a que la app sea mas facil de mantener. Por ejemplo, si mas adelante cambiamos las cuentas mock por datos reales de Firebase, la pantalla del dashboard no deberia cambiar mucho, porque la pantalla consume un provider y no conoce directamente de donde vienen los datos.

## Por que usamos Clean Architecture

Usamos esta arquitectura porque los requerimientos pedian modularizar por funcionalidades y porque la app puede crecer.

Con esta estructura podemos separar responsabilidades:

- La pantalla se encarga de mostrar informacion.
- El notifier maneja el estado.
- El caso de uso representa una accion de negocio.
- El repositorio define como se piden los datos.
- El datasource sabe de donde salen los datos.

Un ejemplo claro esta en el dashboard:

- Entidad: `lib/features/dashboard/domain/entities/account_summary_entity.dart`
- Repositorio abstracto: `lib/features/dashboard/domain/repositories/dashboard_repository.dart`
- Caso de uso: `lib/features/dashboard/domain/usecases/get_dashboard_accounts_usecase.dart`
- Datasource mock: `lib/features/dashboard/data/datasources/dashboard_mock_data_source.dart`
- Repositorio concreto: `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`
- Notifier: `lib/features/dashboard/presentation/providers/dashboard_notifier.dart`
- Estado: `lib/features/dashboard/presentation/providers/dashboard_state.dart`
- Provider: `lib/features/dashboard/presentation/providers/dashboard_providers.dart`
- Pantalla: `lib/features/dashboard/presentation/views/dashboard_view.dart`

## Dashboard de productos y saldos

Para el requerimiento del dashboard, la pantalla muestra las cuentas del usuario con su tipo, numero, propietario y saldo.

Por ahora las cuentas son mock, pero no estan escritas directamente en la pantalla. Estan en:

`lib/features/dashboard/data/datasources/dashboard_mock_data_source.dart`

Esto es importante porque la pantalla no depende del mock. La pantalla solo escucha el estado del provider:

`lib/features/dashboard/presentation/providers/dashboard_providers.dart`

El flujo queda asi:

1. `DashboardView` pide el estado.
2. `DashboardNotifier` carga las cuentas.
3. `GetDashboardAccountsUseCase` ejecuta la accion.
4. `DashboardRepository` define el contrato.
5. `DashboardRepositoryImpl` pide los datos al datasource.
6. `DashboardMockDataSource` obtiene los datos mock o los lee desde cache local.

Tambien agregamos estados de carga, exito y error para que la pantalla pueda reaccionar mejor.

## Uso de Freezed

Usamos Freezed para representar estados de forma mas ordenada.

Freezed nos permite definir estados como:

- `initial`
- `loading`
- `success`
- `error`

Esto hace que sea mas claro saber que esta pasando en una pantalla.

Archivos donde usamos Freezed:

- `lib/features/login/presentation/providers/login_state.dart`
- `lib/features/login/presentation/providers/register_state.dart`
- `lib/features/dashboard/presentation/providers/dashboard_state.dart`

En login, por ejemplo, Freezed ayuda a saber si el usuario esta en estado inicial, cargando, autenticado o si hubo un error.

En dashboard, Freezed ayuda a mostrar:

- un loading mientras se cargan las cuentas,
- las cuentas cuando la carga fue exitosa,
- un mensaje de error si algo falla.

## Uso de Notifier

Usamos notifiers con Riverpod para manejar la logica de estado de algunas pantallas.

Los notifiers son utiles porque evitan que la pantalla tenga demasiada logica. La pantalla solo observa el estado y el notifier se encarga de cambiarlo.

Archivos importantes:

- `lib/features/login/presentation/providers/login_notifier.dart`
- `lib/features/login/presentation/providers/register_notifier.dart`
- `lib/features/dashboard/presentation/providers/dashboard_notifier.dart`
- `lib/features/transfers/presentation/providers/transfer_notifier.dart`
- `lib/features/mobile_topup/presentation/providers/topup_form_provider.dart`

Por ejemplo, `DashboardNotifier` se encarga de cargar las cuentas y cambiar el estado a `loading`, `success` o `error`.

## Selector de idioma

El selector de idioma esta en:

`lib/features/settings/presentation/views/settings_view.dart`

Usamos un `SegmentedButton` para que el usuario pueda elegir entre:

- Espanol
- Ingles

Cuando el usuario selecciona un idioma, se actualiza el controlador:

`lib/app/presentation/controllers/locale_controller.dart`

Ese controlador cambia el idioma de la app usando un `ValueNotifier`.

## Configuracion i18n

La internacionalizacion esta configurada con los archivos `.arb`.

Archivos principales:

- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_localizations.dart`

En `pubspec.yaml` esta activada la generacion de localizaciones con:

`generate: true`

En `lib/main.dart` configuramos:

- `AppLocalizations.delegate`
- `GlobalMaterialLocalizations.delegate`
- `GlobalWidgetsLocalizations.delegate`
- `GlobalCupertinoLocalizations.delegate`
- `supportedLocales`

Esto permite que la app pueda mostrar textos en espanol o ingles.

## Persistencia con SharedPreferences

Usamos `shared_preferences` para guardar informacion sencilla en el dispositivo.

Actualmente lo usamos para dos cosas:

1. Guardar el idioma seleccionado por el usuario.
2. Guardar en cache las cuentas mock del dashboard.

Archivos importantes:

- `lib/app/presentation/controllers/locale_controller.dart`
- `lib/features/dashboard/data/datasources/dashboard_mock_data_source.dart`

Esto permite que si el usuario cambia el idioma, la app recuerde esa seleccion cuando se vuelva a abrir.

Tambien permite que el dashboard lea primero las cuentas desde cache local antes de cargar nuevamente los mocks.

## Conexion con Firebase

Firebase se usa principalmente para autenticacion.

Archivos importantes:

- `lib/firebase_options.dart`
- `lib/main.dart`
- `lib/features/login/data/datasources/firebase_login_data_source.dart`
- `lib/features/login/data/repositories/login_repository_impl.dart`
- `lib/features/login/presentation/providers/login_providers.dart`

En `main.dart` inicializamos Firebase con:

`Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`

El datasource de Firebase se encarga de operaciones como:

- escuchar cambios de sesion,
- iniciar sesion con email y password,
- obtener el usuario actual,
- cerrar sesion.

La pantalla de login no habla directamente con Firebase. La pantalla usa providers y el flujo pasa por el repositorio y los casos de uso.

## Router y flujo principal

El router principal esta en:

`lib/app/router/app_router.dart`

Este archivo decide que pantalla se muestra segun si el usuario esta autenticado o no.

Reglas principales:

- Si el usuario no esta autenticado, se redirige a `/login`.
- Si el usuario esta autenticado y entra a `/login`, se redirige al home.
- El home usa `HomeTabsView`.

La vista principal despues del login esta en:

`lib/app/presentation/views/home_tabs_view.dart`

Esa vista contiene el menu inferior con:

- Inicio
- Transferencias
- Pagos
- Configuracion

## Archivos mas importantes del flujo

Estos son los archivos que explican mejor el funcionamiento general de la app:

- `lib/main.dart`: inicializa Firebase, carga idioma guardado y configura MaterialApp.
- `lib/app/router/app_router.dart`: controla rutas y redireccion segun autenticacion.
- `lib/app/presentation/views/home_tabs_view.dart`: pantalla principal despues del login.
- `lib/features/login/presentation/views/login_view.dart`: pantalla de inicio de sesion.
- `lib/features/login/presentation/providers/login_notifier.dart`: logica de login.
- `lib/features/login/data/datasources/firebase_login_data_source.dart`: conexion directa con Firebase Auth.
- `lib/features/dashboard/presentation/views/dashboard_view.dart`: muestra productos y saldos.
- `lib/features/dashboard/presentation/providers/dashboard_notifier.dart`: carga las cuentas del dashboard.
- `lib/features/dashboard/data/datasources/dashboard_mock_data_source.dart`: mock y cache local de cuentas.
- `lib/features/settings/presentation/views/settings_view.dart`: configuracion y selector de idioma.
- `lib/app/presentation/controllers/locale_controller.dart`: controla y guarda el idioma.

## Resumen de decisiones

Las decisiones principales fueron:

- Organizar el proyecto por features.
- Usar Clean Architecture para separar responsabilidades.
- Usar Riverpod para providers y manejo de estado.
- Usar Freezed para estados importantes como login y dashboard.
- Usar Firebase Auth para autenticacion.
- Usar i18n con archivos ARB para espanol e ingles.
- Usar SharedPreferences para guardar idioma y cache local.
- Usar mocks en dashboard por ahora, pero ubicados en data para poder reemplazarlos facilmente despues.

Con esta estructura, el proyecto queda preparado para crecer sin que todas las pantallas dependan directamente de Firebase, mocks o detalles internos de almacenamiento.
