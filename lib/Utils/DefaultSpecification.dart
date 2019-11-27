import 'package:intl/intl.dart';

class DefaultSpecification {
  static String dateFormat(DateTime time) =>
      DateFormat("dd-MM-yyyy").format(time);
}