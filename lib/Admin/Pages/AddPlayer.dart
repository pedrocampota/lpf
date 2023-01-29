//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final positionController = TextEditingController();
  final numberController = TextEditingController();
  final antidopingController = TextEditingController();
  final antidopingDaysController = TextEditingController();
  final clubIdController = TextEditingController();
  final contractDaysController = TextEditingController();
  final passportNumberController = TextEditingController();
  bool antidopingBool = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text(
            'Adicionar Jogador',
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
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Age - Ex: 23'),
                    controller: ageController,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Passport Number - Ex: 11111'),
                    controller: passportNumberController,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Position - Ex: PL'),
                    controller: positionController,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Number - Ex: 7'),
                    controller: numberController,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Contract - Ex: 6'),
                    controller: contractDaysController,
                  ),
                  LiteRollingSwitch(
                    textOn: "Sim",
                    textOff: "Não",
                    value: true,
                    colorOn: Colors.greenAccent,
                    colorOff: Colors.redAccent,
                    iconOn: Icons.done,
                    iconOff: Icons.remove_circle_outline,
                    textSize: 16.0,
                    onChanged: (bool state) {
                      setState(() {
                        antidopingBool = state;
                      });
                    },
                    onDoubleTap: () {},
                    onSwipe: () {},
                    onTap: () {},
                  ),
                  TextField(
                    autofocus: false,
                    decoration:
                        InputDecoration(hintText: 'Antidoping days - Ex: 10'),
                    controller: antidopingDaysController,
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
              final age = ageController.text;
              final position = positionController.text;
              final number = numberController.text;
              final antidoping = antidopingBool;
              final antidopingDays = nameController.text;
              final clubId = '7FjvLsX3YjavXFcU8xT8'; //clubIdController.text;
              final contractDays = contractDaysController.text;
              final passportNumber = passportNumberController.text;

              createPlayer(
                  name: name,
                  age: age,
                  position: position,
                  number: number,
                  antidoping: antidoping,
                  antidopingDays: antidopingDays,
                  clubId: clubId,
                  contractDays: contractDays,
                  passportNumber: passportNumber);
              Navigator.pop(context);
              showToastMessage('Jogador criado com sucesso.');
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

  //This function is responsible to create new players
  Future createPlayer(
      {required String name,
      required String age,
      required String position,
      required String number,
      required bool antidoping,
      required String antidopingDays,
      required String clubId,
      required String contractDays,
      required String passportNumber}) async {
    //Reference document to create new player
    final docPlayer = FirebaseFirestore.instance.collection('players').doc();

    final player = Player(
        id: docPlayer.id,
        name: name,
        age: age,
        position: position,
        number: number,
        antidoping: antidoping,
        antidopingDays: antidopingDays,
        clubId: clubId,
        contractDays: contractDays,
        passportNumber: passportNumber);
    final json = player.toJson();

    //Create document and write data to Firebase
    await docPlayer.set(json);
  }
}
