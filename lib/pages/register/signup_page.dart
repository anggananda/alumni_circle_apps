import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isChecked = false;
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
                          "Register",
                          style: TextStyle(
                            fontSize: 26,
                            color: primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Create your account",
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
                                            labelText: 'Username',
                                            border: InputBorder.none),
                                        keyboardType: TextInputType.text,
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
                              const SizedBox(
                                height: 10,
                              ),
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
                              const SizedBox(
                                height: 10,
                              ),
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
                                            labelText: 'Confirm Password',
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
                              const SizedBox(height: 25.0),
                              // Submit button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), 
                                    ),
                                    minimumSize: Size(double.infinity, 48),
                                    backgroundColor: primaryColor),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryFontColor),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Text(
                              //   "Or continue with :",
                              //   style: TextStyle(color: primaryFontColor),
                              // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // SizedBox(
                              //   width: double.infinity,
                              //   height: 45,
                              //   child: SignInButton(
                              //     Buttons.Google,
                              //     onPressed: () {
                              //       // Fungsi yang akan dijalankan saat tombol ditekan
                              //       // Anda dapat menambahkan logika autentikasi Google di sini
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Have an Account?"),
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.pushNamed(
                                                context, '/login')
                                          },
                                      child: Text(
                                        "Login",
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
