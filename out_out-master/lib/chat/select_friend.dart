import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/chat/chat.dart';
import 'package:out_out/models/friendList_model.dart' as FriendList;
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class SelectFriendPage extends StatefulWidget {
  const SelectFriendPage({Key key}) : super(key: key);

  @override
  _SelectFriendPageState createState() => _SelectFriendPageState();
}

class _SelectFriendPageState extends State<SelectFriendPage> {
  List<FriendList.Data> _data = [];
  User _user;

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    ApiImplementer.ListFriendApiImplementer(
      accessToken: _user.accessToken,
      userid: _user.userId,
    ).then((value) {
      setState(() {
        _data = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Select Friend"),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => Container(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            isNewChat: true,
                            peerId: _data.elementAt(index).userId,
                            peerName: _data.elementAt(index).fullName,
                            peerAvatar: _data.elementAt(index).profileImage,
                          ),
                        ));
                  },
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: _data.length != 0
                            ? Image.network(
                                _data[index].profileImage,
                                fit: BoxFit.fill,
                                width: 60.0,
                                height: 60.0,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: CustomColor.colorAccent,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 50.0,
                                    color: CustomColor.color_gray,
                                  );
                                },
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: CustomColor.color_gray,
                              ),
                        //  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      Container(
                        child: Text(
                          '${_data[index].fullName}',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CustomColor.color_gray),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
            margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
          ),
          itemCount: _data.length,
        ));
  }
}
