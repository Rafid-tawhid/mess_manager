import 'package:flutter/material.dart';
import 'package:mess_manager/models/addMember_models.dart';

import '../db/firestore_helper.dart';
import '../models/add_meals.dart';

class MembersMealProvider extends ChangeNotifier{
  List<AddMemberMeals> memberMealNumberList=[];
  double sumofMeals=0.0;
  bool callOnce=true;

  Future<void> insertMemberMeals(AddMemberMeals memberMeals)=>
      FireStoreHelper.addMemberMeals(memberMeals);

  Future<void> getTotalMealsByName(String name) async{
    FireStoreHelper.getTotalMealsByName(name).listen((event) {
      memberMealNumberList=List.generate(event.docs.length, (index) => AddMemberMeals.fromMap(event.docs[index].data()));

      if(callOnce){
        memberMealNumberList.forEach((element) {
          sumofMeals = sumofMeals + element.number;
        });
      }
      callOnce=false;
      notifyListeners();
    });
  }

}