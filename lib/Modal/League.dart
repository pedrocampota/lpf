import 'package:firebase_auth/firebase_auth.dart';

class League {
  String id;
  final String name;

  League({
    this.id = '',
    required this.name,
  });

  //Map to set
  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  //Map to get
  static League fromJson(Map<String, dynamic> json) =>
      League(id: json['id'], name: json['name']);
}
