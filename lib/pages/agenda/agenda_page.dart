import 'package:app_a_o_c/pages/agenda/is_modification_a_conserver.dart';
import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:app_a_o_c/shared/utils/date_utilitaire.dart';
import 'package:app_a_o_c/shared/widgets/date_picker.dart';
import 'package:app_a_o_c/shared/widgets/labeled_switch.dart';
import 'package:app_a_o_c/shared/widgets/number_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:app_a_o_c/main.dart';
import '../../features/agenda/agenda.dart';

class AgendaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda:  aujourd\'hui ${DateUtilitaire.dateDuJour()}',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  // Empêche l'erreur en donnant une hauteur disponible.
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      CalendarScreen(),
                    ],
                  ),
                ),
                Expanded(
                  // Empêche l'erreur en donnant une hauteur disponible.
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text('Panneau de droite ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            // Informations générales.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 8),
                Text(
                    'Journée du ${DateUtilitaire.date2String(appState.dateSelectionnee)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 8),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, //.spaceBetween,
              children: [
                SizedBox(height: 8),
                Text('Configuration générale:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 8),
                if (appState.dateSelectionnee.isAfter(currentDate)) ...[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ModificationConfigurationGenerale(
                              date: appState.dateSelectionnee,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(width: 8),
              ],
            ),
            if (!Agenda.instance.isChome(appState.dateSelectionnee)) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // .spaceBetween,
                children: [
                  SizedBox(width: 8),
                  Text(
                      'Nombre de mottes: ${Agenda.instance.nombreDeMotte(appState.dateSelectionnee)}.  Poids d\'une motte, min: ${Agenda.instance.poidsMinMotte(appState.dateSelectionnee)} kg, max: ${Agenda.instance.poidsMaxMotte(appState.dateSelectionnee)} kg'),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // .spaceBetween,
                children: [
                  Text(
                      'Poids total: ${Agenda.instance.poidsTotalJournee(appState.dateSelectionnee)} kg',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(height: 8),
            ],
            Text(Agenda.instance.nombreDeRDV(appState.dateSelectionnee),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = currentDate;
  DateTime? _selectedDay;

  // Exemple de données associées à certains jours
  Map<DateTime, List<Widget>> _events = {
    DateTime.utc(2025, 2, 28): [Icon(Icons.star, color: Colors.amber)],
    DateTime.utc(2025, 3, 1): [Icon(Icons.event, color: Colors.blue)],
    DateTime.utc(2025, 3, 10): [
      Text("RDV",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red))
    ],
  };

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    DateTime startDate = DateTime(
        Agenda.instance.anneeAgenda, Agenda.instance.moisDebutAgenda, 1);
    DateTime endDate = DateTime(
      startDate.year,
      startDate.month + Agenda.instance.nbMoisAgenda,
      startDate.day,
    );
    _selectedDay = appState.dateSelectionnee;
    return TableCalendar(
      firstDay: startDate,
      lastDay: endDate,
      focusedDay: _focusedDay,
      currentDay: currentDate,
      // Style des jours de la semaine
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1.0), // Ajuste la hauteur du texte
        weekendStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1.0,
            color: Colors.red),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          appState.majDateSelectionnee(selectedDay);
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            width: double.infinity, // Prend toute la largeur dispo !
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(1),
            // color: Colors.amber,
            decoration: BoxDecoration(
//             color: Colors.amber,
              color: /* Colors.grey[200],*/
                  //(dateCourante.day)*3 pour simuler le capacite reserve dans journee.
                  getBackgroundColor(day.day),

              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day.day.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (_events[day] != null) ..._events[day]!,
              ],
            ),
          );
        },
      ),
    );
  }
}

Color? getBackgroundColor(int day) {
  int value = day * 3;
  if (value < 30) return Colors.blue[50];
  if (value < 60) return Colors.yellow[100];
  if (value < 90) return Colors.amber[100];
  return Colors.green[100];
}

class ModificationConfigurationGenerale extends StatefulWidget {
  final DateTime date;

  ModificationConfigurationGenerale({
    super.key,
    required this.date,
  });

  @override
  ModificationConfigurationGeneraleState createState() =>
      ModificationConfigurationGeneraleState();
}

enum DeploiementConfiguration { journee, periode }

class ModificationConfigurationGeneraleState
    extends State<ModificationConfigurationGenerale> {
  CaracteristiquesJournee caracteristiquesJourneeint = CaracteristiquesJournee(
    chome: Agenda.instance.isChome(currentDate),
    nombreDeMotte: Agenda.instance.nombreDeMotte(currentDate),
    poidsMotteMax: Agenda.instance.poidsMaxMotte(currentDate),
    poidsMotteMin: Agenda.instance.poidsMinMotte(currentDate),
  );
  DateTime dateDebut = currentDate;
  DateTime dateFin = currentDate;
  DeploiementConfiguration? _deploiement = DeploiementConfiguration.journee;

  List<bool> isChecked = [false, false, false, false, false, false, false];
  final List<String> daysOfWeek = [
    'lun.',
    'mar.',
    'mer.',
    'jeu.',
    'ven.',
    'sam.',
    'dim.'
  ];

  @override
  void initState() {
    super.initState();
    dateDebut = widget.date;
    dateFin = widget.date;
    caracteristiquesJourneeint = CaracteristiquesJournee(
      chome: Agenda.instance.isChome(widget.date),
      nombreDeMotte: Agenda.instance.nombreDeMotte(widget.date),
      poidsMotteMax: Agenda.instance.poidsMaxMotte(widget.date),
      poidsMotteMin: Agenda.instance.poidsMinMotte(widget.date),
    );
    isChecked[widget.date.weekday - 1] = true;
    //dateFin = DateTime(Parametres.instance.anneeFichierAgenda,
    //     Agenda.instance.moisDebutAgenda+Agenda.instance.nbMoisAgenda, 1);
  }

  void _updateDateDebut(DateTime date) {
    dateDebut = date;
    setState(() {});
  }

  void _updateDateFin(DateTime date) {
    dateFin = date;
    setState(() {});
  }

  void _updateNbMotte(int nbMotte) {
    caracteristiquesJourneeint.nombreDeMotte = nbMotte;
    setState(() {});
  }

  void _updateJourChome(bool isChome) {
    caracteristiquesJourneeint.chome = isChome;
    setState(() {});
  }

  void _updatePoidsMinMotte(int poidsMin) {
    caracteristiquesJourneeint.poidsMotteMin = poidsMin;
    setState(() {});
  }

  void _updatePoidsMaxMotte(int poidsMax) {
    caracteristiquesJourneeint.poidsMotteMax = poidsMax;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            isModificationAConserver(context, widget.date, dateDebut, dateFin,
                isChecked, caracteristiquesJourneeint);
          },
        ),
        title: Text('Mise a jour des paramètres de la journée'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              '  Paramètres de la journée : ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SizedBox(width: 10),
                LabeledSwitch(
                  labelFalse: 'Journée chomée, pas de trituration:',
                  labelTrue: 'Journée de trituration:',
                  value: caracteristiquesJourneeint.chome,
                  onValueChanged: _updateJourChome,
                ),
              ],
            ),
            if (!caracteristiquesJourneeint.chome) ...[
              Row(
                children: [
                  SizedBox(width: 10),
                  NumberPicker(
                    initialCount: caracteristiquesJourneeint.nombreDeMotte,
                    texteDescription: 'Nombre de mottes :',
                    increment: 1,
                    valeurMax: 6,
                    valeurMin: 1,
                    unite: '',
                    onValueChanged: _updateNbMotte,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  NumberPicker(
                    initialCount: caracteristiquesJourneeint.poidsMotteMin,
                    texteDescription: 'Poids min d\'une motte :',
                    increment: 5,
                    valeurMax: caracteristiquesJourneeint.poidsMotteMax,
                    valeurMin: 120,
                    unite: 'kg',
                    onValueChanged: _updatePoidsMinMotte,
                  ),
                  SizedBox(width: 10),
                  Text('Poids min pour la journée : '
                      '''${caracteristiquesJourneeint.poidsMotteMin * caracteristiquesJourneeint.nombreDeMotte}'''
                      ' kg'),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  NumberPicker(
                    initialCount: caracteristiquesJourneeint.poidsMotteMax,
                    texteDescription: 'Poids max d\'une motte :',
                    increment: 5,
                    valeurMax: 300,
                    valeurMin: caracteristiquesJourneeint.poidsMotteMin,
                    unite: 'kg',
                    onValueChanged: _updatePoidsMaxMotte,
                  ),
                  SizedBox(width: 10),
                  Text('Poids max pour la journée : '
                      '''${caracteristiquesJourneeint.poidsMotteMax * caracteristiquesJourneeint.nombreDeMotte}'''
                      ' kg'),
                ],
              ),
            ],
            SizedBox(height: 10),
            if (Agenda.instance
                .getJournee(widget.date)
                .caracteristiquesJournee
                .chome) ...[
              Text(
                '  Appliquer ce paramètre à : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ] else ...[
              Text(
                '  Appliquer ces paramètres à : ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 10),
                Radio<DeploiementConfiguration>(
                  value: DeploiementConfiguration.journee,
                  groupValue: _deploiement,
                  onChanged: (DeploiementConfiguration? value) {
                    setState(() {
                      _deploiement = value;
                    });
                  },
                ),
                Text.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: " seulement à la journée du ",
                      style: TextStyle(
                        color: _deploiement == DeploiementConfiguration.journee
                            ? Colors.black
                            : Colors.grey,
                      ), // Texte grisé si désactivé
                    ),
                    TextSpan(
                        text: DateUtilitaire.date2String(widget.date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              _deploiement == DeploiementConfiguration.journee
                                  ? Colors.black
                                  : Colors.grey,
                        ) // Texte grisé si désactivé),
                        ),
                    TextSpan(
                      text: '.',
                    ),
                  ],
                )),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Radio<DeploiementConfiguration>(
                  value: DeploiementConfiguration.periode,
                  groupValue: _deploiement,
                  onChanged: (DeploiementConfiguration? value) {
                    setState(() {
                      _deploiement = value;
                    });
                  },
                ),
                DatePicker(
                  texteDescription: ' sur la période du ',
                  isEnabled: _deploiement == DeploiementConfiguration.periode,
                  date: dateDebut,
                  dateMin: currentDate,
                  dateMax: dateFin,
                  onValueChanged: _updateDateDebut,
                ),
                DatePicker(
                  texteDescription: ' au ',
                  isEnabled: _deploiement == DeploiementConfiguration.periode,
                  date: dateFin,
                  dateMin: dateDebut,
                  dateMax: DateTime(
                      Agenda.instance.anneeAgenda,
                      Agenda.instance.moisDebutAgenda +
                          Agenda.instance.nbMoisAgenda,
                      1),
                  onValueChanged: _updateDateFin,
                ),
                SizedBox(width: 10),
                Text.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: '.',
                    ),
                  ],
                )),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 160),
                for (int i = 0; i < daysOfWeek.length; i++)
                  Column(
                    children: [
                      Text(
                        daysOfWeek[i],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              _deploiement == DeploiementConfiguration.periode
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      Checkbox(
                        value: isChecked[i],
                        onChanged: (_deploiement ==
                                    DeploiementConfiguration.periode) &&
                                (Agenda.instance.listeJourSemaineSurPeriode(
                                    dateDebut, dateFin)[i])
                            ? (bool? value) {
                                setState(() {
                                  isChecked[i] = value!;
                                });
                              }
                            : null,
                      )
                    ],
                  ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    isModificationAConserver(context, widget.date, dateDebut,
                        dateFin, isChecked, caracteristiquesJourneeint);
                    print("Annuler");
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text('Annuler'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Maj de l'agenda.
                    Agenda.instance.majCaracteristiquesJournee(dateDebut,
                        dateFin, isChecked, caracteristiquesJourneeint);
                    // Notifie les listeners si nécessaire
                    context.read<MyAppState>().majCaracteristiquesJournee();
                    // Retourne à la page précédente .
                    Navigator.pop(context);

                    print("Sauvegarder");
                  },
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.edit),
                  label: Text('Sauvegarder'),
                ),
              ),
            ]),
          ]),
    );
  }
}