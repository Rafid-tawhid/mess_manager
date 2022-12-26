import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_manager/auth/firebase_auth_service.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:mess_manager/pages/login_page.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key? key}) : super(key: key);
  static const String routeName='/launcher';

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(FirebaseAuthService.currentUser==null){
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
      else {
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
