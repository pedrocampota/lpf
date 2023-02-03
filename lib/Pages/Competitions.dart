//Libraries
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/Screens/TableScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Widgets
import 'package:lpf/Widgets/LeagueContainer.dart';

class Competitions extends StatelessWidget {
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
                      'Competições',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    physics: ScrollPhysics(),
                    children: [
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'media/images/ligas/liga_bwin.png',
                            color: Color.fromARGB(255, 1, 9, 37)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TableScreen(
                                    code: 'PPL', leagueName: 'Primeira Liga'),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'media/images/ligas/segunda_liga.png',
                            color: Color.fromARGB(255, 28, 158, 213)),
                        onTap: () {
                          showToastMessage('Segunda Liga');
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'media/images/ligas/terceira_liga.png',
                            color: Color(0xFF3d2166)),
                        onTap: () {
                          showToastMessage('Terceira Liga');
                        },
                      ),
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'media/images/ligas/liga_bpi.png',
                            color: Color.fromARGB(255, 241, 241, 241)),
                        onTap: () {
                          showToastMessage('Liga BPI');
                          //Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => super.widget));
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ));

  void showToastMessage(String leagueName) {
    Fluttertoast.showToast(
        msg: "A " + leagueName + " estará disponivel em breve.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12,
        gravity: ToastGravity.CENTER);
  }
}
