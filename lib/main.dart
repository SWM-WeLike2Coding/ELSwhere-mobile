import 'package:elswhere/resources/app_resource.dart';
import 'package:elswhere/views/els_list_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ELSwhere());
}

class ELSwhere extends StatelessWidget {
  const ELSwhere({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
      home: ELSListView(),
    );
  }
}
