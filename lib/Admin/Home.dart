//Libraries
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpf/Admin/Pages/AddLeague.dart';

// Pages
import 'Pages/AddLeague.dart';
import 'Pages/ManageLeague.dart';
import 'Pages/AddPlayer.dart';
import 'Pages/ManagePlayer.dart';
import 'Pages/AddTeam.dart';
import 'Pages/ManageTeam.dart';
import 'Pages/ExpiringContracts.dart';
import 'Pages/AntidopingControl.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key, required this.title});
  final String title;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 18, 18, 18),
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
          leading: IconButton(
              icon: const Icon(Iconsax.backward),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.more_square),
              color: Colors.white,
              onPressed: () {
                showToastMessage('Menu de Opções.');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    Container(
                      child: Column(
                        children: [
                          title('Área de Gestão', 0, Iconsax.edit),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            physics: ScrollPhysics(),
                            children: [
                              GestureDetector(
                                child: card('Adicionar/Gerir\n Liga',
                                    0xFF090979, 0xFF00d4ff, Iconsax.cup),
                                onTap: () {
                                  openActionDialogManageArea(
                                      'Ligas',
                                      'Adicionar',
                                      'Gerir',
                                      () => AddLeague(),
                                      () => ManageLeague());
                                },
                              ),
                              GestureDetector(
                                child: card('Adicionar/Gerir\n Equipa',
                                    0xFF090979, 0xFF00d4ff, Iconsax.people),
                                onTap: () {
                                  openActionDialogManageArea(
                                      'Equipas',
                                      'Adicionar',
                                      'Gerir',
                                      () => AddTeam(),
                                      () => ManageTeam());
                                },
                              ),
                              GestureDetector(
                                child: card('Adicionar/Gerir\n Jogador',
                                    0xFF090979, 0xFF00d4ff, Iconsax.user),
                                onTap: () {
                                  openActionDialogManageArea(
                                      'Jogadores',
                                      'Adicionar',
                                      'Gerir',
                                      () => AddPlayer(),
                                      () => ManagePlayer());
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          title('Área de Consultas', 20, Iconsax.eye),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            physics: ScrollPhysics(),
                            children: [
                              GestureDetector(
                                child: card('Contratos a\n Expirar', 0xFFfd1d1d,
                                    0xFFfcb045, Iconsax.document_text_14),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExpiringContracts(),
                                      ));
                                },
                              ),
                              GestureDetector(
                                child: card('Controlo\n Antidoping', 0xFFfd1d1d,
                                    0xFFfcb045, Iconsax.health),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AntidopingControl(),
                                      ));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 18, 18, 18),
            label: const Text('Suporte',
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            icon:
                const Icon(color: Color(0xFFFFFFFF), size: 26, Iconsax.support),
            onPressed: () {
              showToastMessage('Não disponivel de momento.');
            }),
      );

  //Function to not repeat title many times
  title(String title, double paddingTop, IconData iconName) {
    return Container(
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.only(top: paddingTop),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.5, color: Color.fromARGB(255, 18, 18, 18)),
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                              color: Color.fromARGB(255, 18, 18, 18),
                              size: 20,
                              iconName),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color.fromARGB(255, 18, 18, 18),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ])),
              )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //Function to not repeat cards many times
  card(String cardTitle, int firstColor, int secondColor, IconData iconName) {
    return Card(
      shadowColor: Colors.grey.shade100,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(firstColor),
            Color(secondColor),
          ],
        )),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(color: Color(0xFFFFFFFF), size: 26, iconName),
            SizedBox(height: 10),
            Text(cardTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  //Mostrar mensagem toast
  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12,
        gravity: ToastGravity.CENTER);
  }

  Future<String?> openActionDialogManageArea(
          String dialogTitle,
          String firstActionText,
          String secondActionText,
          Widget Function() createPage,
          Widget Function() editPage) =>
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                titlePadding: EdgeInsets.all(20),
                title: Text(
                  dialogTitle,
                  style: TextStyle(
                      color: Color.fromARGB(255, 18, 18, 18),
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20),
                content: Text('Escolhe uma opção:'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          child: SizedBox(
                            width: 80,
                            child: Text(firstActionText,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 18, 18, 18))),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => createPage(),
                                ));
                          }),
                      TextButton(
                          child: SizedBox(
                            width: 80,
                            child: Text(secondActionText,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 18, 18, 18))),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => editPage(),
                                ));
                          })
                    ],
                  )
                ],
              ));
}
