import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/logging/app_logger.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(SendOtp(_phoneController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          appLogger.d('LoginScreen AuthState: ${state.runtimeType}');

          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is AuthOtpSent) {
            appLogger.d(
              'LoginScreen: AuthOtpSent received. Navigating to OtpScreen.',
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpScreen(phoneNumber: state.phoneNumber),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

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
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter your registered phone number to continue.',
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 15,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: 'Enter phone number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';

                        if (phone.isEmpty) {
                          return 'Please enter your phone number.';
                        }

                        if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                          return 'Enter numbers only.';
                        }

                        if (phone.length < 10) {
                          return 'Enter a valid phone number.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: isLoading ? null : _sendOtp,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send OTP'),
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
