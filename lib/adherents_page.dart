import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:aA_O_C/main.dart';
import 'liste_adherents.dart';

class AdherentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Fiches adhérents',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BarreNavigation(),
            SizedBox(height: 10),
            AdherentsListScreen(),
          ],
        ),
      ),
    );
  }
}

class AdherentsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Flexible(
      flex: 1,
      child: ListView.builder(
        itemCount: ListeAdherents.instance.listeAdherentsCourant.length,
        itemBuilder: (context, index) {
          var adherent = ListeAdherents.instance.listeAdherentsCourant[index];
          var labelTextTelephone = adherent.noTelephonePortable;
          if (adherent.noTelephonePortable.isEmpty) {
            labelTextTelephone = adherent.noTelephoneFixe;
          } else {
            labelTextTelephone = adherent.noTelephonePortable;
          }

          return Card(
              child: InkWell(
                  onTap: () {
                    // Action à réaliser lors de l'appui
                    print('Card with ListTile tapped');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ModificationFicheAdherent(
                            localCurrentAd: adherent,
                            editCreateDisplay: EditCreateDisplay.edit);
                      }),
                    );
                  },
                  /*(context) {
                        return ModificationFicheAdherent(
                            localCurrentAd: adherent,
                            editCreateDisplay: EditCreateDisplay.edit);
                      },*/
                  child: ListTile(
                    leading: Icon(Icons.contact_phone, size: 56.0),
                    title: Text('${adherent.nom} ${adherent.prenom}'),
                    subtitle: Text(labelTextTelephone),

                    //  trailing: Icon(Icons.more_vert),
                    trailing: PopupMenuButton<int>(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text('Editer'),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text('Supprimer'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ModificationFicheAdherent(
                                    localCurrentAd: adherent,
                                    editCreateDisplay: EditCreateDisplay.edit);
                              },
                            ),
                          );
                        } else if (value == 1) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'Suppression de la fiche d\'adhérent'),
                              content:
                                  const Text('La suppression est définitive!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    appState.deleteAdherent(adherent);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )));
        },
      ),
    );
  }
}

class FicheAdherent extends StatelessWidget {
  final bool enableEditBool;
  final Adherent adherent;
  final dynamic formKey;

  FicheAdherent(
      {super.key,
      required this.enableEditBool,
      required this.adherent,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    var callbackTelephone = adherent.setNoTelephonePortable;
    var labelTextTelephone = adherent.noTelephonePortable;
    print(adherent);
    if (adherent.noTelephonePortable.isEmpty) {
      callbackTelephone = adherent.setNoTelephoneFixe;
      labelTextTelephone = adherent.noTelephoneFixe;
      print('tel fixe');
    } else {
      callbackTelephone = adherent.setNoTelephonePortable;
      labelTextTelephone = adherent.noTelephonePortable;

      print('tel portable');
    }

    return Form(
      key: formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      labelTextDecoration: "Mme,M",
                      labelText: adherent.civilite,
                      enableEdit: enableEditBool,
                      callback: adherent.setCivilite,
                      validation: validationAucune,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "* Nom",
                      labelText: adherent.nom,
                      enableEdit: enableEditBool,
                      callback: adherent.setNom,
                      validation: validationChampNonVide,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Prenom",
                      labelText: adherent.prenom,
                      enableEdit: enableEditBool,
                      callback: adherent.setPrenom,
                      validation: validationAucune,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
              ],
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    child: ChampTexte(
                      labelTextDecoration: "Numéro",
                      labelText: adherent.noRue,
                      enableEdit: enableEditBool,
                      callback: adherent.setNoRue,
                      validation: validationAucune,
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: ChampTexte(
                      labelTextDecoration: "Adresse",
                      labelText: adherent.adresse,
                      enableEdit: enableEditBool,
                      callback: adherent.setAdresse,
                      validation: validationAucune,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(width: 20),
                  ),
                  Flexible(
                    flex: 10,
                    child: ChampTexte(
                      labelTextDecoration: "Complement adresse",
                      labelText: adherent.complementAdresse,
                      enableEdit: enableEditBool,
                      callback: adherent.setComplementAdresse,
                      validation: validationAucune,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(width: 20),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Code postal",
                      labelText: adherent.codePostal,
                      enableEdit: enableEditBool,
                      callback: adherent.setCodePostal,
                      mask: '#####',
                      hint: 'Ex: 83440',
                      validation: validationCodePostalOuVide,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Commune",
                      labelText: adherent.commune,
                      enableEdit: enableEditBool,
                      callback: adherent.setCommune,
                      validation: validationAucune,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
              ],
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(width: 20),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "* Téléphone",
                      labelText: labelTextTelephone,
                      enableEdit: enableEditBool,
                      callback: callbackTelephone,
                      mask: '## ## ## ## ##',
                      hint: 'Ex: 01 23 45 67 89',
                      validation: validationNumeroTel,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "@ mail",
                      labelText: adherent.adresseMail,
                      enableEdit: enableEditBool,
                      callback: adherent.setAdresseMail,
                      validation: validationAdresseMailOuVide,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(width: 20),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Date création",
                      labelText: adherent.dateCreation,
                      enableEdit: false,
                      callback: (value) => {},
                      validation: validationAucune,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Date dernière MAJ",
                      labelText: adherent.dateDerniereMAJ,
                      enableEdit: false,
                      callback: (value) => {},
                      validation: validationAucune,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Auteur dernière MAJ",
                      labelText: adherent.sourceDerniereMAJ,
                      enableEdit: false,
                      callback: (value) => {},
                      validation: validationAucune,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: ChampTexte(
                      labelTextDecoration: "Identificateur",
                      labelText: adherent.identificateur.toString(),
                      enableEdit: false,
                      callback: (value) => {},
                      validation: validationAucune,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum EditCreateDisplay {
  create,
  edit,
  display,
}

class ModificationFicheAdherent extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final EditCreateDisplay editCreateDisplay;
  final Adherent localCurrentAd;
  ModificationFicheAdherent(
      {super.key,
      required this.localCurrentAd,
      required this.editCreateDisplay});
  @override
  Widget build(BuildContext context) {
    bool editTrueCreateFalse =
        true; // Pour faire la difference entre une fiche que l'on cree ou que l'on edite
    bool modifiableTrueAffichageFalse =
        true; // Pour permettre de faire de modif dans la fiche ou juste pour faire l'affichage.
    String titreAppBar = "";
    var appState = context.watch<MyAppState>();

    // Se rappelle l'adherent clique qui devient le courant.
    switch (editCreateDisplay) {
      case EditCreateDisplay.edit:
        titreAppBar = 'Modification de la fiche';
        appState.editAd.copyAdherentFrom(localCurrentAd);
        editTrueCreateFalse = true;
        modifiableTrueAffichageFalse = true;
        break;
      case EditCreateDisplay.create:
        titreAppBar = 'Création de la fiche';
        appState.editAd.copyAdherentFrom(Adherent("", "", ""));
        editTrueCreateFalse = false;
        modifiableTrueAffichageFalse = true;
        break;
      case EditCreateDisplay.display:
        titreAppBar = 'Affichage de la fiche';
        appState.editAd.copyAdherentFrom(localCurrentAd);
        editTrueCreateFalse = false;
        modifiableTrueAffichageFalse = false;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titreAppBar),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            dialogConfirmation(context, appState, localCurrentAd,
                editTrueCreateFalse, _formKey.currentState?.validate());
          },
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              //             fit: FlexFit.loose,
              flex: 1,
              child: FicheAdherent(
                enableEditBool: modifiableTrueAffichageFalse,
                adherent: appState.editAd,
                formKey: _formKey,
              ),
            ),
            if (editCreateDisplay != EditCreateDisplay.display)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      dialogConfirmation(
                          context,
                          appState,
                          localCurrentAd,
                          editTrueCreateFalse,
                          _formKey.currentState?.validate());
                    },
                    icon: Icon(Icons.delete_forever),
                    label: Text('Annuler'),
                    //  color: theme.colorScheme.primary,    // ← And also this.
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      dialogChampObligatoire(
                          context,
                          appState,
                          localCurrentAd,
                          editTrueCreateFalse,
                          _formKey.currentState?.validate());
                    },
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.edit),
                    label: Text('Sauvegarder'),
                    //  color: theme.colorScheme.primary,    // ← And also this.
                  ),
                ),
              ]),
          ]),
    );
  }
}

void dialogConfirmation(
    BuildContext context,
    MyAppState appState,
    Adherent localCurrentAd,
    bool editTrueCreateFalse,
    bool? champsValidesTrue) {
  //var appState = context.watch<MyAppState>();
  // if ((appState.editAd.nom.isNotEmpty) &&
  //    (appState.editAd.noTelephone.isNotEmpty))
  {
    if (!(localCurrentAd.isAdherentIdentique(appState.editAd))) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('La fiche d\'adhérent a été modifiée!'),
          content: const Text('Conserver les modifications:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Non!'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                dialogChampObligatoire(context, appState, localCurrentAd,
                    editTrueCreateFalse, champsValidesTrue);
//                appState.majAdherentEdite();
                //               Navigator.pop(context);
                //              Navigator.pop(context);
              },
              child: const Text('Oui!'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
//  } else {
  // Ne passera jamais dans le else de dialogChampObligatoire,
  // il y a un champ obligatoire de vide.
  //  dialogChampObligatoire(context, appState);
  //}
}

//-----------------------------------------------------------------------
// Boite de dialogue avec gestion des champs obligatoires.
//-----------------------------------------------------------------------
void dialogChampObligatoire(
    BuildContext context,
    MyAppState appState,
    Adherent localCurrentAd,
    bool editTrueCreateFalse,
    bool? champsValidesTrue) {
  if (champsValidesTrue == null || champsValidesTrue == false) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Les champs entourés doivent être corrigés!'),
        content: const Text('Reprendre les modifications ou abandonner:'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Abandonner!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Reprendre!'),
          ),
        ],
      ),
    );
  } else {
    if (editTrueCreateFalse == true) {
      appState.majAdherentEdite(localCurrentAd);
    } else {
      appState.createAdherentEdite();
    }
    Navigator.pop(context);
  }
}

class BarreNavigation extends StatelessWidget {
  BarreNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var myControllerTextFieldRechercheLocal =
        appState.myControllerTextFieldRecherche;

    return Row(children: [
      Expanded(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Flexible(
                  //             fit: FlexFit.loose,
                  flex: 1,
                  child: TextField(
                    controller: myControllerTextFieldRechercheLocal,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // perform the clear.
                          myControllerTextFieldRechercheLocal.clear();
                        },
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Perform the search here
                          appState.searchStrinInName(
                              myControllerTextFieldRechercheLocal.text);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    print('create!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModificationFicheAdherent(
                              localCurrentAd: Adherent("", "", ""),
                              editCreateDisplay: EditCreateDisplay.create)),
                    );
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.edit),
                  label: Text('Nouveau'),
                  //  color: theme.colorScheme.primary,    // ← And also this.
                ),
                SizedBox(width: 10),
              ],
            ),
            Text(appState.resultatRecherche()),
          ],
        ),
      ),
    ]);
  }
}

//----------------------------------------------------------------
// parametres à passer à la classe ChampTexte
//----------------------------------------------------------------
class ParametresChampTexte {
  final TextEditingController textController = TextEditingController();
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final String mask;
  final TextInputType textInputType;

  ParametresChampTexte(
      {required this.formatter,
      this.validator,
      required this.hint, // description du format attendu 'ex: 01 23 45 67 89'
      required this.mask, // description du format '## ## ## ## ##'. A=tout sauf chiffres, #=chiffre
      required this.textInputType});
}

String? validationNumeroTel(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un numéro.';
  }
  if (value.length != 14) {
    // il ya les blans.
    return 'Le numéro doit contenir 10 chiffres.';
  }
  return null;
}

String? validationAucune(String? value) {
  return null;
}

String? validationChampNonVide(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ce champ doit être renseigné.';
  }
  return null;
}

String? validationCodePostalOuVide(String? value) {
  if (value != null && value.isNotEmpty) {
    if (value.length != 5) {
      return 'Le numéro doit contenir 5 chiffres.';
    }
  }
  return null;
}

String? validationAdresseMailOuVide(String? value) {
  if (value != null && value.isNotEmpty) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }
  }
  return null;
}
//----------------------------------------------------------------
// class ChampTexte
//----------------------------------------------------------------

class ChampTexte extends StatelessWidget {
  final String labelText;
  final String labelTextDecoration;
  final bool enableEdit; // false rend le TextField non éditable
  final void Function(String) callback;
  final String hint; // description du format attendu 'ex: 01 23 45 67 89'
  final String
      mask; // description du format '## ## ## ## ##'. A=tout sauf chiffres, #=chiffre
  final String? Function(String?)? validation;

  ChampTexte({
    super.key,
    required this.labelText,
    required this.labelTextDecoration,
    required this.enableEdit,
    required this.callback,
    required this.validation,
    this.hint = '',
    this.mask = '',
  });

  /*@override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }*/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enableEdit, // false rend le TextField non éditable
        controller: TextEditingController(text: labelText),
        onChanged: (text) {
          callback(text);
          //print('$labelTextDecoration : $text');
        },
        inputFormatters: [
          MaskTextInputFormatter(
              mask: mask,
              //filter: {"#": RegExp(r'[0-9]')},
              initialText: labelText,
              type: MaskAutoCompletionType.eager //lazy
              )
        ],
        validator: (value) {
          return validation!(value);
        },
        /*(value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer un numéro';
          }
          if (value.length != 10) {
            return 'Le numéro doit contenir 10 chiffres';
          }
          return null;
        },*/
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),

          //border: OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          labelText: labelTextDecoration,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
