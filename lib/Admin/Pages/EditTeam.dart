//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/Team.dart';

class EditTeam extends StatefulWidget {
  const EditTeam({super.key});

  @override
  State<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'Editar Equipas',
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
      body: StreamBuilder<List<Team>>(
          stream: listTeams(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final teams = snapshot.data!;

              return ListView(
                children: teams.map(buildTeam).toList(),
              );
            } else {
              return Center(child: Text('Sem ligas para mostrar'));
            }
          }));

  //Function to list teams
  Stream<List<Team>> listTeams() => FirebaseFirestore.instance
      .collection('teams')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList());

  Widget buildTeam(Team team) => Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                team.name,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            )
          ],
        ),
      );
}
