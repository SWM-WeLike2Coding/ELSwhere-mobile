import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/data/models/dtos/response_issuer_dto.dart';
import 'package:elswhere/data/models/dtos/response_ticker_symbol_dto.dart';
import 'package:elswhere/data/services/api_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import '../models/dtos/response_page_summarized_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';

part 'els_product_service.g.dart';

@RestApi(baseUrl: '')
abstract class ProductService {
  factory ProductService(Dio dio) {
    final _baseUrl = '$baseUrl/product-service';
    dio.interceptors.add(ApiInterceptor());
    return _ProductService(dio, baseUrl: _baseUrl);
  }

  @GET("/v1/others/ticker")
  Future<List<ResponseTickerSymbolDto>> fetchTickers();

  @GET("/v1/others/issuer")
  Future<List<ResponseIssuerDto>> fetchIssuers();

  @GET("/v1/product/{status}-sale")
  Future<ResponsePageSummarizedProductDto> fetchProducts(
    @Path("status") String status,
    @Query("type") String type,
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET("/v1/product/{id}")
  Future<ResponseSingleProductDto> fetchProduct(@Path("id") int id);

  @POST("/v1/product/search")
  Future<ResponsePageSummarizedProductDto> fetchFilteredProducts(@Body() RequestProductSearchDto data);

  @GET("/v1/product/similar/{id}")
  Future<HttpResponse> fetchSimilarProducts(@Path("id") int id);

  @POST("/v1/product/like/{id}")
  Future<HttpResponse> postProductLike(@Path("id") int id);

  @DELETE("/v1/product/like/{id}")
  Future<HttpResponse> deleteProductLike(@Path("id") int id);
}
