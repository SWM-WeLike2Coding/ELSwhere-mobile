import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dtos/response_page_summarized_product_dto.dart';
import '../models/dtos/response_single_product_dto.dart';
import '../resources/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class  ProductService {
  static final String _baseUrl = dotenv.env['ELS_BASE_URL']!;

  Future<ResponsePageSummarizedProductDto> fetchProducts(String type, int page, int size) async {
    final url = '$_baseUrl/product-service/product/on-sale?type=$type&page=$page&size=$size';
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
    final url = '$_baseUrl/product-service/product/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return ResponseSingleProductDto.fromJson(data);
    } else {
      throw Exception(errorMessage);
    }
  }

  Future<ResponsePageSummarizedProductDto> fetchFilteredProducts(String body) async {
    final url = Uri.parse('$_baseUrl/product-service/product/search');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    print(body);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        return ResponsePageSummarizedProductDto.fromJson(data);
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(errorMessage);
    }
  }
}
