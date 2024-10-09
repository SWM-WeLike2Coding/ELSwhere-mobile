import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/models/dtos/post-service/summarized_generic_post_dto.dart';
import 'package:elswhere/data/providers/post_provider.dart';
import 'package:elswhere/ui/screens/post/notice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NoticeItem extends StatefulWidget {
  final SummarizedGenericPostDto notice;

  const NoticeItem({super.key, required this.notice});

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  final DateFormat dateFormat = DateFormat().addPattern('yyyy년 MM월 dd일');
  late final SummarizedGenericPostDto _notice;
  late PostProvider _postProvider;

  @override
  void initState() {
    _postProvider = Provider.of<PostProvider>(context, listen: false);
    _notice = widget.notice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onItemTapped,
      child: SizedBox(
        child: Padding(
          padding: edgeInsetsAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.notice.title,
                style: textTheme.M_16.copyWith(color: AppColors.gray900),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(DateTime.parse(widget.notice.createdAt)),
                style: textTheme.M_12.copyWith(color: AppColors.gray400),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );

    final result = await _postProvider.fetchSingleNotice(_notice.id);

    Navigator.pop(context);

    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NoticeDetailScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: MSG_ERR_FETCH_NOTICES, toastLength: Toast.LENGTH_SHORT);
    }
  }
}
