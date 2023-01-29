//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/League.dart';

class EditLeague extends StatefulWidget {
  const EditLeague({super.key});

  @override
  State<EditLeague> createState() => _EditLeagueState();
}

class _EditLeagueState extends State<EditLeague> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'Editar Liga',
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
      body: StreamBuilder<List<League>>(
          stream: listLeagues(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final leagues = snapshot.data!;

              return ListView(
                children: leagues.map(buildLeague).toList(),
              );
            } else {
              return Center(child: Text('Sem ligas para mostrar'));
            }
          }));

  //Function to list leagues
  Stream<List<League>> listLeagues() => FirebaseFirestore.instance
      .collection('leagues')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => League.fromJson(doc.data())).toList());

  Widget buildLeague(League league) => Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                league.name,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          ],
        ),
      );
}
