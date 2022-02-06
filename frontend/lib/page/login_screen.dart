import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:csi5112_frontend/page/home.dart';
import 'package:csi5112_frontend/util/constants.dart';
import 'package:csi5112_frontend/util/custom_route.dart';
import 'package:csi5112_frontend/util/users.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreentState();
}

class _LoginScreentState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data, bool isSwitched) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'User not exists';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,
      additionalSignupFields: const [
        UserFormField(
            keyName: 'Username', icon: Icon(FontAwesomeIcons.userAlt)),
        UserFormField(keyName: 'Name'),
        UserFormField(keyName: 'Surname'),
      ],
      initialAuthMode: AuthMode.login,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 450.0),
          child: FlutterSwitch(
            width: 130.0,
            height: 45.0,
            valueFontSize: 16.0,
            toggleSize: 20.0,
            value: isSwitched,
            borderRadius: 30.0,
            padding: 15.0,
            showOnOff: true,
            activeText: "Merchant",
            inactiveText: "Customer",
            inactiveColor: Colors.blue,
            activeColor: Colors.red,
            activeTextFontWeight: FontWeight.bold,
            inactiveTextFontWeight: FontWeight.bold,
            onToggle: (val) {
              setState(() {
                isSwitched = val;
              });
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 500.0, left: 50),
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300.0,
              child: isDesktop(context) == true
                  ? DefaultTextStyle(
                      style: GoogleFonts.oswald(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText('Sell your products online with'),
                          RotateAnimatedText('unbeatable reach'),
                          RotateAnimatedText('Stress-free delivery'),
                          RotateAnimatedText(
                              'to your customer\'s doorstep 24/7, from'),
                          ColorizeAnimatedText(
                            'House of eGro',
                            textStyle: GoogleFonts.oswald(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            colors: [
                              Colors.purple,
                              Colors.blue,
                              Colors.yellow,
                              Colors.red,
                            ],
                          ),
                        ],
                        onTap: () {},
                      ),
                    )
                  : Container(),
            )),
        Container(
            margin: const EdgeInsets.only(bottom: 500.0),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 280.0,
              child: DefaultTextStyle(
                style: GoogleFonts.oswald(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                child: TextLiquidFill(
                  text: 'eGro',
                  waveColor: Colors.orange.shade900,
                  boxBackgroundColor: Colors.pink.shade900,
                  textStyle: const TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 180.0,
                ),
              ),
            )),
      ],
      theme: LoginTheme(
        primaryColor: Colors.teal,
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.pink.shade900,
        pageColorDark: Colors.pink.shade900,
        logoWidth: 0.80,
        titleStyle: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'Quicksand',
            letterSpacing: 1,
            fontStyle: FontStyle.italic,
            fontSize: 10),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        buttonStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(
            backgroundColor: Colors.orange,
            color: Colors.white,
          ),
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: BorderRadius.circular(4),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),

      // ),
      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return _loginUser(loginData, isSwitched);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
          }
        }
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => const MyHomePage(),
          settings: const RouteSettings(name: '/home'),
        ));
      },
      hideForgotPasswordButton: true,
      onRecoverPassword: (name) {
        return null;
      },
    );
  }
}
