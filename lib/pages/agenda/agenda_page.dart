import 'package:app_a_o_c/pages/agenda/donner_rdv.dart';
import 'package:app_a_o_c/pages/agenda/filtre_config_generale.dart';
import 'package:app_a_o_c/pages/agenda/modification_config_generale/modification_config_generale.dart';
import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:app_a_o_c/shared/utils/date_utilitaire.dart';
import 'package:app_a_o_c/shared/widgets/app_card.dart';
import 'package:app_a_o_c/shared/widgets/app_divider.dart';
import 'package:app_a_o_c/shared/widgets/app_slider.dart';
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
                      AppCard(
                        child: CalendarScreen(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Empêche l'erreur en donnant une hauteur disponible.
                  child: AppCard(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        FiltreConfigGenerale(),
                        AppDivider(),
                        AppSlider(texteDescription:"Rendez-vous possibles pour: ", textUnite: "kg",),
                        AppDivider(),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DonnerRDV();
                                },
                              ),
                            );
                          },
                          iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.calendar_month),
                          label: Text('Donner un RDV'),
                          //  color: theme.colorScheme.primary,    // ← And also this.
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Informations générales.
            Expanded(
              child: AppCard(
                child: ListView(
                  children: [
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 16),
                        Text(
                            'Journée du ${DateUtilitaire.date2String(appState.dateSelectionnee)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    AppDivider(),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, //.spaceBetween,
                      children: [
                        SizedBox(width: 16),
                        Text('Configuration journée:',
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
                      ],
                    ),
                    if (!Agenda.instance
                        .isChome(appState.dateSelectionnee)) ...[
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // .spaceBetween,
                        children: [
                          SizedBox(width: 8),
                          Text(
                              'Nombre de mottes: ${Agenda.instance.nombreDeMotte(appState.dateSelectionnee)}.  Poids d\'une motte, min: ${Agenda.instance.poidsMinMotte(appState.dateSelectionnee)} kg, max: ${Agenda.instance.poidsMaxMotte(appState.dateSelectionnee)} kg'),
                        ],
                      ),
                      SizedBox(height: 8),
                      AppDivider(),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // .spaceBetween,
                        children: [
                          SizedBox(width: 16),
                          Text(
                              'Poids total réservé: ${Agenda.instance.poidsTotalJournee(appState.dateSelectionnee)} kg',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(height: 8),
                      AppDivider(),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 16),
                        Text(
                            Agenda.instance
                                .nombreDeRDV(appState.dateSelectionnee),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
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
//              color: /* Colors.grey[200],*/
              //(dateCourante.day)*3 pour simuler le capacite reserve dans journee.
//                  getBackgroundColor(day.day),

              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: getBorderColor(
                    day,
                    appState
                        .poidsPourRendezVous), //getBackgroundColor(day.day),     // couleur du contour
                width: 2.0, // épaisseur du contour
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day.day.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (_events[day] != null) ..._events[day]!,
                Text(
                  Agenda.instance.getCaracteritiqueForDay(
                      appState.filtrePourCalendier, day),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Color getBorderColor(DateTime day, int poidsRDV) {
  if (day.isBefore(currentDate) ||
      Agenda.instance.getJournee(day).caracteristiquesJournee.chome) {
    return Colors.grey;
  } else {
    CaracteristiquesJournee caracteristiquesJournee =
        Agenda.instance.getJournee(day).caracteristiquesJournee;

    int poidsDispo = caracteristiquesJournee.nombreDeMotte *
            caracteristiquesJournee.poidsMotteMax -
        caracteristiquesJournee.poidsTotalJournee;
    if (poidsDispo >= poidsRDV) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }
}

