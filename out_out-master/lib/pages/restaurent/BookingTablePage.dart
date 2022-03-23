import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/ListAccountResponseModel.dart';
import 'package:out_out/models/TableModel/tablelistmodel.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/widget/common_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingTablePage extends StatefulWidget {
  BookingTablePage(this.item);

  ListAccountItem item;

  @override
  BookingTablePageState createState() => BookingTablePageState();
}

class BookingTablePageState extends State<BookingTablePage> {
  final _swiftController = TextEditingController();
  final _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  MaterialLocalizations localizations;
  User user;
  bool _isLoading = false;
  TableListModel _response;
  SharedPreferences _sharedPreferences;

  List<TablesItem> tableList = [];
  TablesItem selectedTable;

  @override
  void initState() {
    print("Restaurant Name" + widget.item.fullName);
    getTableList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = MaterialLocalizations.of(context);

    if (!_isLoading) {
      _sharedPreferences =
          Provider.of<CommonDetailsProvider>(context).getPreferencesInstance;
    }

    _isLoading = true;
    super.didChangeDependencies();
  }

  void getTableList() async {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    ApiImplementer.getTableList(
      accessToken: user.accessToken,
      user_id:  widget.item.userId,
    ).then((value) {
      if (value.errorcode == ApiImplementer.SUCCESS) {
        setState(() {
          _isLoading = false;
          _response = value;

          if (_response.data != null && _response.data.isNotEmpty) {
            tableList = _response.data;
          } else {
            CommonDialogUtil.showErrorSnack(
                context: context, msg: "No Tables Available!!");
          }
        });
      } else if (value.errorcode == "2") {
        print("logout");
        _sharedPreferences.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName, (Route<dynamic> route) => false);
        CommonDialogUtil.showErrorSnack(context: context, msg: value.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: CommonAppBar(),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Text(
                "Table Booking",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton<TablesItem>(
                    hint: new Text("Select Table"),
                    value: selectedTable,
                    isDense: true,
                    onChanged: (TablesItem newValue) {
                      setState(() {
                        selectedTable = newValue;
                      });
                      print(selectedTable.id);
                    },
                    items: tableList.map((TablesItem item) {
                      return new DropdownMenuItem<TablesItem>(
                        value: item,
                        child: new Text('${item.name} (${item.capacity})',
                            style: new TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              child: TextFormField(
                controller: _swiftController,
                decoration: InputDecoration(
                    labelText: 'Number of Person',
                    hintText: 'Number of Person',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    )),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 16.0,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              child: TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () async {
                  final TimeOfDay timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  if (timeOfDay != null && timeOfDay != selectedTime) {
                    setState(() {
                      selectedTime = timeOfDay;
                      final formattedTimeOfDay =
                          localizations.formatTimeOfDay(timeOfDay);

                      _timeController.text = formattedTimeOfDay;
                    });

                    print("${selectedTime.hour}:${selectedTime.minute}");
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Time to Arrive',
                    hintText: 'Time to Arrive',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    )),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: () {
                if (validData()) {
                  ApiImplementer.addBookingTable(
                    accessToken: user.accessToken,
                    user_id: user.userId,
                    to_user_id: widget.item.userId,
                    tableId: selectedTable.id,
                    persons: _swiftController.text.toString(),
                    time: "${selectedTime.hour}:${selectedTime.minute}",
                  ).then((value) {
                    if (value.errorcode == ApiImplementer.SUCCESS) {
                      setState(() {
                        _isLoading = false;
                        _response = value;
                        CommonDialogUtil.showSuccessSnack(
                            context: context, msg: _response.msg);
                        Navigator.pop(context);
                      });
                    } else if (value.errorcode == "2") {
                      print("logout");
                      _sharedPreferences.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName,
                          (Route<dynamic> route) => false);
                      CommonDialogUtil.showErrorSnack(
                          context: context, msg: value.msg);
                    }
                  });
                }
              },
              child: Container(
                height: 40,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: CustomColor.colorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                child: Text(
                  "Book Table",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  bool validData() {
    String person = _swiftController.text;
    String price = _timeController.text;
    bool isValid = true;
    if (selectedTable == null) {
      isValid = false;
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please select Table!');
    } else if (person.isEmpty) {
      isValid = false;
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter Number of person!');
    } else if (price.isEmpty) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please select arrival time!');
      isValid = false;
    }
    return isValid;
  }
}
