import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1, // épaisseur de la ligne
      //color: Colors.grey, // couleur
      height: 16,
      indent: 16, // marge à gauche
      endIndent: 16, // marge à droite
    );
  }
}
