import 'package:flutter/material.dart';
import 'package:mini_ecommerce_catalog/shared_prefs/shared_preference.dart';
import 'package:provider/provider.dart';

import '../../customization/custom_textfield.dart';
import '../../providers/auth_provider.dart';
import '../dashboard_screen/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pswdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  final RegExp emailValidatorRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp passwordValidatorRegExp = RegExp(
    r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{6,16}$",
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenWidth * 0.02,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        labelText: "Email",
                        hintText: "Enter email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!emailValidatorRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      CustomTextField(
                        controller: pswdController,
                        labelText: "Password",
                        hintText: "Enter password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!passwordValidatorRegExp.hasMatch(value)) {
                            return 'Password must be atleast 6 characters, include uppercase, lowercase, number, and special character.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obsureText: !showPassword,
                        sufFixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        maxLine: 1,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // LOGIN BUTTON
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          minimumSize: WidgetStatePropertyAll(
                            Size(screenWidth * 0.6, 45),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.white60,
                          ),
                        ),
                        onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                             final authProvider =
                            Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );

                            if (authProvider.isLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DashboardScreen(),
                                ),
                              );
                            } else if (authProvider.errorMessage !=
                                null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    authProvider.errorMessage!,
                                  ),
                                ),
                              );
                              authProvider.clearError();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login Btn clicked")),
                            );
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.030),

                      Row(
                        children: [
                          Expanded(child: Divider(thickness: 2)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: TextButton(
                              onPressed: () {
                              },
                              child: Text(
                                'New User? Sign Up',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(thickness: 2)),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
                          elevation: 2,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () async {
                          /* ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Google login clicked")),
                          );*/
                          final authProvider = Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          );
                          await authProvider.googleLogin();

                          if (authProvider.isLoggedIn) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DashboardScreen(),
                              ),
                            );
                          } else if (authProvider.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage!),
                              ),
                            );
                            print(authProvider.errorMessage);
                            authProvider.clearError();
                          }
                        },
                        icon: Image.asset(
                          "assets/icons/google_icon.png",
                          fit: BoxFit.contain,
                          height: 20,
                        ),
                        label: Text('Sign in with Google'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
