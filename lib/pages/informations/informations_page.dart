import 'package:app_a_o_c/shared/widgets/infos_version_widget.dart';
import 'package:flutter/material.dart';


class InformationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Informations',
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                //          border: Border.all(color: Theme.of(context).splashColor, width: 2),
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).dividerColor)),
                //          borderRadius: BorderRadius.circular(12),
                /*          boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 1),
              ),
            ],*/
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Application pour l\'Association des Oléiculteurs de Callian.'),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 10),
                Image.asset(
                  'assets/icon/iconeAppOlive512x512.png',
                  width: 40, // Largeur en pixels
                  height: 40, // Hauteur en pixels
                  fit: BoxFit.cover, // Ajustement du contenu (optionnel)
                ),
                SizedBox(width: 10),
                InfosVersionWidget(),
                SizedBox(width: 10),
                Image.asset(
                  'assets/icon/iconeAppOlive512x512.png',
                  width: 40, // Largeur en pixels
                  height: 40, // Hauteur en pixels
                  fit: BoxFit.cover, // Ajustement du contenu (optionnel)
                ),
              ],
            ),
          ],
        ));
  }
}
