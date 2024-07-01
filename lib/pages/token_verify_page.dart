import 'package:alumni_circle_app/pages/confirm_password_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';

class TokenVerifyPage extends StatefulWidget {
  final String username;

  const TokenVerifyPage({Key? key, required this.username}) : super(key: key);

  @override
  State<TokenVerifyPage> createState() => _TokenVerifyPageState();
}

class _TokenVerifyPageState extends State<TokenVerifyPage> {
  final TextEditingController _tokenController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _tokenController.addListener(_validateTextField);
  }

  @override
  void dispose(){
    _tokenController.dispose();
    super.dispose();
  }

  void _validateTextField() {
    setState(() {
      _isButtonEnabled = _tokenController.text.length == 4;
    });
  }

  void _sendTokenVerify() async{
    final token = _tokenController.text;

    if(token.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill token')));
      return;
    }

    try{
      final response = await DataService.sendVerification(token);
      if(response.statusCode == 200){
        debugPrint("Successfully Token");
        _navigateToSetPassword();
        showSuccessDialog(
            context, "Your input token was valid");
      }else{
        debugPrint("Failed ${response.statusCode}");
        showWarningDialog(context, 'Invalid Token');
      }
    }catch(error){
      debugPrint(error.toString());
      showNoInternetDialog(context);
    }
  }

  void _navigateToSetPassword(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmPasswordPage(username: widget.username),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Token', style: TextStyle(fontWeight: FontWeight.bold),),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.security,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Enter the 4-digit verification code sent to ${widget.username}',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _tokenController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter 4-digit code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2.0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                        cursorColor: Colors.blue,
                        onChanged: (value) {
                          _validateTextField();
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 4) {
                            return 'Please enter a valid 4-digit code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                // Validate the form and proceed if valid
                                if (_tokenController.text.length == 4) {
                                  _sendTokenVerify();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: colors2, // Ubah warna teks tombol
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(color: primaryFontColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
