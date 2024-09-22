import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/request_create_holding_dto.dart';
import 'package:elswhere/data/models/dtos/response_interesting_product_dto.dart';
import 'package:elswhere/data/models/dtos/response_investment_type_dto.dart';
import 'package:elswhere/data/models/dtos/summarized_user_holding_dto.dart';
import 'package:elswhere/data/models/dtos/user_like_product_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'user_service.g.dart';

@RestApi(baseUrl: '')
abstract class UserService {
  factory UserService(Dio dio) {
    final _baseUrl = '$baseUrl/user-service';
    return _UserService(dio, baseUrl: _baseUrl);
  }

  @GET("/v1/user")
  Future<HttpResponse> checkUser();

  @PATCH("/v1/user/change/nickname")
  Future<HttpResponse> changeNickname(@Body() Map<String, dynamic> body);

  @DELETE("/v1/user")
  Future<HttpResponse> deleteUser();

  @GET("/v1/user/logout")
  Future<HttpResponse> logout();

  @GET("/v1/interest")
  Future<List<ResponseInterestingProductDto>> getInterestedProducts();

  @POST("/v1/interest")
  Future<HttpResponse> registerInterestedProduct(@Body() Map<String, dynamic> body);

  @DELETE("/v1/interest/{id}")
  Future<HttpResponse> deleteInterestedProduct(@Path("id") int id);

  @POST("/v1/user/check/nickname")
  Future<HttpResponse> checkNicknamePossible(@Body() Map<String, dynamic> body);

  @GET("/v1/propensity/survey")
  Future<ResponseInvestmentTypeDto> getMyInvestmentType();

  @POST("/v1/propensity/survey")
  Future<HttpResponse> sendNewInvestmentType(@Body() Map<String, dynamic> body);

  @GET("/v1/holding")
  Future<HttpResponse<List<SummarizedUserHoldingDto>>> fetchHoldingProducts();

  @POST("/v1/holding")
  Future<HttpResponse> addHoldingProduct(@Body() RequestCreateHoldingDto body);

  @DELETE("/v1/holding/{id}")
  Future<HttpResponse> deleteHoldingProduct(@Path("id") int id);

  @PATCH("/v1/holding/{id}")
  Future<HttpResponse> updateHoldingProduct(
    @Path("id") int id,
    @Query("price") int price,
  );

  @GET("/v1/product/like")
  Future<HttpResponse<List<UserLikeProductDto>>> fetchLikeProducts();
}
