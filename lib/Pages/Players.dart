//Libraries
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/Screens/TableScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Widgets
import 'package:lpf/Widgets/LeagueContainer.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

import '../Modal/Team.dart';

class Players extends StatelessWidget {
  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: Color.fromARGB(255, 33, 91, 171),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Jogadores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )),
              ),
            ),
            Expanded(
                child: StreamBuilder<List<Player>>(
                    stream: listPlayers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final players = snapshot.data!;

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          children: players.map(buildPlayers).toList(),
                        );
                      } else {
                        return Center(
                            child: Text('Não existem jogadores registados.'));
                      }
                    }))
          ],
        ),
      ));

  //Obter a listagem de jogadores
  Stream<List<Player>> listPlayers() => FirebaseFirestore.instance
      .collection('players')
      .orderBy('teamId')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Player.fromJson(doc.data())).toList());

  //Obter o nome da equipa em que o jogador está ativo
  Future<String> getPlayerTeamName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  Widget buildPlayers(Player player) => Card(
        shadowColor: Colors.white,
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 80,
                      child: CircleAvatar(
                        radius: 50, // Image radius
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      )),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      FutureBuilder<String>(
                        future: getPlayerTeamName(player.teamId),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ); //!TODO
                          } else if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Idade: ${player.age}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Posição: ${player.position}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );

  void showToastMessage(String leagueName) {
    Fluttertoast.showToast(
        msg: "A " + leagueName + " estará disponivel.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12,
        gravity: ToastGravity.CENTER);
  }
}
