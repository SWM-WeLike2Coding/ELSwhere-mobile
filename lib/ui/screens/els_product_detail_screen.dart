import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/views/els_product_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ELSProductDetailScreen extends StatefulWidget {
  const ELSProductDetailScreen({super.key});

  @override
  State<ELSProductDetailScreen> createState() => _ELSProductDetailScreenState();
}

class _ELSProductDetailScreenState extends State<ELSProductDetailScreen> {
  bool isLiked = false;
  bool isBookmarked = false;

  void changeLiked() => setState(() => isLiked = !isLiked);
  void changeBookmarked() => setState(() => isBookmarked = !isBookmarked);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Padding(
          padding: edgeInsetsAll8,
          child: AppBar(
            backgroundColor: AppColors.backgroundGray,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: AppColors.contentWhite,
                  child: isLiked
                      ? const Icon(Icons.favorite, color: AppColors.contentRed)
                      : const Icon(Icons.favorite_border_outlined),
                ),
                onPressed: changeLiked,
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: AppColors.contentWhite,
                  child: isBookmarked
                      ? const Icon(Icons.bookmark, color: AppColors.contentYellow)
                      : const Icon(Icons.bookmark_border_outlined),
                ),
                onPressed: changeBookmarked,
              ),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: AppColors.contentWhite,
                  child: const Icon(Icons.add),
                ),
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ELSProductDetailView(),
      ),
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
