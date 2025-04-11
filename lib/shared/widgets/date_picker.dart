import 'package:app_a_o_c/shared/utils/date_utilitaire.dart';
import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final String texteDescription;
  final bool isEnabled;
  final DateTime date;
  final DateTime dateMin;
  final DateTime dateMax;
  final Function(DateTime) onValueChanged;

  // Constructeur avec paramètres obligatoires
  const DatePicker({
    super.key,
    required this.texteDescription,
    required this.isEnabled,
    required this.date,
    required this.dateMin,
    required this.dateMax,
    required this.onValueChanged,
  });
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime selectedDate = currentDate;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.date; // Initialise une seule fois
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: widget.dateMin,
      lastDate: widget.dateMax,
      locale: Locale('fr', 'FR'),
      helpText: '',
    );
    if (pickedDate != null) {
      widget.onValueChanged(pickedDate);
    }
    setState(() {
      if (pickedDate != null) {
        selectedDate = pickedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.texteDescription,
              style: TextStyle(
                color: widget.isEnabled ? null : Colors.grey,
              ), // Texte grisé si désactivé),
            ),
          ],
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
          onPressed: widget.isEnabled
              ? () {
                  _selectDate();
                }
              : null,
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: DateUtilitaire.date2String(selectedDate),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.calendar_month),
              SizedBox(width: 10),
            ],
          )),
    ]);
  }
}
