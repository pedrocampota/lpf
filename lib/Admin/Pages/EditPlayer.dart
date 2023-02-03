//Libraries
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Modal Objects
import 'package:lpf/Modal/Player.dart';

class EditPlayer extends StatefulWidget {
  final String playerId;
  final String playerName;

  const EditPlayer(
      {super.key, required this.playerId, required this.playerName, required});
  @override
  State<EditPlayer> createState() => _EditPlayerState();
}

class _EditPlayerState extends State<EditPlayer> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        title: Row(
          children: [
            Text(
              "A editar ",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
            Text(
              widget.playerName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        leading: IconButton(
            icon: const Icon(Iconsax.backward),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
              icon: const Icon(Iconsax.trash),
              color: Colors.white,
              onPressed: () {
                openDeleteDialog();
              })
        ],
      ),
      body: FutureBuilder<Player?>(
        future: readPlayer(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final player = snapshot.data;

            return player == null
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('media/images/no_internet.gif',
                            height: 200, width: 200),
                        Text('Oops!',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                        Text(
                            'Não foi possivel realizar a conexão,\n com o servidor.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300))
                      ],
                    ),
                  )
                : buildPlayer(player);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ));

  //Construir o layout para mostrar o jogador
  Widget buildPlayer(Player player) => SafeArea(
          child: Expanded(
        child: Container(
          child: Column(
            children: [
              FutureBuilder<Player?>(
                future: readPlayer(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final player = snapshot.data;

                    return player == null
                        ? Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('media/images/no_internet.gif',
                                    height: 200, width: 200),
                                Text('Oops!',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    'Não foi possivel realizar a conexão,\n com o servidor.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          )
                        : Expanded(
                            child: Center(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('media/images/construcao.png',
                                      height: 200, width: 200),
                                  Text('Página em Contrição!',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 15, right: 15),
                                    child: Text(
                                        'Fica atento ao nosso website, para saberes de todas as novidades sobre desenvolvimento da app.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                  )
                                ],
                              ),
                            ),
                          ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            ],
          ),
        ),
      ));

  //Obter o nosso jogador através do id vindo da classe anterior e puxando do firestore
  Future<Player?> readPlayer() async {
    final docPlayer =
        FirebaseFirestore.instance.collection('players').doc(widget.playerId);
    final snapshot = await docPlayer.get();

    if (snapshot.exists) {
      return Player.fromJson(snapshot.data()!);
    }
  }

  //Obter a equipa em que o jogador está ativo
  Future<Player?> readTeam(teamId) async {
    final docPlayer =
        FirebaseFirestore.instance.collection('teams').doc(teamId);
    final snapshot = await docPlayer.get();

    if (snapshot.exists) {
      return Player.fromJson(snapshot.data()!);
    }
  }

  //!TODO!
  //Obter o nome da liga em que a equipa que o jogador joga pertence
  Future<String> getLeagueName(String documentId) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('leagues')
        .doc(documentId)
        .get();
    return documentSnapshot.get('name');
  }

  // Abrir caixa de diálogo confirmar se realmente pretende-se apagar o jogador
  Future<String?> openDeleteDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.all(20),
            title: Text(
              'Eliminar Jogador',
              style: TextStyle(
                  color: Color.fromARGB(255, 6, 82, 187),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            content: Container(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ao confirmares, o jogador ${widget.playerName} será eliminado permanentemente.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: Text('Confirmar'),
                      onPressed: () {
                        final docPlayer = FirebaseFirestore.instance
                            .collection('players')
                            .doc(widget.playerId);

                        docPlayer.delete();

                        Navigator.pop(context);

                        Fluttertoast.showToast(
                            msg:
                                'O utilizador ${widget.playerName} foi eliminado com sucesso.',
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 12,
                            gravity: ToastGravity.CENTER);
                      })
                ],
              )
            ],
          ));
}
