import 'package:dio/dio.dart';
import 'package:elswhere/config/config.dart';
import 'package:elswhere/data/models/dtos/analysis/monte_carlo_response.dart';
import 'package:elswhere/data/models/dtos/analysis/price_ratio_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analysis_service.g.dart';

@RestApi(baseUrl: '')
abstract class AnalysisService {
  factory AnalysisService(Dio dio) {
    final _baseUrl = '$baseUrl/analysis-service';
    return _AnalysisService(dio, baseUrl: _baseUrl);
  }

  @GET("/v1/product/price/ratio/{productId}")
  Future<HttpResponse<PriceRatioResponse>> getPriceRatio(@Path("productId") int productId);

  @POST("/v1/product/price/ratio/list")
  Future<HttpResponse<PriceRatioResponse>> getPriceRatioList(@Body() Map<String, dynamic> productIdList);

  @GET("/v1/monte-carlo/{productId}")
  Future<HttpResponse<MonteCarloResponse>> fetchMonteCarloResponse(@Path("productId") int productId);
}
