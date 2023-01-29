import 'package:flutter/material.dart';

class LeagueContainer extends StatelessWidget {
  final String image;
  final Color color;
  const LeagueContainer({Key? key, required this.image, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Image.asset(image),
    );
  }
}
