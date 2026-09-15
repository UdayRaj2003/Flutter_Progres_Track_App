import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/logging/app_logger.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<Logout>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChecking());

    try {
      final hasSession = await authRepository.hasSession();

      if (hasSession) {
        // Session restoration will be completed
        // when we add session loading in the next phase.
        emit(AuthUnauthenticated());
        return;
      }

      emit(AuthUnauthenticated());
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await authRepository.sendOtp(
        phoneNumber: event.phoneNumber,
      );

      if (!response.isSent) {
        emit(
          AuthError(
            response.message.isNotEmpty
                ? response.message
                : 'Unable to send OTP.',
          ),
        );
        return;
      }

      emit(
        AuthOtpSent(phoneNumber: event.phoneNumber, message: response.message),
      );
    } catch (error, stackTrace) {
      appLogger.e('SendOtp failed', error: error, stackTrace: stackTrace);

      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final session = await authRepository.verifyOtp(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );

      emit(AuthAuthenticated(session));
    } on OtpMaxAttemptsException catch (_) {
    emit(AuthOtpLocked(DateTime.now().add(const Duration(seconds: 60))));
  }  catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRepository.logout();

      emit(AuthUnauthenticated());
    } catch (error, stackTrace) {
      appLogger.e('Logout failed', error: error, stackTrace: stackTrace);

      emit(AuthError(error.toString()));
    }
  }
}
