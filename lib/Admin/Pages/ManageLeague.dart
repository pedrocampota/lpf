//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/League.dart';

class ManageLeague extends StatefulWidget {
  const ManageLeague({super.key});

  @override
  State<ManageLeague> createState() => _ManageLeagueState();
}

class _ManageLeagueState extends State<ManageLeague> {
  Color mainColor = Color.fromARGB(255, 18, 18, 18);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Text(
          'Gerir Liga',
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
      body: Container(
        color: Colors.grey.shade100,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ColoredBox(
                color: Color.fromARGB(255, 33, 91, 171),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Área de Gestão das Ligas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    )),
              ),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              child: StreamBuilder<List<League>>(
                  stream: listLeagues(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final leagues = snapshot.data!;

                      return ListView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: leagues.map(buildLeague).toList(),
                      );
                    } else {
                      return Center(child: Text('Sem ligas para mostrar.'));
                    }
                  }),
            ))
          ],
        ),
      ));

  //Function to list leagues
  Stream<List<League>> listLeagues() => FirebaseFirestore.instance
      .collection('leagues')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => League.fromJson(doc.data())).toList());

  Widget buildLeague(League league) => GestureDetector(
        child: Container(
            width: double.infinity,
            child: Card(
              shadowColor: Color.fromARGB(46, 255, 255, 255),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0.5,
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            league.name,
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(color: mainColor, size: 26, Iconsax.arrow_right)
                      ],
                    ),
                  ],
                ),
              ),
            )),
        onTap: () {
          showToastMessage('Edição disponível em breve.');
        },
      );

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
}
