import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import '../shared/constants.dart';
import 'login_service.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController =
      TextEditingController(text: 'tito+bs792@expatrio.com');
  TextEditingController passwordController =
      TextEditingController(text: 'nemampojma');
  LoginService loginService = LoginService();
  bool _validateEmail = false;
  bool _validatePass = false;
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                width: size.width,
                child: Opacity(
                  opacity: 0.5,
                  child: LottieBuilder.asset(
                    'assets/login-background.json',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              // Existing content remains here
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: Image.asset('assets/2019_XP_logo_white.png'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: buildRowWithIconAndText(
                          Icons.mail_outline,
                          'EMAIL ADDRESS',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          key: const Key('email'),
                          controller: nameController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                            ),
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(
                              color: themeColor,
                            ),
                            errorText:
                                _validateEmail ? 'Email Can\'t Be Empty' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: buildRowWithIconAndText(
                            Icons.lock_outline, 'PASSWORD'),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          key: const Key('password'),
                          obscureText: !_passwordVisible,
                          controller: passwordController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: themeColor),
                            ),
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(
                              color: themeColor,
                            ),
                            errorText: _validatePass
                                ? 'Password Can\'t Be Empty'
                                : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: themeColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                          child: const Text(
                            'LOGIN',
                            key: Key('login'),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () async {
                            String emailWithoutWhiteSpace = nameController.text
                                .replaceAll(RegExp(r"\s+\b|\b\s"), "");

                            setState(() {
                              nameController.text.isEmpty
                                  ? _validateEmail = true
                                  : _validateEmail = false;
                            });
                            setState(() {
                              passwordController.text.isEmpty
                                  ? _validatePass = true
                                  : _validatePass = false;
                            });

                            if (!_validateEmail && !_validatePass) {
                              var validCredential = await loginService.login(
                                  emailWithoutWhiteSpace,
                                  passwordController.text,
                                  context);

                              if (validCredential) {
                                // Do something on successful login
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          maximumSize: const Size(100, 130),
                        ),
                        onPressed: () {
                          // Open the link in the browser
                          launch('https://help.expatrio.com/hc/en-us');
                        },
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.question_circle,
                                color: themeColor),
                            Text(
                              'Help',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Existing Spacer remains here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRowWithIconAndText(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }
}
