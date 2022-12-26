import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/addMember_models.dart';
import '../providers/member_provider.dart';
import '../utils/custom_colors.dart';

class AddMemberPage extends StatefulWidget {
  static const routeName = '/add-member';

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final _formKey=GlobalKey<FormState>();

  int? mId;

  late MemberProvider provider;

  @override
  void didChangeDependencies() {

    provider=Provider.of<MemberProvider>(context,listen: false);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    // getId(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
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
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: CustomColors.appColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.person,color: Colors.redAccent,size: 50,),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Add New Member',
                    style: TextStyle(
                      color: CustomColors.appColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    cursorColor: CustomColors.appColor,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: CustomColors.appColor,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: CustomColors.appColor,
                      ),
                      hintText: "Enter Member's Name",
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Required';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    cursorColor: CustomColors.appColor,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: CustomColors.appColor,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: CustomColors.appColor,
                      ),
                      hintText: "Member's Email Address(valid)",
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Required';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      if(_formKey.currentState!.validate()){
                        saveAddMember(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CustomColors.appColor,
                      ),
                      child: const Center(
                        child: Text(
                          'Add In Your Mess',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // getId(BuildContext context) async{
  void saveAddMember(BuildContext context) async{
    var member = AddMemberModel(
      name: nameController.text,
      email: emailController.text,
      date: DateTime.now().toString()
    );
    EasyLoading.show();
    provider.insertMembers(member).then((value) {
      EasyLoading.dismiss();
      Navigator.pop(context);
    });

  }
}