import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/ui/screens/attention_setting_screen.dart';
import 'package:elswhere/ui/views/els_product_list_view.dart';
import 'package:flutter/material.dart';

// 이슈들
// 1. 피그마에서 우측 상단에 '+' 버튼이 있는데 어떤 역할을 하는건지 모르겠음


class AttentionProductsScreen extends StatefulWidget {
  const AttentionProductsScreen({super.key});

  @override
  State<AttentionProductsScreen> createState() => _AttentionProductsScreenState();
}

class _AttentionProductsScreenState extends State<AttentionProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttentionSettingScreen()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body:
        Padding(
          padding: edgeInsetsAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '관심상품',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12,),
              Card(
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AttentionSettingScreen()),
                    );
                  },
                  child: Container(
                    padding: edgeInsetsAll12,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFA4C1FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: borderRadiusCircular10,
                    ),
                    child: Center(
                      child:
                        Text(
                          "원하는 조건을 등록하고\n관심상품 알림을 받아보세요.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF444444),
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
                  ),
                ),
              ),
              ELSProductListView(type: "latest"),
            ],
          ),
        )
    );
  }
}
