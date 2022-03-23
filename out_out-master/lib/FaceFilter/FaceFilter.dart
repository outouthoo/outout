import 'package:flutter/material.dart';
// import 'package:rwa_deep_ar/rwa_deep_ar.dart';
//import 'package:rwa_deep_ar/rwa_deep_ar.dart';
//import 'package:rwa_deep_ar/rwa_deep_ar.dart';

class FaceFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
// return _FaceFilterState();
  }
}
// class _FaceFilterState extends State<FaceFilter> {
//   List<String> _list= new List();
//   CameraDeepArController cameraDeepArController;
//   int currentPage = 0;
//   final vp = PageController(viewportFraction: .24);
//   Effects currentEffect = Effects.none;
//   Filters currentFilter = Filters.none;
//   Masks currentMask = Masks.none;
//   bool isRecording = false;
// String  base ='assets/images/filtericon';
//   @override
//   void initState() {
//     _list.add('${base}/none.png');
//     _list.add('${base}/aviators.png');
//     _list.add('${base}/bigmouth.png');
//     _list.add('${base}/dalmatian.png');
//     _list.add('${base}/flowers.png');
//     _list.add('${base}/grumpycat.png');
//     _list.add('${base}/lion.png');
//     _list.add('${base}/mudMask.png');
//     _list.add('${base}/koala.png');
//     _list.add('${base}/lion.png');
//     _list.add('${base}/mudMask.png');
//     _list.add('${base}/obama.png');
//     _list.add('${base}/pug.png');
//     _list.add('${base}/slash.png');
//     _list.add('${base}/sleepingmask.png');
//     _list.add('${base}/smallface.png');
//     _list.add('${base}/teddycigar.png');
//     _list.add('${base}/tripleface.png');
//     _list.add('${base}/twistedFace.png');
//     _list.add('${base}/teddycigar.png');
//     _list.add('${base}/tripleface.png');
//     _list.add('${base}/twistedFace.png');
//     super.initState();
//     print(_list.toString());
//   }
// Widget getFooter() {
//   return Padding(
//     padding: const EdgeInsets.only(left: 30, top: 60),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.black.withOpacity(0.3)),
//                   child: InkWell(onTap: (){
//                //     Navigator.of(context).pushNamed(MemoryPage.routeName);
//                   },
//                     child: Icon(
//                       Icons.arrow_back_ios_outlined,
//                       color: Colors.white,
//                       size: 23,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//
//               ],
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       color: Colors.black.withOpacity(0.3)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         IconButton(onPressed: (){
//                           setState(() {
//                        //     _controller.description.lensDirection.index;
//                           });
//
//                         },
//                             icon:Icon(
//                               SimpleLineIcons.refresh,
//                               color: Colors.white,
//                               size: 25,
//                             )),
//                         SizedBox(
//                           height: 18,
//                         ),
//                         InkWell(onTap: (){
//                       //    _controller.value.flashMode;
//                         },
//                           child: Icon(
//                             Entypo.flash,
//                             color: Colors.white,
//                             size: 25,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 18,
//                         ),
//
//
//
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//
//           child: Column(
//             children: [
//               Text('${Masks.aviators.toString()}'),
//               Row(
//                 children: List.generate(Masks.values.length, (p) {
//                   bool active = currentPage == p;
//                   return GestureDetector(
//                     onTap: () {
//                       currentPage = p;
//                       cameraDeepArController.changeMask(p);
//
//                       setState(() {
//
//                       });
//                     },
//                     child: Container(
//                         margin: EdgeInsets.all(5),
//                         width: active ? 80 : 70,
//                         height: active ? 80 : 70,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color:
//                             active ? Colors.redAccent : Colors.white,
//                             shape: BoxShape.circle),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Image.asset('${_list[p]}'),
//                         )
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }
// @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         floatingActionButton: getFooter(),
//         body: Stack(
//           children: [
//             CameraDeepAr(
//                 onCameraReady: (isReady) {
//                   print("Camera status $isReady");
//                 },
//                 onImageCaptured: (path) {
//                   print("Image Taken $path");
//                 },
//                 onVideoRecorded: (path) {
//                   print("Video Recorded @ $path");
//                 },
//                 //Enter the App key generate from Deep AR
//                 androidLicenceKey:
//                 "b27cc85ebbad20a351484e125b0eb5d006601d50ee1919b4519be806f1996d4357c68ba8d411e6a5",
//                 iosLicenceKey:
//                 "11fcdbc4a66ee978bff2ed08d5c73456b4e6855f4d990a2e4c5821dd1f23ce59d90f0a2e66977eaa",
//                 cameraDeepArCallback: (c) async {
//                   cameraDeepArController = c;
//                   setState(() {});
//                 }),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
//                 //height: 250,
//                 child: Column(
//
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//
//
//
//
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
