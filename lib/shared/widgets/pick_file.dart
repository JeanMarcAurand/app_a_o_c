import 'package:file_picker/file_picker.dart';

Future<String?> pickFile(String path, String type) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: [type],
    initialDirectory: path,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    print('Nom du fichier : ${file.name}');
    print('Chemin du fichier : ${file.path}');
    return file.path;
  } else {
    // L'utilisateur a annulé la sélection
    return null;
  }
}
