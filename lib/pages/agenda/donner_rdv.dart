import 'package:app_a_o_c/shared/utils/date_utilitaire.dart';
import 'package:app_a_o_c/shared/widgets/app_card.dart';
import 'package:app_a_o_c/shared/widgets/app_divider.dart';
import 'package:app_a_o_c/shared/widgets/app_slider.dart';
import 'package:app_a_o_c/shared/widgets/date_picker.dart';
import 'package:flutter/material.dart';

enum TypeDateRDV { plusProche, libreChoix }


class DonnerRDV extends StatefulWidget {
  @override
  State<DonnerRDV> createState() => DonnerRDVState();
}

class DonnerRDVState extends State<DonnerRDV> {
    TypeDateRDV? _typeDateRDV = TypeDateRDV.plusProche;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donner un rendez-vous',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Row(
        children: [
          Expanded(
            child: AppCard(
              child: Column(
                children: [
                  AppSlider(
                    texteDescription: "Réservation pour: ",
                    textUnite: "kg",
                  ),
                  AppDivider(),
                  Text(
                    "Date:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                                  Row(
                  children: [
                    SizedBox(width: 10),
                    Radio<TypeDateRDV>(
                      value: TypeDateRDV.plusProche,
                      groupValue: _typeDateRDV,
                      onChanged: (TypeDateRDV? value) {
                        setState(() {
                          _typeDateRDV = value;
                        });
                      },
                    ),
                    Text.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: " Date la plus proche ",
                          style: TextStyle(
                            color:
                                _typeDateRDV == TypeDateRDV.plusProche
                                    ? null
                                    : Colors.grey,
                          ), // Texte grisé si désactivé
                        ),
                        TextSpan(
                            text: "date la plus proche",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _typeDateRDV ==
                                      TypeDateRDV.plusProche
                                  ? null
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
                    Radio<TypeDateRDV>(
                      value: TypeDateRDV.libreChoix,
                      groupValue: _typeDateRDV,
                      onChanged: (TypeDateRDV? value) {
                        setState(() {
                          _typeDateRDV = value;
                        });
                      },
                    ),

                    SizedBox(width: 10),
                    
                  ],
                ),
                  AppDivider(),
                ],
              ),
            ),
          ),
          Expanded(
            child: AppCard(
              child: Column(
                children: [
                  Text(
                    "Récapitulation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
