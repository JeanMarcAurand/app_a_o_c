import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  final String texteDescription;
  final int initialCount;
  final int valeurMax;
  final int valeurMin;
  final int increment;
  final String unite;

  final Function(int) onValueChanged;

  // Constructeur avec paramètres obligatoires
  const NumberPicker({
    super.key,
    required this.texteDescription,
    required this.initialCount,
    required this.valeurMax,
    required this.valeurMin,
    required this.increment,
    required this.unite,
    required this.onValueChanged,
  });
  @override
  NumberPickerState createState() => NumberPickerState();
}

class NumberPickerState extends State<NumberPicker> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    _counter = widget.initialCount; // Initialise une seule fois
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.texteDescription, // Affichage du nombre
            //style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_counter > widget.valeurMin) {
                  _counter -= widget.increment; // Empêche d'aller en négatif
                }
              });
              widget.onValueChanged(_counter);
            },
            child: Icon(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '$_counter ${widget.unite}', // Affichage du nombre
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_counter < widget.valeurMax) {
                  _counter += widget.increment;
                }
              });
              widget.onValueChanged(_counter);
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
