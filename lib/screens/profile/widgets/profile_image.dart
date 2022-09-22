import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/constraints/colors.dart';
import 'package:traidbiz_seller/controller/auth_controller.dart';

class ProfileImage extends GetView<AuthController> {
  const ProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 250,
          child: ClipPath(
            clipper: ProfileBackgroundClipper(),
            child: Container(
              width: 300,
              height: 250,
              color: colorPrimary,
            ),
          ),
        ),
        Positioned(
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(width: 4, color: Colors.white),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  "${controller.authCookie?.user?.profileImage}",
                ),
              ),
            ),
          ),
          left: 0,
          right: 0,
          bottom: 10,
        ),
        // Positioned(
        //   child: Center(
        //     child: Container(
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: colorPrimary,
        //       ),
        //       padding: const EdgeInsets.all(4),
        //       child: const Icon(Icons.image, color: Colors.white),
        //     ),
        //   ),
        //   left: 0,
        //   right: -65,
        //   bottom: 10,
        // ),
        Positioned(
          child: Center(
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          left: 0,
          right: 0,
          top: 60,
        ),
      ],
    );
  }
}

class ProfileBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height / 2)
      ..quadraticBezierTo(size.width / 2, size.height, 0, size.height / 2)
      ..lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
