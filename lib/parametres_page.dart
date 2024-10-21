import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aA_O_C/main.dart';
import 'liste_adherents.dart';
import 'adherents_page.dart';

class ParametresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Column(children: [
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
            padding: const EdgeInsets.all(16.0),
            child: Text('Contenu avec bordure et ombre'),
          ),
        ),
      ]
          /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BarreNavigation(),
            SizedBox(height: 10),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: FicheAdherent(
                  enableEditBool: false, adherent: appState.currentAd),
            ),
            SizedBox(height: 10),
            BarreEdition(),
          ],
        ),
      ),*/
          ),
    );
  }
}


class ColorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = [
      {'name': 'cardColor Color', 'color': theme.cardColor},
      {'name': 'hintColor Color', 'color': theme.hintColor},
      {'name': 'focusColor Color', 'color': theme.focusColor},
      {'name': 'hoverColor Color', 'color': theme.hoverColor},
      {'name': 'shadowColor Color', 'color': theme.shadowColor},
      {'name': 'splashColor Color', 'color': theme.splashColor},
      {'name': 'canvasColor Color', 'color': theme.canvasColor},
      {'name': 'dividerColor Color', 'color': theme.dividerColor},
      {'name': 'primaryColor Color', 'color': theme.primaryColor},
      {'name': 'primaryColorDark Color', 'color': theme.primaryColorDark},
      {'name': 'primaryColorLight Color', 'color': theme.primaryColorLight},
      {'name': 'disabledColor Color', 'color': theme.disabledColor},
      {'name': 'highlightColor Color', 'color': theme.highlightColor},
      {'name': 'indicatorColor Color', 'color': theme.indicatorColor},
      {
        'name': 'secondaryHeaderColor Color',
        'color': theme.secondaryHeaderColor
      },
      {
        'name': 'dialogBackgroundColor Color',
        'color': theme.dialogBackgroundColor
      },
      {
        'name': 'unselectedWidgetColor Color',
        'color': theme.unselectedWidgetColor
      },
      {
        'name': 'scaffoldBackgroundColor Color',
        'color': theme.scaffoldBackgroundColor
      },
    ];

    return Flexible(
      flex: 1,
      child: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final colorInfo = colors[index];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: colorInfo['color'] as Color,
            ),
            title: Text(colorInfo['name'] as String),
          );
        },
      ),
    );
  }
}
