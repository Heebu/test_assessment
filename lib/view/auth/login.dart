import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      'Login to continue',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade50,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextField(
                              controller: viewModel.emailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                hintText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,

                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: TextField(
                              controller: viewModel.passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'password',
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,

                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text("Login"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          await viewModel.signInEmail();

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

                          foregroundColor: Colors.black,
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
