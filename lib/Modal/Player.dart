import 'package:firebase_auth/firebase_auth.dart';
import 'package:lpf/Modal/Team.dart';

class Player {
  String id;
  final String name;
  final String age;
  final String passportNumber;
  final String position;
  final String number;
  final String contractDate;
  final String contractDuration;
  final String contractExpiringDate;
  final String antidopingDate;
  final bool antidoping;

  final String antidopingDays;
  final String teamId;

  Player(
      {this.id = '',
      required this.name,
      required this.age,
      required this.passportNumber,
      this.position = '',
      this.number = '',
      required this.contractDate,
      required this.contractDuration,
      required this.contractExpiringDate,
      required this.antidoping,
      required this.antidopingDate,
      required this.antidopingDays,
      required this.teamId});

  //Map to set
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'passportNumber': passportNumber,
        'position': position,
        'number': number,
        'contractDate': contractDate,
        'contractDuration': contractDuration,
        'contractExpiringDate': contractExpiringDate,
        'antidoping': antidoping,
        'antidopingDate': antidopingDate,
        'antidopingDays': antidopingDays,
        'teamId': teamId
      };

  //Map to get
  static Player fromJson(Map<String, dynamic> json) => Player(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      passportNumber: json['passportNumber'],
      position: json['position'],
      number: json['number'],
      contractDate: json['contractDate'],
      contractDuration: json['contractDuration'],
      contractExpiringDate: json['contractExpiringDate'],
      antidoping: json['antidoping'],
      antidopingDate: json['antidopingDate'],
      antidopingDays: json['antidopingDays'],
      teamId: json['teamId']);
}
