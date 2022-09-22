import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';

import '../../../controller/store_settings_controller.dart';

class StoreImageWidget extends GetView<StoreSettingsController> {
  const StoreImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: controller.pickStoreLogo,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  image: controller.storeLogoImagePath.isNotEmpty
                      ? DecorationImage(
                          image: controller.storeLogoImagePath.contains("http")
                              ? CachedNetworkImageProvider(
                                  '${controller.storeLogoImagePath}')
                              : Image.file(
                                  File(
                                    "${controller.storeLogoImagePath}",
                                  ),
                                ).image,
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.white,
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 30),
                    Icon(PhosphorIcons.upload_simple),
                    SizedBox(height: 10),
                    Text(
                      'Add Logo',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: controller.pickStoreBanner,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  image: controller.storeBannerImagePath.isNotEmpty
                      ? DecorationImage(
                          image:
                              controller.storeBannerImagePath.contains("http")
                                  ? CachedNetworkImageProvider(
                                      '${controller.storeBannerImagePath}')
                                  : Image.file(
                                      File(
                                        "${controller.storeBannerImagePath}",
                                      ),
                                    ).image,
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.white,
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 30),
                    Icon(PhosphorIcons.upload_simple),
                    SizedBox(height: 10),
                    Text(
                      'Add Banner',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
