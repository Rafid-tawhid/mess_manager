import 'package:flutter/material.dart';

import '../db/firestore_helper.dart';
import '../models/add_meals.dart';

class MembersMealProvider extends ChangeNotifier{
  Future<void> insertMemberMeals(AddMemberMeals memberMeals)=>
      FireStoreHelper.addMemberMeals(memberMeals);
}