import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            right: 0.0,
            left: 0.0,
            top: 10,
            child: Opacity(
              opacity: 0.8,
              child: Center(
                child: AssetImageWidget(
                  imagePath: 'assets/images/intropage.png',
                  width: 500,
                  height: 259,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 250),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        )),
                    child: Column(
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 26,
                            color: primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Login in Your Account",
                          style: TextStyle(
                            // fontSize: 26,
                            color: primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    color: thirdColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex:
                                          0, // Tidak ada ruang fleksibel untuk ikon
                                      child: Icon(Icons.email),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        // initialValue: "email",
                                        decoration: const InputDecoration(
                                            labelText: 'Email',
                                            border: InputBorder.none),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: thirdColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex:
                                          0, // Tidak ada ruang fleksibel untuk ikon
                                      child: Icon(Icons.lock),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        // initialValue: "password",
                                        decoration: const InputDecoration(
                                            labelText: 'Password',
                                            border: InputBorder.none),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () => {},
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            color: secondaryFontColor),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 15.0),
                              // Submit button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/navigate');
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Atur radius sudut menjadi 10
                                    ),
                                    minimumSize: Size(double.infinity, 48),
                                    backgroundColor: primaryColor),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryFontColor),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Or continue with :",
                                style: TextStyle(color: primaryFontColor),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: SignInButton(
                                  Buttons.Google,
                                  onPressed: () {
                                    // Fungsi yang akan dijalankan saat tombol ditekan
                                    // Anda dapat menambahkan logika autentikasi Google di sini
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't Have an Account?"),
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.pushNamed(
                                                context, '/signup')
                                          },
                                      child: Text(
                                        "Register",
                                        style:
                                            TextStyle(color: Colors.blue[800]),
                                      ))
                                ],
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
