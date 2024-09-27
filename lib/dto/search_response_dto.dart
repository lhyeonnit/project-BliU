
import 'package:BliU/data/search_popular_data.dart';
import 'package:BliU/data/search_product_data.dart';
import 'package:BliU/data/search_store_data.dart';

class SearchResponseDTO {
  final bool? result;
  final List<SearchStoreData>? storeSearch;
  final List<SearchProductData>? productSearch;

  SearchResponseDTO({
    required this.result,
    required this.storeSearch,
    required this.productSearch,
  });

  // JSON to Object
  factory SearchResponseDTO.fromJson(Map<String, dynamic> json) {
    return SearchResponseDTO(
      result: json['result'],
      storeSearch: (json['data']['store_search']),
      productSearch: (json['data']['product_search']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'store_search': storeSearch?.map((it) => it.toJson()).toList(),
        'product_search': productSearch?.map((it) => it.toJson()).toList(),
      }
    };
  }
}