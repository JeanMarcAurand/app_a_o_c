import 'package:flutter/material.dart';

class LabeledSwitch extends StatefulWidget {
  final String labelFalse;
  final String labelTrue;
  final bool value;
  final Function(bool) onValueChanged;

  //final ValueChanged<bool> onChanged;
  const LabeledSwitch({
    super.key,
    required this.labelFalse,
    required this.labelTrue,
    required this.value,
    required this.onValueChanged,
  });

  @override
  State<LabeledSwitch> createState() => _LabeledSwitchState();
}

class _LabeledSwitchState extends State<LabeledSwitch> {
  bool _isSelected = true;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.value; // Initialise une seule fois
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onValueChanged(_isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.all(
            4.0), //const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Text(
              _isSelected ?  widget.labelFalse : widget.labelTrue,
              style: TextStyle(
                color: _isSelected ? null : Colors.grey,
              ),
            ),
            Switch(
              value: _isSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _isSelected = newValue;
                });
                widget.onValueChanged(_isSelected);
              },
            ),
          ],
        ),
      ),
    );
  }
}
