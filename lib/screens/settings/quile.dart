// import 'dart:convert';
//
// import 'package:delta_markdown/delta_markdown.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:get/get.dart';
// import 'package:markdown/markdown.dart';
// import 'package:traidbiz_seller/screens/settings/textttt.dart';
//
// import '../../controller/store_settings_controller.dart';
//
// class Quile extends StatefulWidget {
//   const Quile({Key? key}) : super(key: key);
//
//   @override
//   State<Quile> createState() => _QuileState();
// }
//
// class _QuileState extends State<Quile> {
//   final controller = Get.find<StoreSettingsController>();
//
//   @override
//   void initState() {
//     super.initState();
//     // controller.controllerQQ.document.insert(0, data)
//     // controller.controllerQQ = QuillController(document: Html(data: 'sds',)., selection: selection)
//     // controller.controllerQQ.addListener(() {
//     //   controller.shopDescriptionController.value = quillDeltaToHtml(controller.controllerQQ.document.toDelta());
//     // });
//   }
//
//   String quillDeltaToHtml(Delta delta) {
//     final convertedValue = jsonEncode(delta.toJson());
//     final markdown = deltaToMarkdown(convertedValue);
//     final html = markdownToHtml(markdown);
//
//     return html;
//   }
//   ccc(){
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // height: MediaQuery.of(context).size.height*.8,
//       child: Column(
//         children: [
//           QuillToolbar.basic(controller: controller.controllerQQ),
//           Expanded(
//             child: QuillEditor.basic(
//               controller: controller.controllerQQ,
//               readOnly: false, // true for view only mode
//             ),
//           ),
//           ElevatedButton(onPressed: (){}, child: const Textttt(text: 'Submit',style: TextStyle(),))
//         ],
//       ),
//     );
//   }
// }
