import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/ChatGruoplist.dart' as ChatGruoplist ;
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/preferences_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chatlist.dart';
import 'Creategruop.dart';
// ignore: must_be_immutable
class EditChatGruop extends StatefulWidget{
  final List< ChatGruoplist.Memberlist> chatData;
  final String chatId;
  final String chatAvatar;
  String chatName;
  final String chatTotalM;
  EditChatGruop({Key key,  this.chatId, this.chatAvatar, this.chatName, this.chatTotalM,this.chatData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditchatGruop_state();

  }

}
class EditchatGruop_state extends State<EditChatGruop>{
  @override
  void didChangeDependencies() {
    if (!_isLoading) {


      _sharedPreferences = Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
      _profileUrl.value =
          _sharedPreferences.get(PreferenceConstants.PROFILE_IMAGE);
      _userName.value =
      '${_sharedPreferences.get(PreferenceConstants.FIRST_NAME)} ${_sharedPreferences.get(PreferenceConstants.LAST_NAME)}';
      _city.value = _sharedPreferences.get(PreferenceConstants.CITY);
      _birthDate.value = _sharedPreferences.get(PreferenceConstants.DOB);
      _accessToken = _sharedPreferences.get(PreferenceConstants.ACCESS_TOKEN);
      _userId = _sharedPreferences.get(PreferenceConstants.USER_ID);
      print("mohit");
      print(_userId);

    }
    _isLoading = true;
    super.didChangeDependencies();

  }
  File _image;
  List<ChatGruoplist.Memberlist> Totalmemebers = new List();
  _imgFromCamera() async {
   PickedFile  image = await ImagePicker.platform.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image =File( image.path);
      print(_image);
      ApiImplementer.EditgruopImplementer(accessToken:_accessToken ,userid:_userId ,name:widget.chatName,gruopid:widget.chatId ,
          groupphoto:base64Encode(_image.readAsBytesSync()) ).then((value) => print(value.toString()));

    });
  }
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  RxString _profileUrl = ''.obs;
  RxString _userName = ''.obs;
  RxString _city = ''.obs;
  RxString _birthDate = ''.obs;
  String _accessToken = '';
  String _userId = '';
  final picker = ImagePicker();
  Function_Edit(){

  }
  _imgFromGallery() async {
    PickedFile image = await  ImagePicker.platform.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {

      _image =File(image.path);
      print(image.path);
      ApiImplementer.EditgruopImplementer(accessToken:_accessToken ,userid:_userId ,name:widget.chatName,gruopid:widget.chatId ,
          groupphoto:base64Encode(_image.readAsBytesSync()) ).then((value) => print(value.toString()));

    });
  }
  void function(){
    return print('${_controller.text}');
  }
TextEditingController _controller= TextEditingController();

  Widget _widgetgruop (){
    return TextFormField(onChanged: (value){
      ApiImplementer.EditgruopnameImplementer(accessToken:_accessToken ,name:value ,userid:_userId, gruopid:widget.chatId ,
           ).then((value) => print(value.toString()));

    },
      onEditingComplete:function,
      controller: _controller,
      decoration: new InputDecoration(
     
          errorStyle: TextStyle(fontSize: 18.0),
          labelText: 'Group Name',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(
                color: Colors.blue,
              )),
          border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(
                  color: Colors.black, width: 1.0))),
      style: new TextStyle(color: Colors.black),
      validator: (value) {
        if (value.isEmpty) {
          return '\u26A0 Field is empty.';
        }
        return null;
      },
    );
  }
  @override
  void initState() {
    Totalmemebers.addAll(widget.chatData);
    _controller.text = widget.chatName  ;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     appBar:AppBar(actions: [IconButton(onPressed: (){
       ApiImplementer.DeletegruopImplementer(accessToken: _accessToken,userid: _userId,gruopid: widget.chatId).
       then((value) {
         setState(() {
           if (value['errorcode'] == "2") {
             print("logout");
             _sharedPreferences.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
             CommonDialogUtil.showErrorSnack(
                 context: context, msg: value['msg']);
           } else {
             var setdata = Provider.of<CommonDetailsProvider>(
                 context, listen: false);


             setdata.Fun_deletechatdata(int.parse(widget.chatId));

             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => Chat_gruop_list()),
             );
           }

         });
       });

   }, icon: Icon(Icons.delete,color: Colors.white,))],
       backgroundColor: Colors.black,
       title: Text('Edit Gruop Details'),leading:
     IconButton(onPressed: (){
       Navigator.pop(context);
     },
       icon: Icon(Icons.arrow_back_ios_outlined),),) ,
     body: Column(children: [
       SizedBox(height: 20,),
       Stack(
           children: [

             Container(
               margin: EdgeInsets.only(top: 30,left: 40,right: 40),
               height: 150,decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(16.0),
             ),),
             InkWell(
               onTap: (){
    showModalBottomSheet(
    context: context,
    builder: (context) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    ListTile(
    leading: new Icon(Icons.camera),
    title: new Text('Camera'),
    onTap: () {
     _imgFromCamera();
    Navigator.pop(context);
    },
    ),
    Divider(),
    ListTile(
    leading: new Icon(Icons.image),
    title: new Text('Gallery'),
    onTap: () {
      _imgFromGallery();
    Navigator.pop(context);
    },
    ),

    ],
    );
    });

             },
               child: Align(
                   alignment: Alignment.topCenter,
                   child: SizedBox(
                     child: CircleAvatar(
                       radius: 75.0,
                       backgroundColor: Colors.white,
                       child:CircleAvatar(
    radius: 55,
    backgroundColor: Color(0xffFDCF09),
    child:
    CircleAvatar(child: Align(
                           alignment: Alignment.bottomRight,
                           child: CircleAvatar(
                             backgroundColor: Colors.white,
                             radius: 25.0,
                             child: Icon(
                               Icons.camera_alt,
                               size: 25.0,
                               color: Color(0xFF404040),
                             ),
                           ),
                         ),
                         radius: 68.0,

                         backgroundImage:widget.chatAvatar!=null?
    NetworkImage(widget.chatAvatar): AssetImage('assets/images/user-image-default.png'),
                       ),
                     ),)
               ),
             ),
             ),
           ]
       ),
       Container(
           padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
           child: _widgetgruop()
       ),
       SizedBox(height: 20,),
       Row(
         children: [
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text('Gruop Members'),
                 ),
               ],
             ),
           ),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 InkWell(onTap: (){
                   Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(builder: (context) => add_Frnds_gruop(gruopId:widget.chatId)),

                   );
                 },
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('Add Members'),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
       SizedBox(height: 20,),
       Container(height: MediaQuery.of(context).size.height*0.42,
         child: ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,
             itemCount: Totalmemebers.length,
             itemBuilder: (context,index){
           return Column(
             children: [
               ListTile(title:Text(Totalmemebers[index].firstName) ,trailing: IconButton(icon:Icon(Icons.delete),
                 onPressed: (){
                 setState(() {
                   Totalmemebers.removeAt(index);
                   ApiImplementer.DeleteuserfromgruopImplementer(accessToken:_accessToken ,addusers:Totalmemebers[index].id ,
                       userid: _userId,gruopid:widget.chatId).then((value) => print('value'));

                 });

               },),),
             Divider()
             ],
           );

         }),
       )
     ],),

   );
  }

}