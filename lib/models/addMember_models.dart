// ignore_for_file: unused_element


const String tableMemberColId = 'id';
const String tableMemberColName = 'name';
const String tableMemberColEmail = 'email';
const String tableMemberColDate = 'date';

class AddMemberModel {
  String? id;
  final String name;
  final String email;
  final String date;

  AddMemberModel({
    this.id,
    required this.name,
    required this.email,
    required this.date
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tableMemberColId:id,
      tableMemberColName: name,
      tableMemberColEmail: email,
      tableMemberColDate: date,
    };

    return map;
  }

  factory AddMemberModel.fromMap(Map<String, dynamic> map) => AddMemberModel(
        id: map[tableMemberColId],
        name: map[tableMemberColName],
        email: map[tableMemberColEmail],
        date: map[tableMemberColDate],

  );

  @override
  String toString() {
    return 'AddMemberModel{id: $id, name: $name, email: $email, date: $date}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddMemberModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
