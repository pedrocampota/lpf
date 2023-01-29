import 'package:firebase_auth/firebase_auth.dart';

class Player {
  String id;
  final String name;
  final String age;
  final String clubId;
  final String passportNumber;
  final String position;
  final String number;
  final String contractDays;
  final bool antidoping;
  final String antidopingDays;

  Player(
      {this.id = '',
      required this.name,
      required this.age,
      required this.clubId,
      required this.passportNumber,
      this.position = '',
      this.number = '',
      required this.contractDays,
      required this.antidoping,
      required this.antidopingDays});

  //Map to set
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'clubId': clubId,
        'passportNumber': passportNumber,
        'position': position,
        'number': number,
        'contractDays': contractDays,
        'antidoping': antidoping,
        'antidopingDays': antidopingDays
      };

  //Map to get
  static Player fromJson(Map<String, dynamic> json) => Player(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      clubId: json['clubId'],
      passportNumber: json['passportNumber'],
      position: json['position'],
      number: json['number'],
      contractDays: json['contractDays'],
      antidoping: json['antidoping'],
      antidopingDays: json['antidopingDays']);
}
