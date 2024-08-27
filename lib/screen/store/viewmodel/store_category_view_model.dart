import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeCategoryViewModelProvider = StateNotifierProvider<StoreCategoryViewModel, List<StoreCategoryState>>(
      (ref) => StoreCategoryViewModel(),
);

class StoreCategoryState {
  final List<String> products;
  final bool isLoading;
  final bool hasMore;

  StoreCategoryState({
    required this.products,
    required this.isLoading,
    required this.hasMore,
  });

  StoreCategoryState copyWith({
    List<String>? products,
    bool? isLoading,
    bool? hasMore,
  }) {
    return StoreCategoryState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class StoreCategoryViewModel extends StateNotifier<List<StoreCategoryState>> {
  StoreCategoryViewModel()
      : super(List.generate(
      9,
          (_) => StoreCategoryState(
        products: List.generate(10, (index) => '상품 $index'),
        isLoading: false,
        hasMore: true,
      )));

  void loadMore(int tabIndex) async {
    if (state[tabIndex].isLoading || !state[tabIndex].hasMore) return;

    state = state.asMap().map((index, categoryState) {
      if (index == tabIndex) {
        return MapEntry(
          index,
          categoryState.copyWith(isLoading: true),
        );
      }
      return MapEntry(index, categoryState);
    }).values.toList();

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    state = state.asMap().map((index, categoryState) {
      if (index == tabIndex) {
        final newProducts = List<String>.generate(10, (i) => '상품 ${categoryState.products.length + i}');
        return MapEntry(
          index,
          categoryState.copyWith(
            products: [...categoryState.products, ...newProducts],
            isLoading: false,
            hasMore: newProducts.length >= 10,
          ),
        );
      }
      return MapEntry(index, categoryState);
    }).values.toList();
  }
}
