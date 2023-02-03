//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lpf/Admin/Pages/EditPlayer.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class ManagePlayer extends StatefulWidget {
  const ManagePlayer({super.key});

  @override
  State<ManagePlayer> createState() => _ManagePlayerState();
}

class _ManagePlayerState extends State<ManagePlayer> {
  Color mainColor = Color.fromARGB(255, 18, 18, 18);

  late TextEditingController numDaysController;

  @override
  void initState() {
    super.initState();
    //getTable();
    numDaysController = TextEditingController();
  }

  @override
  void dispose() {
    numDaysController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'Gerir Jogadores',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        leading: IconButton(
            icon: const Icon(Iconsax.backward),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [],
      ),
      body: Container(
        color: Colors.grey.shade100,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ColoredBox(
                color: Color.fromARGB(255, 33, 91, 171),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Área de Gestão de Jogadores',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    )),
              ),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("players")
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.length == 0) {
                    return Expanded(
                        child: Center(
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Não existem exames de jogadores para o periodo calculado.",
                                textAlign: TextAlign.center,
                              )
                            ]),
                      ),
                    ));
                  }

                  final data = snapshot.data!.docs;
                  final groups = groupBy(data, (element) => element["teamId"]);

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final key = groups.keys.elementAt(index);
                      final group = groups[key];

                      return Container(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ExpansionTile(
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              collapsedBackgroundColor: Colors.white,
                              collapsedTextColor: Colors.black,
                              tilePadding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 10, right: 10),
                              backgroundColor: Colors.white,
                              title: FutureBuilder<String>(
                                future: getPlayerTeamName(key),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.length == 0) {
                                      return Text("Sem resultados");
                                    } else {
                                      return Text(
                                        '${snapshot.data} (${group!.length})',
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text('Erro: ${snapshot.error}');
                                  } else {
                                    return Text('${group!.length}');
                                  }
                                },
                              ),
                              children: group!
                                  .where((e) => e["teamId"] == e["teamId"])
                                  .map(
                                    (e) => GestureDetector(
                                      child: Container(
                                        width: double.infinity,
                                        child: Card(
                                          shadowColor:
                                              Color.fromARGB(46, 255, 255, 255),
                                          color: Colors.grey.shade50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0.5,
                                          margin: EdgeInsets.all(10),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 80,
                                                        child: CircleAvatar(
                                                          radius:
                                                              50, // Image radius
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://i.pravatar.cc/300'),
                                                        )),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e["name"],
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SafeArea(
                                                            child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Posição ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${e['position']}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              ', ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${e['age']}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' anos ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Icon(
                                                            color: mainColor,
                                                            size: 26,
                                                            Iconsax.edit)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditPlayer(
                                                  playerId: e["id"],
                                                  playerName: e["name"]),
                                            ));
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ));
                    },
                  );
                },
              ),
            ))
          ],
        ),
      ));

  //Agrupar os dados de acordo com o teamId
  Map<T, List<E>> groupBy<E, T>(List<E> list, T Function(E element) groupBy) {
    final groupedMap = <T, List<E>>{};

    for (E element in list) {
      final key = groupBy(element);
      (groupedMap[key] ??= []).add(element);
    }

    return groupedMap;
  }

  //Obter o nome da equipa em que o jogador está ativo
  Future<String> getPlayerTeamName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  // Formatar data para a desejada
  getFormatedDate(DateTime date) {
    var initialDate = DateTime.parse(date.toString());
    return DateFormat('dd/MM/yyyy').format(initialDate);
  }
}
