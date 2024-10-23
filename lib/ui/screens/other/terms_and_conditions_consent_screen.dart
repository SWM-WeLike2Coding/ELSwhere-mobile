import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/user_info_provider.dart';
import 'package:elswhere/ui/screens/other/initial_screen.dart';
import 'package:elswhere/ui/widgets/privacy_policy_dialog.dart';
import 'package:elswhere/ui/widgets/signup_success_dialog.dart';
import 'package:elswhere/ui/widgets/terms_and_conditions_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsConsentScreen extends StatefulWidget {
  const TermsAndConditionsConsentScreen({super.key});

  @override
  State<TermsAndConditionsConsentScreen> createState() => _TermsAndConditionsConsentScreenState();
}

class _TermsAndConditionsConsentScreenState extends State<TermsAndConditionsConsentScreen> {
  late List<bool> _agreeList;
  late UserInfoProvider provider;
  bool isAgree = false;

  @override
  void initState() {
    _agreeList = List.generate(3, (_) => false);
    provider = Provider.of<UserInfoProvider>(context, listen: false);
    super.initState();
  }

  void _onValueChanged(int index, bool value) {
    setState(() {
      _agreeList[index] = value;
      if (index == 0) {
        for (int i = 0; i < 3; i++) {
          _agreeList[i] = value;
        }
      } else {
        bool first = _agreeList[1];
        bool second = _agreeList[2];
        if (first & second) {
          _agreeList[0] = true;
        } else {
          _agreeList[0] = false;
        }
      }
      isAgree = _agreeList[0];
    });
  }

  void _onTapCompleteButton() async {
    if (isAgree) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator.adaptive()));

      final result = await provider.signUp();

      Navigator.pop(context);

      if (result) {
        if (mounted) await showSignupSuccessDialog(context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const InitialScreen()),
          (_) => false,
        );
      } else {
        Fluttertoast.showToast(msg: MSG_ERR_UNEXPECTED, toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: edgeInsetsAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildServiceAgreementText(TITLE_SERVICE_AGREEMENT),
                  const SizedBox(height: 40),
                  _buildServiceAgreementItem(
                    index: 0,
                    content: TextSpan(style: textTheme.M_16.copyWith(color: AppColors.gray500), text: '전체 동의'),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.gray50, thickness: 1),
                  const SizedBox(height: 24),
                  _buildServiceAgreementItem(
                    index: 1,
                    content: TextSpan(
                      style: textTheme.M_16.copyWith(color: AppColors.gray500),
                      children: [
                        const TextSpan(text: '(필수) '),
                        TextSpan(
                            text: '개인정보 처리방침',
                            style: textTheme.M_16.copyWith(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const PrivacyPolicyDialog(),
                                );
                              }),
                        const TextSpan(text: '에 동의합니다.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildServiceAgreementItem(
                    index: 2,
                    content: TextSpan(
                      style: textTheme.M_16.copyWith(color: AppColors.gray500),
                      children: [
                        const TextSpan(text: '(필수) '),
                        TextSpan(
                          text: 'ELSwhere의 약관',
                          style: textTheme.M_16.copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                context: context,
                                builder: (context) => const TermsAndConditionsDialog(),
                              );
                            },
                        ),
                        const TextSpan(text: '에 동의합니다.'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildCompleteButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text('회원가입', style: textTheme.SM_18.copyWith(color: AppColors.gray950)),
        centerTitle: false,
      ),
    );
  }

  Widget _buildServiceAgreementText(String content) {
    return Text(
      content,
      style: textTheme.SM_24,
    );
  }

  Widget _buildServiceAgreementItem({required int index, required TextSpan content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                checkColor: Colors.white,
                activeColor: AppColors.mainBlue,
                side: const BorderSide(width: 2, color: AppColors.gray200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                value: _agreeList[index],
                onChanged: (value) => _onValueChanged(index, value!),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(content),
      ],
    );
  }

  Widget _buildCompleteButton() {
    Color boxColor = isAgree ? AppColors.mainBlue : AppColors.gray100;
    Color textColor = isAgree ? Colors.white : AppColors.gray300;

    return GestureDetector(
      onTap: _onTapCompleteButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 48,
          color: boxColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('회원가입 완료', style: textTheme.M_16.copyWith(color: textColor)),
          ),
        ),
      ),
    );
  }
}
