import 'dart:convert';
import 'dart:developer';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:traidbiz_seller/screens/settings/quile.dart';

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

  RxBool show = false.obs;

  List<String> shippingZoneList = [
    "Viti Levu",
    "Taveuni",
    "Ovalau",
    "Vanua Levu"
  ];

  getData() async {
    getStoreProfileInfo1().then((response1) {
      print("jsonEncode(response1)");
      print(jsonEncode(response1));
      controller.storeSlugController.text = response1.response!.storeSlug ?? "";
      // controller.shopDescriptionController.text =
      //     response1.response!.shopDescription ?? "";
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
      controller.creditShippingZoneController.value =
          response1.response!.creditShippingZone ?? "";
      controller.countryCode.value = response1.response!.country ?? "";
      show.value = true;
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
          () =>
          LoadingOverlay(
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
                          icon: const Icon(Icons.ac_unit_sharp),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Store Name required";
                            } else {
                              return null;
                            }
                          }
                      ),
                      // customTextField(
                      //   onTap: (){
                      //     // showEditorDialogue();
                      //   },
                      //     maxLines: 12,
                      //     read: false,
                      //     hintText: "Store Description",
                      //     controller: controller.shopDescriptionController,
                      //     icon: const Icon(Icons.description_outlined),
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return "Store Name required";
                      //       } else {
                      //         return null;
                      //       }
                      //     }
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     showEditorDialogue();
                      //   },
                      //   child: Container(
                      //     decoration: const BoxDecoration(
                      //       // border: Border.all(color: Colors.grey),
                      //         color: Colors.white
                      //     ),
                      //     padding: const EdgeInsets.all(4),
                      //     width: double.maxFinite,
                      //     child: Obx(() {
                      //       return Html(
                      //         data: controller.shopDescriptionController.value,
                      //       );
                      //     }),
                      //   ),
                      // ),
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
                          icon: const Icon(Icons.signpost_outlined),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Store Name required";
                            } else {
                              return null;
                            }
                          }
                      ),
                      customTextField(
                          hintText: "Store City",
                          controller: controller.cityController,
                          icon: const Icon(Icons.location_city),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Store Name required";
                            } else {
                              return null;
                            }
                          }
                      ),
                      customTextField(
                          hintText: "Store postcode",
                          controller: controller.postcodeController,
                          icon: const Icon(Icons.numbers_sharp),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Store Name required";
                            } else {
                              return null;
                            }
                          }
                      ),
                      customTextField(
                        hintText: "Store country",
                        controller: controller.countryController,
                        icon: const Icon(Icons.my_location),
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Store Name required";
                        //   } else {
                        //     return null;
                        //   }
                        // }
                      ),
                      // if(controller.countryCode.value == "")
                      // Container(
                      //   // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       // border: Border.all(color: Colors.red,width: 1.0,),
                      //       borderRadius: BorderRadius.circular(5.0)
                      //   ),
                      //   child: CountryPickerDropdown(
                      //     isExpanded: true,
                      //     initialValue: "IN",
                      //     isFirstDefaultIfInitialValueNotProvided: false,
                      //     itemBuilder: _buildDropdownItemNew,
                      //     onValuePicked: (Country country) {
                      //       print(country.name+"23123123231");
                      //       print(country.phoneCode);
                      //       print(country.isoCode.toString());
                      //       print(country.iso3Code);
                      //       controller.countryCode.value = country.iso3Code;
                      //       // countryPostCode = country.phoneCode;
                      //       // countryIsoCode = country.isoCode.toLowerCase();
                      //       // print("object$countryPostCode");
                      //       // print("object1$countryIsoCode");
                      //     },
                      //   ),
                      // ),
                      if(show.value == true)
                        Obx(() {
                          return Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: Colors.red,width: 1.0,),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: CountryPickerDropdown(
                              isExpanded: true,
                              initialValue: controller.countryCode.value
                                  .toLowerCase() == "" ? "in" : controller
                                  .countryCode.value
                                  .toLowerCase(),
                              isFirstDefaultIfInitialValueNotProvided: false,
                              itemBuilder: _buildDropdownItemNew,
                              onValuePicked: (Country country) {
                                print(country.name + "978897987987");
                                print(country.phoneCode);
                                print(country.isoCode.toString());
                                print(country.iso3Code);
                                controller.countryCode.value = country.isoCode;
                                // countryPostCode = country.phoneCode;
                                // countryIsoCode = country.isoCode.toLowerCase();
                                // print("object$countryPostCode");
                                // print("object1$countryIsoCode");
                              },
                            ),
                          );
                        }),
                      customTextField(
                          hintText: "Store state",
                          controller: controller.stateController,
                          icon: const Icon(Icons.my_location_sharp),
                          validator: (value) {
                            if (value!.isEmpty) {
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
                        icon: const FaIcon(FontAwesomeIcons.twitter),
                      ),
                      customTextField(
                          hintText: "facebook",
                          controller: controller.facebookController,
                          icon: const FaIcon(FontAwesomeIcons.facebook)
                      ),
                      customTextField(
                          hintText: "instagram",
                          controller: controller.instagramController,
                          icon: const FaIcon(FontAwesomeIcons.instagram)
                      ),
                      customTextField(
                          hintText: "youtube",
                          controller: controller.youtubeController,
                          icon: const FaIcon(FontAwesomeIcons.youtube)
                      ),
                      customTextField(
                          hintText: "linkedin",
                          controller: controller.linkedinController,
                          icon: const FaIcon(FontAwesomeIcons.linkedin)
                      ),
                      customTextField(
                          hintText: "whatsapp",
                          controller: controller.whatsappController,
                          icon: const FaIcon(FontAwesomeIcons.whatsapp)
                      ),
                      customTextField(
                          hintText: "viber",
                          controller: controller.viberController,
                          icon: const FaIcon(FontAwesomeIcons.viber)
                      ),
                      customTextField(
                          hintText: "tik_tok",
                          controller: controller.tikTokController,
                          icon: const FaIcon(FontAwesomeIcons.tiktok)
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
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              value: controller.creditShippingZoneController
                                  .value == "" ? null : controller
                                  .creditShippingZoneController.value,
                              decoration: inputDecorationFilled2.copyWith(
                                hintText: "Credit Shipping Zone",
                                // prefixIcon: Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     const SizedBox(width: 15),
                                //     icon,
                                //     const SizedBox(width: 10),
                                //     Container(
                                //       height: 25,
                                //       width: 1,
                                //       color: Colors.grey.withOpacity(0.5),
                                //     ),
                                //     const SizedBox(width: 10),
                                //   ],
                                // ),
                              ),
                              onChanged: (value) {
                                controller.creditShippingZoneController.value =
                                value!;
                              },
                              items: List.generate(
                                  shippingZoneList.length, (index) =>
                                  DropdownMenuItem(
                                      value: shippingZoneList[index],
                                      child: Text(shippingZoneList[index]))),
                              // keyboardType: TextInputType.number,
                              // validator: validator,
                            );
                          }),
                        ],
                      ),
                      // customTextField(
                      //   hintText: "Credit Shipping Zone",
                      //   controller: controller.storePhoneController,
                      //   icon: const Icon(Icons.store),
                      // ),
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
    onTap,
    bool read = false,
    int maxLines = 1,
  }) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TextFormField(
          onTap: onTap,
          readOnly: read,
          controller: controller,
          maxLines: maxLines,
          minLines: 1,
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


  Widget _buildDropdownItemNew(Country country) =>
      Row(
        children: [
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8,),
          // Text("+${country.phoneCode}(${country.isoCode})"),
          Text("+${country.phoneCode} "),
          Text(country.name),
        ],
      );
}


// class SettingScreen extends GetView<StoreSettingsController> {
//   const SettingScreen({Key? key}) : super(key: key);
//
// }
