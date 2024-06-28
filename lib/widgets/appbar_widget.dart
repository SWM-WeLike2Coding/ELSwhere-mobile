import 'package:flutter/material.dart';

class AppBarWidget extends AppBar{
  AppBarWidget._privateConstructor();
  static final _appBar = AppBarWidget._privateConstructor();
  factory AppBarWidget() {
    return _appBar;
  }
}
