import 'package:elswhere/providers/els_product_provider.dart';
import 'package:elswhere/resources/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../views/els_product_detail_view.dart';

class ELSProductDetailScreen extends StatefulWidget {
  const ELSProductDetailScreen({super.key});

  @override
  State<ELSProductDetailScreen> createState() => _ELSProductDetailScreenState();
}

class _ELSProductDetailScreenState extends State<ELSProductDetailScreen> {
  bool isLiked = false;
  bool isStared = false;

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
        title: Text(
          "상품 상세 정보",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: edgeInsetsAll16,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "상품 정보",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          icon: isLiked
                              ? const Icon(Icons.thumb_up_alt)
                              : const Icon(Icons.thumb_up_alt_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isStared = !isStared;
                            });
                          },
                          icon: isStared
                              ? const Icon(Icons.star)
                              : const Icon(Icons.star_border),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              // minimumSize: Size.zero,
                              ),
                          child: Text(
                            "VS",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ELSProductDetailView(constraints: constraints),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCompanyCard(BoxConstraints constraints) {
    final height = constraints.maxHeight;
    final width = constraints.maxWidth;
    return SizedBox(
      height: height / 6,
      width: width / 2 - 30,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular10),
        color: AppColors.blues2,
        child: Container(
          padding: edgeInsetsAll16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Hello'),
            ],
          ),
        ),
      ),
    );
  }
}
