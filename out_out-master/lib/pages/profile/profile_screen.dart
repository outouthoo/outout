import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/pages/memory_page/memory_page_emog.dart';
import 'package:out_out/pages/memory_page/memory_page_image.dart';
import 'package:out_out/pages/memory_page/memory_page_video.dart';
import 'package:out_out/pages/profile/profile_page_emog.dart';
import 'package:out_out/pages/profile/profile_page_photo.dart';
import 'package:out_out/pages/profile/profile_page_video.dart';
import 'package:out_out/pages/shout_out_page/shout_out_page.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-page-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Column(
        children: [
          Container(
            height: 4.0,
            color: CustomColor.colorAccent,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 90,
                    height: 90,
                    //BoxDecoration Widget
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://assets.entrepreneur.com/content/3x2/1300/20150218142709-happy-people.jpeg'),
                        fit: BoxFit.cover,
                      ), //DecorationImage
                      border: Border.all(
                        width: 3,
                        color: CustomColor.colorPrimaryDark,
                      ), //Border.all
                      borderRadius: BorderRadius.circular(15),
                    ), //BoxDecoration
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 3,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 6.0,
                    children: [
                      Text(
                        'Bobby Brown',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Night Club based in Birmingham',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        'www.pryzm.co.uk',
                        style: TextStyle(
                          color: CustomColor.colorPrimaryDark,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 4.0,
            color: CustomColor.colorAccent,
          ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    indicatorWeight: 0.0,
                    indicatorColor: Colors.transparent,
                    isScrollable: false,
                    unselectedLabelColor: Colors.grey,
                    indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          0.0,
                        ),
                      ),
                      color: CustomColor.colorAccent,
                    ),
                    tabs: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Icon(
                            Icons.camera_alt,
                            size: 35.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Icon(
                            Icons.videocam_outlined,
                            size: 35.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            size: 35.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ProfilePagePhoto(),
                        ProfilePageVideo(),
                        ProfilePageEmoG(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
