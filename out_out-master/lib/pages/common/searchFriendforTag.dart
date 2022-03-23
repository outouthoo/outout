import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/models/search_friends_list_model.dart' as friendModel;
import 'package:provider/provider.dart';

class SearchTagFriend extends StatefulWidget {
  @override
  SearchTagFriendState createState() => SearchTagFriendState();
}

class SearchTagFriendState extends State<SearchTagFriend> {
  User _user;
  List<friendModel.Data> _nonVipFriends = [];

  @override
  void initState() {
    _user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    super.initState();
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
                'Search Friends for add Tag',
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
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              hintText: "Search Friend",
              contentPadding: EdgeInsets.only(
                  left: 22.0, top: 24.0, right: 12.0, bottom: 16.0),
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
        ),
        _nonVipFriends.length != 0
            ? Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _nonVipFriends.length,
                    itemBuilder: (BuildContext context, int index) {
                      friendModel.Data item = _nonVipFriends.elementAt(index);
                      return InkWell(
                        onTap: (){
                          Navigator.pop(context,item);
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                //BoxDecoration Widget
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: CustomColor.colorPrimaryDark,
                                  ), //Border.all
                                  borderRadius: BorderRadius.circular(7),
                                ), //BoxDecoration
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, _, error) =>
                                        Image.asset(person_placeholder),
                                    placeholder: (context, _) =>
                                        Image.asset(person_placeholder),
                                    imageUrl: '${item.profileImage ?? ''}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Center(
                                child: Text(
                                  '${item.fullName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: CommonUtils.FONT_SIZE_16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            : Expanded(
                child: Center(
                  child: Text(
                    'The people search not available.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
      ]),
    );
  }
}
