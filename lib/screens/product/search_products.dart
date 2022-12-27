import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/product/product_detail_controller.dart';
import '/data/models/product/product_model.dart';
import '../../constraints/colors.dart';
import '../../data/models/product/search/search_product.dart';
import '../../data/repository/product_repository.dart';

class SearchProductScreen extends StatelessWidget {
  final String? search;
  const SearchProductScreen({Key? key, required this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
      ),
      body: FutureBuilder(
        future: ProductRepository().searchProducts(search),
        builder: (context, AsyncSnapshot<List<SearchProduct>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<SearchProduct>? products = snapshot.data;

          return products?.length == 0 ?
           const Center(child: Text("No Products Found"),) :
          ListView.builder(
            itemCount: products?.length,
            itemBuilder: (context, index) => ProductItemWidget(
              product: products?[index],
            ),
          );
        },
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final SearchProduct? product;
  const ProductItemWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final controller = Get.find<ProductDetailController>();
        debugPrint(product.toString());
        controller.gotoUpdateProductScreen(ProductModel(
          id: product?.id,
          title: product?.name,
          imageUrl: product?.imageUrl ?? "url",
          type: product?.type ?? "simple",
          price: product?.price ?? "0",
          regularPrice: product?.price ?? "0",
          productWeight: product?.productWeight ?? "0",
          productLength: product?.productLength ?? "0",
          productWidth: product?.productWidth ?? "0",
          productHeight: product?.productHeight ?? "0",
          quantity: product?.quantity ?? "0",
          description: product?.description ?? "",
        ));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
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
                      text: "${product?.name} ",
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
                  Text(
                    "\$ ${product?.price}",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stock: ${product!.quantity ?? 'n/a'}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
