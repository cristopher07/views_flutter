import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/firebase_login_data_source.dart';
import '../../data/datasources/login_local_data_source.dart';
import '../../data/repositories/login_repository_impl.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';
import 'login_notifier.dart';
import '../../domain/entities/user_entity.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final loginLocalDataSourceProvider = Provider<LoginLocalDataSource>((ref) {
  return LoginLocalDataSourceImpl();
});

final firebaseLoginDataSourceProvider = Provider<FirebaseLoginDataSource>((
  ref,
) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseLoginDataSourceImpl(firebaseAuth: firebaseAuth);
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final firebaseDataSource = ref.watch(firebaseLoginDataSourceProvider);
  final localDataSource = ref.watch(loginLocalDataSourceProvider);
  return LoginRepositoryImpl(
    firebaseDataSource: firebaseDataSource,
    localDataSource: localDataSource,
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return LoginUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentFirebaseUserUseCaseProvider =
    Provider<GetCurrentFirebaseUserUseCase>((ref) {
      final repository = ref.watch(loginRepositoryProvider);
      return GetCurrentFirebaseUserUseCase(repository);
    });

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(loginRepositoryProvider);
  return repository.authStateChanges();
});

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final getCurrentFirebaseUserUseCase = ref.watch(
    getCurrentFirebaseUserUseCaseProvider,
  );
  final logoutUseCase = ref.watch(logoutUseCaseProvider);

  return LoginNotifier(
    loginUseCase: loginUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    getCurrentFirebaseUserUseCase: getCurrentFirebaseUserUseCase,
    logoutUseCase: logoutUseCase,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final firebaseUser = authState.valueOrNull;
  if (firebaseUser != null) {
    return true;
  }

  final state = ref.watch(loginProvider);
  return state.maybeWhen(success: (user) => true, orElse: () => false);
});

final currentUserProvider = Provider<String?>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(success: (user) => user.username, orElse: () => null);
});

final currentUserDisplayNameProvider = Provider<String?>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(
    success: (user) {
      final fullName = '${user.firstName} ${user.lastName}'.trim();
      if (fullName.isNotEmpty) return fullName;
      return user.username;
    },
    orElse: () => null,
  );
});

final userDataProvider = Provider<UserEntity?>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(success: (user) => user, orElse: () => null);
});
