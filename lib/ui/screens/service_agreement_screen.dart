import 'package:flutter/material.dart';

import '../../config/app_resource.dart';

class ServiceAgreementScreen extends StatefulWidget {
  final int typeIndex;
  const ServiceAgreementScreen({super.key, required this.typeIndex});

  @override
  State<ServiceAgreementScreen> createState() => _ServiceAgreementScreenState();
}

class _ServiceAgreementScreenState extends State<ServiceAgreementScreen> with TickerProviderStateMixin {
  late final TabController tabController;
  String _appBarTitle = "서비스 약관";

  void _handleTabSelection() {
    setState(() {
      if (tabController.index == 0) {
        _appBarTitle = "서비스 약관";
      } else {
        _appBarTitle = "개인 정보 처리 방침";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.typeIndex,
      animationDuration: const Duration(milliseconds: 300),
    );
    tabController.addListener(_handleTabSelection);
    _appBarTitle = tabController.index == 0 ? "서비스 약관" : "개인 정보 처리 방침";
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
            title: Text(
              _appBarTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
          ),
        ),
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(50), // TabBar의 전체 높이
            child: Padding(
              padding: edgeInsetsAll8,
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: "서비스 이용 약관"),
                  Tab(text: "개인 정보 처리 방침"),
                ],
                // labelPadding: EdgeInsets.symmetric(horizontal: 6), // 탭 사이의 패딩
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xFF1C6BF9), width: 1.5),
                ),
                // indicatorPadding: EdgeInsets.only(left: 24, right: 24), // 첫 번째 탭의 인디케이터 패딩
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: AppColors.contentBlack,
                labelStyle: Theme.of(context).textTheme.displayMedium,
                unselectedLabelColor: AppColors.gray400,
                unselectedLabelStyle: Theme.of(context).textTheme.displayMedium,
                overlayColor: const WidgetStatePropertyAll(AppColors.gray400),
                splashBorderRadius: BorderRadius.circular(10),
                indicatorSize: TabBarIndicatorSize.label, // 라벨 크기에 맞춰 인디케이터 표시
                // indicatorPadding: const EdgeInsets.symmetric(horizontal: 12),
                indicatorColor: AppColors.contentBlack,
                dividerColor: AppColors.gray100,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                UsageAgreement(),
                PrivacyPolicy(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UsageAgreement extends StatelessWidget {
  const UsageAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: edgeInsetsAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "제 1 조 (목적)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            Text(
              "본 약관은 ELS 상품을 소개하는 앱(이하 \"앱\")을 이용함에 있어 회사와 이용자의 권리, 의무 및 책임 사항을 규정하는 것을 목적으로 합니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 2 조 (용어의 정의)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedList([
              "\"회사\"라 함은 ELS 상품을 소개하는 앱을 운영하는 주체를 말합니다.",
              "”이용자”라 함은 본 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 말합니다.",
              "”서비스”라 함은 회사가 제공하는 ELS 상품 정보 및 관련 부가 서비스를 의미합니다.",
            ]),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 3 조 (약관의 게시 및 변경)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedList([
              "본 약관은 앱 내에 게시함으로써 효력이 발생합니다.",
              "회사는 필요에 따라 약관을 변경할 수 있으며, 변경된 약관은 앱 내에 게시함으로써 효력이 발생합니다.",
              "이용자는 변경된 약관에 동의하지 않을 권리가 있으며, 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.",
            ]),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 4 조 (서비스의 제공)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedList([
              "회사는 이용자에게 다음과 같은 서비스를 제공합니다. a. ELS 상품 정보 제공 b. 투자 관련 뉴스 및 자료 제공 c. 기타 회사가 정하는 서비스",
              "서비스는 연중무휴 24시간 제공함을 원칙으로 합니다. 다만, 회사의 사정으로 인한 서비스 중단 시 사전에 공지합니다.",
            ]),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 5 조 (이용자의 의무)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedList([
              "이용자는 본 약관 및 관련 법령을 준수하여야 합니다.",
              "이용자는 타인의 권리나 명예를 침해하는 행위를 해서는 안 됩니다.",
              "이용자는 허위 정보를 제공하거나 부정한 방법으로 서비스를 이용해서는 안 됩니다.",
            ]),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 6 조 (회사의 의무)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedList([
              "회사는 이용자에게 안정적인 서비스를 제공하기 위해 최선을 다합니다",
            ]),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: edgeInsetsAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "제 1 조 (목적)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            Text(
              "본 방침은 ELS 상품을 소개하는 앱(이하 \"앱\")을 이용하는 이용자의 개인 정보를 보호하기 위해 회사가 취하는 조치와 이용자의 권리, 회사의 의무를 규정하는 것을 목적으로 합니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 2 조 (수집하는 개인 정보의 항목 및 수집 방법)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            OrderedListItem(
              1,
              "수집하는 개인 정보의 항목",
            ),
            Padding(
              padding: EdgeInsets.only(left: 24),
              child: UnorderedList([
                "필수 정보: 이름, 이메일 주소, 전화번호, 생년월일, 성별",
                "선택 정보: 투자 성향, 관심 상품 자동 수집 정보: 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보",
              ]),
            ),
            OrderedListItem(
              2,
              "수집 방법",
            ),
            Padding(
              padding: EdgeInsets.only(left: 24),
              child: UnorderedList([
                "회원 가입 및 서비스 이용 과정에서 이용자가 직접 입력",
                "서비스 이용 과정에서 자동으로 수집",
              ]),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 3 조 (개인 정보의 수집 및 이용 목적)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            Text(
              "회사는 수집한 개인 정보를 다음의 목적을 위해 이용합니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: UnorderedList([
                "서비스 제공 및 운영: ELS 상품 정보 제공, 맞춤형 추천 서비스",
                "고객 관리: 회원 관리, 서비스 이용에 관한 상담 및 문의 처리",
                "마케팅 및 광고: 이벤트 및 광고성 정보 제공, 이용자의 서비스 이용에 대한 통계 분석",
              ]),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 4 조 (개인 정보의 보유 및 이용 기간)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            Text(
              "회사는 이용자의 개인 정보를 원칙적으로 개인 정보의 수집 및 이용 목적이 달성된 후에는 지체 없이 파기합니다. 단, 관련 법령에 따라 보관할 필요가 있는 경우 회사는 해당 법령에서 정한 기간 동안 개인 정보를 보관합니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: UnorderedList([
                "계약 또는 청약철회 등에 관한 기록: 5년",
                "소비자의 불만 또는 분쟁 처리에 관한 기록: 3년",
                "웹사이트 방문 기록: 6개월",
              ]),
            ),
            Text(
              "이용자는 허위 정보를 제공하거나 부정한 방법으로 서비스를 이용해서는 안 됩니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "제 6 조 (회사의 의무)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434648),
              ),
            ),
            Text(
              "회사는 이용자에게 안정적인 서비스를 제공하기 위해 최선을 다합니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF434648),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderedList extends StatelessWidget {
  const OrderedList(this.texts, {super.key});
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    int i = 1;
    for (var text in texts) {
      // Add list item
      widgetList.add(OrderedListItem(i, text));
      i += 1;
    }

    return Column(children: widgetList);
  }
}

class OrderedListItem extends StatelessWidget {
  const OrderedListItem(this.number, this.text, {super.key});
  final String text;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$number .  ",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF434648),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF434648),
            ),
          ),
        ),
      ],
    );
  }
}

class UnorderedList extends StatelessWidget {
  const UnorderedList(this.texts, {super.key});
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "•  ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF434648),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF434648),
            ),
          ),
        ),
      ],
    );
  }
}
