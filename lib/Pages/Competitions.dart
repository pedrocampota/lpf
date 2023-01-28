import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/Screens/TableScreen.dart';
import 'package:lpf/Widgets/LeagueContainer.dart';

class Competitions extends StatelessWidget {
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
                        fontWeight: FontWeight.w400
                      ),
                    )),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(15.0),
              child: ListView(
                children: [
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
            ))
          ],
        ),
      ));
}
