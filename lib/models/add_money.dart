
import 'package:cloud_firestore/cloud_firestore.dart';

const String tableMemberColId = 'id';
const String tableMemberColName = 'name';
const String tableMemberColAmount = 'amount';
const String tableMemberColDate = 'date';

class AddMoney {
  String? id;
  final String name;
  final Timestamp date;
  final double amount;

  AddMoney(
      {this.id, required this.name, required this.date, required this.amount});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableMemberColId: id,
      tableMemberColName: name,
      tableMemberColAmount: amount,
      tableMemberColDate: date,
    };

    return map;
  }

  factory AddMoney.fromMap(Map<String, dynamic> map) =>
      AddMoney(
          id: map[tableMemberColId],
          name: map[tableMemberColName],
          amount: map[tableMemberColAmount],
          date: map[tableMemberColDate]
      );

}