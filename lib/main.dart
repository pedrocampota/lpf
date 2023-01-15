// Libraries
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// Pages
import 'Pages/Competitions.dart';
import 'Pages/Plus.dart';

//Actions Classes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LPF',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            foregroundColor: Colors.white, //<-- SEE HERE
          ),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
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

  /* This widget is the home page of your application. It is stateful, meaning
   that it has a State object (defined below) that contains fields that affect
   how it looks.

   This class is the configuration for the state. It holds the values (in this
 case the title) provided by the parent (in this case the App widget) and
   used by the build method of the State. Fields in a Widget subclass are
   always marked "final".*/

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final screens = [
    Center(child: Text('Página Inicial')),
    Center(child: Text('Página dos Clubes')),
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
                label: 'Clubes'),
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
