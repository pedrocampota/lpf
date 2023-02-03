//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class AntidopingControl extends StatefulWidget {
  const AntidopingControl({super.key});

  @override
  State<AntidopingControl> createState() => _AntidopingControlState();
}

class _AntidopingControlState extends State<AntidopingControl> {
  Color mainColor = Color.fromARGB(255, 18, 18, 18);

  late TextEditingController numDaysController;
  String numDays = '15';

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
            'Controlo Antidoping',
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
                        children: [
                          Text(
                            'A mostrar resultados superiores a:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${numDays} dias',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
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
                      .orderBy('antidopingDate',
                          descending:
                              false) // a obter de forma que mostre primeiro os jogados que estão com menos tempo restante de contrato
                      .where('antidopingDate',
                          isLessThanOrEqualTo: getDateDaysBeforeNow(numDays))
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
                    final groups =
                        groupBy(data, (element) => element["teamId"]);

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final key = groups.keys.elementAt(index);
                        final group = groups[key];

                        return ExpansionTile(
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
                                  // Aqui você pode trabalhar com os dados do snapshot
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
                              .map((e) => Container(
                                    width: double.infinity,
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0.7,
                                      margin: EdgeInsets.all(10),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width: 80,
                                                    child: CircleAvatar(
                                                      radius:
                                                          50, // Image radius
                                                      backgroundImage: NetworkImage(
                                                          'https://i.pravatar.cc/300'),
                                                    )),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e["name"],
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SafeArea(
                                                        child: Row(
                                                      children: [
                                                        Text(
                                                          "Data do último exame feito:",
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          getFormatedDate(
                                                              DateTime.parse(e[
                                                                  "antidopingDate"])),
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    );
                  },
                ),
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          label: const Text('Filtrar',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
          icon: const Icon(color: Color(0xFFFFFFFF), size: 26, Iconsax.filter),
          onPressed: () async {
            final numDays = await openDialogFilter();
            if (numDays == null || numDays.isEmpty) return;
            setState(() => this.numDays = numDays);
          },
        ),
      );

  //Agrupar os dados de acordo com o teamId
  Map<T, List<E>> groupBy<E, T>(List<E> list, T Function(E element) groupBy) {
    final groupedMap = <T, List<E>>{};

    for (E element in list) {
      final key = groupBy(element);
      (groupedMap[key] ??= []).add(element);
    }

    return groupedMap;
  }

  void _updateNumDays(int newNumDays) {
    setState(() {
      numDays = newNumDays.toString();
    });
  }

  //Obter o nome da equipa em que o jogador está ativo
  Future<String> getPlayerTeamName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  // Abrir caixa de diálogo para inserir o número de de dias
  Future<String?> openDialogFilter() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.all(20),
            title: Text(
              'Filtrar Exames',
              style: TextStyle(
                  color: Color.fromARGB(255, 6, 82, 187),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Número de dias'),
              controller: numDaysController,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(child: Text('Resetar'), onPressed: reset),
                  TextButton(child: Text('Submeter'), onPressed: submit)
                ],
              )
            ],
          ));

//Faz reset a pesquisa
  void reset() {
    _updateNumDays(int.parse('15'));
    numDaysController.text = '15';
    Navigator.of(context).pop(numDaysController.text);
  }

  //Submete a pesquisa
  void submit() {
    _updateNumDays(int.parse(numDaysController.text));

    Navigator.of(context).pop(numDaysController.text);
  }

  //Obter data x dias antes
  String getDateDaysBeforeNow(String numberDays) {
    DateTime date =
        DateTime.now().subtract(Duration(days: int.parse(numberDays)));
    return DateFormat("yyyy-MM-dd").format(date);
  }

  // Formatar data para a desejada
  getFormatedDate(DateTime date) {
    var initialDate = DateTime.parse(date.toString());
    return DateFormat('dd/MM/yyyy').format(initialDate);
  }
}
