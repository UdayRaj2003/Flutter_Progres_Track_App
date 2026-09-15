import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'dashboard_screen.dart';
class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Timer? _lockTimer;
  int _secondsRemaining = 0;
  void _startLockCountdown(DateTime lockedUntil) {
  _lockTimer?.cancel();
  _tick(lockedUntil);
  _lockTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _tick(lockedUntil),
  );
}

void _tick(DateTime lockedUntil) {
  final remaining = lockedUntil.difference(DateTime.now()).inSeconds;
  if (!mounted) return;
  setState(() => _secondsRemaining = remaining > 0 ? remaining : 0);
  if (_secondsRemaining == 0) {
    _lockTimer?.cancel();
  }
}
  @override
  void dispose() {
    _otpController.dispose();
    _lockTimer?.cancel();
    super.dispose();
  }

  void _verifyOtp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          VerifyOtp(
            phoneNumber: widget.phoneNumber,
            otp: _otpController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
           if (state is AuthOtpLocked) {            
    _startLockCountdown(state.lockedUntil);
  }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }

          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
final isLocked = _secondsRemaining > 0;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),

                    const Text(
                      'Enter OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Enter the OTP sent to ${widget.phoneNumber}.',
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6, 
                      enabled: !isLocked,
                      decoration: const InputDecoration(
                        labelText: 'OTP',
                        hintText: 'Enter OTP',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final otp =
                            value?.trim() ?? '';

                        if (otp.isEmpty) {
                          return 'Please enter the OTP.';
                        }

                        if (!RegExp(r'^[0-9]+$')
                            .hasMatch(otp)) {
                          return 'OTP must contain numbers only.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: (isLoading || isLocked) ? null : _verifyOtp,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isLocked
                                  ? 'Try again in ${_secondsRemaining}s'
                                  : 'Verify OTP',
                            ),
                    ),
                 ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}