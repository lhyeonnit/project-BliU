import 'package:BliU/data/category_data.dart';
import 'package:BliU/screen/category/viewmodel/category_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCategoryBottom extends StatefulWidget {
  final Function(CategoryData)
      onCategorySelected; // Callback to handle category selection

  const ProductCategoryBottom({
    super.key,
    required this.onCategorySelected,
  });

  @override
  _ProductCategoryBottomState createState() => _ProductCategoryBottomState();
}

class _ProductCategoryBottomState extends State<ProductCategoryBottom> {
  Function(CategoryData) get onCategorySelected => widget.onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(categoryModelProvider);
        final categories = model?.categoryResponseDTO?.list ?? [];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 17, top: 15),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryData = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onCategorySelected(categoryData);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          categoryData.ctName ?? "",
                          style: TextStyle(
                              fontSize: Responsive.getFont(context, 16),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
