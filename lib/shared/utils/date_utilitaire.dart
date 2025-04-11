import 'package:app_a_o_c/shared/utils/app_config.dart';
import 'package:intl/intl.dart';

class DateUtilitaire{
static DateTime addOneDay(DateTime date) {
    return DateTime(date.year, date.month, date.day + 1);
  }

 static String jourDeLaSemaine(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

 static String date2String(DateTime date) {
    return '${DateFormat('EEEE').format(date)} ${DateFormat('d').format(date)} ${DateFormat('MMMM').format(date)}';
  }

static  String dateDuJour() {
    DateTime date = currentDate;
    return date2String(date);
  }
}