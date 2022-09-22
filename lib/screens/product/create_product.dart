import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../constraints/colors.dart';
import '../../constraints/styles.dart';
import '../../controller/product/product_detail_controller.dart';
import 'widgets/choose_image_sheet.dart';
import 'widgets/gallery_image_widget.dart';
import 'widgets/product_category_chip_widget.dart';

class CreateProductScreen extends GetView<ProductDetailController> {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Create Product'),
          actions: [
            TextButton(
              onPressed: controller.createNewProduct,
              child: const Text('CREATE'),
            ),
          ],
        ),
        body: LoadingOverlay(
          isLoading: controller.isProductCreating,
          child: Form(
            key: controller.productFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: controller.productNameController,
                            decoration: inputDecorationFilled.copyWith(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Please enter product name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: inputDecorationFilled.copyWith(
                              hintText: 'Price',
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 15),
                                  const Text(
                                    '\$',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2f2f2f),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 25,
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.5),
                                  )
                                ],
                              ),
                            ),
                            controller: controller.regularPriceController,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Please enter product price"),
                            ]),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 10),
                          // TextFormField(
                          //   controller: controller.salePriceController,
                          //   decoration: inputDecorationFilled.copyWith(
                          //     hintText: 'Sale Price',
                          //     prefixIcon: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         const SizedBox(width: 15),
                          //         const Text(
                          //           '\$',
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold,
                          //             color: Color(0xFF2f2f2f),
                          //           ),
                          //         ),
                          //         const SizedBox(width: 10),
                          //         Container(
                          //           height: 25,
                          //           width: 1,
                          //           color: Colors.grey.withOpacity(0.5),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          //   validator: MultiValidator([
                          //     RequiredValidator(
                          //         errorText: "Please enter product sale price")
                          //   ]),
                          //   keyboardType: TextInputType.number,
                          // ),
                          const SizedBox(height: 10),
                          TextFormField(
                            // keyboardType: TextInputType.number,
                            controller: controller.skuController,
                            decoration: inputDecorationFilled.copyWith(
                              hintText: 'SKU',
                            ),
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Please enter product sku';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: controller.stockQuantityController,
                            decoration: inputDecorationFilled.copyWith(
                              hintText: 'Stock Quantity ',
                            ),
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return 'Please enter stock Quantity';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: textFieldFillColor,
                            ),
                            child: InkWell(
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    color: Theme.of(context).backgroundColor,
                                    child: const ProductCategoryChipWidget(),
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  SizedBox(width: 15),
                                  Text(
                                    'Categories',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  Icon(Icons.keyboard_arrow_down_rounded),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 4,
                            children: List.generate(
                              controller.categories?.length ?? 0,
                              (index) => FilterChip(
                                label: Text(
                                  "${controller.categories?[index].name}",
                                  style: TextStyle(
                                    color: controller.categories?[index]
                                                .isSelected ??
                                            false
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected:
                                    controller.categories?[index].isSelected ??
                                        false,
                                backgroundColor: Colors.white,
                                selectedColor: colorPrimary,
                                checkmarkColor: Colors.white,
                                onSelected: (value) {
                                  // todo: do on selected
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final response = await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: (context) => const ChooseImageSheetWidget(),
                      );
                      if (response != null && response.runtimeType == XFile) {
                        controller.setProductImage(response.path);
                      }
                      debugPrint("Response : $response");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.withOpacity(0.2),
                        image: controller.productImage.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(
                                  File(controller.productImage),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      margin: const EdgeInsets.all(15),
                      height: 180,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 100,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final _response = await showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            builder: (context) =>
                                const ChooseImageSheetWidget(),
                          );
                          if (_response != null &&
                              _response.runtimeType == XFile) {
                            controller.setProductImage(_response.path);
                          }
                        },
                        child: const Text('Select Image'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // backgroundColor: colorSecondary,
                        ),
                      ),
                    ),
                  ),
                  const GalleryImagesWidget(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.createNewProduct,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // backgroundColor: colorSecondary,
                        ),
                        child: const Text('Update Product'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
