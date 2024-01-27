import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/constants.dart';
import 'login_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController =
  TextEditingController(text: 'tito+bs792@expatrio.com');
  final TextEditingController _passwordController =
  TextEditingController(text: 'nemampojma');
  final LoginService _loginService = LoginService();
  bool _validateEmail = false;
  bool _validatePassword = false;
  late bool _isPasswordVisible;

  @override
  void initState() {
    _isPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: size.width,
              child: Opacity(
                opacity: 0.5,
                child: Lottie.asset(
                  'assets/login-background.json',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SingleChildScrollView(
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
                  _buildRowWithIconAndText(
                      Icons.mail_outline, 'EMAIL ADDRESS'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      key: const Key('email'),
                      controller: _emailController,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kThemeColor),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: kThemeColor),
                        errorText:
                        _validateEmail ? 'Email Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRowWithIconAndText(
                      Icons.lock_outline, 'PASSWORD'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      key: const Key('password'),
                      obscureText: !_isPasswordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kThemeColor),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(color: kThemeColor),
                        errorText: _validatePassword
                            ? 'Password Can\'t Be Empty'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kThemeColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kThemeColor,
                      ),
                      child: const Text(
                        'LOGIN',
                        key: Key('login'),
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () async {
                        String emailWithoutWhiteSpace =
                        _emailController.text.replaceAll(
                            RegExp(r"\s+\b|\b\s"), "");

                        setState(() {
                          _emailController.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                        });
                        setState(() {
                          _passwordController.text.isEmpty
                              ? _validatePassword = true
                              : _validatePassword = false;
                        });

                        if (!_validateEmail && !_validatePassword) {
                          await _loginService.login(
                              emailWithoutWhiteSpace,
                              _passwordController.text,
                              context);
                        }
                      },
                    ),
                  ),
                  const Text("Developed by Giancarlo Mennillo",
                      style: TextStyle(fontSize: 10)),
                ],
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
                        maximumSize: Size(
                            size.width > 600 ? 130 : 100,
                            size.width > 600 ? 530 : 130),
                      ),
                      onPressed: () {
                        // Open the link in the browser
                        launchUrl(
                            Uri.parse('https://help.expatrio.com/hc/en-us'));
                      },
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.question_circle,
                              color: kThemeColor,
                              size: size.width > 600 ? 28 : 20),
                          Text(
                            'Help',
                            style: TextStyle(
                              fontSize: size.width > 600 ? 22 : 10.0,
                              color: kThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWithIconAndText(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
