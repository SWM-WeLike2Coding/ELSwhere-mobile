import 'package:dio/dio.dart';
import 'package:elswhere/models/dtos/request_product_search_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/dtos/response_page_summarized_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';

part 'els_product_service.g.dart';

@RestApi(baseUrl: '')
abstract class ProductService {
  factory ProductService(Dio dio) {
    final baseUrl = '${dotenv.env['ELS_BASE_URL']!}/product-service';
    return _ProductService(dio, baseUrl: baseUrl);
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