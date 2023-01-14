import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class TableScreen extends StatefulWidget {
  final String code;
  final String leagueName;

  const TableScreen({Key? key, required this.code, required this.leagueName})
      : super(key: key);
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List? _table;

  getTable() async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v3/competitions/${widget.code}/standings'),
        headers: {'X-Auth-Token': '6a21f4ec793b42d5b2b4d2a005e47dc0'});
    String body = response.body;
    Map data = jsonDecode(body);
    List table = data['standings'][0]['table'];
    setState(() {
      _table = table;
    });
  }

  Widget buildTable() {
    List<Widget> teams = [];
    for (var team in _table!) {
      teams.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    team['position'].toString().length > 1
                        ? Text(team['position'].toString() + ' º ')
                        : Text(" " + team['position'].toString() + ' º '),
                    Row(
                      children: [
                        Image.network(
                          team['team']['crestUrl'],
                          height: 20,
                          width: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5,
                              bottom: 0,
                              right: 0,
                              top: 0), //apply padding to some sides only
                          child:
                              team['team']['shortName'].toString().length > 11
                                  ? Text(team['team']['shortName']
                                          .toString()
                                          .substring(0, 11) +
                                      '...')
                                  : Text(team['team']['shortName'].toString()),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //                    Text(widget.leagueName),
                    Text(team['playedGames'].toString()),
                    Text(team['won'].toString()),
                    Text(team['draw'].toString()),
                    Text(team['lost'].toString()),
                    Text(team['goalsFor'].toString()),
                    Text(team['goalsAgainst'].toString()),
                    Text(team['goalDifference'].toString()),
                    Text(team['points'].toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: teams,
    );
  }

  @override
  void initState() {
    super.initState();
    getTable();
  }

  @override
  Widget build(BuildContext context) {
    return _table == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 0, 28, 49),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              /*decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  const Color(0xffe84860),
                  const Color(0xffe70066),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),*/
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Pos',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Clube',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'V',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'E',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'D',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'GM',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'GS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'DG',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Pts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTable(),
                ],
              ),
            ),
          );
  }
}
