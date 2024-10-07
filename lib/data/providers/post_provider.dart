import 'dart:developer';

import 'package:elswhere/data/models/dtos/post-service/request_title_and_body_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/request_update_notice_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/response_page_summarized_generic_post_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/response_single_generic_post_dto.dart';
import 'package:elswhere/data/models/dtos/post-service/summarized_generic_post_dto.dart';
import 'package:elswhere/data/services/post_service.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService;

  ResponsePageSummarizedGenericPostDto? _notices;
  ResponseSingleGenericPostDto? _singleNotice;

  bool _isLoading = false;

  ResponsePageSummarizedGenericPostDto? get notices => _notices;
  ResponseSingleGenericPostDto? get singleNotice => _singleNotice;
  bool get isLoading => _isLoading;

  PostProvider(this._postService);

  Future<bool> fetchNotices({String? keyword, int? bodySize = 50, int? page = 0, int? size = 20, String? sort}) async {
    bool success = true;
    _isLoading = true;
    _notices = null;
    notifyListeners();

    try {
      final httpResponse = await _postService.fetchNotices(keyword, bodySize, page, size, sort);
      final response = httpResponse.response;

      if (response.statusCode == 200) {
        _notices = httpResponse.data;
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      _notices = null;
      success = false;
      log('$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return success;
  }

  Future<bool> postNotice(RequestTitleAndBodyDto body) async {
    bool success = true;

    try {
      final httpResponse = await _postService.postNotice(body);
      final response = httpResponse.response;

      if (response.statusCode != 200) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      log('$e');
      success = false;
    }
    return success;
  }

  Future<bool> fetchSingleNotice(int id) async {
    bool success = true;
    _isLoading = true;
    _singleNotice = null;
    notifyListeners();

    try {
      final httpResponse = await _postService.fetchSingleNotice(id);
      final response = httpResponse.response;

      if (response.statusCode == 200) {
        _singleNotice = httpResponse.data;
      } else {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      log('$e');
      _singleNotice = null;
      success = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteSingleNotice(int id) async {
    bool success = true;

    try {
      final httpResponse = await _postService.deleteSingleNotice(id);
      final response = httpResponse.response;

      if (response.statusCode != 200) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      log('$e');
      success = false;
    }

    return success;
  }

  Future<bool> patchSingleNotice(int id, RequestUpdateNoticeDto body) async {
    bool success = true;

    try {
      final httpResponse = await _postService.patchSingleNotice(id, body);
      final response = httpResponse.response;

      if (response.statusCode != 200) {
        throw Exception('Error Code: ${response.statusCode}, ${response.statusMessage}');
      }
    } catch (e) {
      log('$e');
      success = false;
    }

    return success;
  }
}
