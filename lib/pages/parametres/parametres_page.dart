import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:app_a_o_c/main.dart';
import '../../features/parametres/parametres.dart';
import '../adherents/adherents_page.dart';
import '../../features/adherents/liste_adherents.dart';

Future<String?> pickFile(String path, String type) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: [type],
    initialDirectory: path,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    print('Nom du fichier : ${file.name}');
    print('Chemin du fichier : ${file.path}');
    return file.path;
  } else {
    // L'utilisateur a annulé la sélection
    return null;
  }
}

class ParametresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Column(
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
              padding: const EdgeInsets.all(16.0),
              child: Text('Fichier adherents et planning:'),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: ChampTexte(
                      labelTextDecoration: "Fichier adhérents",
                      labelText: Parametres.instance.nomFichierAdherents,
                      enableEdit: false,
                      callback: (value) => {},
                      validation: validationAucune,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final directory =
                          await getApplicationDocumentsDirectory();
                      String? selectedFile =
                          await pickFile(directory.path, "csv");
                      if (selectedFile != null &&
                          selectedFile.toString().isNotEmpty) {
                        // Mise à jour du fichier de paramètres.
                        Parametres instanceParametres = Parametres.instance;
                        appState.majParametresNomFichierAdherent(selectedFile);
                        await instanceParametres.ecritureFichierParametres();

                        // Mise a jour à partir du nouveau fichier d'adhérents.
                        ListeAdherents.instance.localFileName = selectedFile;
                        ListeAdherents instanceListeAdherent =
                            ListeAdherents.instance;
                        await instanceListeAdherent.lectureFichierAdherents();
                      }
                    },
                    child: Text('Sélectionner un fichier'),
                  ),
                  SizedBox(width: 10),
                ],
              )),
        ],
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
        'color': theme.dialogTheme.backgroundColor
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
