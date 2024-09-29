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
    final storeSearch = List<SearchStoreData>.from((json['data']['store_search'])?.map((item) {
      return SearchStoreData.fromJson(item as Map<String, dynamic>);
    }).toList());
    final productSearch = List<SearchProductData>.from((json['data']['product_search'])?.map((item) {
      return SearchProductData.fromJson(item as Map<String, dynamic>);
    }).toList());
    return SearchResponseDTO(
      result: json['result'],
      storeSearch: storeSearch,
      productSearch: productSearch,
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