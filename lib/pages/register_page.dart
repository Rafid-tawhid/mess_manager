import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mess_manager/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../auth/firebase_auth_service.dart';
import '../utils/custom_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String routeName='/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
                      'Registration',
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
                        hintText: "Members's Password",
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

                          await FirebaseAuthService.registerUser(email_Controller.text, password_Controller.text).then((user) async {
                           EasyLoading.dismiss();
                            Navigator.pushReplacementNamed(context, LoginPage.routeName);
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

                  ],
                ),
              ),
            )),
      ),
    );
  }
}
