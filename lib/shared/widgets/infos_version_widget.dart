
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfosVersionWidget extends StatelessWidget {
  const InfosVersionWidget({super.key});

  Future<PackageInfo> _loadPackageInfo() => PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _loadPackageInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement...");
        } else if (snapshot.hasError) {
          return const Text("Erreur de version");
        } else if (!snapshot.hasData) {
          return const Text("Pas de données");
        }

        final info = snapshot.data!;
        return Text(
            "Version ${info.appName} : ${info.version} (build ${info.buildNumber})");
      },
    );
  }
}
