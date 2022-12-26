import 'package:cloud_firestore/cloud_firestore.dart';

const String tableCostingColId = 'id';
const String tableCostingColNote = 'note';
const String tableCostingColType = 'type';
const String tableCostingColAmount = 'amount';
const String tableCostingColDate = 'date';


class AddCosting{
  String? id;
  final String note;
  final String type;
  final Timestamp date;
  final double amount;

  AddCosting({
    this.id,
   required this.note,
   required this.type,
   required this.date,
   required this.amount});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableCostingColId: id,
      tableCostingColNote: note,
      tableCostingColType: type,
      tableCostingColDate: date,
      tableCostingColAmount:amount
    };

    return map;
  }

  factory AddCosting.fromMap(Map<String, dynamic> map) =>
      AddCosting(
          id: map[tableCostingColId],
          note: map[tableCostingColNote],
          type: map[tableCostingColType],
          amount: map[tableCostingColAmount],
          date: map[tableCostingColDate]
      );

  @override
  String toString() {
    return 'AddCosting{id: $id, note: $note, type: $type, date: $date, amount: $amount}';
  }
}