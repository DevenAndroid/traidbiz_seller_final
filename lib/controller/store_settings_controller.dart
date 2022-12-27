import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/controller/home_controller.dart';
import 'package:traidbiz_seller/data/repository/store_repository.dart';
import '/data/local/auth_db.dart';
import '/utils/snackbar.dart';
import '/constraints/api_endpoints.dart';
import '/data/remote/api_service.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/store_settings/store_settings.dart';
import 'auth_controller.dart';

class StoreSettingsController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final GlobalKey<FormState> storeSettingsFormKey = GlobalKey<FormState>();
  final StoreRepository _repository = StoreRepository();

  final _storeSettings = const StoreProfileInfo().obs;
  StoreProfileInfo get storeSettings => _storeSettings.value;

  // controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController storeAddressController = TextEditingController();
  final TextEditingController storePhoneController = TextEditingController();

  final TextEditingController storeSlugController = TextEditingController();
  // final TextEditingController shopDescriptionController = TextEditingController();
  // RxString shopDescriptionController = "".obs;
  // final TextEditingController streetController = TextEditingController();
  final TextEditingController street2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController viberController = TextEditingController();
  final TextEditingController tikTokController = TextEditingController();
  RxString creditShippingZoneController = "".obs;

  RxString countryCode = "".obs;

  final ImagePicker _picker = ImagePicker();

  updateQuilValue(){

    // var myJSON = jsonDecode(shopDescriptionController.value);
    // controllerQQ = QuillController(
    //     document: htmlparser.parse(shopDescriptionController.value),
    //     selection: const TextSelection.collapsed(offset: 0));
  }

  final storeLogoImagePath = ''.obs;
  final storeBannerImagePath = ''.obs;

  XFile? _storeBanner;
  XFile? _storeLogo;

  @override
  void onInit() {
    super.onInit();
    getStoreProfileInfo();
  }

  void pickStoreLogo() async {
    _picker.pickImage(source: ImageSource.gallery).then((pickedImage) {
      if (pickedImage != null) {
        storeLogoImagePath.value = pickedImage.path;
        _storeLogo = pickedImage;
        update();
      } else {
        debugPrint("No image selected");
      }
    });
  }

  void pickStoreBanner() {
    _picker.pickImage(source: ImageSource.gallery).then((pickedImage) {
      if (pickedImage != null) {
        storeBannerImagePath.value = pickedImage.path;
        _storeBanner = pickedImage;
        update();
      } else {
        debugPrint("No image selected");
      }
    });
  }

  Future<void> getStoreProfileInfo() async {

    final response = await _repository.getStoreProfileInfo();
    _storeSettings.value = response;
    nameController.text = _storeSettings.value.storeProfile?.storeName ?? '';
    storeAddressController.text = _storeSettings.value.storeProfile?.location ?? '';
    storePhoneController.text = _storeSettings.value.storeProfile?.phone ?? '';
    storeLogoImagePath.value = _storeSettings.value.storeProfile?.logoUrl ?? '';
    storeBannerImagePath.value = _storeSettings.value.storeProfile?.bannerUrl ?? '';


    HomeController controller = Get.find<HomeController>();
    AuthController authController = Get.find<AuthController>();

    controller.updateUserProfileFromStoreSettings(response);
    authController.updateProfile();
    update();
  }

  Future<void> saveStoreSettings() async {
    if (storeSettingsFormKey.currentState?.validate() == true) {
      _isLoading.value = true;
      var client = dio.Dio();
      try {
        final logo = await _storeLogo?.readAsBytes();
        final banner = await _storeBanner?.readAsBytes();
        Map<String, dynamic> map = {};
        map["cookie"] = "${AuthDb.getAuthCookie()?.cookie}";
        map["store_name"] = nameController.text;
        map["address"] = storeAddressController.text;
        map["banner"] = banner != null ? convert.base64Encode(banner) : null;
        map["logo"] = logo != null ? convert.base64Encode(logo) : null;
        map["phone"] = storePhoneController.text;
        map["store_slug"] = storeSlugController.text;
        // map["shop_description"] = shopDescriptionController.value;
        // map["street"] = streetController.text;
        map["street_2"] = street2Controller.text;
        map["city"] = cityController.text;
        map["postcode"] = postcodeController.text;
        map["country"] = countryCode.value;
        map["state"] = stateController.text;
        map["twitter"] = twitterController.text;
        map["facebook"] = facebookController.text;
        map["instagram"] = instagramController.text;
        map["youtube"] = youtubeController.text;
        map["linkedin"] = linkedinController.text;
        map["whatsapp"] = whatsappController.text;
        map["viber"] = viberController.text;
        map["tik_tok"] = tikTokController.text;
        map["credit_shipping_zone"] = creditShippingZoneController.value;


        // final _body =
        // StoreSettings(
        //   cookie: "${AuthDb.getAuthCookie()?.cookie}",
        //   name: nameController.text,
        //   address: storeAddressController.text,
        //   banner: _banner != null ? convert.base64Encode(_banner) : null,
        //   logo: _logo != null ? convert.base64Encode(_logo) : null,
        //   phone: storePhoneController.text,
        //
        // ).toJson();

        debugPrint(jsonEncode(map));

        final response = await ApiService.post(
          storeSettingsApi,
          client,
          body: jsonEncode(map),
        );

        final settings = StoreSettingsResponse.fromJson(response);
        if (settings.status == 'success') {
          snack('Success', "${settings.message}", Icons.done);
          getStoreProfileInfo();
        } else {
          log("${settings.message}");
          snack('Failed', "Upload failed", Icons.error);
        }
      } catch (e) {
        log(e.toString());
        snack('Failed', "Upload failed", Icons.error);
      } finally {
        _isLoading.value = false;
        update();
      }
    } else {
      return Future.error("All fields are required");
    }
  }
}



class ModelStoreSettings {
  String? status;
  Response? response;

  ModelStoreSettings({this.status, this.response});

  ModelStoreSettings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? storeName;
  String? phone;
  String? address;
  String? logoUrl;
  String? bannerUrl;
  String? storeSlug;
  String? shopDescription;
  String? street2;
  String? city;
  String? postcode;
  String? state;
  String? country;
  String? creditShippingZone;
  String? twitter;
  String? facebook;
  String? instagram;
  String? youtube;
  String? linkedin;
  String? whatsapp;
  String? viber;
  String? tikTok;

  Response(
      {this.storeName,
        this.phone,
        this.address,
        this.logoUrl,
        this.bannerUrl,
        this.storeSlug,
        this.shopDescription,
        this.street2,
        this.city,
        this.postcode,
        this.state,
        this.country,
        this.creditShippingZone,
        this.twitter,
        this.facebook,
        this.instagram,
        this.youtube,
        this.linkedin,
        this.whatsapp,
        this.viber,
        this.tikTok});

  Response.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'];
    phone = json['phone'];
    address = json['address'];
    logoUrl = json['logo_url'];
    bannerUrl = json['banner_url'];
    storeSlug = json['store_slug'];
    shopDescription = json['shop_description'];
    street2 = json['street_2'];
    city = json['city'];
    postcode = json['postcode'];
    state = json['state'];
    country = json['country'];
    creditShippingZone = json['credit_shipping_zone'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    linkedin = json['linkedin'];
    whatsapp = json['whatsapp'];
    viber = json['viber'];
    tikTok = json['tik_tok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_name'] = storeName;
    data['phone'] = phone;
    data['address'] = address;
    data['logo_url'] = logoUrl;
    data['banner_url'] = bannerUrl;
    data['store_slug'] = storeSlug;
    data['shop_description'] = shopDescription;
    data['street_2'] = street2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['state'] = state;
    data['country'] = country;
    data['credit_shipping_zone'] = creditShippingZone;
    data['twitter'] = twitter;
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['linkedin'] = linkedin;
    data['whatsapp'] = whatsapp;
    data['viber'] = viber;
    data['tik_tok'] = tikTok;
    return data;
  }
}


