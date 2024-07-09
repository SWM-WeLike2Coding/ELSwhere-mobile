import 'package:elswhere/providers/els_product_provider.dart';
import 'package:elswhere/resources/app_resource.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ELSProductDetailView extends StatefulWidget {
  const ELSProductDetailView({super.key});

  @override
  State<ELSProductDetailView> createState() => _ELSProductDetailViewState();
}

class _ELSProductDetailViewState extends State<ELSProductDetailView> {
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
              Consumer<ELSProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading && productProvider.product == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (productProvider.product == null) {
                    return const Center(child: Text('상품이 존재하지 않습니다.'));
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          Card(
                            child: const Placeholder(),
                          ),
                          const SizedBox(width: 20,),
                          Card(
                            child: const Placeholder(),
                          )
                        ],
                      )
                    ],
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
