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

  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

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
            'http://api.football-data.org/v4/competitions/${widget.code}/standings/?season=2022&matchday=34'),
        headers: {'X-Auth-Token': '6a21f4ec793b42d5b2b4d2a005e47dc0'});
    String body = response.body;
    Map data = jsonDecode(body);
    List table = data['standings'][0]['table'];
    setState(() {
      _table = table;
    });
  }

  Future refresh() async {
    //Removing items before every request
    //setState(() => items.clear());

    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v4/competitions/${widget.code}/standings/?season=2022&matchday=${controller.text}'),
        headers: {'X-Auth-Token': '6a21f4ec793b42d5b2b4d2a005e47dc0'});
    String body = response.body;
    Map data = jsonDecode(body);
    List table = data['standings'][0]['table'];
    setState(() {
      _table = table;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: Color.fromARGB(255, 33, 91, 171),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Pos',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Clube',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
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
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'V',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'E',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'D',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'GM',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'GS',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'DG',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Pts',
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    buildTable(),
                  ],
                ),
              ),
            )
          ],
        ),
      ));

  Widget buildTable() {
    List<Widget> teams = [];
    for (var team in _table ?? []) {
      teams.add(Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey.withOpacity(0.1)),
          )),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: team['position'].toString().length > 1
                                  ? Text(team['position'].toString() + ' º ')
                                  : Text(" " +
                                      team['position'].toString() +
                                      ' º ')),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Image.network(
                                team['team']['crest'],
                                height: 20,
                                width: 20,
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 5,
                                bottom: 0,
                                right: 0,
                                top: 0), //apply padding to some sides only
                            child: team['team']['shortName'].toString().length >
                                    11
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
          )));
    }
    return teams.length != 0
        ? Column(children: teams)
        : teams.length == 0
            ? Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              )
            : Center(
                child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 100, bottom: 100),
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 193, 216, 255)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('media/images/no_internet.gif',
                          height: 200, width: 200),
                      Text('Oops!',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                      Text(
                          'Não foi possivel realizar a conexão,\n com o servidor.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300))
                    ],
                  ),
                )
              ]));
    ;
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
    refresh();

    Navigator.of(context).pop(controller.text);
  }
}
