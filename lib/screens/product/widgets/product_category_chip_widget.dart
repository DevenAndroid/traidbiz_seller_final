import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constraints/colors.dart';
import '../../../controller/category_controller.dart';

class ProductCategoryChipWidget extends GetView<CategoryController> {
  const ProductCategoryChipWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();

    return controller.obx(
          (data) =>
          Scaffold(
            appBar: AppBar(
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  onChanged: (value) {
                     controller.categorySearch =
                        controller.categories!.where((element) =>
                            element.name!.toLowerCase().contains(
                                value.toLowerCase())).toList();
                    print('skhfdjhfjh' +
                        controller.categorySearch.length.toString());
                    print('skhfdjhfjh' + controller.categorySearch.toString());
                  },

                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            // controller.getProductCategories(_textEditingController.text.toString());
                          },
                          child: Icon(Icons.search, color: Colors.red,))
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.back(),
              child: const Icon(
                Icons.arrow_forward_outlined,
              ),
            ),
            body: SingleChildScrollView(
                  controller: controller.scroll,
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 4,
                    children: List.generate(
                      _textEditingController.text.isNotEmpty ? controller.categorySearch.length
                          :
                      controller.categories?.length ?? 0,
                          (index) =>
                          FilterChip(
                            label: Text(
                              _textEditingController.text.isNotEmpty
                                  ? controller.categorySearch[index].name.toString()
                                  :
                              "${controller.categories?[index].name}",
                              style: TextStyle(
                                color: controller.categories?[index]
                                    .isSelected ??
                                    false
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            selected: controller.categories?[index]
                                .isSelected ??
                                false,
                            backgroundColor: Colors.white,
                            selectedColor: colorPrimary,
                            checkmarkColor: Colors.white,
                            onSelected: (value) {
                              controller.updateProductSelection(
                                controller.categories?[index],
                              );
                            },
                          ),
                    ),
                  )
              )

          ),
      onLoading: const Center(
        child: CircularProgressIndicator(color: Colors.blue),),
      onEmpty: const Center(
        child: Text('No Categories available'),
      ),
      onError: (error) {
        return Column(
          children: [
            const Center(
              child: Text('Failed to load categories...'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                controller.getProductCategories();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
