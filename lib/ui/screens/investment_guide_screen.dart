import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/data/models/dtos/post_dto.dart';
import 'package:elswhere/ui/widgets/post_card.dart';
import 'package:flutter/material.dart';

class InvestmentGuideScreen extends StatefulWidget {
  const InvestmentGuideScreen({super.key});

  @override
  State<InvestmentGuideScreen> createState() => _InvestmentGuideScreenState();
}

class _InvestmentGuideScreenState extends State<InvestmentGuideScreen> {
  List<PostDto> postList = [
    PostDto(
      title: "ELS가 무엇인가요?",
      content:
          "ELS(Equity Linked Securities)는 주가 연계 증권을 의미하며, 특정 주식이나 주가지수의 변동에 따라 수익이 결정되는 금융 상품입니다.\n\n일반적으로 ELS는 원금보장이 되지 않지만, 일정 조건을 충족하면 높은 수익을 기대할 수 있습니다.\n\n투자자는 주식시장에 직접 투자하는 것보다 낮은 리스크로 주식시장의 성과에 참여할 수 있으며, 만기 시 원금 손실이 발생할 수도 있지만, 다양한 조건을 통해 투자자의 리스크를 분산하고 관리할 수 있습니다. ELS는 다양한 투자 전략과 조건을 통해 투자자의 다양한 수익 목표를 충족시킬 수 있는 유연한 금융 상품입니다.",
      type: "guide",
      createdAt: DateTime(2024, 8, 11),
      imagePath: "assets/images/image_ELS_intro.jpg",
    ),
    PostDto(
      title: "ELS 상품 유형에 대해 알려주세요.",
      content:
          "스텝다운형 ELS: 스텝다운형 ELS는 주가가 일정 범위 내에 유지될 경우 수익률이 단계적으로 증가하는 구조를 가진 ELS입니다. 일정 기간 동안 주가가 기준 이상으로 유지되면 수익률이 증가하며, 일정 기간 후에는 수익률이 감소할 수 있습니다.\n\n낙아웃형 ELS: 낙아웃형 ELS는 주가가 사전에 설정된 특정 가격 이하로 떨어지면 자동으로 원금 손실이 발생하는 구조를 가진 ELS입니다. 주가가 일정 가격 이하로 하락하면 ELS는 조기 만기되고, 손실이 발생할 수 있습니다.\n\n월지급형 ELS: 월지급형 ELS는 정기적으로 월 단위로 수익금을 지급하는 구조를 가진 ELS입니다. 일반적으로 매월 고정된 금액이나 수익률을 지급합니다.\n\n리자드형 ELS: 리자드형 ELS는 주식의 가격이 일정 범위 내에서 움직일 때 수익이 발생하며, 일정 범위를 벗어날 경우 원금 손실이 발생하는 구조를 가진 ELS입니다. 보통 리자드형 ELS는 주가가 범위 내에 있으면 수익을 지급하고, 범위를 벗어나면 손실을 보게 됩니다.",
      type: "guide",
      createdAt: DateTime(2024, 8, 11),
    ),
    PostDto(
      title: "상품 투자 시 고려 사항에는 어떤 것이 있나요?",
      content:
          "기초 자산: ELS는 특정 주식, 주가지수 또는 여러 자산의 성과에 따라 수익이 결정됩니다. 기초 자산의 성격과 과거 성과를 분석하여 투자 리스크를 평가해야 합니다.\n\n성과 조건: ELS의 수익 구조는 기초 자산의 성과에 따라 결정됩니다. 성과 조건(예: 주가가 특정 범위 내에 있어야 한다거나, 특정 기준 이상이어야 한다 등)을 명확히 이해하고, 기초 자산의 변동성이 성과 조건에 미치는 영향을 분석합니다.\n\n수익 구조: ELS는 다양한 수익 구조를 가질 수 있습니다. 예를 들어, 스텝다운형은 일정 기간 동안 주가가 일정 범위 내에 있을 경우 수익률이 증가하고, 낙아웃형은 특정 주가 수준 이하로 떨어질 경우 손실이 발생합니다. 각 구조의 수익 방식과 조건을 이해합니다.\n\n리스크: ELS는 원금 손실의 위험이 있습니다. 특히 낙아웃형 ELS는 주가가 설정된 기준 이하로 하락하면 원금 손실이 발생할 수 있습니다. ELS의 리스크를 평가하고, 자신이 감당할 수 있는 리스크 범위를 확인합니다.\n\n만기: ELS는 일반적으로 만기일이 있으며, 만기 시 기초 자산의 성과에 따라 수익이 결정됩니다. 만기일까지의 투자 기간을 고려하여 투자 계획을 세웁니다.\n\n조기 상환: 일부 ELS는 조기 상환 옵션이 있습니다. 조기 상환 조건과 그로 인해 발생할 수 있는 수익 변동을 이해하고, 조기 상환이 투자 전략에 미치는 영향을 분석합니다.\n\n세금: ELS의 수익은 자본 이득세의 대상이 될 수 있습니다. 세금 규정을 확인하고, 세금 부담을 고려한 투자 결정을 내립니다.\n\n수수료: ELS를 거래할 때 발생하는 수수료나 비용(예: 판매 수수료, 관리 수수료 등)을 이해하고, 수수료가 수익에 미치는 영향을 분석합니다.\n\n환매 조건: 일부 ELS는 시장에서 거래가 불가능할 수 있으며, 만기 전 환매가 어려울 수 있습니다. 환매 조건과 환매 가능성에 대해 확인합니다.\n\n발행사: ELS는 금융기관이 발행하며, 발행사의 신뢰도와 재무 건전성을 평가해야 합니다. 발행사의 신용 상태가 ELS의 리스크에 영향을 미칠 수 있습니다.\n\n투자 목적: ELS의 투자 목적(예: 고수익 추구, 자산 배분 등)에 맞는 상품을 선택합니다. 투자 목적에 따라 적합한 ELS를 선택하고, 목표와 일치하는 상품을 결정합니다.\n\n투자 기간: ELS의 만기 기간과 자신이 계획한 투자 기간이 일치하는지 확인합니다. 투자 기간에 맞는 ELS를 선택하여 유동성과 자금 필요성에 맞게 투자 계획을 세웁니다.\n\n시장 동향: 기초 자산의 시장 동향과 경제 전반의 영향을 분석합니다. 기초 자산의 시장 상황이 ELS의 성과에 영향을 미칠 수 있습니다.\n\n경제 상황: 경제 지표와 정책 변화가 기초 자산에 미치는 영향을 고려하고, 경제 상황에 따른 리스크를 평가합니다.",
      type: "guide",
      createdAt: DateTime(2024, 8, 11),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopContent(),
          _buildPostCards(postList),
        ],
      ),
    );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: AppColors.gray50,
          width: 1,
        ))),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0), // 좌측 패딩을 추가
            child: Align(
              alignment: Alignment.center, // 아이콘을 수직 가운데 정렬
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: const Text(
            "투자가이드",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
      child: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1C6BF9),
            ),
            width: 18,
            height: 18,
            child: const Center(
              child: Text(
                "?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                  height: 16.52 / 14,
                  letterSpacing: -0.02,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            "자주 묻는 질문",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 18.88 / 16,
              letterSpacing: -0.02,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPostCards(List<PostDto> posts) {
    print(posts.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: posts.asMap().entries.map((entry) {
        int index = entry.key;

        return Column(
          children: [
            PostCard(post: posts[index]),
            if (index < posts.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  height: 1.0,
                  color: AppColors.gray50,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
