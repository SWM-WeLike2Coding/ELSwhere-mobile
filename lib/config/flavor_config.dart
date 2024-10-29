import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../flavors.dart';

class Config {
  final String baseUrl;
  final String loginEndpoint;

  Config._dev()
      : baseUrl = dotenv.env['ELS_BASE_URL_DEV']!,
        loginEndpoint = dotenv.env['ELS_LOGIN_ENDPOINT']!;

  Config._prod()
      : baseUrl = dotenv.env['ELS_BASE_URL_PROD']!,
        loginEndpoint = dotenv.env['ELS_LOGIN_ENDPOINT']!;

  factory Config(Flavor? flavor) {
    switch (flavor) {
      case Flavor.dev:
        _instance = Config._dev();
        break;
      case Flavor.prod:
        _instance = Config._prod();
        break;
      default:
        _instance = Config._dev();
        break;
    }
    return instance;
  }

  static Config? _instance;
  static Config get instance => _instance ?? Config(F.appFlavor ?? Flavor.dev);
}
