import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mess_manager/models/addMember_models.dart';
import 'package:mess_manager/models/add_costing.dart';
import 'package:mess_manager/models/add_meals.dart';
import 'package:mess_manager/models/add_money.dart';

import '../db/firestore_helper.dart';

class MemberProvider extends ChangeNotifier {

  List<String> memberList=[];
  double totalMoney=0.0;
  String? memberName;
  List<AddMemberModel> memberListInfo=[];
  List<AddMoney> memberMoneyInfoList=[];
  List<double> total=[];
  List<AddMemberMeals> memberMealInfoList=[];
  late bool callOnce=true;


  Future<bool> checkMembers(String email)=>FireStoreHelper.checkMembers(email);

  Future<void> insertMembers(AddMemberModel memberModel)=>FireStoreHelper.addNewMember(memberModel);

  Future<void> getAllMembers() async{
    FireStoreHelper.getAllMembers().listen((event) {
      memberList=List.generate(event.docs.length, (index) => event.docs[index].data()['name']);
      memberListInfo=List.generate(event.docs.length, (index) => AddMemberModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
  String loginMemberName(){
    List<AddMemberModel> member=[];
    memberListInfo.forEach((element) {
      if(element.email==FirebaseAuth.instance.currentUser!.email){
        member.add(element);
      }
    });
    memberName=member.first.name;
    return member.first.name;
  }



  Future<void> insertMembersMoney(AddMoney money)=>
      FireStoreHelper.addMemberMoney(money);



  Future<void> addMessCosting(AddCosting costing)=>
      FireStoreHelper.addMessCosting(costing);

  Future<void> getAllMembersMoneyInfo() async{
    FireStoreHelper.getAllMembersMoneyInfo().listen((event) {
      memberMoneyInfoList=List.generate(event.docs.length, (index) => AddMoney.fromMap(event.docs[index].data()));
      notifyListeners();
     if(callOnce){
       total=List.generate(event.docs.length, (index) => event.docs[index].data()['amount']);
       total.forEach((element) {
         totalMoney+=element;
       });
       callOnce=false;
     }
    });

  }

  Future<void> getAllMembersMealInfo() async{
    FireStoreHelper.getAllMembersMealInfo().listen((event) {
      memberMealInfoList=List.generate(event.docs.length, (index) => AddMemberMeals.fromMap(event.docs[index].data()));

      notifyListeners();
    });
  }

}