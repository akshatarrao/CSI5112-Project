import 'package:csi5112_frontend/component/theme_data.dart';
import 'package:csi5112_frontend/page/customer_home.dart';
import 'package:csi5112_frontend/page/item_list.dart';
import 'package:csi5112_frontend/page/login_screen.dart';
import 'package:csi5112_frontend/page/merchant_home.dart';
import 'package:csi5112_frontend/util/transition_route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dataModel/user.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSI 5112',

      // Default visual properties, like colors fonts and shapes, for this app's material widgets.
      theme: ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.orange),
        textTheme: TextTheme(
          headline3: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.orange,
          ),
          button: const TextStyle(
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          headline1: const TextStyle(fontFamily: 'Quicksand'),
          headline2: const TextStyle(fontFamily: 'Quicksand'),
          headline4: const TextStyle(fontFamily: 'Quicksand'),
          headline5: const TextStyle(fontFamily: 'NotoSans'),
          headline6: const TextStyle(fontFamily: 'NotoSans'),
          subtitle1: const TextStyle(fontFamily: 'NotoSans'),
          bodyText1: const TextStyle(fontFamily: 'NotoSans'),
          bodyText2: const TextStyle(fontFamily: 'NotoSans'),
          subtitle2: const TextStyle(fontFamily: 'NotoSans'),
          overline: const TextStyle(fontFamily: 'NotoSans'),
        ),
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: CustomColors.accentColorMaterial)
            .copyWith(secondary: Colors.orange),
      ),

      //  The list of observers for the [Navigator] created for this app.
      navigatorObservers: [TransitionRouteObserver()],
      //  The name of the first route to show, if a [Navigator] is built.
      initialRoute: LoginScreen.routeName,
      // The application's top-level routing table.
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        ItemList.routeName: (context) => ItemList.getDefaultEmptyPage(User(name: "fake", password: "fake", userType: "hh",id:-1)),
        MyHomePage.routeName: (context) => MyHomePage(currentUser: User(name: "fake", password: "fake", userType: "hh",id:-1)),
        MerchantPage.routeName: (context) => MerchantPage(currentUser: User(name: "fake", password: "fake", userType: "hh",id:-1)),
      },
    );
  }
}
