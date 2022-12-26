
import 'package:cloud_firestore/cloud_firestore.dart';

const String tableMemberColId = 'id';
const String tableMemberColName = 'name';
const String tableMemberColType = 'type';
const String tableMemberColNumber = 'number';
const String tableMemberColDate = 'date';

class AddMemberMeals {
  String? id;
  final String name;
  final Timestamp date;
  final String type;
  final int number;


  AddMemberMeals(
      {this.id, required this.name, required this.date, required this.type, required this.number});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableMemberColId: id,
      tableMemberColName: name,
      tableMemberColType: type,
      tableMemberColNumber: number,
      tableMemberColDate: date,
    };

    return map;
  }

  factory AddMemberMeals.fromMap(Map<String, dynamic> map) =>
      AddMemberMeals(
          id: map[tableMemberColId],
          name: map[tableMemberColName],
          type: map[tableMemberColType],
          number: map[tableMemberColNumber],
          date: map[tableMemberColDate]
      );

}