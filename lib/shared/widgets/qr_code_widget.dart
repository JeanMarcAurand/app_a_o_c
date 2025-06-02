import 'package:app_a_o_c/features/adherents/liste_adherents.dart';
import 'package:app_a_o_c/main.dart';
import 'package:app_a_o_c/shared/widgets/app_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Adherent localCurrentAd = appState.adherentQRCode;
    String texteTel = "Pas de numéro de tel pour cet adhérent.";
    String noTel = "";
    if (localCurrentAd.noTelephonePortable.isNotEmpty) {
      noTel = 'tel:${localCurrentAd.noTelephonePortable}';
      texteTel =
          ' Pour contacter le ${localCurrentAd.noTelephonePortable} flasher:';
    } else {
      if (localCurrentAd.noTelephoneFixe.isNotEmpty) {
        noTel = 'tel:${localCurrentAd.noTelephoneFixe}';
        texteTel =
            ' Pour contacter le ${localCurrentAd.noTelephoneFixe} flasher:';
      } else {
        noTel = "";
        texteTel = " Pas de numéro de téléphone pour cet adhérent.";
      }
    }
    String texteMail = " Pas d'adresse mail pour cet adhérent.";
    String mail = "";
    if (localCurrentAd.adresseMail.isNotEmpty) {
      mail =
          'mailto:${localCurrentAd.adresseMail}?subject=Moulin%20de%20Callian.&body=%20%20Bonjour!%0A%0A%0A%0A%20%20Le moulin de Callian%0A';
      texteMail = ' Pour contacter ${localCurrentAd.adresseMail} flasher:';
    } else {
      mail = "";
      texteMail = " Pas d'adresse mail pour cet adhérent.";
    }

    return Expanded(
      // Empêche l'erreur en donnant une hauteur disponible.
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${localCurrentAd.civilite} ${localCurrentAd.nom}',
                style: TextStyle(fontSize: 24),
              ),
              Text('${localCurrentAd.noRue} ${localCurrentAd.adresse}'),
              Text('${localCurrentAd.codePostal} ${localCurrentAd.commune}'),
              AppDivider(),
              Text(texteTel),
              if (noTel.isNotEmpty)
                QrImageView(
                  data: noTel,
                  version: QrVersions.auto,
                  size: 100,
                  gapless: false,
                  backgroundColor: Colors.white,
                ),
              AppDivider(),
              Text(texteMail),
              if (mail.isNotEmpty)
                QrImageView(
                  data: mail,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                  backgroundColor: Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
