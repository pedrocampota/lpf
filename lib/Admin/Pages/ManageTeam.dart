//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/Team.dart';

class ManageTeam extends StatefulWidget {
  const ManageTeam({super.key});

  @override
  State<ManageTeam> createState() => _ManageTeamState();
}

class _ManageTeamState extends State<ManageTeam> {
  Color mainColor = Color.fromARGB(255, 18, 18, 18);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'Gerir Equipas',
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
                          'Área de Gestão de Equipas',
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
                stream:
                    FirebaseFirestore.instance.collection("teams").snapshots(),
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
                  final groups =
                      groupBy(data, (element) => element["leagueId"]);

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
                                  .where((e) => e["leagueId"] == e["leagueId"])
                                  .map((e) => GestureDetector(
                                        child: Container(
                                            width: double.infinity,
                                            child: Card(
                                              shadowColor: Color.fromARGB(
                                                  46, 255, 255, 255),
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0.5,
                                              margin: EdgeInsets.all(10),
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            e['name'],
                                                            style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Icon(
                                                            color: mainColor,
                                                            size: 26,
                                                            Iconsax.arrow_right)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        onTap: () {
                                          showToastMessage(
                                              'Edição disponível em breve.');
                                        },
                                      ))
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

  //Function to list teams
  Stream<List<Team>> listTeams() => FirebaseFirestore.instance
      .collection('teams')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList());

  Widget buildTeam(Team team) => GestureDetector(
        child: Container(
            width: double.infinity,
            child: Card(
              shadowColor: Color.fromARGB(46, 255, 255, 255),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0.5,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            team.name,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(color: mainColor, size: 26, Iconsax.arrow_right)
                      ],
                    ),
                  ],
                ),
              ),
            )),
        onTap: () {
          showToastMessage('Edição disponível em breve.');
        },
      );

  //Agrupar os dados de acordo com o leagueId
  Map<T, List<E>> groupBy<E, T>(List<E> list, T Function(E element) groupBy) {
    final groupedMap = <T, List<E>>{};

    for (E element in list) {
      final key = groupBy(element);
      (groupedMap[key] ??= []).add(element);
    }

    return groupedMap;
  }

  //Obter o nome da liga relacionada à equipa
  Future<String> getPlayerTeamName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('leagues')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  //Mostrar mensagem toast
  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12,
        gravity: ToastGravity.CENTER);
  }
}
