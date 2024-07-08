import 'package:elswhere/resources/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ELSProductDetailView extends StatelessWidget {
  const ELSProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("상품 상세 정보"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: edgeInsetsAll16,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "상품 정보",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
