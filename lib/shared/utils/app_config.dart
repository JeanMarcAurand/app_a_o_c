class AppConfig {
  static DateTime? testDate=DateTime.utc(2024, 12, 15); // Simule le 15 décembre 2024
 // static DateTime? testDate=null; // null = utilise la vraie date

}

DateTime get currentDate => AppConfig.testDate ?? DateTime.now();