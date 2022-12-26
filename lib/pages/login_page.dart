import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mess_manager/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:mess_manager/pages/launcher_page.dart';
import 'package:mess_manager/pages/register_page.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:provider/provider.dart';
import '../utils/custom_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName='/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passObsecure = true;
  bool isLoading = false;
  String error = '';
  final _formKey=GlobalKey<FormState>();

  final email_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Form(
        key: _formKey,
        child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.person,color: Colors.red,),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Log In As Mess Member',
                      style: TextStyle(
                        color: CustomColors.appColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: email_Controller,
                      cursorColor: CustomColors.appColor,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Required';
                        }
                        else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: CustomColors.appColor, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10),
                        focusColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.email,
                          color: CustomColors.appColor,
                        ),
                        hintText: "Members's Email",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: password_Controller,
                      obscureText: passObsecure,
                      cursorColor: CustomColors.appColor,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Required';
                        }
                        else {
                          return null;
                        }
                      },
                      style: TextStyle(
                          color: CustomColors.appColor, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10),
                        focusColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: CustomColors.appColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passObsecure ? Icons.visibility : Icons.visibility_off,
                            color: CustomColors.appColor,
                          ),
                          onPressed: () {
                            setState(() {
                              passObsecure = !passObsecure;
                            });
                          },
                        ),
                        hintText: "Member's Password",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          EasyLoading.show();

                            await FirebaseAuthService.loginUser(email_Controller.text, password_Controller.text).then((user) async {
                              if(user!=null){
                                final isMember=await Provider.of<MemberProvider>(context,listen: false).checkMembers(email_Controller.text);
                                if(isMember){
                                  Navigator.pushReplacementNamed(context, LauncherPage.routeName);
                                  EasyLoading.dismiss();
                                }
                                else {
                                  EasyLoading.dismiss();
                                  setState(() {
                                    error='You Are not a Member';
                                  });
                                }
                              }
                            }
                            ).catchError((e){
                              EasyLoading.dismiss();
                              setState(() {
                                error=e.toString();
                              });
                            });


                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: CustomColors.appColor,
                        ),
                        child: Center(
                          child:
                          // isLoading ? CircularProgressIndicator(color: Colors.white,) :
                          Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 45,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 20),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Not Yet Registered? Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(RegisterPage.routeName);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
