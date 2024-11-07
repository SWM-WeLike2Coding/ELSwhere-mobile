import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

bool isTextOverflowing(String text, double maxWidth, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);

  return textPainter.didExceedMaxLines;
}

Widget getMarqueeIfOverflow({required double maxWidth, required double height, required String text, required TextStyle style}) {
  return isTextOverflowing(text, maxWidth, style)
      ? SizedBox(
          height: height,
          width: maxWidth,
          child: Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            startAfter: const Duration(seconds: 1),
            velocity: 30.0,
            blankSpace: 100,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            fadingEdgeEndFraction: 0.7,
            decelerationCurve: Curves.linear,
          ),
        )
      : Text(
          text,
          style: style,
        );
}

bool isDateAfterOrSame(DateTime date) {
  // 현재 날짜
  DateTime today = DateTime.now();

  // 비교할 날짜와 현재 날짜에서 시간 정보 제거
  DateTime inputDate = DateTime(date.year, date.month, date.day);
  DateTime currentDate = DateTime(today.year, today.month, today.day);

  // 날짜만 비교
  return inputDate.isAfter(currentDate) || inputDate.isAtSameMomentAs(currentDate);
}

Future<String?> currentStoreVersion(String bundleId) async {
  Dio dio = Dio();
  String? version;
  try {
    if (Platform.isAndroid) {
      final http.Response response = await http.get(Uri.parse("https://play.google.com/store/apps/details?id=$packageName&gl=US"));
      if (response.statusCode == 200) {
        RegExp regexp = RegExp(r'\[\[\[\"(\d+\.\d+(\.[a-z]+)?(\.([^"]|\\")*)?)\"\]\]');
        version = regexp.firstMatch(response.body)?.group(1);
      }
    } else {
      Uri uri = Uri.https(
        "itunes.apple.com",
        "/lookup",
        {"bundleId": packageName},
      );
      final Response response = await dio.get(uri.toString());
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.data);
        version = jsonObj['results'][0]['version'];
      }
    }
    storeVersion = version!;
    return version;
  } catch (e) {
    return null;
  }
  return null;
}

bool checkAppVersion(String remoteVersion) {
    List<int> remote = remoteVersion.split(".").map((e) => int.parse(e)).toList();
    List<int> local = localLatestVersion.split(".").map((e) => int.parse(e)).toList();
    log('Remote Latest Version: $remoteVersion');
    log('Local Latest Version: $localLatestVersion');

    for (int i = 0; i < 3; i++) {
      if (remote[i] > local[i]) {
        return false;
      } else if (remote[i] < local[i]) {
        return true;
      }
    }
    return true;
  }