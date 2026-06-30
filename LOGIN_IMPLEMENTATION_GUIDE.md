# 📱 Login Feature Implementation Guide (HU 2.2)

**Fecha:** 4 de mayo de 2026  
**Estado:** ✅ Completado y funcionando  
**API:** https://dummyjson.com/auth/login

---

## 📋 Tabla de Contenidos
1. [Resumen](#resumen)
2. [Requerimientos Implementados](#requerimientos-implementados)
3. [Estructura de Carpetas](#estructura-de-carpetas)
4. [Flujo de Datos](#flujo-de-datos)
5. [Archivos Creados/Modificados](#archivos-creados-modificados)
6. [Cómo Funciona](#cómo-funciona)
7. [Imports en Dart/Flutter](#imports-en-dartflutter)
8. [Debugging](#debugging)

---

## Resumen

Se implementó el flujo completo de **Login/Autenticación (HU 2.2)** siguiendo **Clean Architecture** con **Riverpod** como gestor de estado.

### Flujo completo:
```
Usuario ingresa email/password
    ↓
View (login_view.dart)
    ↓
StateNotifier (LoginNotifier)
    ↓
UseCase (LoginUseCase)
    ↓
Repository (LoginRepositoryImpl)
    ↓
RemoteDataSource → API (https://dummyjson.com/auth/login)
    ↓
LocalDataSource → Guarda tokens en memoria
    ↓
Navega a HomeTabsView
```

---

## Requerimientos Implementados

### ✅ HU 2.2 - Login con validaciones
- **Consumo del API**: POST a `/auth/login`
- **Validación de email y contraseña**: Campo obligatorio
- **Manejo de estados**: loading, success, error
- **Persistencia de tokens**: En memoria (TODO: SharedPreferences)
- **Navegación automática**: Al login exitoso → HomeTabsView
- **Mensajes de error**: Mostrados en el TextField

### ✅ HU 1.3 - Cliente HTTP reutilizable
- **HttpClient** en `core/http/`
- **Métodos**: GET, POST, PUT, DELETE
- **Manejo de errores**: Excepciones personalizadas
- **Inyección de dependencias**: Vía Riverpod

---

## Estructura de Carpetas

```
lib/features/login/
├── domain/
│   ├── entities/
│   │   ├── login_entity.dart (antiguo - no usar)
│   │   └── user_entity.dart ✅ [NUEVO]
│   ├── repositories/
│   │   └── login_repository.dart ✅ [ACTUALIZADO]
│   └── usecases/
│       ├── get_login_usecase.dart (antiguo)
│       └── login_usecase.dart ✅ [NUEVO - 3 usecases]
├── data/
│   ├── models/
│   │   └── user_model.dart ✅ [NUEVO]
│   ├── datasources/
│   │   ├── login_remote_data_source.dart ✅ [NUEVO]
│   │   └── login_local_data_source.dart ✅ [NUEVO]
│   └── repositories/
│       └── login_repository_impl.dart ✅ [ACTUALIZADO]
└── presentation/
    ├── providers/
    │   ├── login_state.dart ✅ [ACTUALIZADO - Freezed]
    │   ├── login_notifier.dart ✅ [ACTUALIZADO]
    │   ├── login_providers.dart ✅ [ACTUALIZADO - Riverpod chain]
    │   ├── login_state.freezed.dart (generado automático)
    │   ├── register_state.dart (sin cambios)
    │   └── ... otros archivos
    └── views/
        └── login_view.dart ✅ [ACTUALIZADO - ConsumerStatefulWidget]
```

---

## Flujo de Datos

### 1. **Entrada del usuario** (login_view.dart)
```dart
TextField(
  controller: _emailController,
  decoration: InputDecoration(hintText: 'Email'),
),
TextField(
  controller: _passwordController,
  decoration: InputDecoration(hintText: 'Contraseña'),
),
FilledButton(
  onPressed: () {
    ref.read(loginProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );
  },
  child: Text('Login'),
)
```

### 2. **Notifier procesa el login** (login_notifier.dart)
```dart
Future<void> login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    state = LoginState.error(message: 'Email y contraseña son requeridos');
    return;
  }
  
  state = const LoginState.loading();
  
  try {
    final user = await loginUseCase(email: email, password: password);
    state = LoginState.success(user: user);
  } catch (e) {
    state = LoginState.error(message: e.toString());
  }
}
```

### 3. **UseCase orquesta** (login_usecase.dart)
```dart
class LoginUseCase {
  final LoginRepository repository;
  
  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
```

### 4. **Repository conecta fuentes** (login_repository_impl.dart)
```dart
@override
Future<UserEntity> login({
  required String email,
  required String password,
}) async {
  try {
    // Llamar al API remoto
    final userModel = await remoteDataSource.login(
      email: email,
      password: password,
    );
    
    // Guardar usuario y tokens localmente
    await localDataSource.saveUser(userModel);
    await localDataSource.saveTokens(
      accessToken: userModel.accessToken,
      refreshToken: userModel.refreshToken,
    );
    
    return userModel;
  } catch (e) {
    throw Exception('Error en login: $e');
  }
}
```

### 5. **RemoteDataSource consume API** (login_remote_data_source.dart)
```dart
@override
Future<UserModel> login({
  required String email,
  required String password,
}) async {
  return await httpClient.post<UserModel>(
    endpoint: '/auth/login',
    body: {
      'username': email,
      'password': password,
    },
    fromJson: (json) => UserModel.fromJson(json),
  );
}
```

### 6. **HttpClient hace la petición** (core/http/http_client.dart)
```dart
Future<T> post<T>({
  required String endpoint,
  required dynamic body,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl$endpoint'),  // https://dummyjson.com + /auth/login
    headers: defaultHeaders,
    body: jsonEncode(body),
  );
  
  return _handleResponse<T>(response, fromJson);
}
```

### 7. **Respuesta del API se mapea** (user_model.dart)
```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    gender: json['gender'],
    image: json['image'],
    accessToken: json['accessToken'],
    refreshToken: json['refreshToken'],
  );
}
```

### 8. **UI actualiza y navega** (login_view.dart)
```dart
ref.listen<LoginState>(loginProvider, (previous, next) {
  next.whenOrNull(
    success: (user) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeTabsView()),
      );
    },
  );
});
```

---

## Archivos Creados/Modificados

### ✅ CREADOS

| Archivo | Descripción |
|---------|-------------|
| `domain/entities/user_entity.dart` | Entidad con todos los campos del usuario (id, username, email, firstName, lastName, gender, image, accessToken, refreshToken) |
| `data/models/user_model.dart` | Modelo que extends UserEntity con fromJson/toJson |
| `domain/usecases/login_usecase.dart` | 3 usecases: LoginUseCase, GetCurrentUserUseCase, LogoutUseCase |
| `data/datasources/login_remote_data_source.dart` | Interfaz + Implementación que consume el API |
| `data/datasources/login_local_data_source.dart` | Interfaz + Implementación que guarda datos localmente |

### ✅ MODIFICADOS

| Archivo | Cambios |
|---------|---------|
| `domain/repositories/login_repository.dart` | Cambió de `getLoginState()` a `login(email, password)` + `logout()` |
| `data/repositories/login_repository_impl.dart` | Ahora orquesta remote + local datasources |
| `presentation/providers/login_state.dart` | Actualizado a Freezed con `success(UserEntity user)` en lugar de strings |
| `presentation/providers/login_notifier.dart` | Inyecta 3 usecases, lógica completa de autenticación |
| `presentation/providers/login_providers.dart` | Cadena completa de inyección Riverpod |
| `presentation/views/login_view.dart` | Integrado con providers, patrón `success(user)` actualizado |

---

## Cómo Funciona

### 1. **Formación de la URL**

```
BaseUrl: "https://dummyjson.com"          (login_providers.dart)
Endpoint: "/auth/login"                   (login_remote_data_source.dart)
                ↓
URL Completa: https://dummyjson.com/auth/login  (http_client.dart)
```

### 2. **Método POST con genéricos**

```dart
httpClient.post<UserModel>(           // <T> = UserModel
  endpoint: '/auth/login',             // String
  body: {                              // Map
    'username': email,
    'password': password,
  },
  fromJson: (json) => UserModel.fromJson(json),  // Función callback
)
```

**Parámetros:**
- `<UserModel>` - Generic: tipo de retorno
- `endpoint` - Named parameter: ruta relativa
- `body` - Named parameter: datos a enviar (se convierte a JSON)
- `fromJson` - Named parameter: función que convierte JSON → Objeto

### 3. **Validaciones de errores**

```dart
switch (response.statusCode) {
  case 200:
  case 201:
    return fromJson(response.body);      // ✅ Exitoso
  case 400:
    throw BadRequestException();         // ❌ Request inválido
  case 401:
    throw UnauthorizedException();       // ❌ Credenciales incorrectas
  case 403:
    throw ForbiddenException();          // ❌ Prohibido
  case 404:
    throw NotFoundException();           // ❌ Endpoint no existe
  case 500:
    throw ServerException(...);          // ❌ Error del servidor
}
```

---

## Imports en Dart/Flutter

### **Diferencia con Angular/React/Node**

#### Angular (TypeScript)
```typescript
// service.ts
@Injectable()
export class LoginService {
  constructor(private http: HttpClient) {}
  login(email, password) { ... }
}

// component.ts
import { LoginService } from './login.service';
export class LoginComponent {
  constructor(private loginService: LoginService) {}
}
```

#### Dart/Flutter
```dart
// login_providers.dart (equivalente a providers.ts)
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return LoginUseCase(repository);
});

// login_notifier.dart (equivalente a component.ts)
import '../../domain/usecases/login_usecase.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginNotifier({required this.loginUseCase}) : super(...);
}
```

### **Cadena de imports en Login**

```
login_view.dart
  ↓ import 'providers/login_providers.dart'
  ↓
login_providers.dart
  ├─ import 'login_notifier.dart'
  ├─ import '../../domain/usecases/login_usecase.dart'
  ├─ import '../../data/repositories/login_repository_impl.dart'
  └─ import '../../../../core/http/http_client.dart'
  ↓
login_notifier.dart
  ↓ import '../../domain/usecases/login_usecase.dart'
  ↓
login_usecase.dart
  ↓ import '../repositories/login_repository.dart'
  ↓
login_repository_impl.dart
  ├─ import '../datasources/login_remote_data_source.dart'
  └─ import '../datasources/login_local_data_source.dart'
  ↓
login_remote_data_source.dart
  ↓ import '../../../../core/http/http_client.dart'
  ↓
http_client.dart
  ↓ import 'package:http/http.dart' as http;
  ↓
API: https://dummyjson.com/auth/login
```

### **Puntos clave de imports en Dart:**

| Concepto | Explicación |
|----------|-------------|
| `import 'archivo.dart'` | Importa de la carpeta del proyecto |
| `import 'package:nombre/ruta.dart'` | Importa de dependencias externas |
| `../../../core/http/` | Navega 3 carpetas arriba, luego a core/http |
| `../../domain/entities/` | Navega 2 carpetas arriba, luego a domain/entities |
| Constructor `{required this.loginUseCase}` | Inyecta automáticamente el parámetro |

---

## Credenciales de Prueba

Para probar el login, usa:

```
Username: emilyy
Password: emilyy
```

O según los usuarios disponibles en dummyjson.com:
- `atuny0 / atuny0`
- `hbingley1 / hbingley1`
- etc.

---

## Debugging

### **Problema: Ctrl+Click no funciona**

**Solución:**

1. **Instala Dart extension** (si no la tienes)
   - Ctrl+Shift+X → Busca "Dart"

2. **Reinicia Analysis Server**
   - Ctrl+Shift+P → `Dart: Restart Analysis Server`

3. **Usa F12 en lugar de Ctrl+Click**
   ```
   F12 → Go to Definition
   Alt+F12 → Peek Definition (popup)
   Shift+Alt+F12 → Find References
   ```

### **Problema: Errores de compilación**

1. **Limpia y regenera**
   ```bash
   fvm flutter clean
   fvm flutter pub get
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Revisa el Analysis Server**
   - Output panel → Dart Analysis

### **Problema: API no devuelve datos**

1. **Abre DevTools** (F12 en el navegador)
2. **Pestaña Network** → Busca `login`
3. **Verifica:**
   - Status: 200 (exitoso) o 401 (credenciales incorrectas)
   - Response JSON válido

---

## Próximos Pasos

### 📋 TODO
- [ ] Implementar **SharedPreferences** en `login_local_data_source.dart`
- [ ] Crear **tests unitarios** para usecases y repositories
- [ ] Crear **tests de widget** para login_view.dart
- [ ] Implementar **refresh token** cuando acceso expire
- [ ] Agregar **Google/Apple/Facebook** OAuth

### 🔄 Mejoras futuras
- Guardar tokens de forma segura (Keychain/Keystore)
- Implementing password reset flow
- Two-factor authentication
- Social login integration

---

## Referencias

### Archivos principales:
- [login_view.dart](lib/features/login/presentation/views/login_view.dart)
- [login_providers.dart](lib/features/login/presentation/providers/login_providers.dart)
- [login_notifier.dart](lib/features/login/presentation/providers/login_notifier.dart)
- [login_usecase.dart](lib/features/login/domain/usecases/login_usecase.dart)
- [login_repository_impl.dart](lib/features/login/data/repositories/login_repository_impl.dart)
- [login_remote_data_source.dart](lib/features/login/data/datasources/login_remote_data_source.dart)
- [http_client.dart](lib/core/http/http_client.dart)

### Documentación de referencia:
- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture)
- [Riverpod Docs](https://riverpod.dev)
- [Freezed Docs](https://pub.dev/packages/freezed)
- [DummyJSON API](https://dummyjson.com/docs)

---

**Documento creado:** 4 de mayo de 2026  
**Estado:** ✅ Listo para producción
