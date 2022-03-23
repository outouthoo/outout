import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/MenuModels/menumodels.dart';
import 'package:out_out/models/TableModel/tablelistmodel.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:provider/provider.dart';

class AddTableItem extends StatefulWidget {
  AddTableItem(this.item);

  TablesItem item;

  @override
  AddTableItemState createState() => AddTableItemState();
}

class AddTableItemState extends State<AddTableItem> {
  final _itemNumberTextEditingController = TextEditingController();
  final _capacityTextEditingController = TextEditingController();
  final _focusNodeItemName = FocusNode();
  final _focusNodePrice = FocusNode();
  User user;
  bool isEdit = false;

  bool isValid() {
    String name = _itemNumberTextEditingController.text;
    String price = _capacityTextEditingController.text;
    bool isValid = true;
    if (name.isEmpty) {
      isValid = false;
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter item name!');
    } else if (price.isEmpty) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter capacity!');
      isValid = false;
    }
    return isValid;
  }

  @override
  void initState() {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    if (widget.item != null) {
      isEdit = true;
      _itemNumberTextEditingController.text = widget.item.name;
      _capacityTextEditingController.text = widget.item.capacity;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(height: 70, child: Image.asset(out_out_actionbar)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              isEdit? "Edit Table": "Add Table",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _itemNumberTextEditingController,
                focusNode: _focusNodeItemName,
                onFieldSubmitted: (value) {
                  _focusNodePrice.requestFocus();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Table Number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Table Number',
                    hintText: 'Enter Table Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    )),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _capacityTextEditingController,
                focusNode: _focusNodePrice,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Capacity',
                    hintText: 'Enter Number of person',
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 38.0),
              child: InkWell(
                onTap: () {
                  String itemName = _itemNumberTextEditingController.text;
                  String capacity = _capacityTextEditingController.text;
                  if (isValid()) {
                    CommonDialogUtil.showProgressDialog(
                        context, 'Please wait...');
                    if (isEdit) {
                      ApiImplementer.editTableItem(
                              accessToken: user.accessToken,
                              user_id: user.userId,
                              id: widget.item.id,
                              name: itemName,
                              price: capacity,)
                          .then((value) {
                        Navigator.of(context).pop();
                        print(value);
                        Navigator.of(context).pop(value);
                      }).onError((error, stackTrace) {
                        Navigator.of(context).pop();
                        print(stackTrace.toString());
                        CommonDialogUtil.showErrorSnack(
                            context: context, msg: error.toString());
                      });
                    } else {
                      ApiImplementer.addTableItem(
                              accessToken: user.accessToken,
                              user_id: user.userId,
                              name: itemName,
                              capacity: capacity,)
                          .then((value) {
                        Navigator.of(context).pop();
                        print(value);
                        Navigator.of(context).pop(value);
                      }).onError((error, stackTrace) {
                        Navigator.of(context).pop();
                        print(stackTrace.toString());
                        CommonDialogUtil.showErrorSnack(
                            context: context, msg: error.toString());
                      });
                    }
                  }
                },
                child: CommonGradiantButton(
                  title:               isEdit? "Edit Table": "Add Table",

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
