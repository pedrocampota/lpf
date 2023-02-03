//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lpf/Widgets/TitleBar.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class DropdownItem {
  final String teamValue;
  final String teamName;

  DropdownItem(this.teamValue, this.teamName);
}

class _AddPlayerState extends State<AddPlayer> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final positionController = TextEditingController();
  final numberController = TextEditingController();
  final antidopingController = TextEditingController();
  final antidopingDaysController = TextEditingController();
  final clubIdController = TextEditingController();
  final contractDurationController = TextEditingController();
  final passportNumberController = TextEditingController();
  bool antidopingBool = true;

  final List<DropdownItem> _teamDropdownItems = [];
  DropdownItem? _teamSelectedItem;
  String? teamIdValue;

  String contractDateText = 'Escolher data de contracto';
  DateTime contractDateValue = DateTime(2023, 01, 01);
  String contractExpiringDateValue = '';
  String antidopingDateText = 'Escolher data do exame';
  DateTime antidopingDateValue = DateTime(2023, 01, 01);

  @override
  void initState() {
    super.initState();
    _getDropdownItems();
  }

  void _getDropdownItems() async {
    var firestore = FirebaseFirestore.instance;
    var snapshot = await firestore.collection('teams').get();

    for (var document in snapshot.docs) {
      _teamDropdownItems
          .add(DropdownItem(document.data()['id'], document.data()['name']));
    }
    setState(() {});
  }

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
              child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.all(10),
                  children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBar('Informações Necessárias', 0,
                          Iconsax.document_text_1),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: DropdownButtonFormField<DropdownItem>(
                          //isExpanded: true,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Escolher equipa...',
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
                          value: _teamSelectedItem,
                          items: _teamDropdownItems.map((DropdownItem item) {
                            return DropdownMenuItem<DropdownItem>(
                              value: item,
                              child: Text(item.teamName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _teamSelectedItem = value!;
                              teamIdValue = value.teamValue;
                            });
                          },
                        ),
                      ),
                      TextField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: 'Primeiro e último nome'),
                        controller: nameController,
                      ),
                      TextField(
                        autofocus: false,
                        decoration: InputDecoration(hintText: 'Idade'),
                        controller: ageController,
                      ),
                      TextField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: 'Número do Passaporte'),
                        controller: passportNumberController,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(contractDateText),
                            ElevatedButton(
                                child: Text('Escolher'),
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: contractDateValue,
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2050),
                                  );

                                  // se 'cancelar' => null
                                  if (newDate == null) return;

                                  // se 'ok' => dateTime
                                  setState(() {
                                    contractDateValue = newDate;

                                    var originalDateString = DateTime.parse(
                                        contractDateValue.toString());
                                    final formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(originalDateString);
                                    contractDateText =
                                        'Data escolhida: $formattedDate';
                                  });
                                })
                          ],
                        ),
                      ),
                      TextField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: 'Contrato em Meses'),
                        controller: contractDurationController,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Fez teste antidopping?'),
                                  LiteRollingSwitch(
                                    textOn: "Sim",
                                    textOff: "Não",
                                    value: true,
                                    animationDuration:
                                        Duration(milliseconds: 400),
                                    textOnColor: Colors.white,
                                    colorOn: Colors.greenAccent,
                                    colorOff: Colors.redAccent,
                                    iconOn: Icons.done,
                                    iconOff: Icons.remove_circle_outline,
                                    textSize: 16,
                                    onChanged: (bool state) {
                                      setState(() {
                                        antidopingBool = state;
                                      });
                                    },
                                    onDoubleTap: () {},
                                    onSwipe: () {},
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(antidopingDateText),
                                  ElevatedButton(
                                      child: Text('Escolher'),
                                      onPressed: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: antidopingDateValue,
                                          firstDate: DateTime(2015),
                                          lastDate: DateTime(2050),
                                        );

                                        // se 'cancelar' => null
                                        if (newDate == null) return;

                                        // se 'ok' => dateTime
                                        setState(() {
                                          antidopingDateValue = newDate;

                                          var originalDateString =
                                              DateTime.parse(antidopingDateValue
                                                  .toString());
                                          final formattedDate =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(originalDateString);
                                          antidopingDateText =
                                              'Data escolhida: $formattedDate';
                                        });
                                      })
                                ],
                              ),
                            ],
                          )),
                      TextField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: 'Dias de Antidoping'),
                        controller: antidopingDaysController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: [
                            TitleBar('Informações Opcionais', 20,
                                Iconsax.document_text_1),
                            TextField(
                              autofocus: false,
                              decoration: InputDecoration(hintText: 'Posição'),
                              controller: positionController,
                            ),
                            TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Número na Camisola'),
                              controller: numberController,
                            ),
                          ],
                        ),
                      )
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
              //Teste de Antioping
              var originalAntidopingDate =
                  DateTime.parse(antidopingDateValue.toString());
              final finalAntidopingDate =
                  DateFormat('yyyy-MM-dd').format(originalAntidopingDate);

              //Data de contrato
              var originalContractDate =
                  DateTime.parse(contractDateValue.toString());
              final finalContractDate =
                  DateFormat('yyyy-MM-dd').format(originalContractDate);
              //Data de expiração de contrato
              var contractDurationValue =
                  monthsToDays(int.parse(contractDurationController.text));

              DateTime originalContractExpiringDate = originalContractDate
                  .add(Duration(days: contractDurationValue));

              final finalContractExpiringDate =
                  DateFormat('yyyy-MM-dd').format(originalContractExpiringDate);

              final name = nameController.text;
              final age = ageController.text;
              final position = positionController.text;
              final number = numberController.text;
              final antidoping = antidopingBool;
              final antidopingDate = finalAntidopingDate;
              final antidopingDays = antidopingDaysController.text;
              final contractDate = finalContractDate;
              final contractDuration = contractDurationController.text;
              final contractExpiringDate = finalContractExpiringDate;
              final passportNumber = passportNumberController.text;
              final teamId = teamIdValue.toString();

              createPlayer(
                  name: name,
                  age: age,
                  position: position,
                  number: number,
                  antidoping: antidoping,
                  antidopingDate: antidopingDate,
                  antidopingDays: antidopingDays,
                  contractDate: contractDate,
                  contractDuration: contractDuration,
                  contractExpiringDate: contractExpiringDate,
                  passportNumber: passportNumber,
                  teamId: teamId);
              Navigator.pop(context);
              showToastMessage('Jogador criado com sucesso.');
            }),
      );

  DropdownMenuItem<String> buildMenuItem(String teamValue) => DropdownMenuItem(
      value: teamValue,
      child: Text(
        teamValue,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));

  // Transforma um dado número de meses, neste caso para a duração do contrato, em dias
  int monthsToDays(int months) {
    var durationInMonths = Duration(days: months * 30);
    return (durationInMonths.inDays / 30).round();
  }

  //Mostrar mensagem flutuante de sucesso.
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

  //Enviamos os dados para criar o Jogador
  Future createPlayer(
      {required String name,
      required String age,
      required String position,
      required String number,
      required bool antidoping,
      required String antidopingDate,
      required String antidopingDays,
      required String contractDate,
      required String contractDuration,
      required String contractExpiringDate,
      required String passportNumber,
      required String teamId}) async {
    //Reference document to create new player
    final docPlayer = FirebaseFirestore.instance.collection('players').doc();

    final player = Player(
        id: docPlayer.id,
        name: name,
        age: age,
        position: position,
        number: number,
        antidoping: antidoping,
        antidopingDate: antidopingDate,
        antidopingDays: antidopingDays,
        contractDate: contractDate,
        contractDuration: contractDuration,
        contractExpiringDate: contractExpiringDate,
        passportNumber: passportNumber,
        teamId: teamId);
    final json = player.toJson();

    //Create document and write data to Firebase
    await docPlayer.set(json);
  }
}
