import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../home/home.dart';
import 'auth_viewmodel.dart';



class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: viewModel.isBusy
                    ? const CircularProgressIndicator()
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const FlutterLogo(size: 100),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to Notes',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in with Google to continue',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text("Continue with Google"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          await viewModel.signInWithGoogle();

                          if (viewModel.isLoggedIn) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeScreen(
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Sign-in failed")),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}







// class LoginView extends StackedView<AuthViewModel> {
//   const LoginView({super.key});
//
//   @override
//   Widget builder(
//       BuildContext context,
//       AuthViewModel viewModel,
//       Widget? child,
//       ) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Center(
//         child: viewModel.isBusy
//             ? const CircularProgressIndicator()
//             : ElevatedButton.icon(
//           icon: const Icon(Icons.login),
//           label: const Text("Sign in with Google"),
//           onPressed: () async {
//             await viewModel.signInWithGoogle();
//
//             if (viewModel.isLoggedIn) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => HomeScreen(
//                   ),
//                 ),
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Sign-in failed")),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
// }
