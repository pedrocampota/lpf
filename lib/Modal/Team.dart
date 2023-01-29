import 'package:firebase_auth/firebase_auth.dart';

class Team {
  String id;
  final String name;
  final String leagueId;

  Team({this.id = '', required this.name, required this.leagueId});

  //Map to set
  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'leagueId': leagueId};

  //Map to get
  static Team fromJson(Map<String, dynamic> json) =>
      Team(id: json['id'], name: json['name'], leagueId: json['leagueId']);
}
