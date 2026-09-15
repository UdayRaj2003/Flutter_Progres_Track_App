import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/logging/app_logger.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/student/student_bloc.dart';
import 'bloc/student/student_event.dart';
import 'core/logging/app_bloc_observer.dart';
import 'device/device_info_provider_impl.dart';
import 'repositories/auth_repository_impl.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'storage/auth_storage.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(create: (_) => AuthService()),
        RepositoryProvider<AuthStorage>(create: (_) => AuthStorage()),
        RepositoryProvider<DeviceInfoProviderImpl>(
          create: (_) => DeviceInfoProviderImpl(),
        ),
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            authService: context.read<AuthService>(),
            authStorage: context.read<AuthStorage>(),
            deviceInfoProvider: context.read<DeviceInfoProviderImpl>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepositoryImpl>())
                  ..add(CheckAuthStatus()),
          ),
          BlocProvider<StudentBloc>(
            create: (_) => StudentBloc()..add(LoadStudent()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parent Progress App',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const AuthGate(),
    );
  }
}
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        return current is AuthChecking ||
            current is AuthAuthenticated ||
            current is AuthUnauthenticated;
      },
      builder: (context, state) {
        appLogger.d(
          'AuthGate State: ${state.runtimeType}',
        );

        if (state is AuthChecking) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const DashboardScreen();
        }

        return const LoginScreen();
      },
    );
  }
}