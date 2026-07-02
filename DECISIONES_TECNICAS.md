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
