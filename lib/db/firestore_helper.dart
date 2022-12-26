import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mess_manager/models/addMember_models.dart';
import 'package:mess_manager/models/add_costing.dart';
import 'package:mess_manager/models/add_meals.dart';
import 'package:mess_manager/models/add_money.dart';

class FireStoreHelper {
  static const String _collectionMembers='Members';
  static const String _collectionMeals='Meals';
  static const String _collectionCosting='Costing';
  static const String _collectionMoney='MoneyInfo';


  static FirebaseFirestore _db=FirebaseFirestore.instance;
  static FirebaseAuth _auth=FirebaseAuth.instance;

  static Future<bool> checkMembers(String email) async{

   final snapshot=await _db.collection(_collectionMembers).where('email',isEqualTo: email).get();
   if(snapshot.docs.length>0){
     return true;
   }
   else return false;
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMembers()=>_db.collection(_collectionMembers).snapshots();


  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMembersMoneyInfo()=>_db.collection(_collectionMoney).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllMembersMealInfo()=>_db.collection(_collectionMeals).snapshots();

  static Future<void> addNewMember(AddMemberModel addMemberModel)async{

    final docRef= _db.collection(_collectionMembers).doc();
    addMemberModel.id=docRef.id;
    return docRef.set(addMemberModel.toMap());
  }


  static Future<void> addMemberMeals(AddMemberMeals memberMeals)async{

    final docRef= _db.collection(_collectionMeals).doc();
    memberMeals.id=docRef.id;
    return docRef.set(memberMeals.toMap());
  }


  static Future<void> addMemberMoney(AddMoney money)async{

    final docRef= _db.collection(_collectionMoney).doc();
    money.id=docRef.id;
    return docRef.set(money.toMap());
  }



  static Future<void> addMessCosting(AddCosting costing)async{

    final docRef= _db.collection(_collectionCosting).doc();
    costing.id=docRef.id;
    return docRef.set(costing.toMap());
  }

}