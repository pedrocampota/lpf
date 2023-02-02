import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  String? title;
  double? paddingTop;
  IconData? iconName;

  TitleBar(this.title, this.paddingTop, this.iconName);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.only(top: paddingTop!),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.1, color: Color.fromARGB(255, 18, 18, 18)),
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
                            title ?? 'No title to display',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color.fromARGB(255, 18, 18, 18),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ])),
              ))
        ],
      ),
    );
  }
}
