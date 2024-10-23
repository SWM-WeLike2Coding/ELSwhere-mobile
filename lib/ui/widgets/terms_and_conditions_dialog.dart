import 'package:elswhere/config/app_resource.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({super.key});

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
                _buildSectionTitle('서비스 이용약관'),
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
