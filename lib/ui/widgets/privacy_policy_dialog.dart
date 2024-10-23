import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: edgeInsetsAll16,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('개인정보 처리방침'),
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppColors.gray50),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
