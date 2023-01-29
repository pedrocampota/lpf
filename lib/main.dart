// Libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lpf/firebase_options.dart';
// Pages
import 'Admin/Home.dart';
import 'Pages/Competitions.dart';
import 'Pages/Plus.dart';

//Actions Classes
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liga Portugal',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 1, 9, 37),
          brightness: Brightness.light),

      home: const MainPage(title: 'LPF - Página Inicial'),
      //  home: HomeScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens = [
    Center(child: Text('Página Inicial')),
    Center(child: Text('Página dos Jogadores')),
    Competitions(),
    Plus(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 19, 84),
        title: Image.asset(
          'media/images/logo_appbar.png',
          height: 110,
          width: 110,
        ),
        leading: IconButton(
            icon: const Icon(Iconsax.menu),
            color: Colors.white,
            onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.user),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHomePage(
                      title: 'Página de Admin',
                    ),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.notification),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.search_normal),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Color.fromARGB(255, 158, 198, 255),
            labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.black))),
        child: NavigationBar(
          height: 70,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(seconds: 1),
          destinations: [
            NavigationDestination(
                icon: Icon(Iconsax.home),
                selectedIcon: Icon(Iconsax.home5),
                label: 'Ínicio'),
            NavigationDestination(
                icon: Icon(Iconsax.people),
                selectedIcon: Icon(Iconsax.people5),
                label: 'Jogadores'),
            NavigationDestination(
                icon: Icon(Iconsax.cup),
                selectedIcon: Icon(Iconsax.cup5),
                label: 'Competições'),
            NavigationDestination(
                icon: Icon(Iconsax.element_plus),
                selectedIcon: Icon(Iconsax.element_plus5),
                label: 'Mais'),
          ],
        ),
      ));
}
