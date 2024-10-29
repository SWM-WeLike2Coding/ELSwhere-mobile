enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ELSwhere-DEV';
      case Flavor.prod:
        return 'ELSwhere';
      default:
        return 'title';
    }
  }

}
