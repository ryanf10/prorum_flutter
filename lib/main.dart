import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/screens/home/category_tab_screen.dart';
import 'package:prorum_flutter/screens/welcome/welcome_screen.dart';
import 'package:prorum_flutter/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.initState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Map<int, Color> color = {
      50: Color.fromRGBO(0, 201, 201, 1.0),
      100: Color.fromRGBO(0, 186, 186, 1.0),
      200: Color.fromRGBO(0, 171, 171, 1.0),
      300: Color.fromRGBO(0, 156, 156, 1.0),
      400: Color.fromRGBO(0, 141, 141, 1.0),
      500: Color.fromRGBO(0, 126, 126, 1.0),
      600: Color.fromRGBO(0, 111, 111, 1.0),
      700: Color.fromRGBO(0, 96, 96, 1.0),
      800: Color.fromRGBO(0, 81, 81, 1.0),
      900: Color.fromRGBO(0, 66, 66, 1.0),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prorum',
      // theme: ThemeData(primarySwatch: const MaterialColor(0xFF007E7E, color)),
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: const MaterialColor(0xFF007E7E, color),
      ),
      home: Session.isLoggedin
          ? const CategoryTabScreen()
          : const WelcomeScreen(),
    );
  }
}
