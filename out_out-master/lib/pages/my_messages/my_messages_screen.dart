import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';

class MyMessagesScreen extends StatefulWidget {
  static const routeName = '/My-Messages-Screen';

  @override
  _MyMessagesScreenState createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  CustomColor.colorAccent,
                  CustomColor.colorPrimaryDark,
                ]),
              ),
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.chat,
                      size: 40,
                      color: CustomColor.colorCanvas,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0,),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8, color: Colors.grey),
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        child: Text('Search...',style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14.0,
                        ),),
                      ),
                    ),
                    SizedBox(width: 8.0,),
                    Icon(
                      Icons.group_add,
                      size: 40,
                      color: CustomColor.colorCanvas,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              alignment: Alignment.center,
              child: Text(
                'Current Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 16,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: CustomColor.colorCanvas,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    tileColor: CustomColor.colorCanvas,
                    leading: Container(
                      width: 54,
                      height: 54,
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
                    title: Text('John Smith'),
                    subtitle: Text(
                      'new 5m',
                      style: TextStyle(
                        color: CustomColor.colorAccent,
                      ),
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
