//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class ExpiringContracts extends StatefulWidget {
  const ExpiringContracts({super.key});

  @override
  State<ExpiringContracts> createState() => _ExpiringContractsState();
}

class _ExpiringContractsState extends State<ExpiringContracts> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
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
      body: StreamBuilder<List<Player>>(
          stream: listPlayers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final players = snapshot.data!;

              return ListView(
                children: players.map(buildPlayers).toList(),
              );
            } else {
              return Center(child: Text('Não existem jogadores registados.'));
            }
          }));

  //Function to list players
  Stream<List<Player>> listPlayers() => FirebaseFirestore.instance
      .collection('players')
      .orderBy('contractDate') //verificar esta condição
      .where('contractDate', isGreaterThanOrEqualTo: getSixMonthsAgoDate())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Player.fromJson(doc.data())).toList());

  Widget buildPlayers(Player player) => Container(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  player.name,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )),
            Text(
              "A expirar em " +
                  getDaysMonthsRemainingOfContact(
                      DateTime.parse(player.contractDate)),
              style: TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      );

  // Função usada para pegar na data atual e obter a data de 180 dias (6 meses) atrás
  String getSixMonthsAgoDate() {
    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = now.subtract(Duration(days: 180));
    return DateFormat('yyyy-MM-dd').format(sixMonthsAgo);
  }

  String getDaysMonthsRemainingOfContact(DateTime date) {
    Duration difference = DateTime.now().difference(date);
    int months = (difference.inDays / 30).floor();
    int days = difference.inDays - (months * 30);
    if (months == 0) {
      return '$days dias';
    } else {
      return '$months meses e $days dias';
    }
  }
}
