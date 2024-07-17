import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dtos/response_page_summarized_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';
import '../resources/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class  ProductService {
  static final String _baseUrl = dotenv.env['ELS_BASE_URL']!;

  Future<ResponsePageSummarizedProductDto> fetchProducts(String type, int page, int size) async {
    final url = '$_baseUrl/product/on-sale?type=$type&page=$page&size=$size';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코딩
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return ResponsePageSummarizedProductDto.fromJson(data);
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<ResponseSingleProductDto> fetchProduct(int id) async {
    final url = '$_baseUrl/product/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return ResponseSingleProductDto.fromJson(data);
    } else {
      throw Exception(errorMessage);
    }
  }
}
