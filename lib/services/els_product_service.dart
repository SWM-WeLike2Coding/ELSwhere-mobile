import 'package:dio/dio.dart';
import 'package:elswhere/models/dtos/request_product_search_dto.dart';
import 'package:elswhere/resources/config.dart';
import 'package:elswhere/services/api_interceptor.dart';
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

  @GET("/product/{status}-sale")
  Future<ResponsePageSummarizedProductDto> fetchProducts(
      @Path("status") String status,
      @Query("type") String type,
      @Query("page") int page,
      @Query("size") int size,
  );

  @GET("/product/{id}")
  Future<ResponseSingleProductDto> fetchProduct(@Path("id") int id);

  @POST("/product/search")
  Future<ResponsePageSummarizedProductDto> fetchFilteredProducts(@Body() RequestProductSearchDto data);
}