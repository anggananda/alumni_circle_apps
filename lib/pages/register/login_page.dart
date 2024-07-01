import 'dart:convert';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/dto/login.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/services/sync_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void sendLogin(context, AuthCubit authCubit, ProfileCubit profileCubit) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await DataService.sendLoginData(username, password);
      if (response.statusCode == 200) {
        debugPrint('sending success');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Successfully')));
        final data = jsonDecode(response.body);
        final loggedIn = Login.fromJson(data);
        final token = await SecureStorageUtil.storage.read(key: "device_token");
        await SecureStorageUtil.storage
            .write(key: tokenStoreName, value: loggedIn.accessToken);
        authCubit.login(loggedIn.accessToken, token!);
        getProfile(profileCubit, loggedIn.accessToken, context);
        debugPrint(loggedIn.accessToken);
      } else {
        debugPrint('failed ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.statusCode == 400
                ? 'Fill in the username and password fields'
                : 'Incorrect username or password')));
      }
    } catch (error) {
      debugPrint(error.toString());
      showNoInternetDialog(context);
    }
  }

  void getProfile(ProfileCubit profileCubit, String? accessToken,
      BuildContext context) async {
    if (accessToken == null) {
      debugPrint('Access token is null');
      return;
    }

    final syncService = SyncService();

    try {
      final profile = await DataService.fetchProfile(accessToken);
      debugPrint(profile.toString());
      debugPrint('Roles: ${profile.roles}');
      debugPrint('idAlumni: ${profile.idAlumni}');

      await SecureStorageUtil.storage
          .write(key: "roles", value: profile.roles.toString());
      await SecureStorageUtil.storage
          .write(key: "idAlumni", value: profile.idAlumni.toString());

      profileCubit.setProfile(profile.roles, profile.idAlumni);

      await syncService.syncAlumni(profileCubit.state.idAlumni, accessToken);
      Navigator.pushReplacementNamed(context, '/navigate');
    } catch (error) {
      debugPrint('Error fetching profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final profileCubit = BlocProvider.of<ProfileCubit>(context);
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
              top: 70,
              child: Opacity(
                opacity: 0.8,
                child: Center(
                  child: AssetImageWidget(
                    imagePath: 'assets/images/intropage.png',
                    width: 600,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 350),
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
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 26,
                            color: primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Login in Your Account",
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: thirdColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            labelText: 'Username',
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your username';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: thirdColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.lock),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            border: InputBorder.none,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                              child: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: colors2,
                                              ),
                                            ),
                                          ),
                                          obscureText: _obscureText,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/change_password'),
                                      child: const Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            color: secondaryFontColor),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    sendLogin(
                                        context, authCubit, profileCubit);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 48),
                                      backgroundColor: primaryColor),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryFontColor),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: colors2,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/input_url');
                                        },
                                        icon: const Icon(
                                            Icons.settings_input_antenna),
                                        color: primaryFontColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account?"),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/signup'),
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                            color: Colors.blue[800]),
                                      ),
                                    )
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
      ),
    );
  }
}
