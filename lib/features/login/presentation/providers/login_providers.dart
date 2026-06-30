import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/login_local_data_source.dart';
import '../../data/datasources/login_remote_data_source.dart';
import '../../data/repositories/login_repository_impl.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/http/http_client.dart';
import 'login_state.dart';
import 'login_notifier.dart';
import '../../domain/entities/user_entity.dart';


final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(baseUrl: 'https://dummyjson.com');
});


final loginRemoteDataSourceProvider = Provider<LoginRemoteDataSource>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return LoginRemoteDataSourceImpl(httpClient: httpClient);
});

final loginLocalDataSourceProvider = Provider<LoginLocalDataSource>((ref) {
  return LoginLocalDataSourceImpl();
});


final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final remoteDataSource = ref.watch(loginRemoteDataSourceProvider);
  final localDataSource = ref.watch(loginLocalDataSourceProvider);
  return LoginRepositoryImpl(
    remoteDataSource: remoteDataSource,
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

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  
  return LoginNotifier(
    loginUseCase: loginUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    logoutUseCase: logoutUseCase,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(
    success: (user) => true,
    orElse: () => false,
  );
});


final currentUserProvider = Provider<String?>((ref) {
  final state = ref.watch(loginProvider);
  return state.maybeWhen(
    success: (user) => user.username,
    orElse: () => null,
  );
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
  return state.maybeWhen(
    success: (user) => user,
    orElse: () => null,
  );
});
