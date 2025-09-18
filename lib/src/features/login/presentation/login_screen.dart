import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart'; 
import 'package:provider/provider.dart';
import 'package:time_planner/src/core/app/app_routes.dart';
import 'package:time_planner/src/core/di/injection.dart';
import 'package:time_planner/src/core/ui/widgets/primary_button.dart';
import 'package:time_planner/src/features/login/presentation/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<LoginViewModel>(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.loginSuccess) {
        context.go(AppRoutes.planner);
      }
      if (viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(viewModel.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Renove Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text('Bem-vindo!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Digite seu e-mail ou telefone para continuar.'),
            const SizedBox(height: 40),
            
          
            TextField(
              controller: viewModel.identifierController,
              decoration: const InputDecoration(labelText: 'E-mail ou Telefone', border: OutlineInputBorder()),
              enabled: !viewModel.showOtpFields, 
            ),
            const SizedBox(height: 24),
            
           
            if (viewModel.showOtpFields) ...[
              const Text('Digite o código que você recebeu:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Pinput( 
                length: 4,
                controller: viewModel.otpController,
                autofocus: true,
                onCompleted: (_) => viewModel.validateOtp(),
              ),
              const SizedBox(height: 24),
            ],

          
            PrimaryButton(
              text: viewModel.showOtpFields ? 'Validar Código' : 'Enviar Código',
              onPressed: viewModel.showOtpFields ? viewModel.validateOtp : viewModel.requestOtp,
              isLoading: viewModel.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}