import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/screens/product/search_products.dart';
import '../../controller/category_controller.dart';
import '../../controller/product/product_detail_controller.dart';
import '../../data/models/product/product_model.dart';
import '/constraints/colors.dart';
import '/constraints/styles.dart';
import '../../controller/product/product_controller.dart';

class ProductsScreen extends GetView<ProductController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () async {
              final controller = Get.find<ProductDetailController>();
              controller.gotoCreateProduct();
            },
            padding: const EdgeInsets.all(0),
            icon: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary, width: 2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: colorPrimary,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshProducts,
        child: ListView(
          controller: controller.scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: controller.searchController,
                decoration: inputDecoration.copyWith(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (controller.searchController.text.isNotEmpty) {
                        Get.to(
                          () => SearchProductScreen(
                            search: controller.searchController.text,
                          ),
                        );
                      }
                    },
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (value != "") {
                    Get.to(() => SearchProductScreen(search: value));
                  }
                },
                onSaved: (value) {
                  if (value != "") {
                    Get.to(() => SearchProductScreen(search: value));
                  }
                },
              ),
            ),
            controller.obx(
              (data) => Column(
                children: List.generate(
                  data?.length ?? 0,
                  (index) => ProductItemWidget(
                    product: data?[index],
                  ),
                ),
              ),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Products not found',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: controller.refreshProducts,
                      child: const Text('Refresh Products'),
                    ),
                  ],
                ),
              ),
              onError: (error) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Error: Cannot get products',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: controller.refreshProducts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductItemWidget extends GetView<ProductDetailController> {
  final ProductModel? product;
  const ProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: product?.imageUrl != false
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                            "${product?.imageUrl}",
                            errorListener: () {
                              debugPrint(
                                'Failed to load ${product?.imageUrl}. Product Id: ${product?.id}.',
                              );
                            },
                          ),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                  color: Colors.grey.withOpacity(0.1),
                ),
                margin: const EdgeInsets.all(8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: "${product?.title} ",
                        // textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${product?.type} '.toUpperCase(),
                            style: TextStyle(
                              color: const Color(0xFF17b955),
                              background: Paint()
                                ..strokeWidth = 18.0
                                ..color = const Color(0xFFd2fae2)
                                ..style = PaintingStyle.fill
                                ..strokeJoin = StrokeJoin.round,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product!.priceHtml.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: colorPrimary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Stock: ${product?.quantity ?? 'n/a'}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                try {
                                  await controller.removeProduct(product?.id);
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorSecondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  PhosphorIcons.trash,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                controller.attributeDataList.clear();
                                controller.gotoUpdateProductScreen(product);

                                /// to get previous attributes
                                // controller.getProductAttributeVariationTerms();
                                /// for previous variations
                                controller.getAttributeList();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  PhosphorIcons.pencil,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
