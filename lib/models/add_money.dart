
import 'package:cloud_firestore/cloud_firestore.dart';

const String tableMemberColId = 'id';
const String tableMemberColName = 'name';
const String tableMemberColEmail = 'email';
const String tableMemberColAmount = 'amount';
const String tableMemberColDate = 'date';

class AddMoney {
  String? id;
  final String name;
  final String email;
  final Timestamp date;
  final double amount;

  AddMoney(
      {this.id, required this.name, required this.date, required this.amount,required this.email});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableMemberColId: id,
      tableMemberColName: name,
      tableMemberColAmount: amount,
      tableMemberColDate: date,
      tableMemberColEmail: email,
    };

    return map;
  }

  factory AddMoney.fromMap(Map<String, dynamic> map) =>
      AddMoney(
          id: map[tableMemberColId],
          name: map[tableMemberColName],
          email: map[tableMemberColEmail],
          amount: map[tableMemberColAmount],
          date: map[tableMemberColDate]
      );

}