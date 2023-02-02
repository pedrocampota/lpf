//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class AntidopingControl extends StatefulWidget {
  const AntidopingControl({super.key});

  @override
  State<AntidopingControl> createState() => _AntidopingControlState();
}

class _AntidopingControlState extends State<AntidopingControl> {
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
              ),
            )
          ],
        ),
      );
}
