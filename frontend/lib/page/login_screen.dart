import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/dataModel/user.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/util/constants.dart';
import 'package:csi5112_frontend/util/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import 'merchant_home.dart';

// Login page
class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreentState();
}

// Login page state
class _LoginScreentState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  bool bypassLogin = false;
  bool bypassCustomer = true;
  User currentUser = User(name: "fake", password: "fake", userType: "hh",id:-1);
  
  // This is by no means secure and production ready, but since user
  // login is not in the scope of the project, it is hacked here so we
  // have a user object to use in other pages.
  late Future<List<User>> users;
  
  // login user with email and password
  Future<String?> _loginUser(LoginData data, bool isCustomer, List<User> users) {
    return Future.delayed(loginTime).then((_) {
      if (bypassLogin) {
        return null;
      }

      // if it is a customer login, veryify against the MockUsers
      if (isCustomer) {
        for (var i = 0; i < users.length; i++) {
          if(users[i].userType=="buyer"&& users[i].password==data.password && users[i].name==data.name){
            currentUser=users[i];
            return null;
          }
}

        return 'Invalid Customer';
      }
      // if it is a Merchant Login, verify against the MockMerchants
      else {
       for (var i = 0; i < users.length; i++) {
          if(users[i].userType=="merchant"&& users[i].password==data.password && users[i].name==data.name){
            currentUser=users[i];
            return null;
          }
}

        return 'Invalid Merchant';
      }

    });
  }

  // verify the signup data and create a user
  // Note: this is not a real signup, it is just for demo
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

  // checks whether the app is opened in Desktop mode
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  bool isCustomer = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context,snapshot){
       if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            }
        List<User> users = (snapshot.data as List<User>);
       return buildFlutterLogin(context,users);
    },future:users);

  }

  FlutterLogin buildFlutterLogin(BuildContext context, List<User> users) {
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
    children: bypassLogin
        ? <Widget>[
            ElevatedButton(
              child: const Text('Bypass Login'),
              onPressed: () {
                Navigator.of(context).pushReplacement(FadePageRoute(
                  builder: (context) =>
                      bypassCustomer ? MyHomePage( currentUser: currentUser) : MerchantPage(currentUser:currentUser),
                  settings: RouteSettings(
                      name: bypassCustomer ? '/home' : '/merchant'),
                ));
              },
            )
          ]
        : <Widget>[] +
            [
              Container(
                margin: const EdgeInsets.only(top: 450.0),
                child: FlutterSwitch(
                  width: 130.0,
                  height: 45.0,
                  valueFontSize: 16.0,
                  toggleSize: 20.0,
                  value: isCustomer,
                  borderRadius: 30.0,
                  padding: 15.0,
                  showOnOff: true,
                  activeText: "Customer",
                  inactiveText: "Merchant",
                  inactiveColor: Colors.blue,
                  activeColor: Colors.red,
                  activeTextFontWeight: FontWeight.bold,
                  inactiveTextFontWeight: FontWeight.bold,
                  onToggle: (val) {
                    setState(() {
                      isCustomer = val;
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
                              textStyle:
                                  Theme.of(context).textTheme.headline4,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText(
                                    'Sell your products online with'),
                                RotateAnimatedText('unbeatable reach'),
                                RotateAnimatedText('Stress-free delivery'),
                                RotateAnimatedText(
                                    'to your customer\'s doorstep 24/7, from'),
                                ColorizeAnimatedText(
                                  'House of eGro',
                                  textStyle: GoogleFonts.oswald(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
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
                  child: const SizedBox(
                    width: 280.0,
                    child: Icon(IconLogo.group_2,
                        size: 100, color: Colors.white),
                  )),
            ],
    // login page theme
    theme: LoginTheme(
      primaryColor: const Color.fromARGB(255, 20, 24, 23),
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
    userValidator: (value) {
      if (bypassLogin) {
        return null;
      }
      // validate email format
      if (!value!.contains('@') || !value.endsWith('.com')) {
        return "Email must contain '@' and end with '.com'";
      }
      return null;
    },
    passwordValidator: (value) {
      if (bypassLogin) {
        return null;
      }
      if (value!.isEmpty) {
        return 'Password is empty';
      }
      return null;
    },
    onLogin: (loginData) {
      return _loginUser(loginData, isCustomer, users);
    },
    onSignup: (signupData) {
      signupData.additionalSignupData?.forEach((key, value) {
        debugPrint('$key: $value');
      });
      if (signupData.termsOfService.isNotEmpty) {
        for (var element in signupData.termsOfService) {
          debugPrint(
              ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
        }
      }
      return _signupUser(signupData);
    },
    onSubmitAnimationCompleted: () {
      // if it is a customer, then redirect to home
      if (isCustomer) {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => MyHomePage(currentUser: currentUser),
          settings: const RouteSettings(name: '/home'),
        ));
      }
      //redirect to seller page
      else {
        debugPrint('Merchant login');
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => MerchantPage(currentUser: currentUser),
          settings: const RouteSettings(name: '/merchant'),
        ));
      }
    },
    hideForgotPasswordButton: true,
    onRecoverPassword: (name) {
      return null;
    },
  );
  }


  Future<List<User>> getUsers() async {
    final Response response= await get(Uri.parse('https://localhost:7156/api/user/'));


    if(response.statusCode == 200) {
      return User.fromListJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get Question Date from Service');
    }

  }

  @override
  void initState() {
    super.initState();
    users = getUsers();
  }

}
