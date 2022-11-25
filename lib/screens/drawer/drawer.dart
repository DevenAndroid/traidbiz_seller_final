
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/auth_controller.dart';
import '../../controller/product/product_detail_controller.dart';
import '../../controller/store_settings_controller.dart';
import '../../data/repository/product_repository.dart';
import '../notification/notification.dart';
import '../order/orders.dart';
import '../product/products.dart';
import '../profile/profile.dart';

class CommonDrawer extends StatefulWidget {
  String? userCookie;
  String? userName;
  String? userEmail;
  String? userImage;
  CommonDrawer(this.userCookie, this.userName, this.userEmail, this.userImage, {Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  List<String> drawerItems = [
    'Media',
    'Credit Limit',
    'WholeSale Setting',
    'Admin Support',
    'Credit Report',
    'Credit Shipping',
    'Customers',
    'Refunds',
    'Payments',
    'Followers',
    'Support',
    'Reports',
    'Ledger Book',
    'Staffs',
    'Coupons',
  ];



  // final controller = Get.put(CommonDrawerController());
  final profileController = Get.put(StoreSettingsController());
  final loginController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: SafeArea(
          child: Column(
          // Important: Remove any padding from the ListView.
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height*0.3,
            child: UserAccountsDrawerHeader( // <-- SEE HERE
              decoration: const BoxDecoration(
                  color: Colors.deepOrange),
              accountName: Text(
                widget.userName.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                widget.userEmail.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: Image.network(widget.userImage.toString(),
                  fit: BoxFit.fill
                  ,width: 65,height: 65,)),
              ),
            ),
          ),
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: drawerItems.length,
                  itemBuilder: (context, index){
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.open_in_new,color: Colors.blue,
                        //iN CASE lOGOUT
                        // leading: index==16?Icon(Icons.logout_outlined,color: Colors.blue):Icon(Icons.open_in_new,color: Colors.blue,
                      ),
                      // title: Text(index.toString()+". "+drawerItems[index]),
                      title: Text(drawerItems[index]),
                      onTap: () {
                          switch (index) {
                            case 0:
                              _launchDrawerURL('https://traidbiz.com/store-manager/media/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 1:
                              _launchDrawerURL('https://traidbiz.com/store-manager/credit-limit/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 2:
                              _launchDrawerURL('https://traidbiz.com/store-manager/wholesale-setting/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 3:
                              _launchDrawerURL('https://traidbiz.com/store-manager/admin-support/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 4:
                              _launchDrawerURL('https://traidbiz.com/store-manager/credit-report/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 5:
                              _launchDrawerURL('https://traidbiz.com/store-manager/credit-shipping/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 6:
                              _launchDrawerURL('https://traidbiz.com/store-manager/customers/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 7:
                              _launchDrawerURL('https://traidbiz.com/store-manager/refund-requests/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 8:
                              _launchDrawerURL('https://traidbiz.com/store-manager/payments/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 9:
                              _launchDrawerURL('https://traidbiz.com/store-manager/followers/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 10:
                              _launchDrawerURL('https://traidbiz.com/store-manager/support/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 11:
                              _launchDrawerURL('https://traidbiz.com/store-manager/reports-sales-by-date/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 12:
                              _launchDrawerURL('https://traidbiz.com/store-manager/ledger/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 13:
                              _launchDrawerURL('https://traidbiz.com/store-manager/staffs/?login_cookie=${widget.userCookie}&app_page=true');
                              break;
                            case 14:
                              _launchDrawerURL('https://traidbiz.com/store-manager/coupons/?login_cookie=${widget.userCookie}&app_page=true');
                              break;

                              // fOR lOGOUT
                              /*case 16:
                                final AuthController _controller = Get.find<AuthController>();
                                _controller.logout();
                                break;*/
                          }
                        Navigator.pop(context);
                      },
                    ),
                    const Divider()
                  ],
                );
                  }),
            )
    ],
    ),
        ),);
    //   Obx(() {
    //   return !controller.isDataLoading.value
    //       ?  const Center(
    //           child: CircularProgressIndicator(
    //             color: Colors.red,
    //           ),
    //         )
    //       : SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               Container(
    //                 padding:  const EdgeInsets.only(top: 50, bottom: 20),
    //                 color: Colors.red,
    //                 width: double.maxFinite,
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       height: 125,
    //                       width: 125,
    //                       decoration: BoxDecoration(
    //                           image: DecorationImage(
    //                               image: NetworkImage(
    //                                   '${profileController.storeLogoImagePath}'),
    //                               fit: BoxFit.cover),
    //                           border: Border.all(width: 5, color: Colors.white),
    //                           shape: BoxShape.circle),
    //                     ),
    //                     Container(
    //                       padding:  const EdgeInsets.symmetric(
    //                           vertical: 6, horizontal: 15),
    //                       width: double.maxFinite,
    //                       child: Expanded(
    //                         child: Text(
    //                           profileController.storeNameController.text,
    //                           style:  const TextStyle(
    //                               color: Colors.white,
    //                               fontWeight: FontWeight.w600,
    //                               fontSize: 22),
    //                           overflow: TextOverflow.ellipsis,
    //                           textAlign: TextAlign.center,
    //                         ),
    //                       ),
    //                     ),
    //                     Container(
    //                       padding:  const EdgeInsets.symmetric(horizontal: 15),
    //                       width: double.maxFinite,
    //                       child: Text(
    //                         profileController.storePhoneController.text,
    //                         style:  const TextStyle(
    //                             color: Colors.white, fontSize: 16),
    //                         overflow: TextOverflow.ellipsis,
    //                         textAlign: TextAlign.center,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               /// Booking List
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(()=> const BookingListScreen());
    //                 },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.list_alt_rounded,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "Bookings List",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //               ///  Product Screen
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(() => ProductsScreen());
    //                   Get.put(ProductRepository());
    //                   Get.lazyPut(()=>ProductDetailController());
    //                   },
    //                 child: const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.format_list_numbered_sharp,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "My Products",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(()=> const NotificationScreen());
    //                   },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.notifications_active,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "Notification",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(()=> const OrderScreen());
    //                   Get.put(StoreOrderController1(StoreOrderRepository()));
    //                   Get.lazyPut(()=>StoreOrderController1(StoreOrderRepository()));
    //                   },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.border_all,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "My orders",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(()=>const ProfileScreen());
    //                   },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.person,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "My Profile",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //               InkWell(
    //                 onTap: () {
    //                   Get.to(()=>const UserChatScreen());
    //                 },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.person,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "Users Chat",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //               const Divider(),
    //               ListView.builder(
    //                   itemCount: controller.model.value.menuList!.length,
    //                   shrinkWrap: true,
    //                   padding: EdgeInsets.zero,
    //                   physics:  const NeverScrollableScrollPhysics(),
    //                   itemBuilder: (context, index) {
    //                     return InkWell(
    //                       onTap: () async {
    //                         if (!await launchUrl(
    //                           Uri.parse(controller.model.value.menuList![index].url.toString()),
    //                           mode: LaunchMode.externalApplication,
    //                         )) {
    //                           throw 'Could not launch ${controller.model.value.menuList![index].url.toString()}';
    //                         }
    //                       },
    //                       child: Column(
    //                         children: [
    //                           ListTile(
    //                             title: Text(
    //                               controller.model.value.menuList![index].title
    //                                   .toString(),
    //                               style:  const TextStyle(
    //                                   color: Colors.black, fontSize: 16),
    //                             ),
    //                             leading: SizedBox(
    //                               width: 30,
    //                               height: 30,
    //                               child: SvgPicture.network(controller.model.value.menuList![index].iconUrl.toString()),
    //                             ),
    //                           ),
    //                            const Divider()
    //                         ],
    //                       ),
    //                     );
    //                   }),
    //               InkWell(
    //                 onTap: (){
    //                   final AuthController controller = Get.find<AuthController>();
    //                   loginController.usernameController.text = "";
    //                   loginController.passwordController.text = "";
    //                   controller.logout();
    //                 },
    //                 child:  const ListTile(
    //                   leading: SizedBox(
    //                     width: 30,
    //                     height: 30,
    //                     child: Icon(Icons.logout_rounded,size: 30,color: Colors.black,),
    //                   ),
    //                   title: Text(
    //                     "Logout",
    //                     style: TextStyle(color: Colors.black, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //                const Divider(),
    //             ],
    //           ),
    //         );
    // });
  }

  _launchDrawerURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

















