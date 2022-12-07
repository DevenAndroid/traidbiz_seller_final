import 'dart:convert';
import 'dart:developer';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../constraints/colors.dart';
import '../../constraints/styles.dart';
import '../../controller/store_settings_controller.dart';
import '../../repository/create_variation_attribute_repository.dart';
import 'widget/store_image_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final controller = Get.find<StoreSettingsController>();

  getData() async {
    getStoreProfileInfo1().then((response1){
      print("jsonEncode(response1)");
      print(jsonEncode(response1));
      controller.storeSlugController.text = response1.response!.storeSlug ?? "";
      controller.shopDescriptionController.text = response1.response!.shopDescription ?? "";
      controller.street2Controller.text = response1.response!.street2 ?? "";
      controller.cityController.text = response1.response!.city ?? "";
      controller.postcodeController.text = response1.response!.postcode ?? "";
      controller.countryController.text = response1.response!.city ?? "";
      controller.stateController.text = response1.response!.state ?? "";
      controller.twitterController.text = response1.response!.twitter ?? "";
      controller.facebookController.text = response1.response!.facebook ?? "";
      controller.instagramController.text = response1.response!.instagram ?? "";
      controller.youtubeController.text = response1.response!.youtube ?? "";
      controller.linkedinController.text = response1.response!.linkedin ?? "";
      controller.whatsappController.text = response1.response!.whatsapp ?? "";
      controller.viberController.text = response1.response!.viber ?? "";
      controller.tikTokController.text = response1.response!.tikTok ?? "";
      controller.creditShippingZoneController.text = response1.response!.creditShippingZone ?? "";
      print(controller.storeSlugController.text);
      print(controller.shopDescriptionController.text);
      print(controller.street2Controller.text);
      print(controller.cityController.text);
      print(controller.postcodeController.text);
      print(controller.countryController.text);
      print(controller.stateController.text);
      print(controller.twitterController.text);
      print("jsonEncode(response1)");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => LoadingOverlay(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Store Settings'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.storeSettingsFormKey,
              child: Column(
                children: [
                  const StoreImageWidget(),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: inputDecorationFilled2.copyWith(
                      hintText: 'Name',
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 15),
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.storeAddressController,
                    decoration: inputDecorationFilled2.copyWith(
                      hintText: 'Address',
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 15),
                          const Icon(Icons.maps_home_work),
                          const SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.storePhoneController,
                    decoration: inputDecorationFilled2.copyWith(
                      hintText: 'Phone',
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 15),
                          const Icon(Icons.call),
                          const SizedBox(width: 10),
                          Container(
                            height: 25,
                            width: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  customTextField(
                      hintText: "Store Name",
                      controller: controller.storeSlugController,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  customTextField(
                      hintText: "Store Description",
                      controller: controller.shopDescriptionController,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  // customTextField(
                  //   hintText: "Store Street",
                  //   controller: controller.streetController,
                  //   icon: const Icon(Icons.store),
                  //   validator: (value){
                  //     if(value!.isEmpty){
                  //       return "Store Name required";
                  //     } else {
                  //       return null;
                  //     }
                  //   }
                  // ),
                  customTextField(
                      hintText: "Store Street2",
                      controller: controller.street2Controller,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  customTextField(
                      hintText: "Store City",
                      controller: controller.cityController,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  customTextField(
                      hintText: "Store postcode",
                      controller: controller.postcodeController,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  customTextField(
                    hintText: "Store country",
                    controller: controller.countryController,
                    icon: const Icon(Icons.store),
                    // validator: (value){
                    //   if(value!.isEmpty){
                    //     return "Store Name required";
                    //   } else {
                    //     return null;
                    //   }
                    // }
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red,width: 1.0,),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: CountryPickerDropdown(
                      isExpanded: true,
                      // initialValue: _profileController.model.value.data!.countryISOCode== ""
                      //     ? "fj": _profileController.model.value.data!.countryISOCode.toString(),
                      itemBuilder: _buildDropdownItemNew,
                      onValuePicked: (Country country) {
                        print(country.name);
                        print(country.phoneCode);
                        // countryPostCode = country.phoneCode;
                        // countryIsoCode = country.isoCode.toLowerCase();
                        // print("object$countryPostCode");
                        // print("object1$countryIsoCode");
                      },
                    ),
                  ),
                  customTextField(
                      hintText: "Store state",
                      controller: controller.stateController,
                      icon: const Icon(Icons.store),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Store Name required";
                        } else {
                          return null;
                        }
                      }
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Text("Social Links",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                  customTextField(
                    hintText: "twitter",
                    controller: controller.twitterController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "facebook",
                    controller: controller.facebookController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "instagram",
                    controller: controller.instagramController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "youtube",
                    controller: controller.youtubeController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "linkedin",
                    controller: controller.linkedinController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "whatsapp",
                    controller: controller.whatsappController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "viber",
                    controller: controller.viberController,
                    icon: const Icon(Icons.store),
                  ),
                  customTextField(
                    hintText: "tik_tok",
                    controller: controller.tikTokController,
                    icon: const Icon(Icons.store),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Text("Shipping Zone",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                  customTextField(
                    hintText: "Credit Shipping Zone",
                    controller: controller.storePhoneController,
                    icon: const Icon(Icons.store),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.saveStoreSettings,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: colorSecondary,
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  customTextField({
    required TextEditingController controller,
    required String hintText,
    required Widget icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: inputDecorationFilled2.copyWith(
            hintText: hintText,
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                icon,
                const SizedBox(width: 10),
                Container(
                  height: 25,
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          // keyboardType: TextInputType.number,
          validator: validator,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
  Widget _buildDropdownItemNew(Country country) => Container(
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8,),
        // Text("+${country.phoneCode}(${country.isoCode})"),
        Text("+${country.phoneCode}"),
      ],
    ),
  );
}


// class SettingScreen extends GetView<StoreSettingsController> {
//   const SettingScreen({Key? key}) : super(key: key);
//
// }
