import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mess_manager/auth/firebase_auth_service.dart';
import 'package:mess_manager/models/add_meals.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:mess_manager/providers/meals_provider.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/custom_colors.dart';

class AddMealPage extends StatefulWidget {
  static const routeName = '/addMeal-page';

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  String? member;
  String? meal;
  String? number;

  late MemberProvider provider;
  late MembersMealProvider mealProvider;

  @override
  void didChangeDependencies() {
    provider=Provider.of<MemberProvider>(context,listen: true);
    mealProvider=Provider.of<MembersMealProvider>(context,listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Add Members Meal'),
      ),

      body: ListView(

        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Member Name'),
                Container(
                    child: Text(DateFormat('dd-MMM-yyyy').format(DateTime.now()),style: TextStyle(fontWeight: FontWeight.bold),)
                )
              ],
            ),
          ),
          Text(provider.memberName!),
          // FutureBuilder(
          //   future: provider.loginMemberName(FirebaseAuth.instance.currentUser!.email!),
          //   builder: (context,snapshot){
          //     if(snapshot.hasData)
          //       {
          //         return Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Text(snapshot.data!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          //         );
          //       }
          //     else {
          //      return Center(child: CircularProgressIndicator());
          //     }
          //   },
          //
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
                hint: Text('Select Meals'),
                items: meals.map((meal) =>
                    DropdownMenuItem(
                      child: Text(meal),
                      value: meal,
                    )).toList(),
                onChanged: (value){
                  setState(() {
                    meal=value;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
                hint: Text('No of Meals'),
                items: mealsNumber.map((name) =>
                    DropdownMenuItem(
                      child: Text(name),
                      value: name,
                    )).toList(),
                onChanged: (value){
                  setState(() {
                    number=value;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(onPressed: (){
              EasyLoading.show();
              final meals=AddMemberMeals(
                  name: provider.memberName!,
                  date: Timestamp.fromDate(DateTime.now()),
                  type: meal!,
                  number: int.parse(number!));
              mealProvider.insertMemberMeals(meals).then((value) {
                EasyLoading.dismiss();
                Navigator.pushReplacementNamed(context, DashboardPage.routeName);
              });
            }, child: Text('Add Meals')),
          )
        ],
      )
    );
  }
}