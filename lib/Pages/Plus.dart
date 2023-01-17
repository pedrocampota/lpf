import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/Screens/News.dart';
import 'package:lpf/Screens/TableScreen.dart';
import 'package:lpf/Widgets/LeagueContainer.dart';

class Plus extends StatelessWidget {
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
                  GridView.count(
                    childAspectRatio: (100 / 80),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    crossAxisCount: 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      GestureDetector(
                        child: Card(
                          shadowColor: Colors.grey.shade100,
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.white.withOpacity(1),
                                      BlendMode.dstATop),
                                  image: new AssetImage(
                                      'media/images/plus_news_bg.jpg'),
                                  fit: BoxFit.cover),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Últimas',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                Text('Mundo do Futebol',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => News(),
                              ));
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          shadowColor: Colors.grey.shade100,
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.white.withOpacity(1),
                                      BlendMode.dstATop),
                                  image: new AssetImage(
                                      'media/images/plus_transfermarket_bg.jpg'),
                                  fit: BoxFit.cover),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Mercado',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                Text('Transferências',
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        ),
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
