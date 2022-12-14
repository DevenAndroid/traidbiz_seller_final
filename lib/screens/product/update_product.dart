import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:traidbiz_seller/screens/product/product_variation_list.dart';
import '../../constraints/strings.dart';
import '../../constraints/colors.dart';
import '../../constraints/styles.dart';
import '../../controller/category_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../controller/product/product_detail_controller.dart';
import '../../repository/single_product_repo.dart';
import '../../utils/snackbar.dart';
import 'index.dart';

class UpdateProductScreen extends StatefulWidget {
  final bool? fromCreate;
  const UpdateProductScreen({Key? key, this.fromCreate}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  final controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isProductUpdating,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('Update Product'),
            actions: [
              TextButton(
                onPressed: _updateProduct,
                child: const Text('UPDATE'),
              ),
            ],
          ),
          body: LoadingOverlay(
            isLoading: controller.isProductCreating.value,
            child: Form(
              key: controller.updateProductFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
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
                                hintText: 'Stock Quantity',
                              ),
                              controller: controller.stockQuantityController,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText:
                                        "Please enter product regular price")
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: inputDecorationFilled.copyWith(
                                hintText: 'Regular Price',
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
                                    errorText:
                                        "Please enter product regular price")
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                            //Newly added

                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.weightController,
                              decoration: inputDecorationFilled.copyWith(
                                hintText: 'Weight(Kg)',
                                labelText: 'Weight(Kg)',
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Please enter weight';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.lengthController,
                              decoration: inputDecorationFilled.copyWith(
                                hintText: 'Length (cm)',
                                labelText: 'Length (cm)',
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Please enter length';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.widthController,
                              decoration: inputDecorationFilled.copyWith(
                                hintText: 'Width (cm)',
                                labelText: 'Width (cm)',
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Please enter width';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: controller.heightController,
                              decoration: inputDecorationFilled.copyWith(
                                hintText: 'Height (cm)',
                                labelText: 'Height (cm)',
                              ),
                              validator: (value) {
                                if (value?.isEmpty == true) {
                                  return 'Please enter height';
                                }
                                return null;
                              },
                            ),

                            //Newly added end
                            const SizedBox(height: 10),
                            Container(
                              height: 55,
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
                                  selected: controller
                                          .categories?[index].isSelected ??
                                      false,
                                  backgroundColor: Colors.white,
                                  selectedColor: colorPrimary,
                                  checkmarkColor: Colors.white,
                                  onSelected: (value) {},
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: inputDecorationFilled2.copyWith(
                                hintText: 'Type',
                                isDense: true,
                                fillColor: textFieldFillColor,
                                filled: true,
                              ),
                              validator: (value) =>
                                  value == null ? 'Please select type' : null,
                              items: List.generate(
                                productTypes.length,
                                (index) => DropdownMenuItem(
                                  value: productTypes[index].toLowerCase(),
                                  child: Text(productTypes[index]),
                                ),
                              ),
                              value: controller.productType,
                              onChanged: (value) {
                                controller.productType = value;
                              },
                            ),
                            const SizedBox(height: 10),
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
                                  builder: (context) =>
                                      const ChooseImageSheetWidget(),
                                );
                                if (response != null &&
                                    response.runtimeType == XFile) {
                                  controller.setProductImage(response.path);
                                }
                                debugPrint("Response: $response");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.withOpacity(0.2),
                                  image: controller.productImage.isNotEmpty
                                      ? DecorationImage(
                                          image: controller.productImage
                                                  .contains("http")
                                              ? CachedNetworkImageProvider(
                                                  controller.productImage,
                                                )
                                              : Image.file(
                                                  File(controller.productImage),
                                                ).image,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                // margin: const EdgeInsets.all(15),
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
                                    final response = await showModalBottomSheet(
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
                                    if (response != null &&
                                        response.runtimeType == XFile) {
                                      controller.setProductImage(response.path);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ), backgroundColor: colorSecondary,
                                  ),
                                  child: const Text('Select Image'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Tax
                    const TaxAndShippingWidget(),
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
                            if(controller.updateProductFormKey.currentState!.validate()){
                              controller.isProductCreating.value = true;
                              calculatePrice(
                                productId: controller.projectId,
                                regularPrice: controller.regularPriceController.text.trim(),
                                width: controller.widthController.text.trim(),
                                height: controller.heightController.text.trim(),
                                length: controller.lengthController.text.trim(),
                                weight: controller.weightController.text.trim()
                              ).then((value) {
                                controller.isProductCreating.value = false;
                                controller.regularPriceController.text =
                                    value.data!.priceWithShipping ?? controller.regularPriceController.text;
                                Fluttertoast.showToast(msg: "Price Updated");
                                setState(() {});
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ), backgroundColor: colorSecondary,
                          ),
                          child: const Text('Calculate Price'),
                        ),
                      ),
                    ),

                    // Below Part
                    Visibility(
                      visible:
                          controller.productType?.toLowerCase() == 'variable',
                      child: Column(
                        children: const [
                          SizedBox(height: 20),
                          ProductAttributesWidget(),
                          SizedBox(height: 20),
                          ProductVariationList(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateProduct() async {
    final response =
    await controller.updateProduct(context, widget.fromCreate!);
    if (response['status'] == 'success') {
      Get.back();
      snack('Success', response['message'], Icons.done);
      final productController = Get.find<ProductController>();
      productController.refreshProducts();
    } else {
      snack('Warning', response['message'], Icons.message);
    }
  }
}
