//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';
import 'package:lpf/main.dart';

class ExpiringContracts extends StatefulWidget {
  const ExpiringContracts({super.key});

  @override
  State<ExpiringContracts> createState() => _ExpiringContractsState();
}

class _ExpiringContractsState extends State<ExpiringContracts> {
  Color mainColor = Color.fromARGB(255, 18, 18, 18);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(
            'Contratos a Expirar',
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("players")
              .orderBy('contractExpiringDate',
                  descending:
                      false) // a obter de forma que mostre primeiro os jogados que estão com menos tempo restante de contrato
              .where('contractExpiringDate', isLessThan: getSixMonthsInFutureDate())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data!.docs;
            final groups = groupBy(data, (element) => element["teamId"]);

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final key = groups.keys.elementAt(index);
                final group = groups[key];

                return ExpansionTile(
                  iconColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  collapsedBackgroundColor: Colors.white,
                  collapsedTextColor: Colors.black,
                  tilePadding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                  backgroundColor: Colors.white,
                  title: FutureBuilder<String>(
                    future: getPlayerTeamName(key),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data} (${group!.length})',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        );
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              radius: 50, // Image radius
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
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Assinou em: " +
                                                  getFormatedDate(
                                                      DateTime.parse(
                                                          e["contractDate"])),
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(7),
                                              child: Text(
                                                getDaysMonthsRemainingOfContact(
                                                    DateTime.parse(e[
                                                        'contractExpiringDate'])),
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 14),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: showContractExpiringWarning(
                                                    DateTime.parse(e[
                                                        'contractExpiringDate'])),
                                              ),
                                            ),
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

  //Obter o nome da equipa em que o jogador está ativo
  Future<String> getPlayerTeamName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  // Função usada para pegar na data atual e obter a data de 180 dias (6 meses) para a frente
  String getSixMonthsInFutureDate() {
    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = now.add(Duration(days: 180));
    return DateFormat('yyyy-MM-dd').format(sixMonthsAgo);
  }

  // Função para obter os dias/meses restantes
  String getDaysMonthsRemainingOfContact(DateTime date) {
    Duration difference = date.difference(DateTime.now());
    int months = (difference.inDays / 30).floor();
    int days = difference.inDays - (months * 30);
    String monthString = 'meses';
    String dayString = 'dias';

    if (months == 1) {
      monthString = 'mês';
    }
    if (days == 1) {
      dayString = 'dia';
    }
    if (months == 6 && days == 0) {
      return 'A expirar em $months $monthString';
    }
    if (months == 0) {
      return 'A expirar em $days $dayString';
    }
    if (months == 0 && days == 0) {
      return 'Expirado';
    } else {
      return 'A expirar em $months $monthString e $days $dayString';
    }
  }

  // Função para obter os dias/meses restantes
  showContractExpiringWarning(DateTime date) {
    Duration difference = date.difference(DateTime.now());
    int months = (difference.inDays / 30).floor();
    int days = difference.inDays - (months * 30);

    if (months < 1) {
      return Colors.red.shade300;
    }
    if (months > 3) {
      return Colors.yellow.shade300;
    }
    if (months <= 3 || months > 1) {
      return Colors.orange.shade300;
    }
  }

  // Formatar data para a desejada
  getFormatedDate(DateTime date) {
    var initialDate = DateTime.parse(date.toString());
    return DateFormat('dd/MM/yyyy').format(initialDate);
  }
}
