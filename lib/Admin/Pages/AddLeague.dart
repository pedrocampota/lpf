//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpf/Modal/League.dart';

//Modal Objects
import 'package:lpf/Modal/League.dart';

class AddLeague extends StatefulWidget {
  const AddLeague({super.key});

  @override
  State<AddLeague> createState() => _AddLeagueState();
}

class _AddLeagueState extends State<AddLeague> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text(
            'Adicionar Liga',
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
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: ListView(padding: EdgeInsets.all(10), children: [
            Container(
              child: Column(
                children: [
                  Text('Informações Gerais'),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Nome'),
                    controller: nameController,
                  ),
                ],
              ),
            ),
          ]))
        ])),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
            label: const Text('Adicionar',
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            icon: const Icon(
                color: Color(0xFFFFFFFF), size: 26, Iconsax.add_circle),
            onPressed: () {
              final name = nameController.text;

              createLeague(name: name);
              Navigator.pop(context);
              showToastMessage('Liga criada com sucesso.');
            }),
      );

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12,
        gravity: ToastGravity.CENTER);
  }

  //This function is responsible to create new leagues
  Future createLeague({required String name}) async {
    //Reference document to create new league
    final docLeague = FirebaseFirestore.instance.collection('leagues').doc();

    final league = League(id: docLeague.id, name: name);
    final json = league.toJson();

    //Create document and write data to Firebase
    await docLeague.set(json);
  }
}
