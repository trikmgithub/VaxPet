import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }

    return '.env.development';
  }

  static String get MAPBOX_KEY {
    return dotenv.env['MAPBOX_KEY'] ?? 'pk.eyJ1IjoiY2hyaXMyMzQyMzQiLCJhIjoiY21kYWlmaTZtMGtpMTJscTBqOTZmODZjNiJ9.YgoJGTeLCV3mAvtOcK03bQ';
  }

  static String get API_URL {
    return dotenv.env['API_URL'] ?? 'https://petvax-dva5eufae0brhdgf.eastasia-01.azurewebsites.net/';
  }
}