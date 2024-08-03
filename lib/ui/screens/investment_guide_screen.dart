import 'package:flutter/material.dart';

class InvestmentGuideScreen extends StatefulWidget {
  const InvestmentGuideScreen({super.key});

  @override
  State<InvestmentGuideScreen> createState() => _InvestmentGuideScreenState();
}

class _InvestmentGuideScreenState extends State<InvestmentGuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF5F6F6),
                      width: 1,
                    )
                )
            ),
            child: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
                child: Align(
                  alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              title: Text(
                "투자가이드",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              centerTitle: false,
            ),
          ),
        ),
        body: Center(
          child: Text("투자가이드"),
        )
    );
  }
}
