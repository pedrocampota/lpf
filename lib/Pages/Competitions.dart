import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/Screens/TableScreen.dart';
import 'package:lpf/Widgets/LeagueContainer.dart';

class Competitions extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Competições',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      GestureDetector(
                        child: const LeagueContainer(
                            image: 'media/images/liga_bwin.png'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TableScreen(
                                    code: 'PPL',
                                    leagueName: 'Liga Portugal Bwin'),
                              ));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
