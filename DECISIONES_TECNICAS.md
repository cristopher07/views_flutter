# Decisiones tecnicas

Este proyecto esta organizado por funcionalidades dentro de `lib/features`.

Cada feature puede tener estas carpetas:

- `domain`: entidades, repositorios abstractos y casos de uso.
- `data`: datasources, modelos y repositorios concretos.
- `presentation`: vistas, providers, notifiers y estados.

Ejemplo:

```text
lib/features/login
  data/
  domain/
  presentation/
```

## Conceptos principales

Firebase:

- `Firebase Auth`: servicio que permite iniciar sesion con correo y contrasena.
- `Firebase.initializeApp`: inicializa Firebase antes de usar sus servicios.
- `firebase_options.dart`: archivo generado con la configuracion del proyecto Firebase.
- `authStateChanges`: stream que avisa cuando el usuario inicia o cierra sesion.

Arquitectura:

- `Feature`: modulo de una funcionalidad, por ejemplo `login` o `transfers`.
- `Domain`: reglas principales de la app, sin depender de Firebase ni UI.
- `Data`: implementacion real para obtener datos, por ejemplo Firebase.
- `Presentation`: pantallas, providers y estado visual.
- `UseCase`: accion puntual, por ejemplo iniciar sesion o cerrar sesion.
- `Repository`: contrato entre la app y la fuente de datos.
- `Datasource`: clase que habla directamente con Firebase, API o datos locales.

## Arbol principal

Diagrama generado con apoyo de IA para resumir la estructura principal del proyecto.

```text
lib/
  main.dart
  firebase_options.dart

  app/
    router/
      app_router.dart
    presentation/
      controllers/
        locale_controller.dart
      views/
        home_tabs_view.dart

  core/
    environmet/
      env.dart
    http/
      http_client.dart
      api_exception.dart

  features/
    login/
      data/
        datasources/
          firebase_login_data_source.dart
        models/
          user_model.dart
        repositories/
          login_repository_impl.dart
      domain/
        entities/
          user_entity.dart
        repositories/
          login_repository.dart
        usecases/
          login_usecase.dart
      presentation/
        providers/
          login_providers.dart
          login_notifier.dart
          login_state.dart
        views/
          login_view.dart

    dashboard/
    transfers/
    mobile_topup/
    settings/
    history/

  l10n/
    app_es.arb
    app_en.arb
```

## Login con Firebase

Firebase se usa para iniciar y cerrar sesion con correo y contrasena.

Archivos principales:

- `lib/main.dart`: inicializa Firebase.
- `lib/firebase_options.dart`: configuracion del proyecto Firebase.
- `lib/features/login/data/datasources/firebase_login_data_source.dart`: llama directamente a Firebase Auth.
- `lib/features/login/data/repositories/login_repository_impl.dart`: conecta Firebase con la capa de dominio.
- `lib/features/login/domain/usecases/login_usecase.dart`: casos de uso de login, usuario actual y logout.
- `lib/features/login/presentation/providers/login_providers.dart`: providers de Riverpod.
- `lib/features/login/presentation/views/login_view.dart`: pantalla de login.

Flujo del login:

```text
LoginView
  -> LoginNotifier
  -> LoginUseCase
  -> LoginRepository
  -> FirebaseLoginDataSource
  -> FirebaseAuth
```

## Router

El router esta en:

```text
lib/app/router/app_router.dart
```

Reglas:

- Si no hay usuario autenticado, manda a `/login`.
- Si el usuario ya inicio sesion, manda al home.
- El router escucha los cambios de Firebase Auth.

## Home

La pantalla principal despues del login esta en:

```text
lib/app/presentation/views/home_tabs_view.dart
```

Desde ahi se muestran las secciones principales de la app.

## Estado

Se usa Riverpod para manejar estado.

En login, el estado esta en:

```text
lib/features/login/presentation/providers/login_state.dart
```

Estados principales:

- `initial`
- `loading`
- `success`
- `error`

## Internacionalizacion

Los textos estan en:

```text
lib/l10n/app_es.arb
lib/l10n/app_en.arb
```

La configuracion principal esta en `lib/main.dart`.

## Resumen

Decisiones principales:

- Proyecto separado por features.
- Login conectado a Firebase Auth.
- Pantallas separadas de la logica de Firebase.
- Router protegido segun autenticacion.
- Riverpod para estado.
- Freezed para estados como login.
- i18n con archivos `.arb`.
