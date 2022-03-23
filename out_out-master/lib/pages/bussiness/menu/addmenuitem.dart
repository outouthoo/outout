import 'package:flutter/material.dart';
import 'package:out_out/api/api_implementer.dart';
import 'package:out_out/models/MenuModels/menumodels.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/common_dialog_util.dart';
import 'package:out_out/utils/icon_utils.dart';
import 'package:out_out/widget/common_gradiant_btn.dart';
import 'package:provider/provider.dart';

class AddMenuItem extends StatefulWidget {
  AddMenuItem(this.item);

  MenuItem item;

  @override
  AddMenuItemState createState() => AddMenuItemState();
}

class AddMenuItemState extends State<AddMenuItem> {
  final _itemNameTextEditingController = TextEditingController();
  final _pricesTextEditingController = TextEditingController();
  final _descTextEditingController = TextEditingController();
  final _focusNodeItemName = FocusNode();
  final _focusNodePrice = FocusNode();
  final _focusNodeDesc = FocusNode();
  User user;
  bool isEdit = false;

  bool isValid() {
    String name = _itemNameTextEditingController.text;
    String price = _pricesTextEditingController.text;
    String desc = _descTextEditingController.text;
    bool isValid = true;
    if (name.isEmpty) {
      isValid = false;
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter item name!');
    } else if (price.isEmpty) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter item price!');
      isValid = false;
    } else if (desc.isEmpty) {
      CommonDialogUtil.showErrorSnack(
          context: context, msg: 'Please enter item description!');
      isValid = false;
    }
    return isValid;
  }

  @override
  void initState() {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;
    if (widget.item != null) {
      isEdit = true;
      _itemNameTextEditingController.text = widget.item.name;
      _pricesTextEditingController.text = widget.item.price;
      _descTextEditingController.text = widget.item.description;
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
              isEdit? "Edit Menu Item": "Add Menu Item",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _itemNameTextEditingController,
                focusNode: _focusNodeItemName,
                onFieldSubmitted: (value) {
                  _focusNodePrice.requestFocus();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Item Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Item-Name',
                    hintText: 'Enter Item Name',
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
                controller: _pricesTextEditingController,
                focusNode: _focusNodePrice,
                onFieldSubmitted: (value) {
                  _focusNodeDesc.requestFocus();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Price(€)',
                    hintText: 'Enter Price(€)',
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _descTextEditingController,
                focusNode: _focusNodeDesc,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter Description',
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
              margin: EdgeInsets.symmetric(vertical: 38.0),
              child: InkWell(
                onTap: () {
                  String itemName = _itemNameTextEditingController.text;
                  String price = _pricesTextEditingController.text;
                  String description = _descTextEditingController.text;
                  if (isValid()) {
                    CommonDialogUtil.showProgressDialog(
                        context, 'Please wait...');
                    if (isEdit) {
                      ApiImplementer.editMenuItem(
                              accessToken: user.accessToken,
                              user_id: user.userId,
                              id: widget.item.id,
                              name: itemName,
                              price: price,
                              desc: description)
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
                      ApiImplementer.addMenuItem(
                              accessToken: user.accessToken,
                              user_id: user.userId,
                              name: itemName,
                              price: price,
                              desc: description)
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
                  title:               isEdit? "Edit Menu Item": "Add Menu Item",

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
