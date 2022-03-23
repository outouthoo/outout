import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/pages/wallet/sendMoneyScreen.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:provider/provider.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;

class ListFriendForSendMoney extends StatefulWidget {
  @override
  ListFriendForSendMoneyState createState() => ListFriendForSendMoneyState();
}

class ListFriendForSendMoneyState extends State<ListFriendForSendMoney> {
  User _user;
  List<friendModel.Data> _nonVipFriends = [];

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
    SearchFriendApiCall("");
  }

  void SearchFriendApiCall(String value) async {
    try {
      List<friendModel.Data> newItems = await ApiImplementer.GetFriendList(
          accessToken: _user.accessToken, userid: _user.userId, search: value);
      if (newItems == null || newItems.length <= 0) {
        newItems = [];
      }
      setState(() {
        _nonVipFriends = newItems;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            print('home');
            // Navigator.of(context).pushNamed(HomePage.routeName);
            Navigator.pop(context);
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                0.0,
              ),
            ),
            gradient: LinearGradient(
              colors: [
                CustomColor.colorAccent,
                CustomColor.colorPrimaryDark,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 15.0,
            ),
            child: Center(
              child: Text(
                'Search Friends for Sending Money',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
            maxLines: 6,
            minLines: 1,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              print("submit");
              if (value.isNotEmpty) {
                SearchFriendApiCall(value);
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              hintText: "Search Friend",
              contentPadding: EdgeInsets.only(
                  left: 12.0, top: 24.0, right: 12.0, bottom: 16.0),
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
        ),
        _nonVipFriends.length != 0
            ? Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    shrinkWrap: true,
                    itemCount: _nonVipFriends.length,
                    itemBuilder: (BuildContext context, int index) {
                      friendModel.Data item = _nonVipFriends.elementAt(index);
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.fullName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: CommonUtils.FONT_SIZE_16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                    CustomColor.colorPrimary,
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(50))),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Text("Send Money",
                                    style: TextStyle(
                                        color: CustomColor
                                            .colorCanvas,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: CommonUtils
                                            .FONT_SIZE_12)),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => SendMoneyPage(item),
                                ));
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              )
            : Expanded(
                child: Center(
                  child: Text(
                    'The people you have searched is not available.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
      ]),
    );
  }
}
