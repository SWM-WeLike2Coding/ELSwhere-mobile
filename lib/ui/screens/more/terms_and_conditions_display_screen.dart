import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../../config/app_resource.dart';

class TermsAndConditionsDisplayScreen extends StatefulWidget {
  final int typeIndex;
  const TermsAndConditionsDisplayScreen({super.key, required this.typeIndex});

  @override
  State<TermsAndConditionsDisplayScreen> createState() => _TermsAndConditionsDisplayScreenState();
}

class _TermsAndConditionsDisplayScreenState extends State<TermsAndConditionsDisplayScreen> with TickerProviderStateMixin {
  late final TabController tabController;
  String _appBarTitle = "서비스 약관";

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> _setCurrentScreen() async {
    await analytics.logScreenView(
      screenName: '서비스 이용 약관 동의 화면',
      screenClass: 'ServiceAgreementScreen',
    );
  }

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
    _setCurrentScreen();
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
                  borderSide: BorderSide(color: AppColors.mainBlue, width: 1.5),
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
    return SingleChildScrollView(
      child: Padding(
        padding: edgeInsetsAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "제 1 조 (목적)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Text(
            //   "본 약관은 ELS 상품을 소개하는 앱(이하 \"앱\")을 이용함에 있어 회사와 이용자의 권리, 의무 및 책임 사항을 규정하는 것을 목적으로 합니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 2 조 (용어의 정의)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedList([
            //   "\"회사\"라 함은 ELS 상품을 소개하는 앱을 운영하는 주체를 말합니다.",
            //   "”이용자”라 함은 본 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 말합니다.",
            //   "”서비스”라 함은 회사가 제공하는 ELS 상품 정보 및 관련 부가 서비스를 의미합니다.",
            // ]),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 3 조 (약관의 게시 및 변경)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedList([
            //   "본 약관은 앱 내에 게시함으로써 효력이 발생합니다.",
            //   "회사는 필요에 따라 약관을 변경할 수 있으며, 변경된 약관은 앱 내에 게시함으로써 효력이 발생합니다.",
            //   "이용자는 변경된 약관에 동의하지 않을 권리가 있으며, 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.",
            // ]),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 4 조 (서비스의 제공)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedList([
            //   "회사는 이용자에게 다음과 같은 서비스를 제공합니다. a. ELS 상품 정보 제공 b. 투자 관련 뉴스 및 자료 제공 c. 기타 회사가 정하는 서비스",
            //   "서비스는 연중무휴 24시간 제공함을 원칙으로 합니다. 다만, 회사의 사정으로 인한 서비스 중단 시 사전에 공지합니다.",
            // ]),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 5 조 (이용자의 의무)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedList([
            //   "이용자는 본 약관 및 관련 법령을 준수하여야 합니다.",
            //   "이용자는 타인의 권리나 명예를 침해하는 행위를 해서는 안 됩니다.",
            //   "이용자는 허위 정보를 제공하거나 부정한 방법으로 서비스를 이용해서는 안 됩니다.",
            // ]),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 6 조 (회사의 의무)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedList([
            //   "회사는 이용자에게 안정적인 서비스를 제공하기 위해 최선을 다합니다",
            // ]),
            _buildSectionTitle('1. 목적'),
            _buildSectionContent(
              '본 약관은 ‘ELSwhere’가 제공하는 주가연계증권(ELS) 통합 정보 제공 및 데이터 분석 기반 맞춤형 의사결정 서비스(이하 ‘서비스’)의 이용에 관한 조건 및 절차를 규정합니다.',
            ),
            _buildSectionTitle('2. 서비스 이용'),
            _buildSectionContent(
              '사용자는 본 약관에 동의함으로써 ‘ELSwhere’의 서비스를 이용할 수 있습니다. 본 서비스는 사용자가 ELS 상품 정보를 통합적으로 조회하고 분석된 데이터를 제공받는 데 목적이 있습니다. 서비스 이용자는 만 19세 이상이어야 하며, 미성년자는 법정 대리인의 동의를 받아야만 서비스 이용이 가능합니다.',
            ),
            _buildSectionTitle('3. 투자 참고자료 제공'),
            _buildSectionContent(
              '‘ELSwhere’는 투자 참고자료를 제공하는 플랫폼입니다. 본 서비스에서 제공하는 정보는 투자 판단을 위한 참고자료일 뿐, 직접적인 투자 권유가 아닙니다. 따라서, 사용자는 제공된 자료를 바탕으로 한 모든 투자 결정에 대한 책임을 스스로 부담해야 하며, ‘ELSwhere’는 그로 인한 손실에 대해 어떠한 책임도 지지 않습니다. 본 서비스에서 제공하는 정보는 금융시장 상황, 각종 지표, 과거 데이터 등에 기초한 분석일 뿐, 실제 결과와는 차이가 있을 수 있습니다.',
            ),
            _buildSectionTitle('4. 서비스 제공의 제한 및 중지'),
            _buildSectionContent(
              '‘ELSwhere’는 시스템 유지보수, 기술적 문제, 천재지변 등 불가피한 사유가 있을 경우 서비스의 제공을 일시적으로 제한하거나 중단할 수 있습니다. 또한, 사용자가 본 약관을 위반한 경우 서비스 이용을 제한하거나 중지할 수 있습니다.',
            ),
            _buildSectionTitle('5. 사용자의 의무'),
            _buildSectionContent(
              '사용자는 본 서비스를 이용함에 있어 다음과 같은 행위를 하여서는 안 됩니다:\n'
              '- 타인의 개인정보 도용\n'
              '- 서비스의 부정 이용 및 악용\n'
              '- 법령 및 본 약관에 반하는 행위\n'
              '- 시스템 및 네트워크 보안 위반 시도\n'
              '- 부정확한 정보 입력 및 허위 정보 제공',
            ),
            _buildSectionTitle('6. 면책 사항'),
            _buildSectionContent(
              '‘ELSwhere’는 서비스에서 제공되는 정보의 정확성, 신뢰성에 대해 보증하지 않으며, 사용자 본인의 투자 판단으로 발생한 손실에 대해 책임지지 않습니다. 모든 투자 결정은 사용자의 판단에 따라 이루어져야 하며, ‘ELSwhere’는 투자 과정에서 발생하는 경제적 손실, 기대 수익의 감소 등에 대해 책임을 지지 않습니다. 또한, ‘ELSwhere’는 시스템 장애, 네트워크 문제 등으로 인해 서비스 제공이 지연되거나 중단된 경우에도 책임을 지지 않습니다.',
            ),
            _buildSectionTitle('7. 약관의 개정'),
            _buildSectionContent(
              '‘ELSwhere’는 필요에 따라 본 약관을 개정할 수 있으며, 개정된 약관은 앱 내 공지사항을 통해 사용자에게 고지됩니다. 개정된 약관은 고지된 날로부터 7일 후 효력이 발생하며, 사용자가 개정된 약관에 동의하지 않는 경우 서비스 이용을 중단하고 회원 탈퇴를 할 수 있습니다.',
            ),
            _buildSectionTitle('8. 관할 법원'),
            _buildSectionContent(
              '본 약관과 관련된 분쟁은 대한민국 법령에 따라 관할 법원에서 해결됩니다. 분쟁 발생 시, ‘ELSwhere’와 사용자는 원만한 해결을 위해 성실히 협의할 것입니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: textTheme.SM_18,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: textTheme.R_16.copyWith(height: 1.5),
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: edgeInsetsAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "제 1 조 (목적)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Text(
            //   "본 방침은 ELS 상품을 소개하는 앱(이하 \"앱\")을 이용하는 이용자의 개인 정보를 보호하기 위해 회사가 취하는 조치와 이용자의 권리, 회사의 의무를 규정하는 것을 목적으로 합니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 2 조 (수집하는 개인 정보의 항목 및 수집 방법)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // OrderedListItem(
            //   1,
            //   "수집하는 개인 정보의 항목",
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 24),
            //   child: UnorderedList([
            //     "필수 정보: 이름, 이메일 주소, 전화번호, 생년월일, 성별",
            //     "선택 정보: 투자 성향, 관심 상품 자동 수집 정보: 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보",
            //   ]),
            // ),
            // OrderedListItem(
            //   2,
            //   "수집 방법",
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 24),
            //   child: UnorderedList([
            //     "회원 가입 및 서비스 이용 과정에서 이용자가 직접 입력",
            //     "서비스 이용 과정에서 자동으로 수집",
            //   ]),
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 3 조 (개인 정보의 수집 및 이용 목적)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Text(
            //   "회사는 수집한 개인 정보를 다음의 목적을 위해 이용합니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 12),
            //   child: UnorderedList([
            //     "서비스 제공 및 운영: ELS 상품 정보 제공, 맞춤형 추천 서비스",
            //     "고객 관리: 회원 관리, 서비스 이용에 관한 상담 및 문의 처리",
            //     "마케팅 및 광고: 이벤트 및 광고성 정보 제공, 이용자의 서비스 이용에 대한 통계 분석",
            //   ]),
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 4 조 (개인 정보의 보유 및 이용 기간)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Text(
            //   "회사는 이용자의 개인 정보를 원칙적으로 개인 정보의 수집 및 이용 목적이 달성된 후에는 지체 없이 파기합니다. 단, 관련 법령에 따라 보관할 필요가 있는 경우 회사는 해당 법령에서 정한 기간 동안 개인 정보를 보관합니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 12),
            //   child: UnorderedList([
            //     "계약 또는 청약철회 등에 관한 기록: 5년",
            //     "소비자의 불만 또는 분쟁 처리에 관한 기록: 3년",
            //     "웹사이트 방문 기록: 6개월",
            //   ]),
            // ),
            // Text(
            //   "이용자는 허위 정보를 제공하거나 부정한 방법으로 서비스를 이용해서는 안 됩니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            // Text(
            //   "제 6 조 (회사의 의무)",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.gray800,
            //   ),
            // ),
            // Text(
            //   "회사는 이용자에게 안정적인 서비스를 제공하기 위해 최선을 다합니다.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.gray800,
            //   ),
            // ),
            _buildSectionTitle('1. 개인정보의 수집 및 이용 목적'),
            _buildSectionContent(
              '‘ELSwhere’는 사용자가 주가연계증권(ELS) 관련 정보를 효과적으로 조회하고 맞춤형 서비스를 제공받을 수 있도록 개인정보를 수집합니다. 수집된 정보는 다음과 같은 목적에 사용됩니다:\n'
              '- 회원가입 및 사용자 식별\n'
              '- 서비스 제공 및 맞춤형 정보 제공\n'
              '- 고객 지원 및 문의 응대\n'
              '- 마케팅 및 프로모션 정보 제공\n'
              '- 서비스 개선 및 사용자 경험 분석',
            ),
            _buildSectionTitle('2. 수집하는 개인정보의 항목'),
            _buildSectionContent(
              '‘ELSwhere’는 다음과 같은 정보를 수집합니다:\n'
              '- 회원가입 시: 이름, 이메일 주소, 사용자 식별 번호\n'
              '- 서비스 이용 시: 접속 기록, 서비스 사용 내역, 관심 ELS 상품 정보, 기기 정보',
            ),
            _buildSectionTitle('3. 개인정보의 보유 및 이용 기간'),
            _buildSectionContent(
              '‘ELSwhere’는 개인정보의 수집 및 이용 목적이 달성될 때까지 개인정보를 보유합니다. 단, 관계 법령에 따라 보관할 필요가 있을 경우, 해당 법령에 따라 보유합니다. 보유 기간이 종료된 개인정보는 지체 없이 파기하며, 사용자가 탈퇴를 요청한 경우에도 즉시 파기 절차를 진행합니다.',
            ),
            _buildSectionTitle('4. 개인정보의 제3자 제공'),
            _buildSectionContent(
              '‘ELSwhere’는 원칙적으로 사용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 사용자의 동의가 있거나 법률에 따라 필요한 경우 예외적으로 제공할 수 있습니다. 개인정보를 제공할 경우, 제공받는 자와 제공 목적, 제공되는 개인정보 항목, 보유 및 이용 기간 등을 명확히 고지하고 동의를 받습니다.',
            ),
            _buildSectionTitle('5. 개인정보의 처리 위탁'),
            _buildSectionContent(
              '‘ELSwhere’는 서비스 운영을 위해 일부 업무를 외부 전문 업체에 위탁할 수 있습니다. 이 경우 개인정보 보호를 위해 위탁 업체와의 계약을 통해 개인정보 보호 관련 의무를 명확히 규정하고 철저히 관리·감독합니다.',
            ),
            _buildSectionTitle('6. 개인정보의 파기'),
            _buildSectionContent(
              '‘ELSwhere’는 개인정보 보유 기간이 만료되거나 처리 목적이 달성된 경우, 개인정보를 지체 없이 파기합니다. 파기 절차 및 방법은 다음과 같습니다:\n'
              '- 전자적 파일 형태: 복구 불가능한 방법으로 영구 삭제\n'
              '- 종이 문서: 분쇄기를 이용하여 분쇄하거나 소각',
            ),
            _buildSectionTitle('7. 개인정보 보호책임자'),
            _buildSectionContent(
              '개인정보 관련 문의는 아래의 개인정보 보호책임자에게 연락주시기 바랍니다:\n'
              '이름: 조성범\n'
              '직위: 개발자 및 책임자\n'
              '이메일: welike2coding@gmail.com\n'
              '연락처: 010-6418-2264',
            ),
            _buildSectionTitle('8. 권리와 그 행사 방법'),
            _buildSectionContent(
              '사용자는 언제든지 자신의 개인정보 열람, 정정, 삭제를 요청할 수 있으며, ‘ELSwhere’는 관련 요청을 신속하게 처리하겠습니다. 개인정보 열람, 정정, 삭제를 요청하려면 앱 내 설정 메뉴 또는 고객센터를 통해 신청할 수 있습니다. 또한, 사용자는 개인정보 수집 및 이용에 대한 동의를 철회할 수 있으며, 철회 시 일부 서비스 이용이 제한될 수 있습니다.',
            ),
            _buildSectionTitle('9. 쿠키의 사용'),
            _buildSectionContent(
              '‘ELSwhere’는 사용자 맞춤형 서비스를 제공하기 위해 쿠키를 사용합니다. 쿠키는 사용자의 웹사이트 방문 기록 등을 저장하여 맞춤형 콘텐츠를 제공하는 데 이용됩니다. 사용자는 브라우저 설정을 통해 쿠키 사용을 거부할 수 있으며, 쿠키 사용을 거부할 경우 일부 서비스 이용에 제한이 있을 수 있습니다.',
            ),
            _buildSectionTitle('10. 개인정보의 안전성 확보 조치'),
            _buildSectionContent(
              '‘ELSwhere’는 개인정보 보호를 위해 다음과 같은 조치를 취하고 있습니다:\n'
              '- 관리적 조치: 내부 관리계획 수립, 직원 교육 등\n'
              '- 기술적 조치: 개인정보 접근 권한 관리, 암호화 기술 적용, 보안 프로그램 설치 등\n'
              '- 물리적 조치: 전산실 및 자료 보관실 접근 통제',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: textTheme.SM_18,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: textTheme.R_16.copyWith(height: 1.5),
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
            color: AppColors.gray800,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.gray800,
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
            color: AppColors.gray800,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.gray800,
            ),
          ),
        ),
      ],
    );
  }
}
