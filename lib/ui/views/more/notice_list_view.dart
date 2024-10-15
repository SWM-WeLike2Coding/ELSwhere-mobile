import 'package:elswhere/config/app_resource.dart';
import 'package:elswhere/config/strings.dart';
import 'package:elswhere/data/providers/post_provider.dart';
import 'package:elswhere/ui/widgets/notice_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoticeListView extends StatefulWidget {
  const NoticeListView({super.key});

  @override
  State<NoticeListView> createState() => _NoticeListViewState();
}

class _NoticeListViewState extends State<NoticeListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.notices == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (!provider.isLoading && provider.notices == null) {
          return const Center(child: Text(MSG_ERR_FETCH_NOTICES));
        } else if (!provider.isLoading && provider.notices!.content.isEmpty) {
          return const Center(child: Text(MSG_NO_NOTICES));
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(color: AppColors.gray50),
            itemCount: provider.notices!.content.length,
            itemBuilder: (context, index) => NoticeItem(notice: provider.notices!.content[index]),
            // itemCount: 3,
            // itemBuilder: (context, index) =>
            //     NoticeItem(notice: SummarizedGenericPostDto(id: index, title: "title", author: "author", createdAt: "2024-10-07T08:50:34.880Z", body: "할로할로", images: null, files: null)),
          );
        }
      },
    );
  }
}
