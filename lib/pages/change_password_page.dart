import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/pages/token_verify_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  bool isSumit = false;
  String? _emailError;
  String? _usernameError;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void sendData() async {
    setState(() {
      _emailError = _usernameError = null;
    });

    final username = _usernameController.text;
    final email = _emailController.text;

    if (username.isEmpty) {
      setState(() {
        _usernameError = "Username cannot be empty";
      });
    }

    if (email.isEmpty) {
      setState(() {
        _emailError = "Email cannot be empty";
      });
    }

    if (_usernameError != null || _emailError != null) {
      return;
    }

    try {
      setState(() {
        isSumit = true;
      });
      final response = await DataService.sendForgotPassword(username, email);
      if (response.statusCode == 200) {
        setState(() {
          isSumit = false;
        });
        debugPrint("Successfully sent username and email data");
        navigateToTokenVerify();
        showSuccessDialog(
            context, "Wait and check the verification code in your email");
      } else {
        setState(() {
          isSumit = false;
        });
        debugPrint("Failed ${response.statusCode}");
        showWarningDialog(context, 'Invalid Username or Password');
      }
    } catch (error) {
      setState(() {
        isSumit = false;
      });
      debugPrint(error.toString());
      showNoInternetDialog(context);
    }
  }

  void navigateToTokenVerify() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TokenVerifyPage(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: secondaryColor),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const AssetImageWidget(
                imagePath: 'assets/images/forgotpw.png',
                width: 350,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Forgot your password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Enter your registered email address and username and we will send a verification code to reset your password.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: primaryFontColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.email, color: primaryFontColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryColor, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        errorText: _emailError,
                      ),
                      style: const TextStyle(color: primaryFontColor),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: primaryFontColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person, color: primaryFontColor),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryColor, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        errorText: _usernameError,
                      ),
                      style: const TextStyle(color: primaryFontColor),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors2,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  child: isSumit
                      ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                      : GestureDetector(
                          onTap: sendData,
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
