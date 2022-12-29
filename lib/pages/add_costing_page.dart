import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mess_manager/models/add_costing.dart';
import 'package:mess_manager/pages/dashboard_page.dart';
import 'package:provider/provider.dart';

import '../providers/member_provider.dart';
import '../utils/constants.dart';
import '../utils/custom_colors.dart';

class AddCostsPage extends StatefulWidget {
  const AddCostsPage({Key? key}) : super(key: key);
  static const String routeName='/costs';

  @override
  State<AddCostsPage> createState() => _AddCostsPageState();
}

class _AddCostsPageState extends State<AddCostsPage> {

  String? type;
  String? note;
  String? _dob;
  DateTime? _selectedDate;
  final amountCon=TextEditingController();
  final noteCon=TextEditingController();

  final _fromKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Add Meal Cost Info'),
      ),
      body: Form(
        key: _fromKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Add Meal Cost',
                    style: TextStyle(
                      color: CustomColors.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Meal cost means regular bazar cost which is related to meal rate',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Amount : ',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: amountCon,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
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
                      hintText: "Enter Cost Amount",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Costing Type : ',
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                      validator: (value){
                        if(value==null){
                          return 'required';
                        }
                        else {
                          return null;
                        }
                      },
                      hint: Text('Select Costing Types'),
                      items: types.map((name) =>
                          DropdownMenuItem(
                            child: Text(name),
                            value: name,
                          )).toList(),
                      onChanged: (value){
                        setState(() {
                          type=value;
                        });
                      }),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Notes : ',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: noteCon,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    cursorColor: CustomColors.appColor,
                    style: TextStyle(
                        color: CustomColors.appColor,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 20),
                      focusColor: Colors.white,
                      hintText: "Enter Important Notes",
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

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



                  SizedBox(height: 25),
                  InkWell(
                    onTap: (){
                      if(_fromKey.currentState!.validate()){

                        if(_dob==null){
                          ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.warning,
                                  title: "Select Date",
                                  text: "Show a question message with an icon"
                              )
                          );
                        }
                        final costing=AddCosting(
                            note: noteCon.text,
                            type: type!,
                            date: Timestamp.fromDate(_selectedDate!),
                            amount: double.parse(amountCon.text));

                        EasyLoading.show();
                        Provider.of<MemberProvider>(context,listen: false).addMessCosting(costing).then((value) {
                          EasyLoading.dismiss();
                          Navigator.pushNamed(context, DashboardPage.routeName);
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
}
