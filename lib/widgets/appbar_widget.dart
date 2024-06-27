import 'package:flutter/material.dart';

import '../resources/app_resource.dart';

class AppBarWidget extends AppBar{
  AppBarWidget._privateConstructor();
  static final _appBar = AppBarWidget._privateConstructor();
  factory AppBarWidget() {
    return _appBar;
  }
}
