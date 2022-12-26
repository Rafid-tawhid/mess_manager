import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mess_manager/pages/add_costing_page.dart';
import 'package:mess_manager/pages/add_meals_page.dart';
import 'package:mess_manager/pages/add_money_page.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:mess_manager/pages/launcher_page.dart';
import 'package:mess_manager/pages/login_page.dart';
import 'package:mess_manager/pages/register_page.dart';
import 'package:mess_manager/providers/meals_provider.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:mess_manager/utils/custom_colors.dart';
import 'package:provider/provider.dart';

import 'pages/add_member_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          primarySwatch: buildMaterialColor(CustomColors.appColor),
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName:(context)=>LauncherPage(),
          LoginPage.routeName:(context)=>LoginPage(),
          DashboardPage.routeName:(context)=>DashboardPage(),
          AddMemberPage.routeName:(context)=>AddMemberPage(),
          AddMealPage.routeName:(context)=>AddMealPage(),
          RegisterPage.routeName:(context)=>RegisterPage(),
          AddMembersMoney.routeName:(context)=>AddMembersMoney(),
          AddCostsPage.routeName:(context)=>AddCostsPage(),
        },

      ),
      providers: [
        ChangeNotifierProvider(create: (context)=>MemberProvider()),
        ChangeNotifierProvider(create: (context)=>MembersMealProvider())
      ],
    );
  }


















  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}


