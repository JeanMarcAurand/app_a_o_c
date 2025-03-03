import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aA_O_C/main.dart';
import 'agenda.dart';

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Agenda', style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aujourd\'hui ${Agenda.instance.dateDuJour()}'),
//            BarreNavigation(),
            SizedBox(height: 10),
            CalendarWidget(),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final List<String> daysOfWeek = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];
  final List<String> moisDeLAnnee = [
    '',
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre'
  ];

  final List<int> dates = List.generate(30, (index) => index + 1);
  DateTime? selectedDate;
  int _moisCalendrier = DateTime.now().month;
  int _anneeCalendrier = DateTime.now().year;

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    // Ajoutez ici le code pour récupérer et afficher les rendez-vous de la date sélectionnée
  }

  void _onMoisPrecedentSuivant(int incrementmois) {
    setState(() {
      _moisCalendrier = _moisCalendrier + incrementmois;
      if (_moisCalendrier > 12) {
        _moisCalendrier = _moisCalendrier - 12;
        _anneeCalendrier = _anneeCalendrier + 1;
      }
      if (_moisCalendrier < 1) {
        _moisCalendrier = _moisCalendrier + 12;
        _anneeCalendrier = _anneeCalendrier - 1;
      }
    });
    // Ajoutez ici le code pour récupérer et afficher les rendez-vous de la date sélectionnée
  }

  List<DateTime> getListJour(int annee, int mois) {
    List<DateTime> listeDesDates = [];
// Date début du mois.
    DateTime date = DateTime(annee, mois);
    int jour = date.weekday;
    // Date debut mois suivant.
    DateTime dateFin = DateTime(annee, mois + 1);
// Date début tableau:
    DateTime dateCourante = date.subtract(Duration(days: jour - 1));
    while (dateCourante.isBefore(dateFin) || dateCourante.weekday == 7) {
      listeDesDates.add(dateCourante);
      dateCourante = Agenda.instance.addOneDay(dateCourante);
    }
    return listeDesDates;
  }

  List<Color?> getListCouleur(int annee, int mois) {
    List<Color?> listeDesCouleurs = [];
// Date début du mois.
    DateTime date = DateTime(annee, mois);
    int jour = date.weekday;
    // Date debut mois suivant.
    DateTime dateFin = DateTime(annee, mois + 1);
// Date début tableau:
    DateTime dateCourante = date.subtract(Duration(days: jour - 1));
    while (dateCourante.isBefore(dateFin) || dateCourante.weekday == 7) {
      if (dateCourante.month != mois) {
        listeDesCouleurs.add(Colors.grey[400]);
      } else {
        //(dateCourante.day)*3 pour simuler le capacite reserve dans journee.
        if ((dateCourante.day) * 3 < 30) {
          // Moins de 30%
          listeDesCouleurs.add(Colors.blue[300]);
        } else if ((dateCourante.day) * 3 < 60) {
          // 30% - 60 %
          listeDesCouleurs.add(Colors.yellow[200]);
        } else if ((dateCourante.day) * 3 < 90) {
          // 60% - 99 %
          listeDesCouleurs.add(Colors.yellow[300]);
        } else {
          listeDesCouleurs.add(Colors.green[300]);
        }
      }
      dateCourante = dateCourante.add(Duration(days: 1));
    }
    return listeDesCouleurs;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    int date = DateTime.now().day;
    int mois = DateTime.now().month;
    int annee = DateTime.now().year;

    List<DateTime> dates = getListJour(_anneeCalendrier, _moisCalendrier);
    List<Color?> couleurs = getListCouleur(_anneeCalendrier, _moisCalendrier);
    return Column(
      children: [
        Container(
          width: screenWidth * 0.5, // 40% de la largeur de l'écran
          height: screenHeight * 0.3, // 60% de la hauteur de l'écran
          //color: const Color.fromARGB(255, 151, 180, 152),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _onMoisPrecedentSuivant(-1);
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_back_ios),
                  label: Text(''),
                  //  color: theme.colorScheme.primary,    // ← And also this.
                ),
                SizedBox(width: 5),
                Text('${moisDeLAnnee[_moisCalendrier]} $_anneeCalendrier',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    _onMoisPrecedentSuivant(1);
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.arrow_forward_ios),
                  label: Text(''),
                  //  color: theme.colorScheme.primary,    // ← And also this.
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 jours par semaine
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio:
                    2.0, // = 1 assure que les cellules sont carrées
              ),
              itemCount: daysOfWeek.length + dates.length,
              itemBuilder: (context, index) {
                if (index < daysOfWeek.length) {
                  return Center(
                    child: Text(daysOfWeek[index],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                } else {
                  return GestureDetector(
                    onTap: () =>
                        _onDateSelected(dates[index - daysOfWeek.length]),
                    child: Container(
                      alignment: Alignment.center,
                      //color: couleurs[index - daysOfWeek.length],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: dates[index - daysOfWeek.length].day /
                                31, //0.7, // Exemple de taux de remplissage
                            backgroundColor: Colors.grey[200],
                            color: couleurs[
                                index - daysOfWeek.length], // Colors.blue,
                            strokeWidth: 2,
                          ),
                          Text(
                            '${dates[index - daysOfWeek.length].day}', // Texte à l'intérieur
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: date ==
                                            dates[index - daysOfWeek.length]
                                                .day &&
                                        mois ==
                                            dates[index - daysOfWeek.length]
                                                .month &&
                                        annee ==
                                            dates[index - daysOfWeek.length]
                                                .year
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],

                        //Text('${dates[index - daysOfWeek.length]}'),
                      ),
                    ),
                  );
                }
              },
            ),
          ]),
        ),
        if (selectedDate != null)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zone d'entête
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.green[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Informations générales.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 8),
                          Text(
                              'Configuration de la journée du ${Agenda.instance.date2String(Agenda.instance.getJournee(selectedDate!).date)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {/*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return editInfo(
                                        context,
                                        Agenda.instance
                                            .getJournee(selectedDate!));
                                  },
                                ),
                              );
                            */
                            print( "onPressed: ()");},
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Nombre de mottes: ${Agenda.instance.nombreDeMotte(selectedDate!)}'),
                          Text(
                              'Poids d\'une motte, min: ${Agenda.instance.poidsMinMotte(selectedDate!)} kg, max: ${Agenda.instance.poidsMaxMotte(selectedDate!)} kg'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Poids total: ${Agenda.instance.poidsTotalJournee(selectedDate!)} kg',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),

                      SizedBox(height: 8),
                      Text(Agenda.instance.nombreDeRDV(selectedDate!)),
                    ],
                  ),
                ),
                // Liste de rendez-vous.
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Empêche la liste de défiler indépendamment
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Rendez-vous ${index + 1}'),
                        leading: Icon(Icons.calendar_today),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
/*
class EditInfo extends StatelessWidget {
final Context context;
final Journee journee;
 EditInfo(super.Build,  required this.context, required this.journee) {
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
}
}
*/
/*
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController controller = TextEditingController(text: info);
      TextEditingController dateController = TextEditingController(text: date);
      return AlertDialog(
        title: Text('Éditer Informations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Informations Générales'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                info = controller.text;
                date = dateController.text;
              });
              Navigator.of(context).pop();
            },
            child: Text('Sauvegarder'),
          ),
        ],
      );
    },
  );
}
*/