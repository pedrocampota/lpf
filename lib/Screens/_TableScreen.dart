import 'dart:convert';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
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

  late TextEditingController controller;
  String numJornada = '';

  @override
  void initState() {
    super.initState();
    getTable();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // Sync table with api request data
  getTable() async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v4/competitions/${widget.code}/standings/?season=2022&matchday=35'),
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
                          team['team']['crest'],
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
  Widget build(BuildContext context) {
    return _table == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 6, 82, 187),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 2, 19, 84),
              title: Text(
                widget.leagueName,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ),
              leading: IconButton(
                  icon: const Icon(Iconsax.backward),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.filter),
                  color: Colors.white,
                  onPressed: () async {
                    final numJornada = await openDialogFilter();
                    if (numJornada == null || numJornada.isEmpty) return;
                    setState(() => this.numJornada = numJornada);
                    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => super.widget));
                  },
                )
              ],
            ),
            body: Container(
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

  Future<String?> openDialogFilter() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.all(20),
            title: Text(
              'Filtrar',
              style: TextStyle(
                  color: Color.fromARGB(255, 6, 82, 187),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Número da Jornada'),
              controller: controller,
            ),
            actions: [TextButton(child: Text('Submeter'), onPressed: submit)],
          ));

  void submit() {
    Navigator.of(context).pop(controller.text);
  }
}
