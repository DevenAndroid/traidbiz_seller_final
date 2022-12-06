import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/product/product_model.dart';
import '../../helper/Helpers.dart';
import '../../model/model_attribute_drop_down_value.dart';
import '../../model/model_get_attribute_list.dart';
import '../../repository/attribute_drop_down_repository.dart';
import '../../repository/create_variation_attribute_repository.dart';
import '../../repository/single_product_repo.dart';
import '../../repository/variations_repo.dart';
import '../../screens/product/create_product.dart';
import '../category_controller.dart';
import '/controller/product/product_attribute_controller.dart';
import '/controller/product/product_shipping_controller.dart';
import '/controller/product/product_tax_controller.dart';
import '/controller/product/product_variant_controller.dart';
import '/screens/product/update_product.dart';
import '/utils/snackbar.dart';
import '../../data/models/product/create/create_product.dart';
import '/data/local/auth_db.dart';
import '/data/models/user/user.dart';
import '/data/repository/product_repository.dart';
import '../../data/models/product/category/category.dart';
import 'product_controller.dart';

class ProductDetailController extends GetxController
    with
        ProductAttributeController,
        ProductVariantController,
        ProductTaxController,
        ProductShippingController {
  late AuthCookie? _authCookie;
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // final _isProductCreating = ;
  RxBool isProductCreating = false.obs;

  final _isProductUpdating = false.obs;
  bool get isProductUpdating => _isProductUpdating.value;

  final _productType = "".obs;
  String? get productType =>
      _productType.value.isEmpty ? null : _productType.value;
  set productType(String? type) => _productType.value = type ?? "";

  final ProductRepository _repository = ProductRepository();
  final _categories = <ProductCategory>[].obs;
  List<ProductCategory>? get categories => _categories;
  set categories(List<ProductCategory>? value) =>
      _categories.value = value ?? [];

  String projectId = "";

  // form keys
  final GlobalKey<FormState> productFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateProductFormKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController regularPriceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final _productImage = ''.obs;
  String get productImage => _productImage.value;
  set productImage(String image) => _productImage.value = image;

  final _productGalleryImages = <String>[].obs;
  List<String> get productGalleryImages => _productGalleryImages;

  final _createdProductId = "".obs;
  String get createdProductId => _createdProductId.value;
  set createdProductId(String id) => _createdProductId.value = id;

  @override
  void onInit() {
    super.onInit();
    _authCookie = AuthDb.getAuthCookie();
  }

  Rx<ModelGetAttributeDropDownValue> attributeModel =
      ModelGetAttributeDropDownValue().obs;
  var attributeDataList = RxList<ModelAttributeData>.empty(growable: true);
  var selectedAttributeDataList =
      RxList<ModelAttributeData>.empty(growable: true);
  var sendingAttributeList = RxList<ModelAttributeData>.empty(growable: true);
  bool listVisibility = false;
  RxBool attributeListLoaded = false.obs;
  final ImagePicker ppicker = ImagePicker();

  TextEditingController attributePrice = TextEditingController();
  XFile? variationImage;
  RxString variationImagePath = ''.obs;
  RxBool loader = false.obs;

  Rx<ModelGetAttributeList> attributeList = ModelGetAttributeList().obs;

  pickVariationImage() {
    ppicker.pickImage(source: ImageSource.gallery).then((pickedImage) {
      if (pickedImage != null) {
        variationImagePath.value = pickedImage.path;
        variationImage = pickedImage;
        update();
      } else {
        debugPrint("No image selected");
      }
    });
  }

  createAttributeVariationProductAPI(BuildContext context) async {
    loader.value = true;
    final image = await variationImage?.readAsBytes();
    var imageBase64 = convert.base64Encode(image!);
    createAttributeVariation(createdProductId.toString(), attributePrice.text,
            imageBase64, sendingAttributeList)
        .then((value) {
      getAttributeList();
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value.message)));
      loader.value = false;
    });
  }

  addAttribute(BuildContext context) {
    saveAttribute(context, createdProductId.toString(), attributeDataList)
        .then((value) {
      if (value.status == "success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.message.toString())));
      }
    });
  }

  getAttributeList() {
    attributeListLoaded.value = false;
    print("variation list API called");
    getAttributeVariationLists(createdProductId.toString()).then((value) {
      if (value.status == "success") {
        attributeListLoaded.value = true;
        attributeList.value = value;
      }
    });
  }

  getAttributeDropDownValue(bool from) {
    attributeDropDownValue().then((value) {
      log("New   $value");
      attributeModel.value = value;

      if (from == false) {
        debugPrint("Previous attributes api called");
        getProductAttributeTerms(createdProductId.toString()).then((value) {
          log("Previous   ${jsonEncode(value)}");
          if (value.data != []) {
            for (var item in value.data!) {
              debugPrint(
                  "Get variation  response>>>>>>>>>>11${jsonEncode(attributeDataList)}");
              attributeDataList.add(item);
            }
            for (var i = 0; i < attributeModel.value.data!.length; i++) {
              for (var item in attributeDataList) {
                if (item.titleSlug == attributeModel.value.data![i].titleSlug) {
                  attributeModel.value.data![i].selected = true;
                  log("Checking  ${jsonEncode(item.items)}");
                  attributeModel.value.data![i].items = item.items;
                  log("Checking12  ${jsonEncode(attributeModel.value.data![i].items)}");
                }
              }
            }
          }
          Get.off(() => UpdateProductScreen(fromCreate: from));
        });
      } else {
        debugPrint("Previous attributes api not called");
        Get.off(() => UpdateProductScreen(fromCreate: from));
      }
    });
  }

  void setProductImage(String path) {
    _productImage.value = path;
    update();
  }

  void setProductGalleryImage(int index, String path) {
    if (_productGalleryImages.length - 1 >= index) {
      _productGalleryImages[index] = path;
    } else {
      _productGalleryImages.add(path);
    }
    update();
  }

  Future<XFile?> pickImage({ImageSource? source}) async {
    try {
      final image = await _picker.pickImage(
        source: source ?? ImageSource.gallery,
      );
      return Future.value(image);
    } catch (e) {
      snack('Failed to pick image!', '$e', Icons.error);
      return null;
    }
  }

  void pickProductGalleryImage(ImageSource source, int index) {
    _picker.pickImage(source: source).then((file) {
      if (file != null) {
        _productGalleryImages.add(file.path);
        update();
      }
    });
  }

  void createNewProduct() async {
    if (productFormKey.currentState?.validate() == true) {
      if (productImage.isEmpty) {
        snack('Please select product image!', '', Icons.error);
        return;
      }

      if (productGalleryImages.isEmpty) {
        snack('Please select product gallery images!', '', Icons.error);
        return;
      }
      final _categories = categories
          ?.where((element) => element.isSelected == true)
          .map((e) => e.id)
          .toList()
          .join(",");
      if (_categories?.isEmpty == true) {
        snack(
          'Category Required!',
          'Please select product category!',
          Icons.error,
        );
        return;
      }

      isProductCreating.value = true;
      update();
      try {
        debugPrint("Categories: $_categories");
        _authCookie = AuthDb.getAuthCookie();

        final _body = CreateProductModel(
          cookie: _authCookie?.cookie,
          productName: productNameController.text,
          productPrice: regularPriceController.text,
          productWeight: weightController.text,
          productLength: lengthController.text,
          productWidth: widthController.text,
          productHeight: heightController.text,
          productType: 'simple',
          productDescription: "",
          categories: _categories,
          sku: skuController.text,
          stockQuantity: stockQuantityController.text,
          productImage: convert.base64Encode(
            File(productImage).readAsBytesSync(),
          ),
          productGallery: _productGalleryImages
              .map((element) => ProductGallery(
                    base64Img: convert.base64Encode(
                      File(element).readAsBytesSync(),
                    ),
                  ))
              .toList(),
        );

        debugPrint(_body.toString());

        final _response = await _repository.createNewProduct(_body);
        if (_response['status'] == 'success') {
          projectId = _response['response']['id'].toString();
          _createdProductId.value = _response['response']['id'].toString();
          CategoryController categoryController = Get.find<CategoryController>();
          categoryController.categories!.clear();
          print("Category list cleared");
          await categoryController.getProductCategories("");
          getAttributeDropDownValue(true);
        }
        snack('Message', _response['message'], Icons.message);
      } catch (e) {
        debugPrint("$e");
      } finally {
        isProductCreating.value = false;
        update();

        final _productController = Get.find<ProductController>();
        _productController.refreshProducts();
      }
    }
  }

  Future<dynamic> updateProduct(BuildContext context, bool show) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Get.closeAllSnackbars();
    OverlayEntry loader = Helpers.overlayLoader(context);
    if (updateProductFormKey.currentState?.validate() == true) {
      if (show == true) {
        Overlay.of(context)!.insert(loader);
      }
      final _categories = categories
          ?.where((element) => element.isSelected == true)
          .map((e) => e.id)
          .toList()
          .join(",");
      if (_categories?.isEmpty == true) {
        Helpers.hideLoader(loader);
        snack(
          'Category Required!',
          'Please select product category!',
          Icons.error,
        );
        return false;
      }

      if (productImage.isEmpty) {
        Helpers.hideLoader(loader);
        snack('Please select product image!', '', Icons.error);
        return;
      }

      _isProductUpdating.value = true;
      update();

      try {
        final _body = {
          "product_id": projectId,
          "product_name": productNameController.text,
          "product_type": productType?.toLowerCase(),
          "product_price": regularPriceController.text,
          //
          "weight": weightController.text,
          "length": lengthController.text,
          "width": widthController.text,
          "height": heightController.text,
          //
          "stock_quantity": stockQuantityController.text,
          "product_description": "",
          "categories": _categories,
          "shipping_class_id": selectedShippingClass.termId,
          "tax_status": selectedTaxStatus.toLowerCase(),
          "tax_class": selectedTaxClass,

        };

        if (!productImage.contains("http")) {
          _body['image'] = convert.base64Encode(
            File(productImage).readAsBytesSync(),
          );
        }

        debugPrint(_body.toString());

        final response = await _repository.updateProductInfo(_body);
        Helpers.hideLoader(loader);
        return response;
      } catch (e) {
        Helpers.hideLoader(loader);
        snack('Error', '$e', Icons.error);
        return Future.error(e);
      } finally {
        Helpers.hideLoader(loader);
        _isProductUpdating.value = false;
        update();
      }
    }
  }

  void gotoCreateProduct() async {
    productNameController.text = "";
    regularPriceController.text = "";
    weightController.text = "";
    lengthController.text = "";
    widthController.text = "";
    heightController.text = "";
    skuController.text = "";
    stockQuantityController.text = "";
    _productImage.value = "";
    _productGalleryImages.clear();
    _categories.value = [];
    CategoryController categoryController = Get.find<CategoryController>();
    categoryController.categories!.clear();
    if (kDebugMode) {
      print("Category list cleared");
    }
    await categoryController.getProductCategories("");
    Get.to(() => const CreateProductScreen());
  }

  void gotoUpdateProductScreen(
    ProductModel? product,
  ) async {
    projectId = product!.id.toString();
    createdProductId = product.id.toString();
    Get.dialog(const Center(
      child: CircularProgressIndicator(),
    ));
    log("Single Product APi called");
   await singleProductRepo(productId: product.id.toString()).then((value) {
     weightController.text = "${value.productData!.weight}";
     lengthController.text = "${value.productData!.length}";
     widthController.text = "${value.productData!.width}";
     heightController.text = "${value.productData!.height}";
     log("Single Product APi called ${jsonEncode(value)}");
   });
    _createdProductId.value = "${product.id}";
    productNameController.text = "${product.title}";
    regularPriceController.text = "${product.price}";
    stockQuantityController.text = "${product.quantity}";
    _productType.value = product.type ?? 'simple';
    productImage = product.imageUrl ?? "";

    clearProductAttribute();
    clearProductVariationAttributes();

    categories = product.categories?.map((e) => e.copyWith(isSelected: true)).toList();

    for (var element in shippingClasses) {
      if (element.name?.contains(product.shippingClass ?? '', 0) == true) {
        selectedShippingClass = element;
      }
    }
    for (var element in taxStatus) {
      if (element.contains("${product.taxStatus}", 0)) {
        selectedTaxStatus = element;
      }
    }
    for (var element in taxClass) {
      if (element.contains("${product.taxClass}", 0)) {
        selectedTaxClass = element;
      }
    }

    CategoryController categoryController = Get.find<CategoryController>();
    categoryController.categories!.clear();
    if (kDebugMode) {
      print("Category list cleared");
    }
    await categoryController.getProductCategories("");
    getAttributeDropDownValue(false);
    // getProductAttributeVariationTerms();
  }

  Future<dynamic> removeProduct(int? productId) async {
    try {
      Get.dialog(const Center(
        child: CircularProgressIndicator(),
      ));
      final _response = await _repository.removeProduct(productId);
      // debugPrint(_response.toString());
      Get.back(); // close loading dialog
      snack('Message', "${_response['message']}.", Icons.message);
      final productController = Get.find<ProductController>();
      productController.refreshProducts();
    } catch (e) {
      Get.back(); // close loading dialog
    }
  }
}
