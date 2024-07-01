import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void sendRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password didn't match")));
      return;
    }

    try {
      final response =
          await DataService.sendRegister(email, username, password);
      if (response.statusCode == 201) {
        debugPrint('Register success');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Register success')));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        debugPrint('failed ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${response.statusCode}')));
      }
    } catch (error) {
      debugPrint(error.toString());
      showNoInternetDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: Container(
          decoration: const BoxDecoration(color: primaryColor),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Positioned(
                right: 0.0,
                left: 0.0,
                top: 40,
                child: Opacity(
                  opacity: 0.8,
                  child: Center(
                    child: AssetImageWidget(
                      imagePath: 'assets/images/intropage.png',
                      width: 550,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 292),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          )),
                      child: Column(
                        children: [
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 26,
                              color: primaryFontColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Create your account",
                            style: TextStyle(
                              color: primaryFontColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                children: [
                                  _buildTextField(
                                    controller: _usernameController,
                                    labelText: 'Username',
                                    icon: Icons.person,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField(
                                    controller: _emailController,
                                    labelText: 'Email',
                                    icon: Icons.email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      bool isValid = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        caseSensitive: false,
                                        multiLine: false,
                                      ).hasMatch(value.trim());
                                      if (!isValid) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField(
                                    controller: _passwordController,
                                    labelText: 'Password',
                                    icon: Icons.lock,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    labelText: 'Confirm Password',
                                    icon: Icons.lock,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 25),
                                  ElevatedButton(
                                    onPressed: sendRegister,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: const Size(double.infinity, 48),
                                      backgroundColor: primaryColor,
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryFontColor),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Have an Account?"),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/login');
                                        },
                                        child: Text(
                                          "Login",
                                          style: TextStyle(color: Colors.blue[800]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: thirdColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(icon),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
              ),
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
