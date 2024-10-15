import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/post/request_title_and_body_dto.dart';
import 'package:elswhere/data/models/dtos/post/request_update_notice_dto.dart';
import 'package:elswhere/data/models/dtos/post/response_page_summarized_generic_post_dto.dart';
import 'package:elswhere/data/models/dtos/post/response_single_generic_post_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'post_service.g.dart';

@RestApi(baseUrl: '')
abstract class PostService {
  factory PostService(Dio dio) {
    final _baseUrl = '$baseUrl/post-service';
    return _PostService(dio, baseUrl: _baseUrl);
  }

  @GET('/v1/post/notice') /// 공지사항 목록 조회
  Future<HttpResponse<ResponsePageSummarizedGenericPostDto>> fetchNotices(
    @Query('keyword') String? keyword,
    @Query('bodySize') int? bodySize,
    @Query('page') int? page,
    @Query('size') int? size,
    @Query('sort') String? sort,
  );

  @POST('/v1/post/notice') /// 공지사항 글 등록
  Future<HttpResponse> postNotice(@Body() RequestTitleAndBodyDto body);

  @GET('/v1/post/notice/{id}') /// 공지사항 글 단건 조회
  Future<HttpResponse<ResponseSingleGenericPostDto>> fetchSingleNotice(@Path('id') int id);

  @DELETE('/v1/post/notice/{id}') /// 공지사항 글 삭제
  Future<HttpResponse> deleteSingleNotice(@Path('id') int id);

  @PATCH('/v1/post/notice/{id}') /// 공지사항 글 수정
  Future<HttpResponse> patchSingleNotice(@Path('id') int id, @Body() RequestUpdateNoticeDto body);
}
