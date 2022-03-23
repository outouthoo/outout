import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/list_business_account_modal.dart';
import 'package:out_out/models/list_currency_modal.dart';
import 'package:out_out/models/list_my_friends_modal.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:out_out/models/list_events_model.dart' as eventList;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePrivateEventPage extends StatefulWidget {
  eventList.Data data;
  UpdatePrivateEventPage({Key key,  this.data,}) : super(key: key);

  @override
  _UpdatePrivateEventPageState createState() => _UpdatePrivateEventPageState();
}

class _UpdatePrivateEventPageState extends State<UpdatePrivateEventPage> {
  static const int EVENT_FREE = 0;
  static const int EVENT_PAID = 1;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateController;
  TextEditingController _titleController;
  TextEditingController _locationController;
  TextEditingController _friendController;
  TextEditingController _moreInfoController;
  TextEditingController _priceController;
  bool isHouseParty;
  User user;
  List<BusinessAccount> _businessList;
  List<Friend> _friendList;
  FocusNode _frndFocusNode;
  BusinessAccount _selectedBusinessAccount;
  Friend _selectedFriend;
  Currency _selectedCurrency;
  int _selectedPriceType;
  SharedPreferences _sharedPreferences;

  List<Currency> _currencyList;
  GetCurrencyResponse _getCurrencyResponse;

  @override
  void initState() {

    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    isHouseParty = false;
    _selectedPriceType = EVENT_FREE;
    _dateController = TextEditingController(text: widget.data.eventDate);
    _titleController = TextEditingController(text: widget.data.eventName);
    _locationController = TextEditingController(text: widget.data.eventLat);
    _friendController = TextEditingController(text: widget.data.updatedAt);
    _moreInfoController = TextEditingController();
    _priceController = TextEditingController();
    _frndFocusNode = NoKeyboardEditableTextFocusNode();
    _selectedCurrency = Currency.fromJson(
        {"id": "19", "name": "Pounds", "code": "GBP", "symbol": "£"});
    // getBusinessAccountListApi();
    getCurrencyList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sharedPreferences =
        Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.grey,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: CheckboxListTile(
                      value: isHouseParty,
                      title: Text(
                        'House Party',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: isHouseParty
                              ? CustomColor.colorAccent
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isHouseParty = !isHouseParty;
                        });
                        _titleController.text =
                            isHouseParty ? "House Party" : "";
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    color: CustomColor.colorCanvas,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _titleController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: CommonUtils.FONT_SIZE_16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Title...',
                            hintStyle: TextStyle(
                              fontSize: CommonUtils.FONT_SIZE_13,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    color: CustomColor.colorCanvas,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Location...",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: _locationController,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                  fontSize: CommonUtils.FONT_SIZE_16,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'search location',
                                  hintStyle: TextStyle(
                                    fontSize: CommonUtils.FONT_SIZE_13,
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              )),
                              SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                  onPressed: onSearchLocation,
                                  child: Text("SEARCH"))
                            ],
                          ),
                        ),
                        _selectedBusinessAccount != null
                            ? Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: _selectedBusinessAccount
                                                  .profileImage ==
                                              null
                                          ? null
                                          : NetworkImage(
                                              _selectedBusinessAccount
                                                  .profileImage)),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedBusinessAccount = null;
                                        });
                                      },
                                      icon: Icon(Icons.close)),
                                  title: Text(
                                      _selectedBusinessAccount.firstName +
                                          " " +
                                          _selectedBusinessAccount.lastName),
                                  subtitle: Text(_selectedBusinessAccount.city +
                                      " (" +
                                      _selectedBusinessAccount.latitude +
                                      "," +
                                      _selectedBusinessAccount.longitude +
                                      ")"),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    color: CustomColor.colorCanvas,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _dateController,
                          onTap: () => selectDate(context),
                          focusNode: NoKeyboardEditableTextFocusNode(),
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: CommonUtils.FONT_SIZE_16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Time...',
                            hintStyle: TextStyle(
                              fontSize: CommonUtils.FONT_SIZE_13,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 9.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      color: CustomColor.colorCanvas,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Invite Friends...',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _friendController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(
                                    fontSize: CommonUtils.FONT_SIZE_16,
                                  ),
                                  onTap: onBrowseFriendClick,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'browse friends',
                                    hintStyle: TextStyle(
                                      fontSize: CommonUtils.FONT_SIZE_13,
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                )),
                                SizedBox(
                                  width: 5,
                                ),
                                TextButton(
                                    onPressed: onSearchFriends,
                                    child: Text("SEARCH"))
                              ],
                            ),
                          ),
                          _selectedFriend != null
                              ? Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: _selectedFriend
                                                    .profileImage ==
                                                null
                                            ? null
                                            : NetworkImage(
                                                _selectedFriend.profileImage)),
                                    trailing: IconButton(
                                        onPressed: () {
                                          _friendController.clearComposing();
                                          setState(() {
                                            _selectedFriend = null;
                                          });
                                        },
                                        icon: Icon(Icons.close)),
                                    title: Text(_selectedFriend.fullName),
                                    subtitle: Text(_selectedFriend.email),
                                  ),
                                )
                              : Container()
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    color: CustomColor.colorCanvas,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _moreInfoController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: CommonUtils.FONT_SIZE_16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'More Info...',
                            hintStyle: TextStyle(
                              fontSize: CommonUtils.FONT_SIZE_13,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: RadioListTile(
                              value: EVENT_FREE,
                              selected: _selectedPriceType == EVENT_FREE,
                              title: Text("Free"),
                              groupValue: _selectedPriceType,
                              onChanged: onChangedPrice)),
                      Expanded(
                          child: RadioListTile(
                              value: EVENT_PAID,
                              selected: _selectedPriceType == EVENT_PAID,
                              title: Text("Paid"),
                              groupValue: _selectedPriceType,
                              onChanged: onChangedPrice)),
                    ],
                  ),
                  _selectedPriceType == EVENT_FREE
                      ? Container()
                      : Column(
                          children: [
                            Container(
                              color: CustomColor.colorCanvas,
                              child: ListTile(
                                onTap: onCurrencyClick,
                                title: Text("Select Currency"),
                                subtitle: Text(_selectedCurrency.name +
                                    " (" +
                                    _selectedCurrency.code +
                                    ")"),
                                trailing: Icon(Icons.arrow_drop_down_outlined),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 9.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              color: CustomColor.colorCanvas,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                      fontSize: CommonUtils.FONT_SIZE_16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Price...',
                                      hintStyle: TextStyle(
                                        fontSize: CommonUtils.FONT_SIZE_13,
                                        color: Colors.grey.withOpacity(0.8),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      InkWell(
                        onTap: onCreateButtonClick,
                        child: Container(
                          width: 240,
                          margin: EdgeInsets.symmetric(vertical: 30.0),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                CustomColor.colorAccent,
                                CustomColor.colorPrimary
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Update Private Event',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // Refer step 1
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        initialDatePickerMode: _dateController.text == null
            ? DatePickerMode.year
            : DatePickerMode.day);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day,
            selectedDate.hour, selectedDate.minute);
        _dateController.text =
            CommonUtils().getStandardFormattedDateTime(selectedDate);
      });
    }
    selectTime(context);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, picked.hour, picked.minute);
        _dateController.text =
            CommonUtils().getStandardFormattedDateTime(selectedDate);
      });
    }
  }

  void onCreateButtonClick() {
    if (areAllFieldValid()) {
      ApiImplementer.updateEvent(
              accessToken: user.accessToken,
              userid: user.userId,
              event_id: widget.data.id,
              event_name: _titleController.text.trim(),
              event_date: _dateController.text.trim(),
              event_lat: _selectedBusinessAccount.latitude,
              event_long: _selectedBusinessAccount.longitude,
              event_city: _selectedBusinessAccount.city,
              event_invitees: _selectedFriend.userId,
              event_type: "1",
              price: _selectedPriceType == EVENT_FREE
                  ? "0"
                  : _priceController.text.trim(),
              currency_id: _selectedCurrency.id,
              additional_info: _moreInfoController.text.trim())
          .then((value) {
        if (value.errorcode == "0") {
          Navigator.pop(context);
          CommonDialogUtil.showToastMsg(context: context, toastMsg: value.msg);
        }  else if (value.errorcode == "2") {
          print("logout");
          _sharedPreferences.clear();
          Navigator.of(context)
              .pushReplacementNamed(LoginScreen.routeName);
          CommonDialogUtil.showErrorSnack(
              context: context, msg: value.msg);
        } else {
          CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
        }
      });
    } else {
      CommonDialogUtil.showToastMsg(
          context: context, toastMsg: "Please provide valid details.");
    }
  }

  void onBrowseFriendClick() {
    // SelectDialog.showModal<UserModel>(
    //     context,
    //     label: "Item Builder Example",
    //     items: modelItems,
    //     selectedValue: ex3,
    //     itemBuilder: (BuildContext context, UserModel item, bool isSelected) {
    //   return Container(
    //     decoration: !isSelected
    //         ? null
    //         : BoxDecoration(
    //       borderRadius: BorderRadius.circular(5),
    //       color: Colors.white,
    //       border: Border.all(color: Theme.of(context).primaryColor),
    //     ),
    //     child: ListTile(
    //       leading: CircleAvatar(backgroundImage: item.avatar == null ? null : NetworkImage(item.avatar!)),
    //       selected: isSelected,
    //       title: Text(item.name),
    //       subtitle: Text(item.createdAt.toString()),
    //     ),
    //   );
  }

  Future<void> onSearchLocation() async {
    getBusinessAccountList().then((value) {
      if (value.errorcode == "0") {
        setState(() {
          _businessList = value.data;
        });
        if (_businessList.length > 0) openBusinessAccountSelectionDialog();
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
    });
  }

  void openBusinessAccountSelectionDialog() {
    SelectDialog.showModal<BusinessAccount>(
      context,
      label: "Select Business Account",
      items: _businessList,
      selectedValue: _selectedBusinessAccount,
      showSearchBox: false,
      itemBuilder:
          (BuildContext context, BusinessAccount item, bool isSelected) {
        return Container(
          decoration: !isSelected
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: item.profileImage == null
                    ? null
                    : NetworkImage(item.profileImage)),
            selected: isSelected,
            title: Text(item.firstName + " " + item.lastName),
            subtitle: Text(item.createdAt.toString()),
          ),
        );
      },
      onChange: (selected) {
        setState(() {
          _locationController.clear();
          _selectedBusinessAccount = selected;
        });
      },
    );
  }

  void openFriendsSelectionDialog() {
    SelectDialog.showModal<Friend>(
      context,
      label: "Select Friend",
      items: _friendList,
      selectedValue: _selectedFriend,
      showSearchBox: false,
      itemBuilder: (BuildContext context, Friend item, bool isSelected) {
        return Container(
            decoration: !isSelected
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage: item.profileImage == null
                      ? null
                      : NetworkImage(item.profileImage)),
              selected: isSelected,
              title: Text(item.fullName),
              subtitle: Text(
                item.email,
              ),
            ));
      },
      onChange: (selected) {
        setState(() {
          _friendController.clear();
          _selectedFriend = selected;
        });
      },
    );
  }

  void openCurrencySelectionDialog() {
    SelectDialog.showModal<Currency>(
      context,
      label: "Select Currency",
      items: _currencyList,
      selectedValue: _selectedCurrency,
      showSearchBox: false,
      itemBuilder: (BuildContext context, Currency item, bool isSelected) {
        return Container(
            decoration: !isSelected
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
            child: ListTile(
              selected: isSelected,
              title: Text(item.name),
              subtitle: Text(
                item.code,
              ),
            ));
      },
      onChange: (selected) {
        setState(() {
          _selectedCurrency = selected;
        });
      },
    );
  }

  Future<void> onSearchFriends() async {
    getMyFriendsList().then((value) {
      if (value.errorcode == "0") {
        setState(() {
          _friendList = value.data;
        });
        if (_friendList.length > 0) openFriendsSelectionDialog();
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context)
            .pushReplacementNamed(LoginScreen.routeName);
        CommonDialogUtil.showErrorSnack(
            context: context, msg: value.msg);
      } else
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
    });
  }

  bool areAllFieldValid() {
    if (_titleController.text.trim().length < 1 ||
        _selectedBusinessAccount == null ||
        _selectedFriend == null ||
        _dateController.text.trim().length < 1 ||
        _moreInfoController.text.trim().length < 1) {
      return false;
    } else if (_selectedPriceType == EVENT_PAID &&
        _priceController.text.trim().length < 1) {
      return false;
    } else {
      return true;
    }
  }

  void onChangedPrice(int value) {
    setState(() {
      _selectedPriceType = value;
    });
    log("ON CHANGED:" + value.toString());
  }

  Future<GetBusinessListResponse> getBusinessAccountList() async {
    return ApiImplementer.getBusinessAccountListByLocation(
        accessToken: user.accessToken, place: _locationController.text.trim());
  }

  Future<GetCurrencyResponse> getCurrencyList() async {
    ApiImplementer.getCurrencyListApi().then((value) {
      if (value.errorcode == "0")
        setState(() {
          _getCurrencyResponse = value;
        });
    });
  }

  Future<GetMyFriendsResponse> getMyFriendsList() async {
    return ApiImplementer.getMyFriendsList(
        accessToken: user.accessToken,
        search_query: _friendController.text.trim(),
        user_id: user.userId);
  }

  Future<void> onCurrencyClick() async {
    if (_getCurrencyResponse == null) await getCurrencyList();
    if (_getCurrencyResponse.errorcode == "0") {
      setState(() {
        _currencyList = _getCurrencyResponse.data;
      });
      if (_currencyList.length > 0) openCurrencySelectionDialog();
    } else
      CommonDialogUtil.showErrorSnack(
          context: context, msg: _getCurrencyResponse.msg);
  }
}
