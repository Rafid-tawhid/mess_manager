import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mess_manager/auth/firebase_auth_service.dart';
import 'package:mess_manager/models/add_money.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:provider/provider.dart';

import '../utils/custom_colors.dart';

class AddMembersMoney extends StatefulWidget {
  const AddMembersMoney({Key? key}) : super(key: key);
  static const String routeName='/money';

  @override
  State<AddMembersMoney> createState() => _AddMembersMoneyState();
}

class _AddMembersMoneyState extends State<AddMembersMoney> {
  String? _dob;
  String? _name;
  DateTime? _selectedDate;
  double _amount=0.0;
  final _amountCon=TextEditingController();
  late MemberProvider provider;

  @override
  void didChangeDependencies() {
    provider=Provider.of(context,listen: false);
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Add Members Deposit'),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add Members Money',
                style: TextStyle(
                  color: CustomColors.appColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 35),
              InkWell(
                onTap: () {
                  _selectDate();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColors.appColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 110),
                      Text(_dob==null?'No Date Chosen':_dob!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _amountCon,
                cursorColor: CustomColors.appColor,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: CustomColors.appColor,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 20),
                  focusColor: Colors.white,
                  hintText: "Enter Deposit Amount",
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1,color: Colors.red),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Select Members Who Will Deposit',
              ),
              SizedBox(height: 15),
              Consumer<MemberProvider>(
                builder: (context,provider,_)=>
                    DropdownButtonFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    enabledBorder: OutlineInputBorder( //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder( //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  hint: Text('Select Member'),
                  value: _name,
                  onChanged: (value){
                    _name=value;
                  },
                  items: provider.memberList.map((members) =>
                      DropdownMenuItem(
                        child: Text(members),
                        value: members,
                      )
                  ).toList(),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: (){
                  if(_dob==null||_name==null||_selectedDate==null){
                    ArtSweetAlert.show(
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                            type: ArtSweetAlertType.warning,
                            title: "Select All Field",
                            text: "Show a success message with an icon"
                        )
                    );
                  }
                  else {
                    _addMoneyPage();
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
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _selectDate() async {
    _selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if(_selectedDate!=null){
      setState((){
        _dob=DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  void _addMoneyPage() {
    EasyLoading.show();
    final moneyModel=AddMoney(
        name: _name!,
        email: FirebaseAuthService?.currentUser!.email!,
        date: Timestamp.fromDate(_selectedDate!)!,
        amount: double.parse(_amountCon.text));
    provider.insertMembersMoney(moneyModel).then((value) {
      EasyLoading.dismiss();
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    });
  }
}
