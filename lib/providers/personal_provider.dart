import 'package:flutter/foundation.dart';
import 'package:mess_manager/db/firestore_helper.dart';
import 'package:mess_manager/pages/add_money_page.dart';

import '../models/add_money.dart';

class PersonalInfoProvider extends ChangeNotifier {

  List<AddMoney> personalMoneyInfoList=[];

  Future<List<AddMoney>> getMyMoneyInfo() async {
   await FireStoreHelper.getMyMoneyInfo().listen((event) {
      personalMoneyInfoList=List.generate(event.docs.length, (index) => AddMoney.fromMap(event.docs[index].data()));
    });
   print('personalMoneyInfoList ${personalMoneyInfoList.length}');
   return personalMoneyInfoList;
  }
}