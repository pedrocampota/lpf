//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpf/Widgets/TitleBar.dart';

//Modal Objects
import 'package:lpf/Modal/Team.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({super.key});

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class DropdownItem {
  final String leagueValue;
  final String leagueName;

  DropdownItem(this.leagueValue, this.leagueName);
}

class _AddTeamState extends State<AddTeam> {
  final nameController = TextEditingController();
  final leagueIdController = TextEditingController();

  final List<DropdownItem> _leagueDropdownItems = [];
  DropdownItem? _leagueSelectedItem;
  String? leagueIdValue;

  @override
  void initState() {
    super.initState();
    _getDropdownItems();
  }

  void _getDropdownItems() async {
    var firestore = FirebaseFirestore.instance;
    var snapshot = await firestore.collection('leagues').get();

    for (var document in snapshot.docs) {
      _leagueDropdownItems
          .add(DropdownItem(document.data()['id'], document.data()['name']));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text(
            'Adicionar Equipa',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleBar(
                      'Informações Necessárias', 0, Iconsax.document_text_1),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: DropdownButtonFormField<DropdownItem>(
                      isExpanded: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Escolher liga...',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 18, 18, 18))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 18, 18, 18))),
                      ),
                      value: _leagueSelectedItem,
                      items: _leagueDropdownItems.map((DropdownItem item) {
                        return DropdownMenuItem<DropdownItem>(
                          value: item,
                          child: Text(item.leagueName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _leagueSelectedItem = value!;
                          leagueIdValue = value.leagueValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(hintText: 'Nome da Equipa'),
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
              final leagueId = leagueIdValue.toString();

              createLeague(name: name, leagueId: leagueId);
              Navigator.pop(context);
              showToastMessage('Equipa criada com sucesso.');
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

  //This function is responsible to create new teams
  Future createLeague({required String name, required String leagueId}) async {
    //Reference document to create new league
    final docTeam = FirebaseFirestore.instance.collection('teams').doc();

    final team = Team(id: docTeam.id, name: name, leagueId: leagueId);
    final json = team.toJson();

    //Create document and write data to Firebase
    await docTeam.set(json);
  }
}
